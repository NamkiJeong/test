#!/bin/bash

TestName="Admin_ErrorLog"

dir="$(dirname "$0")"
#echo "$dir"
source "$dir/body_Func.sh"
#nvme id-ctrl /dev/nvme0n1

ErrorLog_check()
{
        cmd="nvme error-log /dev/nvme0n1"

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
ErrorLog_check
