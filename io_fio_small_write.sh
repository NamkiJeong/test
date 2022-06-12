#!/bin/bash

TestName="FIO_small_write"
dir="$(dirname "$0")"
#echo "$dir"
source "$dir/body_fio.sh"
source "$dir/body_Func.sh"


IO_Small_Write $1



