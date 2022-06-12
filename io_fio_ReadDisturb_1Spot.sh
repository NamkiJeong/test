#!/bin/bash

TestName="FIO_ReadDisturb_1spot"
dir="$(dirname "$0")"
#echo "$dir"
source "$dir/body_fio.sh"
source "$dir/body_Func.sh"


IO_ReadDisturb_1Spot $1	 

