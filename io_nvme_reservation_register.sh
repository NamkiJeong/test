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

IO_Reservation_Reg()
{
	Reg_RREGA=$(($RANDOM % 3))
	Reg_IEKEY=$(($RANDOM % 2))
	Reg_CRKEY=$(($RANDOM % 100000))
	Reg_CRKEY=`echo "ibase=16; $Reg_CRKEY"|bc`
	Reg_NRKEY=$(($RANDOM % 100000))
	Reg_NRKEY=`echo "ibase=16; $Reg_NRKEY"|bc`
	Reg_CPTPL=$(($RANDOM % 2 + 2)) 
	
	cmd="nvme resv-register /dev/nvme0n1 -n 0 -c $Reg_CRKEY -k $Reg_NRKEY -i $Reg_IEKEY -r $Reg_RREGA -p $Reg_CPTPL"
        
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
IO_Reservation_Reg

