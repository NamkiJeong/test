#!/bin/bash

TestName="NVMe_Write"

dir="$(dirname "$0")"
#echo "$dir"
source "$dir/body_Func.sh"

MDTS=$(nvme id-ctrl /dev/nvme0n1 |grep mdts|awk -F: '{print $2}')

#echo "MDTS=$MDTS"

runtime=$1

if [ -z $1 ]
then
 	runtime=3
fi
#echo "runtime=$runtime"

NVMe_IO_Write()
{

  	total_size_hex=`nvme id-ns /dev/nvme0n1 |grep nsz |cut -d : -f2| tr -d ' '`
#        echo "total_size_hex=$total_size_hex"

        total_size=`printf "%d\n" $total_size_hex`

	max_lba=`expr $total_size - 1`

	StartTime=`date +%s`

	while [ 1 ]
	do	
		Index="$(($RANDOM% 100))"
        	#tempRange=`expr $total_size + 1`
		#SLBA="$(($RANDOM% $tempRange))"
	
		SLBA="$(($RANDOM% $max_lba))"
		#SLBA="$max_lba"	

#		echo "SLBA=$SLBA"

		NLBA="$(($RANDOM% 1000))"

		ELBA=`expr $SLBA + $NLBA`
		if [ $ELBA -gt $total_size ]; then
			#SLBA=`expr $total_size - $NLBA`
			  SLBA=`expr $total_size - $NLBA`
		fi

		echo "SLBA = $SLBA NLBA = $NLBA ELBA=$ELBA"

		NLB_size=$(($RANDOM % $MDTS))

		Data_size=`expr $NLBA - 1` # 128KB:131072, 4KB=4096
		#nvme write /dev/nvme0n1 -s $SLBA -c $NLB_size -z $Data_size -d writebuf
		cmd="nvme write /dev/nvme0n1 -s $SLBA -c $NLB_size -z $Data_size -d writebuf"

		Log_CMD "$cmd" 0 Start 
		Result=`$cmd 2>&1`
		status=$?
#		#echo status******************=$status
		if (( $status ));then
		Log_CMD "$cmd" ${cmdResult[$status]} "End_$Result"
           	echo " ********* IO Fail:$status **********"
                else
                Log_CMD "$cmd" ${cmdResult[$status]} "End_$Result"
                echo " ********* IO PASS **********"
                fi


		EndTime=`date +%s`
#                echo "EndTime=$EndTime"
                ELAPSED_TIME=`echo "$EndTime-$StartTime"|bc`
#                echo "ELAPSED_TIME=$ELAPSED_TIME"
                if [ $ELAPSED_TIME -gt $runtime ]; then #3seconds 
                      break
                fi

	done
}

NVMe_IO_Write $1

