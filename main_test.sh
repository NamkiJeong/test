#!/bin/bash

dir="$(dirname "$0")"
#echo "$dir"

for((i=0;i<3;i++))
do
#./io_fullwrite.sh
./io_nvme_write.sh 6
./io_fio_RndRead.sh 10
./io_fio_small_write.sh 20
./io_fio_ReadDisturb_1Spot.sh 30
./adm_telemetry.sh
./io_fio_trim.sh 20
#./io_fio_JESD219.sh	
./adm_Device_self_test.sh
./io_nvme_read.sh 7
./io_fio_SeqWrite_128k.sh 60
./adm_ErrorLog.sh
./io_fio_ReadDisturb_MultiSpot.sh 10
./io_fio_RndWrite.sh 30
./adm_Smart.sh
./adm_Device_self_test.sh
done
