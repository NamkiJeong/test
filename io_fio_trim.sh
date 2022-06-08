#!/bin/bash

TestName="FIO_trim"
dir="$(dirname "$0")"
#echo "$dir"
source "$dir/body_fio.sh"
source "$dir/body_Func.sh"


IO_TRIM $1

