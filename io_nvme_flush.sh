#!/bin/bash

TestName="NVMe_Read"

dir="$(dirname "$0")"
#echo "$dir"
source "$dir/body_Func.sh"
#nvme id-ctrl /dev/nvme0n1
#nvme id-ns /dev/nvme0n1
MDTS=$(nvme id-ctrl /dev/nvme0
