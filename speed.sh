#!/usr/bin/env bash
#
# Description: A Network Test Script by Suhail
# Copyright (C) 2022 - 2023 Suhail <sh@suh.ovh>
# Thanks: Teddysun <i@teddysun.com> for bench.sh as a base
# URL: http://network-speed.xyz/
# https://github.com/su-haris/network-tester/blob/master/speed.sh
#
trap _exit INT QUIT TERM

_red() {
    printf '\033[0;31;31m%b\033[0m' "$1"
}

_green() {
    printf '\033[0;31;32m%b\033[0m' "$1"
}

_yellow() {
    printf '\033[0;31;33m%b\033[0m' "$1"
}

_blue() {
    printf '\033[0;31;36m%b\033[0m' "$1"
}

_exists() {
    local cmd="$1"
    if eval type type > /dev/null 2>&1; then
        eval type "$cmd" > /dev/null 2>&1
    elif command > /dev/null 2>&1; then
        command -v "$cmd" > /dev/null 2>&1
    else
        which "$cmd" > /dev/null 2>&1
    fi
    local rt=$?
    return ${rt}
}

_exit() {
    _red "\nThe script has been terminated.\n"
    # clean up
    rm -fr speedtest.tgz speedtest-cli benchtest_*
    exit 1
}

get_opsy() {
    [ -f /etc/redhat-release ] && awk '{print $0}' /etc/redhat-release && return
    [ -f /etc/os-release ] && awk -F'[= "]' '/PRETTY_NAME/{print $3,$4,$5}' /etc/os-release && return
    [ -f /etc/lsb-release ] && awk -F'[="]+' '/DESCRIPTION/{print $2}' /etc/lsb-release && return
}

next() {
    printf "%-75s\n" "-" | sed 's/\s/-/g'
}

speed_test() {
    local nodeName="$2"
    [ -z "$1" ] && ./speedtest-cli/speedtest --progress=no --accept-license --accept-gdpr > ./speedtest-cli/speedtest.log 2>&1 || \
    ./speedtest-cli/speedtest --progress=no --server-id=$1 --accept-license --accept-gdpr > ./speedtest-cli/speedtest.log 2>&1

    if [ "$nodeName" = "Nearest" ]; then
        local isp=$(grep -Po 'ISP: \K.*' ./speedtest-cli/speedtest.log)
        echo -e "\n ISP: $(_blue "$isp") \n"
    fi

    if [ $? -eq 0 ]; then
        local dl_speed=$(awk '/Download/{print $3" "$4}' ./speedtest-cli/speedtest.log)
        local up_speed=$(awk '/Upload/{print $3" "$4}' ./speedtest-cli/speedtest.log)
        local latency=$(awk '/Latency/{print $2" "$3}' ./speedtest-cli/speedtest.log)
        local server_details=$(grep -Po 'Server: \K[^(]+' ./speedtest-cli/speedtest.log)
        local packet_loss=$(awk '/Packet Loss/{print $3}' ./speedtest-cli/speedtest.log)

        local dl_data_used=$(awk '/Download/{print $7}' ./speedtest-cli/speedtest.log)
        local dl_data_units=$(awk '/Download/{print $8}' ./speedtest-cli/speedtest.log)

        local up_data_used=$(awk '/Upload/{print $7}' ./speedtest-cli/speedtest.log)
        local up_data_units=$(awk '/Upload/{print $8}' ./speedtest-cli/speedtest.log)

        if [[ "$dl_data_units" =~ "GB" ]]; then
            dl_data_used=$(awk "BEGIN {print $dl_data_used*1024; exit}")
        fi

        if [[ "$up_data_units" =~ "GB" ]]; then
            up_data_used=$(awk "BEGIN {print $up_data_used*1024; exit}")
        fi   

        if [[ "$packet_loss" =~ "Not" ]]; then
            packet_loss="N/A"
        fi

        if [[ -n "${dl_speed}" && -n "${up_speed}" && -n "${latency}" ]]; then
            printf "%-18s%-12s%-8s%-15s%-15s%-12s\n" " ${nodeName}" "${latency}" "${packet_loss}" "${dl_speed}" "${up_speed}" "${server_details}"

            DL_USED=$(awk "BEGIN {print $dl_data_used+$DL_USED; exit}")
            UL_USED=$(awk "BEGIN {print $up_data_used+$UL_USED; exit}")
        else
            printf "%-18s%-12s%-8s%-15s%-15s%-12s\n" " ${nodeName}" "FAILED"   
        fi
    fi
}

speed() {
    DL_USED=0
    UL_USED=0

    speed_test '' 'Nearest'
    echo -e
    speed_test '10112' 'Cochin, IN'
    speed_test '52216' 'Bangalore, IN'
    speed_test '9690'  'Chennai, IN' 
    speed_test '40507' 'Mumbai, IN'
    speed_test '29658' 'Delhi, IN'
    echo -e
    speed_test '22775' 'Los Angeles, US'
    speed_test '22288' 'Dallas, US'
    speed_test '35055' 'New York, US'
    speed_test '1782'  'Seattle, US'
    speed_test '47746' 'Miami, US'
    speed_test '46416' 'Montreal, CA'
    echo -e 
    speed_test '24215' 'Paris, FR'
    speed_test '46712' 'Amsterdam, NL'
    speed_test '51157' 'Warsaw, PL'
    speed_test '37536' 'London, UK'
    speed_test '31448' 'Frankfurt, DE'
    echo -e 
    speed_test '4845'  'Dubai, AE'
    speed_test '22129' 'Fujairah, AE'
    speed_test '14580' 'Jeddah, KSA'
    echo -e 
    speed_test '24447' 'Shanghai, CN'
    speed_test '27594' 'Guangzhou, CN'
    speed_test '1536'  'Hong Kong, SAR'
    speed_test '40508' 'Singapore, SG'
    speed_test '50686' 'Tokyo, JP'

    TOTAL_DATA=$(awk "BEGIN {print $UL_USED+$DL_USED; exit}")
    TOTAL_DATA_IN_GB=$(awk "BEGIN { printf \"%.2f\n\", $TOTAL_DATA/1024; exit }")
}

io_test() {
    (LANG=C dd if=/dev/zero of=benchtest_$$ bs=512k count=$1 conv=fdatasync && rm -f benchtest_$$ ) 2>&1 | awk -F, '{io=$NF} END { print io}' | sed 's/^[ \t]*//;s/[ \t]*$//'
}

calc_size() {
    local raw=$1
    local total_size=0
    local num=1
    local unit="KB"
    if ! [[ ${raw} =~ ^[0-9]+$ ]] ; then
        echo ""
        return
    fi
    if [ "${raw}" -ge 1073741824 ]; then
        num=1073741824
        unit="TB"
    elif [ "${raw}" -ge 1048576 ]; then
        num=1048576
        unit="GB"
    elif [ "${raw}" -ge 1024 ]; then
        num=1024
        unit="MB"
    elif [ "${raw}" -eq 0 ]; then
        echo "${total_size}"
        return
    fi
    total_size=$( awk 'BEGIN{printf "%.1f", '$raw' / '$num'}' )
    echo "${total_size} ${unit}"
}

check_virt(){
    _exists "dmesg" && virtualx="$(dmesg 2>/dev/null)"
    if _exists "dmidecode"; then
        sys_manu="$(dmidecode -s system-manufacturer 2>/dev/null)"
        sys_product="$(dmidecode -s system-product-name 2>/dev/null)"
        sys_ver="$(dmidecode -s system-version 2>/dev/null)"
    else
        sys_manu=""
        sys_product=""
        sys_ver=""
    fi
    if   grep -qa docker /proc/1/cgroup; then
        virt="Docker"
    elif grep -qa lxc /proc/1/cgroup; then
        virt="LXC"
    elif grep -qa container=lxc /proc/1/environ; then
        virt="LXC"
    elif [[ -f /proc/user_beancounters ]]; then
        virt="OpenVZ"
    elif [[ "${virtualx}" == *kvm-clock* ]]; then
        virt="KVM"
    elif [[ "${sys_product}" == *KVM* ]]; then
        virt="KVM"
    elif [[ "${cname}" == *KVM* ]]; then
        virt="KVM"
    elif [[ "${cname}" == *QEMU* ]]; then
        virt="KVM"
    elif [[ "${virtualx}" == *"VMware Virtual Platform"* ]]; then
        virt="VMware"
    elif [[ "${sys_product}" == *"VMware Virtual Platform"* ]]; then
        virt="VMware"
    elif [[ "${virtualx}" == *"Parallels Software International"* ]]; then
        virt="Parallels"
    elif [[ "${virtualx}" == *VirtualBox* ]]; then
        virt="VirtualBox"
    elif [[ -e /proc/xen ]]; then
        if grep -q "control_d" "/proc/xen/capabilities" 2>/dev/null; then
            virt="Xen-Dom0"
        else
            virt="Xen-DomU"
        fi
    elif [ -f "/sys/hypervisor/type" ] && grep -q "xen" "/sys/hypervisor/type"; then
        virt="Xen"
    elif [[ "${sys_manu}" == *"Microsoft Corporation"* ]]; then
        if [[ "${sys_product}" == *"Virtual Machine"* ]]; then
            if [[ "${sys_ver}" == *"7.0"* || "${sys_ver}" == *"Hyper-V" ]]; then
                virt="Hyper-V"
            else
                virt="Microsoft Virtual Machine"
            fi
        fi
    else
        virt="Dedicated"
    fi
}

ip_info() {
    echo " Basic Network Info"
    next
    local net_type="$(wget -qO- http://ip6.me/api/ | cut -d, -f1)"
    local net_ip="$(wget -qO- http://ip6.me/api/ | cut -d, -f2)"

    local response=$(wget -qO- http://ip-api.com/json/$net_ip)

    # local country=$(echo "$response" | jq -r '.country')
    # local region=$(echo "$response" | jq -r '.regionName')
    # local city=$(echo "$response" | jq -r '.city')
    # local isp=$(echo "$response" | jq -r '.isp')
    # local org=$(echo "$response" | jq -r '.org')
    # local as=$(echo "$response" | jq -r '.as')

    local country=$(echo "$response" | grep -Po '"country": *\K"[^"]*"')
    local country=${country//\"}

    local region=$(echo "$response" | grep -Po '"regionName": *\K"[^"]*"')
    local region=${region//\"}

    local region_code=$(echo "$response" | grep -Po '"region": *\K"[^"]*"')
    local region_code=${region_code//\"}

    local city=$(echo "$response" | grep -Po '"city": *\K"[^"]*"')
    local city=${city//\"}

    local isp=$(echo "$response" | grep -Po '"isp": *\K"[^"]*"')
    local isp=${isp//\"}

    local org=$(echo "$response" | grep -Po '"org": *\K"[^"]*"')
    local org=${org//\"}

    local as=$(echo "$response" | grep -Po '"as": *\K"[^"]*"')
    local as=${as//\"}
    

    if [[ -n "$net_type" ]]; then
        echo " Primary Network    : $(_green "$net_type")"
    fi

    if [[ -n "$isp" && -n "$as" ]]; then
        echo " ISP                : $(_blue "$isp")"
        echo " ASN                : $(_blue "$as")"
    fi
    if [[ -n "$org" ]]; then
        echo " Host               : $(_blue "$org")"
    fi
    if [[ -n "$city" && -n "$region" ]]; then
        echo " Location           : $(_yellow "$city, $region ($region_code)")"
    fi
    if [[ -n "$country" ]]; then
        echo " Country            : $(_yellow "$country")"
    fi
}

install_speedtest() {
    if [ ! -e "./speedtest-cli/speedtest" ]; then
        sys_bit=""
        local sysarch="$(uname -m)"
        if [ "${sysarch}" = "unknown" ] || [ "${sysarch}" = "" ]; then
            local sysarch="$(arch)"
        fi
        if [ "${sysarch}" = "x86_64" ]; then
            sys_bit="x86_64"
        fi
        if [ "${sysarch}" = "i386" ] || [ "${sysarch}" = "i686" ]; then
            sys_bit="i386"
        fi
        if [ "${sysarch}" = "armv8" ] || [ "${sysarch}" = "armv8l" ] || [ "${sysarch}" = "aarch64" ] || [ "${sysarch}" = "arm64" ]; then
            sys_bit="aarch64"
        fi
        if [ "${sysarch}" = "armv7" ] || [ "${sysarch}" = "armv7l" ]; then
            sys_bit="armhf"
        fi
        if [ "${sysarch}" = "armv6" ]; then
            sys_bit="armel"
        fi
        [ -z "${sys_bit}" ] && _red "Error: Unsupported system architecture (${sysarch}).\n" && exit 1
        url1="https://install.speedtest.net/app/cli/ookla-speedtest-1.1.1-linux-${sys_bit}.tgz"
        url2="https://dl.lamp.sh/files/ookla-speedtest-1.1.1-linux-${sys_bit}.tgz"
        wget --no-check-certificate -q -T10 -O speedtest.tgz ${url1}
        if [ $? -ne 0 ]; then
            wget --no-check-certificate -q -T10 -O speedtest.tgz ${url2}
            [ $? -ne 0 ] && _red "Error: Failed to download speedtest-cli.\n" && exit 1
        fi
        mkdir -p speedtest-cli && tar zxf speedtest.tgz -C ./speedtest-cli && chmod +x ./speedtest-cli/speedtest
        rm -f speedtest.tgz
    fi
    echo " Speedtest.net"
    next
    printf "%-18s%-12s%-8s%-15s%-15s%-12s\n" " Location" "Latency" "Loss" "DL Speed" "UP Speed" "Server"
}

print_intro() {
    # echo "-------------------- A speed.sh Script By Suhail ---------------------"
    echo "---------------------------- network-speed.xyz ----------------------------"
    echo "      A simple script to test network performance using speedtest-cli      "
    next
    echo " Version            : $(_green 10/02/2023)"
    # echo " Usage              : $(_red "wget -qO- network-speed.xyz | bash")"
}

# Get System information
get_system_info() {
    cname=$( awk -F: '/model name/ {name=$2} END {print name}' /proc/cpuinfo | sed 's/^[ \t]*//;s/[ \t]*$//' )
    cores=$( awk -F: '/processor/ {core++} END {print core}' /proc/cpuinfo )
    freq=$( awk -F'[ :]' '/cpu MHz/ {print $4;exit}' /proc/cpuinfo )
    ccache=$( awk -F: '/cache size/ {cache=$2} END {print cache}' /proc/cpuinfo | sed 's/^[ \t]*//;s/[ \t]*$//' )
    cpu_aes=$( grep -i 'aes' /proc/cpuinfo )
    cpu_virt=$( grep -Ei 'vmx|svm' /proc/cpuinfo )
    tram=$( LANG=C; free | awk '/Mem/ {print $2}' )
    tram=$( calc_size $tram )
    uram=$( LANG=C; free | awk '/Mem/ {print $3}' )
    uram=$( calc_size $uram )
    swap=$( LANG=C; free | awk '/Swap/ {print $2}' )
    swap=$( calc_size $swap )
    uswap=$( LANG=C; free | awk '/Swap/ {print $3}' )
    uswap=$( calc_size $uswap )
    up=$( awk '{a=$1/86400;b=($1%86400)/3600;c=($1%3600)/60} {printf("%d days, %d hour %d min\n",a,b,c)}' /proc/uptime )
    if _exists "w"; then
        load=$( LANG=C; w | head -1 | awk -F'load average:' '{print $2}' | sed 's/^[ \t]*//;s/[ \t]*$//' )
    elif _exists "uptime"; then
        load=$( LANG=C; uptime | head -1 | awk -F'load average:' '{print $2}' | sed 's/^[ \t]*//;s/[ \t]*$//' )
    fi
    opsy=$( get_opsy )
    arch=$( uname -m )
    if _exists "getconf"; then
        lbit=$( getconf LONG_BIT )
    else
        echo ${arch} | grep -q "64" && lbit="64" || lbit="32"
    fi
    kern=$( uname -r )
    disk_total_size=$( LANG=C; df -t simfs -t ext2 -t ext3 -t ext4 -t btrfs -t xfs -t vfat -t ntfs -t swap --total 2>/dev/null | grep total | awk '{ print $2 }' )
    disk_total_size=$( calc_size $disk_total_size )
    disk_used_size=$( LANG=C; df -t simfs -t ext2 -t ext3 -t ext4 -t btrfs -t xfs -t vfat -t ntfs -t swap --total 2>/dev/null | grep total | awk '{ print $3 }' )
    disk_used_size=$( calc_size $disk_used_size )
    tcpctrl=$( sysctl net.ipv4.tcp_congestion_control | awk -F ' ' '{print $3}' )

    virt_type=$(systemd-detect-virt)
    virt_type=${virt_type^^} || virt="UNKNOWN"
}
# Print System information
print_system_info() {
    echo " Basic System Info"
    next

    if [ -n "$cname" ]; then
        echo " CPU Model          : $(_blue "$cname")"
    else
        echo " CPU Model          : $(_blue "CPU model not detected")"
    fi
    if [ -n "$freq" ]; then
        echo " CPU Cores          : $(_blue "$cores @ $freq MHz")"
    else
        echo " CPU Cores          : $(_blue "$cores")"
    fi
    if [ -n "$ccache" ]; then
        echo " CPU Cache          : $(_blue "$ccache")"
    fi
    if [ -n "$cpu_aes" ]; then
        echo " AES-NI             : $(_green "\xE2\x9C\x94 Enabled")"
    else
        echo " AES-NI             : $(_red "\xE2\x9D\x8C Disabled")"
    fi
    if [ -n "$cpu_virt" ]; then
        echo " VM-x/AMD-V         : $(_green "\xE2\x9C\x94 Enabled")"
    else
        echo " VM-x/AMD-V         : $(_red "\xE2\x9D\x8C Disabled")"
    fi
    echo " Total Disk         : $(_yellow "$disk_total_size") $(_blue "($disk_used_size Used)")"
    echo " Total Mem          : $(_yellow "$tram") $(_blue "($uram Used)")"
    if [ "$swap" != "0" ]; then
        echo " Total Swap         : $(_blue "$swap ($uswap Used)")"
    fi
    echo " System uptime      : $(_blue "$up")"
    echo " Load average       : $(_blue "$load")"
    echo " OS                 : $(_blue "$opsy")"
    echo " Arch               : $(_blue "$arch ($lbit Bit)")"
    echo " Kernel             : $(_blue "$kern")"
    echo " Virtualization     : $(_blue "$virt_type")"
}


print_end_time() {
    echo " Total DL Data      : $DL_USED MB"
    echo " Total UL Data      : $UL_USED MB"
    echo " Total Data         : $TOTAL_DATA MB ($TOTAL_DATA_IN_GB GB)"
    
    next

    end_time=$(date +%s)
    time=$(( ${end_time} - ${start_time} ))
    if [ ${time} -gt 60 ]; then
        min=$(expr $time / 60)
        sec=$(expr $time % 60)
        echo " Finished in        : ${min} min ${sec} sec"
    else
        echo " Finished in        : ${time} sec"
    fi
    date_time=$(date '+%Y-%m-%d %H:%M:%S %Z')
    echo " Timestamp          : $date_time"

}

! _exists "wget" && _red "Error: wget command not found.\n" && exit 1
! _exists "free" && _red "Error: free command not found.\n" && exit 1
start_time=$(date +%s)
get_system_info
check_virt
clear
print_intro
next
print_system_info
next
ip_info
next
install_speedtest && speed && rm -fr speedtest-cli
next
print_end_time
next
