#!/bin/bash

TestName="FIO_Seq_write_128K"
dir="$(dirname "$0")"
#echo "$dir"
source "$dir/body_fio.sh"
source "$dir/body_Func.sh"


IO_SEQ_128k $1 



