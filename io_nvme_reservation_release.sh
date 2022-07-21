#!/bin/bash

TestName="IO_Reservation_Release"

dir="$(dirname "$0")"
#echo "$dir"
source "$dir/body_Func.sh"


feature=$( nvme id-ctrl /dev/nvme0n1 -H | grep -i "Reservations" | awk '{ print $3 }' )

echo "feature_support:$feature"

if [ $feature == "0" -o $feature == "0x0" ]; then
        echo "Reservations feat is not support"
        exit 1
fi

runtime=$1

if [ -z $1 ]
then
        runtime=3
fi
#echo "runtime=$runtime"

IO_Reservation_Release()
{
	NSid=$(nvme get-ns-id /dev/nvme0n1 | cut -d: -f3)
	#echo "NSid:$NSid"	

	ReportLog="./Log/Reservation_Report.Log"
	rkey=`cat $ReportLog | grep rkey | cut -d ":" -f 2 | tr -d ' '`
	if [ -z $rkey ]; then
		rkey=-1
	fi
	echo "rkey:$rkey"

 	rtype=`cat $ReportLog | grep rtype | cut -d ":" -f 2 | tr -d ' '`
        if [ -z $rtype ]; then
                rtype=-1
        fi
        echo "rtype:$rtype"	

	Rel_RRELA=$(($RANDOM % 2)) #0b:Release, 1b:Clear
	Rel_IEKEY=$(($RANDOM % 2)) #1:Current key check skip
        Rel_CRKEY=$rkey
	Rel_RTYPE=$rtype
	#cmd="nvme resv-release /dev/nvme0n1 -n $NSid -c $Rel_CRKEY -i $Rel_IEKEY -a $Rel_RRELA -t $Rel_RTYPE"
       	cmd="nvme resv-release /dev/nvme0n1 -n $NSid -i $Rel_IEKEY -a $Rel_RRELA" 
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
IO_Reservation_Release

