#!/bin/bash

TestName="Admin_SetFeature"

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

Set_Feature()
{
	Feat_num=$(((($RANDOM %16)) +1))
	#Feat_num=18	
	echo "Feat_num:$Feat_num"
	#Random_sel=$(($RANDOM %4))
	#echo "Random_sel:$Random_sel"
        #cmd="nvme set-feature /dev/nvme0 -f 1 /dev/nvme0n1 -v 255"
#:<<'END'
	case "$Feat_num" in
	"1")
		Ran_Dword11=$(($RANDOM %256))
        	echo "Ran_Dword11:$Ran_Dword11"
	
		cmd="nvme set-feature /dev/nvme0 -f $Feat_num /dev/nvme0n1 -v $Ran_Dword11"
	;;
	"2")
                Ran_Dword11=$(($RANDOM %5))
                echo "Ran_Dword11:$Ran_Dword11"

                cmd="nvme set-feature /dev/nvme0 -f $Feat_num /dev/nvme0n1 -v $Ran_Dword11"
        ;;
	"3")
                Ran_Dword11=$(($RANDOM %64))
                echo "Ran_Dword11:$Ran_Dword11"
#need to improve buffer calculation 
                cmd="nvme set-feature /dev/nvme0 -n 1 -f $Feat_num /dev/nvme0n1 -v 0 -d LBA_Range_Type_Data"
        ;;
       "4")
                Ran_Dword11=$(($RANDOM %1048576))
                echo "Ran_Dword11:$Ran_Dword11"

                cmd="nvme set-feature /dev/nvme0 -f $Feat_num /dev/nvme0n1 -v $Ran_Dword11"
        ;;
	"5")
                Ran_Dword11=$(($RANDOM %131071))
                echo "Ran_Dword11:$Ran_Dword11"

                cmd="nvme set-feature /dev/nvme0 -n 1 -f $Feat_num /dev/nvme0n1 -v $Ran_Dword11"
        ;;
        "6")
                Ran_Dword11=$(($RANDOM %2))
                echo "Ran_Dword11:$Ran_Dword11"

                cmd="nvme set-feature /dev/nvme0 -f $Feat_num /dev/nvme0n1 -v $Ran_Dword11"
        ;;
        "7")
                #Ran_Dword11=$(($RANDOM %2))
                echo "Runtime change not support"
		return	
                #cmd="nvme set-feature /dev/nvme0 -f $Feat_num /dev/nvme0n1 -v 3"
        ;;
  	"8")
                Ran_Dword11=$(($RANDOM %65536))
     		echo "Ran_Dword11:$Ran_Dword11"
                cmd="nvme set-feature /dev/nvme0 -f $Feat_num /dev/nvme0n1 -v $Ran_Dword11"
        ;;
	"9")
                echo "not support"
		return 
		Ran_Dword11=$(($RANDOM %131071))
                echo "Ran_Dword11:$Ran_Dword11"
                cmd="nvme set-feature /dev/nvme0 -n 1 -f $Feat_num /dev/nvme0n1 -v 7"
        ;;
	 "10")
                Ran_Dword11=$(($RANDOM %2))
                echo "Ran_Dword11:$Ran_Dword11"
                cmd="nvme set-feature /dev/nvme0 -f $Feat_num /dev/nvme0n1 -v $Ran_Dword11"
        ;;
  	"11")
                Ran_Dword11=$(($RANDOM %32768))
                echo "Ran_Dword11:$Ran_Dword11"
                cmd="nvme set-feature /dev/nvme0 -f $Feat_num /dev/nvme0n1 -v $Ran_Dword11"
        ;;
	"12")
                #Ran_Dword11=$(($RANDOM %64))
                #echo "Ran_Dword11:$Ran_Dword11"
                cmd="nvme set-feature /dev/nvme0 -f $Feat_num /dev/nvme0n1 -v 0 -d APST_Data"
#need to improve buffer calculation
        ;;
 	"13")
                echo "not support"
                return
		Ran_Dword11=$(($RANDOM %32768))
                echo "Ran_Dword11:$Ran_Dword11"
                cmd="nvme set-feature /dev/nvme0 -f $Feat_num /dev/nvme0n1 -v $Ran_Dword11"
        ;;
	"14")
                Ran_Dword11=$(($RANDOM %1048576))
                echo "Ran_Dword11:$Ran_Dword11"
                cmd="nvme set-feature /dev/nvme0 -f $Feat_num /dev/nvme0n1 -v $Ran_Dword11"
        ;;
	"15")
                echo "not support"
                return
		Ran_Dword11=$(($RANDOM %3294967296))
                echo "Ran_Dword11:$Ran_Dword11"
                cmd="nvme set-feature /dev/nvme0 -f $Feat_num /dev/nvme0n1 -v $Ran_Dword11"
        ;;
	"16")
                Ran_Dword11=$(($RANDOM %3294967296))
                echo "Ran_Dword11:$Ran_Dword11"
                cmd="nvme set-feature /dev/nvme0 -f $Feat_num /dev/nvme0n1 -v $Ran_Dword11"
        ;;
	"17")
                echo "not support"
                return
                Ran_Dword11=$(($RANDOM %2))
                echo "Ran_Dword11:$Ran_Dword11"
                cmd="nvme set-feature /dev/nvme0 -f $Feat_num /dev/nvme0n1 -v $Ran_Dword11"
        ;;
 	"18")
                echo "not support"
                return
                Ran_Dword11=$(($RANDOM %3294967296))
                echo "Ran_Dword11:$Ran_Dword11"
                cmd="nvme set-feature /dev/nvme0 -f $Feat_num /dev/nvme0n1 -v $Ran_Dword11"
        ;;

	esac		
#END

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
Set_Feature
