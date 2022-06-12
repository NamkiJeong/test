#!/bin/bash
#clear
TestSuite="NVME_READ"

import_dir="$(dirname "$0")"
#echo "$import_dir"

#nvme id-ctrl /dev/nvme0n1
nvme id-ns /dev/nvme0n1
MDTS=$(nvme id-ctrl /dev/nvme0n1 |grep mdts|awk -F: '{print $2}')

echo "MDTS=$MDTS"

runtime=$1

if [ -z $1 ]
then
 	runtime=3
fi
echo "runtime=$runtime"

NVMe_IO_Read()
{

	#methord 1 totalsize
	#total_size_hex=`nvme id-ns /dev/nvme0n1 |grep nsz |cut -d : -f2| tr -d ' x'`
	#echo "total_size_hex=0x$total_size_hex"
	#total_size="$(echo "ibase=16;${total_size_hex^^}"|bc)"

	#methord 2 totalsize
  	total_size_hex=`nvme id-ns /dev/nvme0n1 |grep nsz |cut -d : -f2| tr -d ' '`
        echo "total_size_hex=$total_size_hex"

        total_size=`printf "%d\n" $total_size_hex`

	max_lba=`expr $total_size - 1`
        echo "total_size=$total_size"
	echo "max_lba=$max_lba"

	StartTime=`date +%s`

	while [ 1 ]
	do	
		#Index=$(RangeRandom 0 100)
		Index="$(($RANDOM% 100))"
        	#tempRange=`expr $total_size + 1`
		#SLBA="$(($RANDOM% $tempRange))"
	
		SLBA="$(($RANDOM% $max_lba))"
		#SLBA="$max_lba"	

		echo "SLBA=$SLBA"

		NLBA="$(($RANDOM% 1000))"

		ELBA=`expr $SLBA + $NLBA`
		if [ $ELBA -gt $total_size ]; then
			#SLBA=`expr $total_size - $NLBA`
			  SLBA=`expr $total_size - $NLBA`
		fi

		echo "SLBA = $SLBA NLBA = $NLBA ELBA=$ELBA"

		NLB_size=$(($RANDOM % $MDTS))

		Data_size=`expr $NLBA - 1` # 128KB:131072, 4KB=4096
		nvme read /dev/nvme0n1 -s $SLBA -c $NLB_size -z $Data_size -d readbufr


		EndTime=`date +%s`
                echo "EndTime=$EndTime"
                ELAPSED_TIME=`echo "$EndTime-$StartTime"|bc`
                echo "ELAPSED_TIME=$ELAPSED_TIME"
                if [ $ELAPSED_TIME -gt $runtime ]; then #3seconds 
                      break
                fi

	done
}


NVMe_IO_Read

:<<'END'
StartTime=`date +%s`

while [ 1 ]
do
	EndTime=`date +%s` 
        echo "EndTime=$EndTime"
	ELAPSED_TIME=`echo "$EndTime-$StartTime"|bc`
	echo "ELAPSED_TIME=$ELAPSED_TIME"
	if [ $ELAPSED_TIME -gt $runtime ]; then
		break
	fi
done

END

	
