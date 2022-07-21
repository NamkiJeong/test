#!/bin/bash

TestName="Admin_GetFeature"


dir="$(dirname "$0")"
#echo "$dir"
source "$dir/body_Func.sh"
#nvme id-ctrl /dev/nvme0n1


#echo "MDTS=$MDTS"

runtime=$1

if [ -z $1 ]
then
        runtime=3
fi
#echo "runtime=$runtime"

Get_Feature()
{
	Random_num=$(((($RANDOM %10)) +2))
	echo "Random_num:$Random_num"
	Random_sel=$(($RANDOM %4))
	echo "Random_sel:$Random_sel"
        cmd="nvme get-feature /dev/nvme0n1 -f $Random_num -s $Random_sel"

         Log_CMD "$cmd" Start
                Result=`$cmd 2>&1`
                status=$?
#               #echo status******************=$status
                if (( $status ));then
                Log_CMD "$cmd" ${cmdResult[$status]} "$Result"
                echo " ********* Admin_cmd Fail:$status **********"
                else
                Log_CMD "$cmd" ${cmdResult[$status]} "$Result"
                echo " ********* Admin_cmd PASS **********"
                fi
	

}
Get_Feature
