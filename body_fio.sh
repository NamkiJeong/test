#!/bin/bash

#TestSuite="FIO"

dir="$(dirname "$0")"

source "$dir/body_Func.sh"

#echo "$dir"

cmdResult=("Success" "Fail")


run_fio()
{
	tstamp=$(date +%y%m%d_%H%M%S)
	fio_result=${tstamp}_fio.log

	
#	fio_result=nvme0n1_fio.log
#	tLogpath="FIOLOG"
	tLogpath="Log/$2"
	#echo tLogpath:$tLogpath

	if [ ! -d "$tLogpath" ]; then
        	mkdir -p $tLogpath;
	fi


	# BS=128k
        #QD=32
        #oper="rw"



#fioCmd="fio --name=/dev/nvme0n1 --atomic=1 --ioengine=libaio --direct=1--rw=${oper} --rwmixread=0 --bs=${BS} --blockalign=${BS} --iodepth=${QD} --numjobs=1 --invalidate=1 --loops=100 --size=100% --time_based --runtime=$1 --norandommap --randrepeat=0" 


#fioCmd="fio --name=/dev/nvme0n1 --atomic=1 --ioengine=libaio --direct=1 $fioParm"

fioCmd="fio --name=/dev/nvme0n1 --atomic=1 --ioengine=libaio --filename=/dev/nvme0n1 --output=${tLogpath}/${fio_result} $fioParm"

#fioCmd="fio --name=/dev/nvme0n1 --atomic=1 --ioengine=libaio --filename=/dev/nvme0n1 $fioParm"

#echo "$fio_result"

#echo "fioParm=$fioParm"
Log_IO "$fioCmd" 0 Start

$fioCmd ;
Returncode=$?
#if [ "$Returncode" -ne 0 ] ; then
#	echo " ####### FIO ERROR :$Returncode ########"
#fi
if (( "$Returncode" )); then
	Log_IO "$fioCmd" ${cmdResult[$Returncode]} "End_$Returncode"
	echo " ####### FIO ERROR :$Returncode ########"

else
	Log_IO "$fioCmd" ${cmdResult[$Returncode]} "End_$Returncode"
	echo " ####### FIO PASS ########"
fi

#echo "$fio_result"


#fio --name=/dev/nvme0n1 --randrepeat=0 --ioengine=libaio --direct=1 --rw=randread --bs=4k --size=100% --numjob=16 --iodepth=64 --time_based --runtime=10 --group_reporting --norandommap
}

IO_SEQ_128k()
{
	#tFIODevname="nvme0n1"
	BS=128k
	QD=32
	oper="rw"
	fioParm="--rw=${oper} --rwmixread=0 --bs=${BS} --blockalign=${BS} --iodepth=${QD} --numjobs=1 --invalidate=1 --loops=100 --size=100% --time_based --runtime=$1 --norandommap --randrepeat=0"
# 	echo "BS : $BS"	
	run_fio 
	wait $! 
}	

IO_FIOPATTERN()
{
	echo "${#START[@]}"
	if [ ${#START[@]} -eq 0 ] ; then
	echo "Set Parameter of ${FUNCNAME[0]}"
	fi

} 

IO_JESD219()
{
	#Full_Write
	BS=128k
	oper=write
	QD=64
	#Log_IO "BG_IO:FIO({$BS} Full Write Thread:1/BS:${BS}k/Oper:${oper}/Range:100%"
#	fioParm="--rw=${oper} --bs=${BS} --blockalign=${BS} --iodepth=${QD} --numjobs=1 --invalidate=1 --loops=1 --size=100% --norandommap --randrepeat=0"
#	run_fio	
#	wait $!
	
	#Rnd Write for 60sec
	BS=4K
	oper=randwrite
	fioParm="--rw=${oper} --bs=${BS} --blockalign=${BS} --iodepth=${QD} --numjobs=1 --invalidate=1 --loops=100 --size=100% --time_based --runtime=60 --norandommap --randrepeat=0"
        run_fio
        wait $!
 	
	#JESD219
	BS=512/4:1024/1:1536/1:2048/1:2560/1:3072/1:3584/1:4k/67:8k/10:16k/7:32k/3:64k/3
	QD=256
	oper=randwrite	
	fioParm="--rw=${oper} --rwmixread=40 --bssplit=${BS} --blockalign=4k --iodepth=${QD} --numjobs=4 --random_distribution=zoned:50/5:30/15:20/80 --group_reporting=1 --loops=1 --size=100%  --norandommap --randrepeat=0"
        run_fio
        wait $!

}	


IO_Small_Write()
{

#	TestSuite
	BS=512/4:1024/1:1536/1:2048/1:2560/1:3072/1:3584/1:4k/67:8k/10:16k/7:32k/3:64k/3
        QD=16
        oper=randwrite
        fioParm="--rw=${oper} --rwmixread=99 --bssplit=${BS} --iodepth=${QD} --numjobs=2 -invalidate=1 --loops=100 --size=100% -time_based --runtime=$1 --norandommap --randrepeat=0"
        run_fio
        wait $!

}


IO_seqW()
{	
        #Full_Write
        BS=128k
        oper=write
        QD=64
        #Log_IO "BG_IO:FIO({$BS} Full Write Thread:1/BS:${BS}k/Oper:${oper}/Range:100%"
        fioParm="--rw=${oper} --bs=${BS} --blockalign=${BS} --iodepth=${QD} --numjobs=1 --invalidate=1 --loops=1 --size=100% --norandommap --randrepeat=0"
        run_fio
        wait $!
}

IO_seqR()
{
	#Full_Read
        BS=128k
        oper=read
        QD=64
        #Log_IO "BG_IO:FIO({$BS} Full Write Thread:1/BS:${BS}k/Oper:${oper}/Range:100%"
        fioParm="--rw=${oper} --bs=${BS} --blockalign=${BS} --iodepth=${QD} --numjobs=1 --invalidate=1 --loops=1 --size=100% --norandommap --randrepeat=0"
        run_fio
        wait $!

}


IO_RndW_4k()
{	
    	#Rnd Write for 60sec
        BS=4k
	QD=32
        oper=randwrite
        fioParm="--rw=${oper} --bs=${BS} --blockalign=${BS} --iodepth=${QD} --numjobs=2 --invalidate=1 --loops=100 --size=100% --time_based --runtime=$1 --norandommap --randrepeat=0"
        run_fio
        wait $!
}	

IO_RndR_4k()
{
  	#Rnd Read for 60sec
        BS=4k
        QD=32
        oper=randread
        fioParm="--rw=${oper} --bs=${BS} --blockalign=${BS} --iodepth=${QD} --numjobs=2 --invalidate=1 --loops=100 --size=100% --time_based --runtime=$1 --norandommap --randrepeat=0"
        run_fio
        wait $!
}

IO_TRIM()
{
	BS=1M/90:4K/10
        QD=32
        oper=trim
	fioParm="--rw=${oper} --trim_percentage=10 --bssplit=${BS} --iodepth=${QD} --group_reporting --end_fsync=0 --invalidate=1 --size=100% --time_based --runtime=$1 --norandommap --randrepeat=0"
        run_fio
        wait $!
}

IO_ReadDisturb_1Spot()
{
	START=( 0% 25% 50% 75% )
	RANGE=( 25% 25% 25% 25% )
	#SPOT_POSITION=$(shuf -i ${START[1]/\%/}-$((${START[1]/\%/}+${RANGE[1]/\%/})) -n 1)\%
	SPOT_POSITION=$(shuf -i 0-100 -n 1)\%	
	echo "spot position = $SPOT_POSITION" 
	#Rnd Read for 60sec
        BS=4k
        QD=64
        oper=read

        fioParm="--rw=${oper} --bs=${BS} --blockalign=512b --iodepth=${QD} --numjobs=4 --invalidate=1 --loops=100 --size=4k --offset=${SPOT_POSITION} --time_based --runtime=$1 --norandommap --randrepeat=0"
        run_fio
        wait $!
}

IO_ReadDisturb_MultiSpot()
{
	START=( 0% 25% 50% 75% )
        RANGE=( 25% 25% 25% 25% )
        
 	for((i=0; i < 4 ; i++))
	do	
		#SPOT_POSITION=$(shuf -i ${START[$i]/\%/}-$((${START[$i]/\%/}+${RANGE[$i]/\%/})) -n 1)\%
        	SPOT_POSITION=$(shuf -i 0-100 -n 1)\%
        	echo "spot position = $SPOT_POSITION"
        	#Rnd Read for 60sec
        	BS=4k
        	QD=64
        	oper=read

        	fioParm="--rw=${oper} --bs=${BS} --blockalign=512b --iodepth=${QD} --numjobs=4 --invalidate=1 --loops=100 --size=4k --offset=${SPOT_POSITION} --time_based --runtime=$1 --norandommap --randrepeat=0"
        	run_fio
        	wait $!
	done
}

IO_compare()
{
        BS=128k
        QD=32
        oper=read
        fioParm="--rw=${oper} --bs=${BS} --verify_pattern=0x1313 --do_verify=1 --iodepth=${QD} --numjobs=1 --invalidate=1 --loops=100 --size=100% --randrepeat=0 --norandommap --overwrite=1 --invaldate=0 --pre_read=0"
        run_fio
        wait $!
	

}

#IO_compare


#run_fio 10
#IO_SEQ_128k 15
#IO_FIOPATTERN FUNCNAME[0] nvme1 2
#IO_JESD219 
#IO_LOW_WRITE 60
#IO_seqR
#IO_seqW
#IO_RndW_4k 60
#IO_RndR_4k 60
#IO_TRIM 60
#IO_ReadDisturb_1Spot 60
#IO_ReadDisturb_MultiSpot 60


