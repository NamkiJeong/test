#!/bin/bash

TestName="IO_Reservation_Acquire"

dir="$(dirname "$0")"
#echo "$dir"
source "$dir/body_Func.sh"


feature=$( nvme id-ctrl /dev/nvme0n1 -H | grep -i "Reservations" | awk '{ print $3 }' )

echo "feature_support:$feature"

if [ $feature == "0" -o $feature == "0x0" ]; then
        echo "Reservations is not support"
        exit 1
fi

runtime=$1

if [ -z $1 ]
then
        runtime=3
fi
#echo "runtime=$runtime"

IO_Reservation_Acquire()
{
	Acq_RACQA=$(($RANDOM % 3))
	Acq_IEKEY=$(($RANDOM % 2))
        Acq_CRKEY=$(($RANDOM % 100000))
        Acq_CRKEY=`echo "ibase=16; $Acq_CRKEY"|bc`
	Acq_PRKEY=$(($RANDOM % 100000))
	Acq_PRKEY=`echo "ibase=16; $Acq_PRKEY"|bc`
	Acq_RTYPE=$(($RANDOM % 6)) 
	Acq_RTYPE=`expr $Acq_RTYPE + 1`	
	cmd="nvme resv-acquire /dev/nvme0n1 -n 0 -c $Acq_CRKEY -p $Acq_PRKEY -i $Acq_IEKEY -a $Acq_RACQA -t $Acq_RTYPE"
        
	Log_CMD "$cmd" 0 Start
        Result=`$cmd 2>&1`
        status=$?
        if (( $status ));then
               Log_CMD "$cmd" ${cmdResult[$status]} "End_$Result"
               echo " ********* IO Fail:$status **********"
        else
                Log_CMD "$cmd" ${cmdResult[$status]} "End_$Result"
                echo " ********* IO PASS **********"
        fi
}
IO_Reservation_Acquire

