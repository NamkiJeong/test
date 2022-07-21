#!/bin/bash

TestName="Admin_FormatNvme"

dir="$(dirname "$0")"
#echo "$dir"
source "$dir/body_Func.sh"

runtime=$1

if [ -z $1 ]
then
        runtime=3
fi
#echo "runtime=$runtime"

FormatNvme()
{
	lbaf_check= `echo $nvme id-ns /dev/nvme0n1 | grep ^lbaf | awk '{ print $2}'`
	lbafnum=`expr $lbaf_check + 1`	
	LBAF=$(($RANDOM % $lbafnum))
	#echo "lbafnum:$lbafnum"
	Secure=$((RANDOM % 3))
	PROTECTION_TYPE=0
	PROTECTION_LOCA=$((RANDOM % 2))
	EXTENDED=$((RANDOM % 2))

	#Secure=2
        #PROTECTION_TYPE=0
        #PROTECTION_LOCA=1
        #EXTENDED=1

	
	cmd="nvme format /dev/nvme0n1 -l $LBAF -s $Secure -i $PROTECTION_TYPE -p $PROTECTION_LOCA -m $EXTENDED"

         Log_CMD "$cmd" 0 Start
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
FormatNvme
