#!/bin/bash

TestName="FIO_Random_read_4k"
dir="$(dirname "$0")"
#echo "$dir"
source "$dir/body_fio.sh"
source "$dir/body_Func.sh"


IO_RndR_4k $1

