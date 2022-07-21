#i/bin/bash


##############################
#Desciption
#func : Log execution
############################

dir="$(dirname "$0")"
#echo "$dir"

declare -a cmdResult
cmdResult=("Success" "Fail")

StartTime=`date +%s`
#echo $StartTime


tLogpath="Log/$2"
#echo tLogpath:$tLogpath

if [ ! -d "$tLogpath" ]; then
	mkdir -p $tLogpath
fi


GetTestName()
{

	echo -n $TestName
}	

#PCI_FULL_PATH=
RangeRandom()
{
	RNumber=`shuf -i ${1}-${2} -n 1`
	echo ${RNumber}
}

PCI_RESCAN()
{
echo "1" > /sys/bus/pci/rescan
}

:<<'END'
PCI_FLR_RESET()
{
	cmd_list="echo \"1\" > ${PCI_FULL_PATH}/reset"
	myResult=`eval ${cmd_list} 2>&1`
	exitstatus=$?
	echo $exitstaus
}
END

GET_RUN_TIME()
{
 	EndTime=`date +%s`
        #echo "EndTime=$EndTime"
        RUN_TIME=`echo "$EndTime-$StartTime"|bc`
	
	echo $RUN_TIME
}
#echo GET_RUN_TIME=`GET_RUN_TIME`
#GET_RUN_TIME

tDevname()
{
	echo "nvme0n1"
}

TCLog()
{

	DATE_v=`date '+%Y-%m-%d %H:%M:%S.%M'`
	UPTIME_v=$(GET_RUN_TIME)

	logstring="[LOG_TS:$DATE_v][RUNTIME:$UPTIME_v][$1]"

	logstring="${logstring}[$(tDevname) : $@]"

		echo "[$(GetTestName)]${logstring}"
                echo "TC:$(GetTestName),${logstring}" | sed 's/\x1b\[0-9;]*m//g' >> $tLogpath/$(GetTestName).tlog
  echo "TC:$(GetTestName),${logstring}" | sed 's/\x1b\[0-9;]*m//g' >> $tLogpath/MainLog.tlog


}


Log_COMPLETED()
{
	TCLog "LOG:COMPLETED" "$@"
}


Log_CMD()
{
	 TCLog "LOG:COMMAND" "$@"
}

Log_IO()
{	
	TCLog "LOG:IO" "$@"
}

Log_INFO()
{
        TCLog "LOG:INFO" "$@"
}


#temp=$(RangeRandom 1 4)
#echo "temp=$temp"


#GET_RUN_TIME
#TCLogger "ioaging" "$@" 


#PCI_RESCAN


