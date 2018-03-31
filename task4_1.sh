#!/bin/bash

output_file_name="task4_1.out"
workdir=$(pwd)
output="${workdir}/${output_file_name}"

function collect_hardware() {
  local motherboard="$(dmidecode -s baseboard-manufacturer) $(dmidecode -s baseboard-product-name)"
  if [ -z "${motherboard}" ]; then
    motherboard="Unknown"
  fi
  echo "--- Hardware ---" >> "${output}"
  echo "CPU: $(dmidecode -s processor-version)" >> "${output}"
  echo "RAM: $(dmidecode | grep "Memory Array Mapped Address" -A 5 | grep "Range Size" | awk -F': ' '{print $2}')" >> "${output}"
  echo "Motherboard: ${motherboard}" >> "${output}"
  echo "System Serial Number: $(dmidecode -s system-serial-number)" >> "${output}"
}

function collect_system() {
  echo "--- System ---" >> "${output}"
  echo "OS Distribution: $(cat /etc/issue.net)" >> "${output}"
  echo "Kernel version: $(uname -r)" >> "${output}"
  echo "Installation date: $(tune2fs -l /dev/sda1 | grep "Filesystem created" | awk '{print $4,$5,$7}')" >> "${output}"
  echo "Hostname: $(uname -n)" >> "${output}"
  echo "Uptime: $(uptime -p | cut -d ' ' -f 2-)" >> "${output}"
  echo "Processes running: $(ps ax | wc -l)" >> "${output}"
  echo "User logged in: $(who | wc -l)" >> "${output}"
}

function collect_network() {
  echo "--- Network ---" >> "${output}"
  echo "Interfaces: $(ip -br -4 a | awk -F' ' '{if ( $3 == "" ) print $1": " "-"; else print $1": " $3}')" >> "${output}"
}

collect_hardware
collect_system
collect_network
