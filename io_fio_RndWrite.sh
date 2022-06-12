#!/bin/bash

TestName="FIO_Random_write_4k"
dir="$(dirname "$0")"
#echo "$dir"
source "$dir/body_fio.sh"
source "$dir/body_Func.sh"


IO_RndW_4k $1



