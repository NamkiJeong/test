#!/bin/bash

TestName="Admin_Smart"

dir="$(dirname "$0")"
#echo "$dir"
source "$dir/body_Func.sh"
#nvme id-ctrl /dev/nvme0n1

Smart_check()
{
	cmd="nvme smart-log /dev/nvme0n1"

	Log_CMD "$cmd" 0 Start
	Result=`$cmd 2>&1`
	status=$?
	#echo status******************=$status
	if (( $status ));then
        	Log_CMD "$cmd" ${cmdResult[$status]} "End_$Result"
                echo " ********* Admin_cmd Fail:$status **********"
        else
                Log_CMD "$cmd" ${cmdResult[$status]} "End_$Result"
                echo " ********* Admin_cmd PASS **********"
        fi
}

Smart_check
