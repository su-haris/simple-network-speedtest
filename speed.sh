#!/usr/bin/env bash
#
# nws.sh
# Description: A Network Benchmark Script by sh97 <sh@suh.ovh>
# Copyright (C) 2022 - 2026 <sh@suh.ovh>
# URL: https://nws.sh/
# https://github.com/su-haris/simple-network-speedtest
#

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
    command -v "$1" >/dev/null 2>&1
}

cleanup() {
    if [[ -n "$RUN_DIR" && "$KEEP_RUN_DIR" != true ]]; then
        rm -rf -- "$RUN_DIR"
    fi
}

_exit() {
    _red "\nThe script has been terminated.\n"
    exit "$1"
}

get_opsy() {
    [ -f /etc/redhat-release ] && awk '{print $0}' /etc/redhat-release && return
    [ -f /etc/os-release ] && awk -F'[= "]' '/PRETTY_NAME/{print $3,$4,$5}' /etc/os-release && return
    [ -f /etc/lsb-release ] && awk -F'[="]+' '/DESCRIPTION/{print $2}' /etc/lsb-release && return
}

next() {
    printf '%75s\n' '' | tr ' ' '-'
}

speed_test() {
    local node_name="$2" log="$RUN_DIR/speedtest.log" status=0
    local args=(--progress=no --accept-license --accept-gdpr)
    [[ -n "$1" ]] && args+=("--server-id=$1")
    "$SPEEDTEST_CMD" "${args[@]}" > "$log" 2>&1 || status=$?

    if [[ "$node_name" == Nearest ]]; then
        local isp
        isp=$(sed -n 's/.*ISP: *//p' "$log")
        echo -e "\n ISP: $(_blue "$isp") \n"
    fi
    if grep -q 'Limit reached' "$log"; then
        printf "%-18s%s\n" " $node_name" "FAILED - IP has been rate limited. Try again after 1 hour."
        return
    fi
    if (( status != 0 )); then
        printf "%-18s%s\n" " $node_name" "FAILED"
        return
    fi

    local dl up latency loss server dl_data up_data
    IFS='|' read -r dl up latency loss server dl_data up_data < <(awk '
        function gb(v, u) {
            gsub(/[()]/, "", u)
            if (u == "GB") return v
            if (u == "MB") return v/1024
            if (u == "KB") return v/1048576
            if (u == "B") return v/1073741824
            return ""
        }
        function rate(v, u) {
            if (u == "Mbps") return v
            if (u == "Gbps") return v*1000
            if (u == "Kbps") return v/1000
            if (u == "bps") return v/1000000
            return ""
        }
        /Download:|Upload:/ {
            speed=""; data=""
            for (i=1; i<NF; i++) {
                if ($i ~ /^[0-9]+([.][0-9]+)?$/) {
                    if ($(i+1) ~ /bps$/) speed=rate($i,$(i+1))
                    if ($(i+1) ~ /^(GB|MB|KB|B)[)]?$/) data=gb($i,$(i+1))
                }
            }
            if ($0 ~ /Download:/) {dl=speed; dl_data=data}
            else {up=speed; up_data=data}
        }
        /Latency:/ && latency == "" {
            for (i=2; i<=NF; i++) if ($i == "ms" && $(i-1) ~ /^[0-9]+([.][0-9]+)?$/) {latency=$(i-1) " ms"; break}
        }
        /Packet Loss:/ {loss=($3 == "Not" ? "N/A" : $3)}
        /Server:/ {server=$0; sub(/^.*Server: */, "", server); sub(/ *\(.*/, "", server)}
        END {printf "%s|%s|%s|%s|%s|%s|%s\n", dl,up,latency,loss,server,dl_data,up_data}
    ' "$log")
    if [[ ! "$dl" =~ ^[0-9]+([.][0-9]+)?$ || ! "$up" =~ ^[0-9]+([.][0-9]+)?$ || -z "$latency" || -z "$dl_data" || -z "$up_data" ]]; then
        printf "%-18s%s\n" " $node_name" "N/A - unrecognized result"
        return
    fi
    printf "%-18s%-12s%-8s%-15s%-15s%-12s\n" " $node_name" "$latency" "${loss:-N/A}" "$dl Mbps" "$up Mbps" "$server"
    record_statistics "$dl" "$up" "$dl_data" "$up_data"
}

speed_locations() {
    case "$REGION" in
        india) cat <<'SERVERS'
15171|Mumbai, MH
6879|Mumbai, MH
33603|Pune, MH
12939|Hyderabad, AP/TL
52216|Bangalore, KA
7379|Bangalore, KA
35402|Mangalore, KA
67859|Chennai, TN
9286|Coimbatore, TN
34444|Madurai, TN
10112|Kochi, KL
29372|Kochi, KL
62260|Trivandrum, KL
12221|Kolkata, WB
16273|Ahmedabad, GJ
47162|Jaipur, RJ
36668|Lucknow, UP
29658|Delhi, DL
10020|Gurgaon, HR
49231|Patna, BH
60294|Aizawl, MZ
SERVERS
            ;;
        asia) cat <<'SERVERS'
69575|Tokyo, JP
18445|Tapei, TW
26352|China Telecom
24447|China Unicom
25858|China Mobile
68983|Hong Kong, CN
|
16749|Ho Chi Minh, VN
2552|Hanoi, VN
8990|Bangkok, TH
7167|Manila, PH
|
5935|Singapore, SG
13623|Singapore, SG
13039|Jakarta, ID
56633|Surabaya, ID
52887|Kuala Lum, MY
|
23647|Mumbai, IN
37352|Chennai, IN
52216|Bangalore, IN
32238|Karachi, PK
51628|Islamabad, PK
54919|Kathmandu, NP
60180|Colombo, SL
30815|Dhaka, BD
|
6430|Novosibirsk, RU
38516|Almaty, KZ
|
4317|Tehran, IR
17336|Dubai, AE
1733|Jeddah, SA
3151|Istanbul, TR
SERVERS
            ;;
        middle-east) cat <<'SERVERS'
1692|Abu Dhabi, AE
22129|Dubai, AE
34240|Fujairah, AE
1717|Muscat, OM
11271|Seeb, OM
15570|Sanaa, YE
6193|Doha, QA
51669|Lusail, QA
17574|Manama, BH
52650|Rifa, BH
25444|Kuwait, KW
3290|Kuwait, KW
1402|Riyadh, SA
16051|Dammam, SA
3196|Jeddah, SA
14580|Jeddah, SA
|
4317|Tehran, IR
39247|Baghdad, IQ
27570|Beirut, LB
54384|Nicosia, CY
38212|Tel Aviv, IL
31160|Amman, JO
41251|Cairo, EG
34283|Cairo, EG
3151|Istanbul, TR
SERVERS
            ;;
        na) cat <<'SERVERS'
3049|Vancouver, BC
28801|Calgary, AB
1493|Winnipeg, MB
53393|Toronto, ON
46416|Montreal, QC
|
36817|New York, NY
32493|Ashburn, VA
58326|Durham, NC
35608|Atlanta, GA
35987|Miami, FL
22288|Dallas, TX
1763|Houston, TX
13628|Kansas, MO
15869|Minneapolis, MN
34707|Chicago, IL
15062|Cleveland, OH
1773|Albuquerque, NM
56839|Denver, CO
10162|Portland, OR
64643|Las Vegas, NV
46758|Ogden, UT
27746|Phoenix, AZ
34840|Los Angeles, CA
49365|San Jose, CA
58291|Spokane, WA
6199|Seattle, WA
|
3499|Hermosillo, MX
7945|Guadalajara, MX
54754|Mexico City, MX
SERVERS
            ;;
        sa) cat <<'SERVERS'
21568|Sao Paulo, BR
3065|Rio, BR
21836|Salvador, BR
5181|Buenos, AR
46678|Buenos, AR
58966|Cordoba, AR
58822|Rosario, AR
20212|Montevideo, UY
8017|Santiago, CL
21436|Santiago, CL
3455|Lima, PE
4992|Lima, PE
21800|Quito, EC
49339|Caracas, VE
44095|Bogota, CO
SERVERS
            ;;
        eu) cat <<'SERVERS'
31183|London, UK
23968|Manchester, UK
38092|Dublin, IE
37363|Amsterdam, NL
61933|Paris, FR
61301|Marseille, FR
14979|Madrid, ES
1695|Barcelona, ES
29467|Lisbon, PT
3243|Rome, IT
7839|Milan, IT
23969|Zurich, CH
50771|Frankfurt, DE
55665|Berlin, DE
12777|Vienna, AT
7842|Budapest, HU
23123|Krakow, PL
4166|Warsaw, PL
29259|Lviv, UA
73217|Kyiv, UA
45318|Bucharest, RO
11500|Timisoara, RO
22669|Helsinki, FI
34024|Stockholm, SE
31861|Oslo, NO
31851|Istanbul, TR
SERVERS
            ;;
        au) cat <<'SERVERS'
18473|Brisbane
44735|Sydney
12492|Sydney
15136|Perth
12494|Perth
43024|Melbourne
12491|Melbourne
13277|Adelaide
18711|Canberra
|
4953|Auckland
5749|Auckland
11327|Auckland
SERVERS
            ;;
        africa) cat <<'SERVERS'
2962|Cape Town, ZA
1491|Cape Town, ZA
21570|Johannesburg, ZA
56612|Harare, ZW
28816|Maputo, MZ
7755|Antananarivo, MG
3846|Darusalaam, TZ
8402|Nairobi, KE
48973|Addis Ababa, ET
34283|Cairo, EG
26790|Alexandria, EG
54524|Rabat, MA
15631|Algiers, DZ
33159|Lagos, NG
SERVERS
            ;;
        iran) cat <<'SERVERS'
4317|Tehran
21031|Tehran
19534|Tehran
43844|Tehran
10076|Mashhad
22295|Mashhad
22297|Shiraz
22245|Isfahan
9888|Tabriz
SERVERS
            ;;
        russia) cat <<'SERVERS'
1907|Moscow
48192|Moscow
10987|Moscow
44806|Moscow
45191|Moscow
|
6051|Petersburg
42152|Petersburg
39860|Kazan
22240|Kazan
65185|Sevastopol
41096|Kaliningrad
37042|Volgograd
|
39503|Omsk
6430|Novosibirsk
3545|Krasnoyarsk
9679|Yakutsk
54169|Vladivostok
SERVERS
            ;;
        indonesia) cat <<'SERVERS'
14325|Jakarta
49585|Jakarta
56632|Jakarta
13039|Jakarta
11118|Jakarta
|
5065|Bandung
32223|Bekasi
63223|Bogor
40832|Malang
47972|Semarang
46091|Surabaya
24587|Yogyakarta
|
59117|Banda Aceh
61882|Medan
50465|Palembang
53101|Pekanbaru
|
46113|Makassar
45520|Depok
47361|Tangerang
SERVERS
            ;;
        china) cat <<'SERVERS'
24447|CU - Shanghai
25858|CM - Beijing
43752|CU - Beijing
26352|CT - Nanjing
60584|CT - Shenzen
36663|CT - Zhenjiang
37235|CU - Shenyang
5396|CT - Suzhou
5317|CT - Yangzhou
54312|CM - Hangzhou
59386|CT - Hangzhou
36646|CU - Zhengzhou
28225|CT - Changsha
4870|CU - Changsha
4575|CM - Chengdu
45170|CU - Wu Xi
17145|CT - Hefei
34115|CT - TianJin
62416|CT - XiNing
59387|CT - NingBo
60794|CM - Guangzhou
|
32155|CM - Kwai Chung
37639|CM - Hong Kong
37695|CU - Hong Kong
28912|Hong Kong
44745|Hong Kong
SERVERS
            ;;
        10gplus) cat <<'SERVERS'
55137|London, UK
30376|London, UK
13764|Amsterdam, NL
51395|Amsterdam, NL
61933|Paris, FR
62943|Frankfurt, DE
37492|Frankfurt, DE
7839|Milan, IT
29467|Lisbon, PT
14979|Madrid, ES
65089|Warsaw, PL
|
8864|Seattle, WA
50081|Los Angeles, CA
14236|Los Angeles, CA
5919|Chicago, IL
14238|Dallas, TX
46120|New York, NY
62109|Miami, FL
|
48463|Tokyo, JP
SERVERS
            ;;
        global) cat <<'SERVERS'
52216|Bangalore, IN
9591|Chennai, IN
61281|Mumbai, IN
|
1782|Seattle, US
34840|Los Angeles, US
22288|Dallas, US
14237|Miami, US
46120|New York, US
46143|Toronto, CA
54754|Mexico City, MX
|
37536|London, UK
72877|Amsterdam, NL
61933|Paris, FR
35692|Frankfurt, DE
37249|Warsaw, PL
11494|Bucharest, RO
46685|Moscow, RU
|
14580|Jeddah, SA
17336|Dubai, AE
31851|Istanbul, TR
4317|Tehran, IR
16744|Cairo, EG
|
69575|Tokyo, JP
24447|Shanghai, CU-CN
44745|Hong Kong, CN
2054|Singapore, SG
63138|Jakarta, ID
|
15132|Sydney, AU
SERVERS
            ;;
    esac
}

speed() {
    reset_statistics
    speed_test '' 'Nearest'
    echo
    local server_id name
    while IFS='|' read -r server_id name; do
        if [[ -z "$server_id" ]]; then
            echo
        else
            speed_test "$server_id" "$name"
        fi
    done < <(speed_locations)
    finalize_statistics
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
    total_size=$(awk -v raw="$raw" -v num="$num" 'BEGIN {printf "%.1f", raw/num}')
    echo "${total_size} ${unit}"
}

detect_connectivity() {
    local version
    IPV4_AVAILABLE=false IPV6_AVAILABLE=false
    for version in 4 6; do
        if ping "-$version" -c 1 -W 4 "ipv${version}.google.com" >/dev/null 2>&1 ||
           wget -qO- -T 5 "-$version" icanhazip.com 2>/dev/null | grep -q .; then
            if [[ "$version" == 4 ]]; then IPV4_AVAILABLE=true; else IPV6_AVAILABLE=true; fi
        fi
    done
}

json_field() {
    awk -v key="$1" '
        match($0, "\"" key "\"[[:space:]]*:[[:space:]]*\"") {
            value=substr($0,RSTART+RLENGTH); sub(/".*/, "", value); print value; exit
        }' <<< "$2"
}

ip_info() {
    echo " Basic Network Info"
    next
    local net_type net_ip response response_ipv4
    net_type=$(wget -T 5 -qO- http://ip6.me/api/ | cut -d, -f1)

    net_ip=$(wget -T 5 -qO- http://icanhazip.com)

    response=$(wget -qO- -T 5 "http://ip-api.com/json/$net_ip")

    local country
    country=$(json_field "country" "$response")

    local region
    region=$(json_field "regionName" "$response")

    local region_code
    region_code=$(json_field "region" "$response")

    local city
    city=$(json_field "city" "$response")

    local isp
    isp=$(json_field "isp" "$response")

    local org
    org=$(json_field "org" "$response")

    local as
    as=$(json_field "as" "$response")

    # This lookup retains the IPv4-specific ASN and location.

    response_ipv4=$(wget -qO- -T 5 http://ipinfo.io)

    local ipv4_city
    ipv4_city=$(json_field "city" "$response_ipv4")

    local ipv4_region
    ipv4_region=$(json_field "region" "$response_ipv4")

    local ipv4_country
    ipv4_country=$(json_field "country" "$response_ipv4")

    local ipv4_asn
    ipv4_asn=$(json_field "org" "$response_ipv4")

    if [[ -n "$net_type" ]]; then
        echo " Primary Network    : $(_green "$net_type")"
    fi

    if [[ "$IPV6_AVAILABLE" == true ]]; then
        echo " IPv6 Access        : $(_green "\xE2\x9C\x94 Online")"
    else
        echo " IPv6 Access        : $(_red "\xE2\x9D\x8C Offline")"
    fi

    if [[ "$IPV4_AVAILABLE" == true ]]; then
        echo " IPv4 Access        : $(_green "\xE2\x9C\x94 Online")"
    else
        echo " IPv4 Access        : $(_red "\xE2\x9D\x8C Offline")"
    fi

    if [[ -n "$isp" ]]; then
        echo " ISP                : $(_blue "$isp")"
    else
        echo " ISP                : Unknown"
    fi

    if [[ -n "$as" ]]; then
        echo " ASN                : $(_blue "$as")"
    else
        echo " ASN                : Unknown"
    fi

    if [[ "$ipv4_asn" != "$as" ]]; then
        echo " ASN (IPv4)         : $(_blue "$ipv4_asn")"
    fi   

    if [[ -n "$org" ]]; then
        echo " Host               : $(_blue "$org")"
    fi

    if [[ -n "$city" && -n "$region" && -n "$country" ]]; then
        echo " Location           : $(_yellow "$city, $region-$region_code, $country")"
    fi

    if [[ "$ipv4_city" != "$city" && "$ipv4_region" != "$region" && -n "$ipv4_city" && -n "$ipv4_region" && -n "$ipv4_country" ]]; then
        echo " Location (IPv4)    : $(_yellow "$ipv4_city, $ipv4_region, $ipv4_country")"
    fi    
}

binary_arch() {
    local machine
    machine=$(uname -m)
    [[ -z "$machine" || "$machine" == unknown ]] && machine=$(arch)
    case "$machine:$1" in
        x86_64:ookla) echo x86_64 ;;
        i386:ookla|i686:ookla) echo i386 ;;
        armv7:ookla|armv7l:ookla) echo armhf ;;
        armv6:ookla) echo armel ;;
        x86_64:iperf) echo x64 ;;
        i386:iperf|i686:iperf) echo x86 ;;
        armv7:iperf|armv7l:iperf) echo arm ;;
        armv8:*|armv8l:*|aarch64:*|arm64:*) echo aarch64 ;;
        *) _red "Error: Unsupported system architecture ($machine) for $1.\n" >&2; return 1 ;;
    esac
}

download_binary() {
    local url="$1" destination="$2"
    if wget -q -t 2 -T 15 -O "$destination" "$url" && [[ -s "$destination" ]]; then
        return 0
    fi
    _exists curl && curl -fsSL --connect-timeout 15 --max-time 60 -o "$destination" "$url" && [[ -s "$destination" ]]
}

install_speedtest() {
    local architecture archive="$RUN_DIR/speedtest.tgz"
    architecture=$(binary_arch ookla) || return 1
    SPEEDTEST_CMD="$RUN_DIR/speedtest/speedtest"
    if ! download_binary "https://install.speedtest.net/app/cli/ookla-speedtest-1.2.0-linux-${architecture}.tgz" "$archive" &&
       ! download_binary "https://dl.lamp.sh/files/ookla-speedtest-1.2.0-linux-${architecture}.tgz" "$archive"; then
        _red "Error: Failed to download speedtest-cli.\n"
        return 1
    fi
    mkdir -p "$RUN_DIR/speedtest" && tar zxf "$archive" -C "$RUN_DIR/speedtest" && chmod +x "$SPEEDTEST_CMD" || return 1
    echo " Speedtest.net (Region: $REGION_NAME)"
    next
    printf "%-18s%-12s%-8s%-15s%-15s%-12s\n" " Location" "Latency" "Loss" "DL Speed" "UP Speed" "Server"
}

print_intro() {
    echo "---------------------------------- nws.sh ---------------------------------"
    echo "      A simple script to bench network performance using speedtest-cli     "
    next
    echo " Version            : $(_green v2026.10.07)"
    echo " Global Speedtest   : $(_red "wget -qO- nws.sh | bash")"
    echo " Region Speedtest   : $(_red "wget -qO- nws.sh | bash -s -- -r <region>")"
    echo " iperf3 test        : $(_red "wget -qO- nws.sh | bash -s -- -iperf")"
    echo " Ping & Routing     : $(_red "wget -qO- nws.sh | bash -s -- -rt <region>")"
}

get_disk_data() {
    LC_ALL=C df -kP -t simfs -t ext2 -t ext3 -t ext4 -t btrfs -t xfs -t vfat -t ntfs -t swap 2>/dev/null | awk '
        NR > 1 && !seen[$1]++ {total+=$2; used+=$3}
        END {printf "%.0f %.0f\n", total,used}'
}

get_system_info() {
    cname=$( awk -F: '/model name/ {name=$2} END {print name}' /proc/cpuinfo | sed 's/^[ \t]*//;s/[ \t]*$//' )
    cores=$( awk -F: '/model name/ {core++} END {print core}' /proc/cpuinfo )
    freq=$( awk -F'[ :]' '/cpu MHz/ {print $4;exit}' /proc/cpuinfo )
    ccache=$( awk -F: '/cache size/ {cache=$2} END {print cache}' /proc/cpuinfo | sed 's/^[ \t]*//;s/[ \t]*$//' )
    cpu_aes=$( grep -i 'aes' /proc/cpuinfo )
    cpu_virt=$( grep -Ei 'vmx|svm' /proc/cpuinfo )
    read -r tram uram swap uswap < <(LC_ALL=C free | awk '/Mem/ {total=$2; used=$3} /Swap/ {print total,used,$2,$3}')
    tram=$(calc_size "$tram")
    uram=$(calc_size "$uram")
    swap=$(calc_size "$swap")
    uswap=$(calc_size "$uswap")
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
        [[ "$arch" == *64* ]] && lbit=64 || lbit=32
    fi
    kern=$( uname -r )
    read -r disk_total_size disk_used_size < <(get_disk_data)
    disk_total_size=$(calc_size "$disk_total_size")
    disk_used_size=$(calc_size "$disk_used_size")
    tcpctrl=$( sysctl net.ipv4.tcp_congestion_control | awk -F ' ' '{print $3}' )

    virt_type=$(systemd-detect-virt 2>/dev/null | tr '[:lower:]' '[:upper:]')
    virt_type=${virt_type:-UNKNOWN}
}
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
    echo " Total RAM          : $(_yellow "$tram") $(_blue "($uram Used)")"
    if [ "$swap" != "0" ]; then
        echo " Total Swap         : $(_blue "$swap ($uswap Used)")"
    fi
    echo " System uptime      : $(_blue "$up")"
    echo " Load average       : $(_blue "$load")"
    echo " OS                 : $(_blue "$opsy")"
    echo " Arch               : $(_blue "$arch ($lbit Bit)")"
    echo " Kernel             : $(_blue "$kern")"
    echo " Virtualization     : $(_blue "$virt_type")"
    echo " TCP Control        : $(_blue "$tcpctrl")"
}

reset_statistics() {
    DL_SUM=0 UL_SUM=0 DL_TOTAL_GB=0 UL_TOTAL_GB=0 SUCCESS_TEST=0
}

record_statistics() {
    local dl="$1" up="$2"
    local count=0
    # Retain data from a successful direction even when its counterpart fails.
    if [[ -n "$dl" && -n "$up" ]]; then
        count=1
    else
        dl=0 up=0
    fi
    IFS='|' read -r DL_SUM UL_SUM DL_TOTAL_GB UL_TOTAL_GB < <(awk \
        -v ds="$DL_SUM" -v us="$UL_SUM" -v dt="$DL_TOTAL_GB" -v ut="$UL_TOTAL_GB" \
        -v dl="$dl" -v up="$up" -v dd="${3:-0}" -v ud="${4:-0}" \
        'BEGIN {printf "%.10f|%.10f|%.10f|%.10f\n", ds+dl,us+up,dt+dd,ut+ud}')
    SUCCESS_TEST=$((SUCCESS_TEST + count))
}

finalize_statistics() {
    IFS='|' read -r AVG_DL_SPEED AVG_UL_SPEED DL_USED_IN_GB UL_USED_IN_GB TOTAL_DATA_IN_GB < <(awk \
        -v dl="$DL_SUM" -v up="$UL_SUM" -v n="$SUCCESS_TEST" -v dd="$DL_TOTAL_GB" -v ud="$UL_TOTAL_GB" \
        'BEGIN {printf "%.2f|%.2f|%.2f|%.2f|%.2f\n", n ? dl/n : 0,n ? up/n : 0,dd,ud,dd+ud}')
}

print_network_statistics() {
    echo " Avg DL Speed       : $AVG_DL_SPEED Mbps"
    echo " Avg UL Speed       : $AVG_UL_SPEED Mbps"
    echo
    echo " Total DL Data      : $DL_USED_IN_GB GB"
    echo " Total UL Data      : $UL_USED_IN_GB GB"
    echo " Total Data         : $TOTAL_DATA_IN_GB GB"
}

print_end_time() {
    end_time=$(date +%s)
    time=$((end_time - start_time))
    if [ ${time} -gt 60 ]; then
        min=$((time / 60))
        sec=$((time % 60))
        echo " Duration           : ${min} min ${sec} sec"
    else
        echo " Duration           : ${time} sec"
    fi
    date_time=$(date '+%d/%m/%Y - %H:%M:%S %Z')
    echo " System Time        : $date_time"

}

get_runs_counter() {
    local counter
    counter=$(wget -T 5 -t 1 -qO- https://runs.nws.sh/)

    if [[ -n "$counter" ]]; then
        echo " Total Script Runs  : $(_green "$counter")"
    fi
}

asn_provider() {
    case "$1" in
        AS174) echo "Cogent" ;;
        AS3356) echo "Lumen" ;;
        AS2914) echo "NTT" ;;
        AS3257) echo "GTT" ;;
        AS6453) echo "TATA" ;;
        AS1299) echo "Arelion" ;;
        AS3491) echo "PCCW Global" ;;
        AS6762) echo "Telecom Italia" ;;
        AS1239) echo "Sprint" ;;
        AS701) echo "Verizon" ;;
        AS6939) echo "Hurricane Electric" ;;
        AS6830) echo "Liberty Global" ;;
        AS6461) echo "Zayo" ;;
        AS3320) echo "Deutsche Telekom" ;;
        AS5511) echo "Orange France" ;;
        *) echo "$1" ;;
    esac
}

cn_get_as_path() {
    local as_path="$1" asn preceding_asn=""
    for asn in $as_path; do
        [[ "$asn" =~ ^AS(4134|4837|58453|4809|9929|58807)$ ]] && break
        preceding_asn="$asn"
    done
    echo "$as_path|$preceding_asn"
}

cn_get_line_type() {
    local as_path=${1%|*} preceding_asn=${1#*|}
    local line_type="Unknown Line |Path not recognized" via_info="via Direct Peering"
    # Classification priority is intentional when several Chinese ASNs occur.
    case " $as_path " in
        *" AS4809 "*) line_type="Premium Line |CN2 China Telecom Next Generation" ;;
        *" AS9929 "*) line_type="Premium Line |CUIB CHINA UNICOM Industrial Internet" ;;
        *" AS58807 "*) line_type="Premium Line |CMIN2 China Mobile International" ;;
        *" AS4134 "*) line_type="Standard Line |China Telecom Backbone" ;;
        *" AS4837 "*) line_type="Standard Line |China Unicom Backbone 169" ;;
        *" AS58453 "*) line_type="Standard Line |China Mobile International" ;;
    esac
    [[ -n "$preceding_asn" ]] && via_info="via $(asn_provider "$preceding_asn")"
    echo "$line_type $via_info"
}

routing_locations() {
    case "$REGION" in
        asia) cat <<'LOCATIONS'
SG - Singapore: CDN77|89.187.162.1
SG - Singapore: LeaseWeb Asia|103.254.153.18
SG - Singapore: Host Universal|207.2.122.3
SG - Singapore: HostHatch|103.167.150.90
SG - Singapore: HE|core2.sin1.he.net
SG - Singapore: ZenLayer|001.sin2.sg.k1s.zenlayer.win
SG - Singapore: TATA|gin-asina-tcore1.as6453.net
SG - Singapore: Telstra|202.84.219.173
JP - Tokyo: xTom|103.201.131.131
JP - Tokyo: Shock Hosting|43.230.161.31
JP - Tokyo: SoftBank|103.214.168.128
JP - Tokyo: CDN77|89.187.160.1
JP - Osaka: Vultr|64.176.34.94
JP - Tokyo: HE|core2.tyo1.he.net
HK - Hong Kong: ZenLayer|006.hkg3.hk.k1s.zenlayer.win
HK - Hong Kong: GCore|5.188.230.129
HK - Hong Kong: LeaseWeb Asia|43.249.36.49
HK - Hong Kong: HE|core2.hkg2.he.net
HK - Hong Kong: CDN77|84.17.57.129
HK - Hong Kong: Telstra|202.84.173.22
SK - Busan: Telstra|202.84.149.162
ID - Jakarta: WarnaHost|103.157.146.2
IN - Mumbai: Vultr|65.20.66.100
IN - Mumbai: Jio|49.44.93.128
IN - Kochi: Airtel|125.21.255.190
IN - Chennai: Linode|speedtest-1.maa1.in.prod.linode.com
IN - Chennai: ZenLayer|001.maa2.in.k1s.zenlayer.win
IN - Chennai: Jio|49.44.93.133
VN - Hanoi: GreenCloud|103.199.17.252
VN - Ho Chi Minh: FPT Telecom|103.186.65.98
PK - Islamabad: Virtury|103.151.111.249
LOCATIONS
            ;;
        na) cat <<'LOCATIONS'
US - Seattle: xTom|23.145.48.48
US - Liberty Lake: Crunchbits|104.36.84.66
US - San Jose: CDN77|156.146.53.53
US - Hillsboro: OVH|51.81.154.196
US - Fremont: Hurricane Electric|core1.fmt2.he.net
US - Los Angeles: Multacom|204.13.154.3
US - Los Angeles: ReliableSite|104.238.206.46
US - Los Angeles: WebNX|64.185.232.162
US - Chicago: Psychz Networks|108.181.140.235
US - Chicago: VirMach|89.33.192.5
US - Kansas City: FreeRangeCloud|23.152.226.2
US - Kansas: IncogNET|23.137.254.200
US - Dallas: GSL|216.146.25.35
US - Salt Lake City: FiberState|38.92.25.252
US - Ashburn: ColoCrossing|192.3.254.158
US - Buffalo: ColoCrossing|192.3.180.103
US - Durham: Cogent|38.45.64.1
US - New York: ReliableSite|104.243.42.233
US - Secaucus: Royale Hosting|45.137.206.1
US - Atlanta: Flexential|82.153.68.71
US - Miami: ReliableSite|104.238.204.68
CA - Vancouver: Hurricane Electric|104.218.61.164
CA - Vancouver: FreeRangeCloud|23.154.81.1
CA - Calgary: FreeRangeCloud|23.133.64.25
CA - Toronto: Amanah|172.93.167.178
CA - Montreal: OVH|51.222.154.207
CA - Halifax: FreeRangeCloud|23.191.80.33
LOCATIONS
            ;;
        eu) cat <<'LOCATIONS'
UK - London: Clouvider|185.42.223.1
UK - London: KuroIT|178.239.171.5
UK - London: CDN77|185.59.221.51
UK - Coventry: UKDedicated|94.229.65.150
UK - Manchester: M247|89.238.129.146
NL - Amsterdam: Clouvider|194.127.172.33
NL - Amsterdam: CDN77|185.102.218.1
NL - Amsterdam: xTom|78.142.195.195
DE - Hamburg: CSN-Solutions|91.108.80.101
DE - Frankfurt: CDN77|185.102.219.93
DE - Frankfurt: Clouvider|91.199.118.14
DE - Falkenstein: Hetzner|fsn1-speed.hetzner.com
DE - Nuremberg: Hetzner|nbg1-speed.hetzner.com
FR - Paris: M247|185.94.189.162
FR - Marseille: CDN77|138.199.14.66
AT - Langenzersdorf: Hohl IT|86.106.182.189
IT - Arezzo: ArubaCloud|188.213.160.1
NO - Sandefjord: GigaHost|185.125.168.212
PL - Warsaw: CDN77|185.246.208.67
FI - Helsinki: Hetzner|hel1-speed.hetzner.com
LV - Riga: MLCloud|194.26.27.1
RO - Bucharest: CDN77|185.102.217.170
RO - Bucharest: M247|185.45.12.22
RU - Moscow: Misaka|45.142.246.177
RU - St Petersburg: Misaka|45.131.70.138
RU - St Petersburg: MLCloud|45.141.84.1
RU - Kazan: MLCloud|176.98.187.1
BG - Sofia: AlphaVPS|79.124.7.8
LOCATIONS
            ;;
        global) cat <<'LOCATIONS'
JP - Tokyo: SoftBank|103.214.168.128
JP - Tokyo: HE|core2.tyo1.he.net
HK - Hong Kong: GCore|5.188.230.129
HK - Hong Kong: LeaseWeb Asia|43.249.36.49
VN - Ho Chi Minh: FPT Telecom|103.186.65.98
SG - Singapore: CDN77|89.187.162.1
SG - Singapore: TATA|gin-asina-tcore1.as6453.net
IN - Chennai: Linode|speedtest-1.maa1.in.prod.linode.com
IN - Mumbai: Jio|49.44.93.128
IR - Tehran: ArvanCloud|37.32.0.1
IR - Isfahan: Webdade|194.5.50.94
RU - Moscow: Misaka|45.142.246.177
RO - Bucharest: M247|185.45.12.22
DE - Falkenstein: Hetzner|fsn1-speed.hetzner.com
FR - Paris: M247|185.94.189.162
NL - Amsterdam: Clouvider|194.127.172.33
UK - London: CDN77|185.59.221.51
CA - Montreal: OVH|51.222.154.207
US - Buffalo: ColoCrossing|192.3.180.103
US - New York: ReliableSite|104.243.42.233
US - Miami: ReliableSite|104.238.204.68
US - Chicago: Psychz Networks|108.181.140.235
US - Dallas: GSL|216.146.25.35
US - Seattle: xTom|23.145.48.48
US - Los Angeles: WebNX|64.185.232.162
LOCATIONS
            ;;
        au) cat <<'LOCATIONS'
AU - Sydney: CDN77|143.244.63.144
AU - Sydney: xTom|syd-v4.lg.v.ps
AU - Perth: Telstra|202.84.221.242
AU - Brisbane: ConXt|202.174.110.136
AU - Melbourne: BinaryLane|103.236.162.1
AU - Melbourne: Aussie Broadband|121.200.10.3
NZ - Auckland: Telstra|202.84.227.54
LOCATIONS
            ;;
        china) cat <<'LOCATIONS'
Beijing - China Telecom|219.141.136.12
Beijing - China Unicom|202.106.50.1
Beijing - China Mobile|221.179.155.161
Beijing - CERNET|101.6.15.66
Shanghai - China Telecom|202.96.209.133
Shanghai - China Unicom|210.22.97.1
Shanghai - China Mobile|211.136.112.200
Guangzhou - China Telecom|58.60.188.222
Guangzhou - China Unicom|210.21.196.6
Guangzhou - China Mobile|120.196.165.24
Chengdu - China Telecom|61.139.2.69
Chengdu - China Unicom|119.6.6.6
Chengdu - China Mobile|211.137.96.205
Shenzhen - China Telecom|106.4.158.58
Shenzhen - China Unicom|221.194.154.193
Shenzhen - China Mobile|223.111.101.29
LOCATIONS
            ;;
    esac
}

routing_ping_test() {
    if ! _exists ping; then
        echo "N/A"
        return
    fi
    LC_ALL=C ping -c 5 -W 4 "$1" 2>/dev/null | awk -F / '
        /packet loss/ {
            line=$0; sub(/% packet loss.*/, "", line); sub(/^.* /, "", line); loss=line
        }
        /min\/avg\/max/ {latency=sprintf("%.0f", $5)}
        END {
            if (latency == "") print "Failed"
            else if (loss == "0") print latency "ms [No Loss]"
            else if (loss != "") print latency "ms [" loss "% loss]"
            else print latency "ms [Loss N/A]"
        }'
}

routing_get_as_path() {
    timeout 30 mtr -wz -c 3 "$1" 2>/dev/null | awk '
        {for (i=1; i<=NF; i++) if ($i ~ /^AS[0-9]+$/ && !seen[$i]++) path=path (path ? " " : "") $i}
        END {print path}'
}

print_routing_header() {
    echo " Ping & Routing Test (Region: $REGION_NAME)"
    next
    printf "%-${1}s | %s\n" " Network" "Details"
    next
}

routing_test() {
    local width=39 location ip ping_result as_path line_type
    [[ "$REGION" == china ]] && width=29
    print_routing_header "$((width + 1))"
    while IFS='|' read -r location ip; do
        ping_result=$(routing_ping_test "$ip")
        as_path=$(routing_get_as_path "$ip")
        printf " %-${width}s | %s\n" "$location" "$ping_result"
        printf " %-${width}s | %s\n" "$ip" "$as_path"
        if [[ "$REGION" == china ]]; then
            if [[ -n "$as_path" ]]; then
                line_type=$(cn_get_line_type "$(cn_get_as_path "$as_path")")
            else
                line_type="Unknown Line |Path not recognized"
            fi
            printf " %-${width}s | %s\n" "${line_type%%|*}" "${line_type#*|}"
        fi
        next
    done < <(routing_locations)
}
# Adapted from YABS (yet-another-bench-script)

install_iperf() {
    if _exists iperf3; then
        IPERF_CMD=$(command -v iperf3)
        return 0
    fi
    local architecture release=iperf3-3.21
    architecture=$(binary_arch iperf) || return 1
    IPERF_CMD="$RUN_DIR/iperf3"
    # YABS publishes static binaries as release assets rather than files on master.
    if ! download_binary "https://github.com/masonr/yet-another-bench-script/releases/download/${release}/iperf3_${architecture}" "$IPERF_CMD"; then
        _red "Error: Failed to download iperf3 binary.\n"
        return 1
    fi
    chmod +x "$IPERF_CMD"
}

iperf_direction_test() {
    local url="$1" ports="$2" flags="$3" attempt port output result status
    local direction=()
    [[ "$4" == download ]] && direction=(-R)
    for attempt in 1 2 3; do
        port=$(shuf -i "$ports" -n 1) || return 1
        status=0
        output=$(timeout 15 "$IPERF_CMD" "$flags" -c "$url" -p "$port" -P 8 "${direction[@]}" 2>/dev/null) || status=$?
        result=$(awk '/\[SUM\]/ && /receiver/ {line=$0} END {print line}' <<< "$output")
        if (( status == 0 )) && [[ "$output" != *error* ]] && awk 'NF >= 8 && $6 ~ /^[0-9]+([.][0-9]+)?$/ && $6+0 > 0 {ok=1} END {exit !ok}' <<< "$result"; then
            echo "$result"
            return 0
        fi
        [[ "$output" == *"unable to connect"* ]] && break
        (( attempt < 3 )) && sleep 2
    done
    return 1
}

parse_iperf_result() {
    # Receiver summary fields: [SUM], interval, sec, data, unit, rate, unit, receiver.
    awk '
        NF >= 8 && $4 ~ /^[0-9]+([.][0-9]+)?$/ && $6 ~ /^[0-9]+([.][0-9]+)?$/ {
            if ($7 == "bits/sec") speed=$6/1000000
            else if ($7 == "Kbits/sec") speed=$6/1000
            else if ($7 == "Mbits/sec") speed=$6
            else if ($7 == "Gbits/sec") speed=$6*1000
            else if ($7 == "Tbits/sec") speed=$6*1000000
            else exit
            if ($5 == "Bytes") data=$4/1073741824
            else if ($5 == "KBytes") data=$4/1048576
            else if ($5 == "MBytes") data=$4/1024
            else if ($5 == "GBytes") data=$4
            else if ($5 == "TBytes") data=$4*1024
            else exit
            if (speed > 0) printf "%.10f|%.10f\n", speed,data
        }' <<< "$1"
}

iperf_locations() {
    cat <<'SERVERS'
speedtest.nyc.purevoltage.com|5201-5210|New York, US|PureVoltage|40G|IPv4|US
speedtest.nocix.net|5201-5205|Kansas City, US|Nocix|200G|IPv4,IPv6|US
speedtest.lax12.us.leaseweb.net|5201-5210|Los Angeles, US|Leaseweb|10G|IPv4,IPv6|US
66.35.22.79|30000-30000|Ashburn, US|Fortinet|10G|IPv4|US
speedtest.xmission.com|5201-5209|Salt Lake, US|XMission|10G|IPv4,IPv6|US
iperf3-vie-at.alwyzon.net|5201-5210|Vienna, AT|Alwyzon|200G|IPv4,IPv6|EU
a210.speedtest.wobcom.de|5201-5201|Frankfurt, DE|Wobcom|50G|IPv4,IPv6|EU
iperf.online.net|5200-5209|Paris, FR|Online.net|100G|IPv4|EU
speedtest.lon1.uk.leaseweb.net|5202-5210|London, UK|Leaseweb|10G|IPv4,IPv6|EU
speedtest.ams1.novogara.net|5200-5209|Amsterdam, NL|Novogara|20G|IPv4,IPv6|EU
speed.cosmonova.net|5201-5209|Kyiv, UA|Cosmonova|40G|IPv4|EU
speedtest.syd12.au.leaseweb.net|5201-5210|Sydney, AU|Leaseweb|10G|IPv4,IPv6|APAC
iperf-sin1.vsys.host|5201-5201|Singapore, SG|VSYS-Host|10G|IPv4|APAC
bom.proof.ovh.net|5201-5210|Mumbai, IN|OVH|10G|IPv4,IPv6|APAC
SERVERS
}

iperf_speed() {
    reset_statistics
    local modes=() mode flags prev_group url ports name host port_speed networks group
    local send recv dl up dl_data up_data dl_display up_display latency
    [[ "$IPV4_AVAILABLE" == true ]] && modes+=(IPv4)
    [[ "$IPV6_AVAILABLE" == true ]] && modes+=(IPv6)
    if (( ${#modes[@]} == 0 )); then
        echo " No IPv4 or IPv6 connectivity detected. Skipping iperf3 tests."
        finalize_statistics
        return
    fi
    echo " iperf3 (Region: GLOBAL)"
    next
    printf "%-18s%-12s%-8s%-15s%-15s%-12s\n" " Location" "Latency" "Port" "DL Speed" "UP Speed" "Server"
    for mode in "${modes[@]}"; do
        flags=-4
        [[ "$mode" == IPv6 ]] && flags=-6
        echo -e "\n Network Mode: $(_blue "$mode") \n"
        prev_group=""
        while IFS='|' read -r url ports name host port_speed networks group; do
            [[ "$networks" == *"$mode"* ]] || continue
            [[ -n "$prev_group" && "$prev_group" != "$group" ]] && echo
            prev_group="$group"
            send=$(iperf_direction_test "$url" "$ports" "$flags" upload)
            sleep 1
            recv=$(iperf_direction_test "$url" "$ports" "$flags" download)
            IFS='|' read -r up up_data < <(parse_iperf_result "$send")
            IFS='|' read -r dl dl_data < <(parse_iperf_result "$recv")
            dl_display="N/A" up_display="N/A"
            [[ -n "$dl" ]] && dl_display=$(awk -v v="$dl" 'BEGIN {printf "%.2f Mbps", v}')
            [[ -n "$up" ]] && up_display=$(awk -v v="$up" 'BEGIN {printf "%.2f Mbps", v}')
            latency="--"
            if _exists ping; then
                latency=$(ping "$flags" -c 1 -W 4 "$url" 2>/dev/null | sed -n 's/.*time=//p' | head -1)
                latency=${latency:---}
            fi
            record_statistics "$dl" "$up" "$dl_data" "$up_data"
            printf "%-18s%-12s%-8s%-15s%-15s%-12s\n" " $name" "$latency" "$port_speed" "$dl_display" "$up_display" "$host"
        done < <(iperf_locations)
        echo
    done
    finalize_statistics
}

run_speed_sh() {
    start_time=$(date +%s)
    get_system_info
    [[ -t 1 ]] && clear
    print_intro
    next
    print_system_info
    next
    detect_connectivity
    ip_info
    next
    case "$MODE" in
        iperf)
            install_iperf || return 1
            iperf_speed
            next
            print_network_statistics
            ;;
        routing) routing_test ;;
        speed)
            install_speedtest || return 1
            speed
            next
            print_network_statistics
            ;;
    esac
    next
    print_end_time
    get_runs_counter
    next
}

region_metadata() {
    cat <<'REGIONS'
global|speed,routing,iperf|GLOBAL
india|speed|INDIA | भारत
asia|speed,routing|ASIA
middle-east|speed|MIDDLE EAST | الشرق الأوسط
na|speed,routing|NORTH AMERICA
sa|speed|SOUTH AMERICA | LA AMÉRICA DEL SUR
eu|speed,routing|EUROPE
au|speed,routing|AUSTRALIA/NZ
africa|speed|AFRICA
iran|speed|IRAN | ایران
china|speed,routing|CHINA | 中華人民共和國
indonesia|speed|INDONESIA
russia|speed|RUSSIA | Россия
10gplus|speed|GLOBAL - 10G+
REGIONS
}

region_name() {
    local key modes label
    while IFS='|' read -r key modes label; do
        if [[ "$key" == "$1" && ",$modes," == *",$MODE,"* ]]; then
            [[ "$key" == au && "$MODE" == routing ]] && label='AUSTRALIA & NZ'
            echo "$label"
            return
        fi
    done < <(region_metadata)
    return 1
}

usage() {
    echo 'Usage: -r <region> | -rt [region] | -iperf'
    local mode key modes label
    for mode in speed routing; do
        printf '%s regions:' "$mode"
        while IFS='|' read -r key modes label; do
            [[ ",$modes," == *",$mode,"* ]] && printf ' %s' "$key"
        done < <(region_metadata)
        echo
    done
    echo 'Visit nws.sh for instructions.'
}

parse_args() {
    MODE=speed REGION=global
    local selected=false requested region
    while (( $# )); do
        case "$1" in
            -h|--help) usage; return 2 ;;
            -iperf) requested=iperf; region=global; shift ;;
            -rt)
                requested=routing; region=global; shift
                if (( $# )) && [[ "$1" != -* ]]; then region="$1"; shift; fi
                ;;
            -r|-r?*)
                requested=speed
                if [[ "$1" == -r ]]; then
                    if (( $# < 2 )) || [[ "$2" == -* ]]; then
                        echo 'Option -r requires a region.' >&2; return 1
                    fi
                    region="$2"; shift 2
                else
                    region=${1#-r}; shift
                fi
                ;;
            --) shift; (( $# == 0 )) && break; echo "Unexpected argument: $1" >&2; return 1 ;;
            *) echo "Invalid option or argument: $1" >&2; return 1 ;;
        esac
        if [[ "$selected" == true && "$MODE" != "$requested" ]]; then
            echo 'Choose one test mode: -r, -rt, or -iperf.' >&2
            return 1
        fi
        MODE="$requested" REGION="$region" selected=true
        if ! region_name "$REGION" >/dev/null; then
            echo "Invalid region: $REGION" >&2; return 1
        fi
    done
    REGION_NAME=$(region_name "$REGION")
}

require_commands() {
    local cmd
    local commands=(wget free awk grep sed tee mktemp)
    case "$MODE" in
        routing) commands+=(mtr timeout) ;;
        iperf) commands+=(timeout shuf) ;;
        speed) commands+=(tar chmod) ;;
    esac
    for cmd in "${commands[@]}"; do
        if ! _exists "$cmd"; then
            _red "nws.sh is unable to run.\nError: $cmd command not found.\n" >&2
            return 1
        fi
    done
}

save_result() {
    local destination
    destination="$PWD/network-speed-$(date +%Y%m%d-%H%M%S)-${RUN_DIR##*/}.txt"
    if cp "$RUN_DIR/network-speed.txt" "$destination"; then
        echo " Result stored locally in $destination"
    else
        KEEP_RUN_DIR=true
        echo " Result stored locally in $RUN_DIR/network-speed.txt"
    fi
}

share_result() {
    local share_link
    if ! _exists curl; then
        echo ' curl is not installed, Unable to share result online'
    elif share_link=$(curl -fsS --connect-timeout 15 --max-time 60 -X POST \
        -F "file=@$RUN_DIR/network-speed.txt" -F "region=$REGION" https://result.nws.sh/upload) &&
        [[ "$share_link" =~ ^https?://[^[:space:]]+$ ]]; then
        echo " Result             : $share_link"
        return
    else
        echo ' Unable to share result online'
    fi
    save_result
}

main() {
    local status
    parse_args "$@"
    status=$?
    (( status == 2 )) && return 0
    if (( status != 0 )); then usage >&2; return "$status"; fi
    require_commands || return 1
    RUN_DIR=$(mktemp -d "${TMPDIR:-/tmp}/nws.XXXXXXXX") || return 1
    KEEP_RUN_DIR=false
    trap cleanup EXIT
    trap '_exit 130' INT
    trap '_exit 131' QUIT
    trap '_exit 143' TERM
    export LC_ALL=C
    run_speed_sh 2>&1 | tee "$RUN_DIR/output.ansi"
    local statuses=("${PIPESTATUS[@]}")
    status=${statuses[0]}
    (( statuses[1] != 0 )) && status=1
    if ! sed $'s/\033[[][^A-Za-z]*[A-Za-z]//g' "$RUN_DIR/output.ansi" > "$RUN_DIR/network-speed.txt"; then
        KEEP_RUN_DIR=true
        echo " Unable to prepare report. Raw output stored in $RUN_DIR/output.ansi" >&2
        return 1
    fi
    if (( status == 0 )); then
        share_result
    else
        echo ' Benchmark failed. Result was not uploaded.'
        save_result
    fi
    next
    return "$status"
}

main "$@"
