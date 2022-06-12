#!/bin/bash

TestName="FIO_Full_read"
dir="$(dirname "$0")"
#echo "$dir"
source "$dir/body_fio.sh"
source "$dir/body_Func.sh"

IO_seqR

