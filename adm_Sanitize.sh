#!/bin/bash

TestName="Admin_Sanitize"

dir="$(dirname "$0")"
#echo "$dir"
source "$dir/body_Func.sh"

runtime=$1

if [ -z $1 ]
then
        runtime=3
fi
#echo "runtime=$runtime"

Sanitize()
{
	start_time=`date +%s.%N`
        start_time_string=`date`

        Log_INFO "Check Sanitize Support bit.."
        Sbit=`nvme id-ctrl /dev/nvme0n1 -o normal |grep sanicap | awk -F:' ' '{print $2}'` 
        #echo "Sbit:$Sbit"
 	#Sbit=`echo 0x"${Sbit:(-1)}"` 
	#Sbit=$[ $IDFY & 0x01]
	#echo "Sbit:$Sbit"
	
	case "$Sbit" in
	"0x0"|"0")
		echo "not support Sanitize"
	;;
	"0x1")
                echo "Crypto Erase support"
		action=4
	;;	
	"0x2")
                echo "Block Erase support"
                action=2
        ;;
	"0x3")
                echo "Crypto & Block Erase support"
                action=$(($(($(($RANDOM % 2))+1))*2))
        ;;
	"0x4")
                echo "Overwrite support"
                action=3
        ;;
	"0x5")
                echo "Crypto Erase & Overwrite support"
                action=$(($(($RANDOM % 2))+3))
        ;;
	"0x6")
                echo "Block Erase & Overwrite support"
                action=$(($(($RANDOM % 2))+2))
        ;;      
	"0x7")
                echo "All options support"
                action=$(($(($RANDOM % 3))+2))
        ;;      
	esac 
	echo "action:$action"

	cmd="nvme sanitize /dev/nvme0n1 -a $action"
	Log_CMD "$cmd" 0 Start
                Result=`$cmd 2>&1`
                status=$?
#               #echo status******************=$status
                if (( $status ));then
                Log_CMD "$cmd" ${cmdResult[$status]} "$Result"
                echo " ********* Admin_cmd Fail:$status **********"
                else
                Log_CMD "$cmd" ${cmdResult[$status]} 
                echo " ********* Admin_cmd PASS **********"
                fi

	Status=$(nvme get-log /dev/nvme0n1 -i 0x81 -l 512 | grep 0000: |awk -F: '{print $2}'| awk -F' ' '{print $3}')
#:<<'END'
	while [ $Status -ne "01" ]
	do
		echo "Status: $Status"
		if [ $Status -eq "00" ]; then
			echo "The NVMe system never sanitized."
			return

		elif [ $Status -eq "02" ]; then
			echo "Sanitize in progress"
			echo "Progress : $(nvme get-log /dev/nvme0n1 -i 0x81 -l 512 | grep 0000: |awk -F: '{print $2}'| awk -F' ' '{print $1 $2}')"	
		elif [ SStatus -eq "03" ]; then
			echo "Sanitize failed"
		else
			echo "Reserved"
			break
		fi
		Status=$(nvme get-log /dev/nvme0n1 -i 0x81 -l 512 | grep 0000: |awk -F: '{print $2}'| awk -F' ' '{print $3}')
	done
	
	if [ $Status -eq "01" ]; then
		echo "Sanitize Succeed"
	fi	

}
Sanitize
