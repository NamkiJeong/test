#!/bin/bash

TestName="NVMe_Flush"

dir="$(dirname "$0")"
source "$dir/body_Func.sh"

Flush()
{
	        cmd="nvme flush /dev/nvme0n1"

                Log_CMD "$cmd" 0 Start
                Result=`$cmd 2>&1`
                status=$?
#               #echo status******************=$status
                if (( $status ));then
                Log_CMD "$cmd" ${cmdResult[$status]} "End_$Result"
                echo " ********* IO Fail:$status **********"
                else
                Log_CMD "$cmd" ${cmdResult[$status]} "End_$Result"
                echo " ********* IO PASS **********"
                fi
		sleep 2
}


Flush
