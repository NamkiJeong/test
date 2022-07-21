#!/bin/bash

dir="$(dirname "$0")"
#echo "$dir"
source "$dir/body_Func.sh"
source "$dir/body_fio.sh"

#./io_nvme_write.sh 2
#./io_fio_RndRead.sh 10

#:<<'END'
for((i=0;i<1;i++))
do
#./io_nvme_write_zeroes.sh
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
./io_nvme_compare.sh
#./io_nvme_write_uncor.sh
#./io_nvme_write_zeroes.sh
./adm_Sanitize.sh
./io_nvme_write.sh 6
./io_nvme_reservation_register.sh
./adm_ErrorLog.sh
./adm_FormatNVMe.sh
./io_nvme_reservation_Report.sh
./io_nvme_reservation_release.sh
./io_fio_RndWrite.sh 30
./io_nvme_reservation_acquire.sh
./adm_SetFearue.sh
./adm_ErrorLog.sh
./adm_GetFeature.sh
./io_nvme_read.sh
done
#END
