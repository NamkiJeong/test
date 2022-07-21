#!/bin/bash

TestName="IO_Reservation_Reg"

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

IO_Reservation_Report()
{
	ReportLog="./Log/Reservation_Report.Log"	
	cmd="nvme resv-report /dev/nvme0n1 -o normal > $ReportLog"
        
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
IO_Reservation_Report

