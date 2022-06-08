#!/bin/bash

TestName="Admin_Device_Selftest"


dir="$(dirname "$0")"
#echo "$dir"
source "$dir/body_Func.sh"
#nvme id-ctrl /dev/nvme0n1


#echo "MDTS=$MDTS"

runtime=$1

if [ -z $1 ]
then
        runtime=3
fi
#echo "runtime=$runtime"

Device_Self_Test()
{
	start_time=`date +%s.%N`
	start_time_string=`date`

	Log_INFO "Check DST Support bit.."
	IDFY=`nvme id-ctrl /dev/nvme0n1 -o normal |grep -i oacs | cut -d":" -f2`
	Sbit=$[ $IDFY & 0x01]
	
	if [ $Sbit -eq "1" ]; then
		Log_INFO "DST Supported"
	else
		Log_INFO "DST Not Supported"
	fi
	
	Random_num=$(((($RANDOM %2)) +1))	 
 	if [ $Random_num -eq "1" ]; then
		Log_INFO "Short DST"
	else [ $Random_num -eq "2" ] ; 
		Log_INFO " Extended DST"
	fi
	echo "Random_num:$Random_num"	
 	cmd="nvme device-self-test /dev/nvme0n1 -s $Random_num"

	 Log_CMD "$cmd" 0 Start
                Result=`$cmd 2>&1`
                status=$?
#               #echo status******************=$status
                if (( $status ));then
                Log_CMD "$cmd" ${cmdResult[$status]} "$Result"
                echo " ********* Admin_cmd Fail:$status **********"
                else
                Log_CMD "$cmd" ${cmdResult[$status]} "$Result"
                echo " ********* Admin_cmd PASS **********"
                fi

	
	DST_Opt=$(nvme get-log /dev/nvme0n1 -i 6 -l 8 -n 0 |grep 0000: |cut -d" " -f2)
	DST_Cmp=$(nvme get-log /dev/nvme0n1 -i 6 -l 8 -n 0 |grep 0000: |cut -d" " -f3)
	Log_INFO " DST option: $DST_Opt, DST_Start"
	sleep 1
	while [ $DST_Cmp -ne "00" ]
	do 
		Cmp=$(nvme get-log /dev/nvme0n1 -i 6 -l 8 -n 0 |grep 0000: |cut -d" " -f3)  
		#Progress=`printf "%d\n" $Cmp`
		echo "DST_Completion: 0x$Cmp %"
		if [ $Cmp == "00" ]; then
			break
		fi

	done
	 Log_INFO " DST option: $DST_Opt, DST_Completion"
		
}
	
Device_Self_Test
