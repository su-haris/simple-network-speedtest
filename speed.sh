#!/usr/bin/env bash
#
# nws.sh
# Description: A Network Benchmark Script by <sh@suh.ovh>
# Copyright (C) 2022 - 2025 <sh@suh.ovh>
# URL: https://nws.sh/
# https://github.com/su-haris/simple-network-speedtest
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

        local dl_speed_num=$(awk '/Download/{print $3}' ./speedtest-cli/speedtest.log)
        local up_speed_num=$(awk '/Upload/{print $3}' ./speedtest-cli/speedtest.log)     

        local latency=$(awk '/Latency/{print $3" "$4}' ./speedtest-cli/speedtest.log)
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

        if grep -q "Limit reached" ./speedtest-cli/speedtest.log; then
            printf "%-18s%-12s%-8s%-15s%-15s%-12s\n" " ${nodeName}" "FAILED - IP has been rate limited. Try again after 1 hour."
        elif [[ -n "${dl_speed}" && -n "${up_speed}" && -n "${latency}" ]]; then
            printf "%-18s%-12s%-8s%-15s%-15s%-12s\n" " ${nodeName}" "${latency}" "${packet_loss}" "${dl_speed}" "${up_speed}" "${server_details}"

            DL_USED=$(awk "BEGIN {print $dl_data_used+$DL_USED; exit}")
            UL_USED=$(awk "BEGIN {print $up_data_used+$UL_USED; exit}")

            SUCCESS_TEST=$((SUCCESS_TEST + 1))
            AVG_DL_SPEED=$(awk "BEGIN {print $AVG_DL_SPEED+$dl_speed_num; exit}")
            AVG_UL_SPEED=$(awk "BEGIN {print $AVG_UL_SPEED+$up_speed_num; exit}")    
        else
            printf "%-18s%-12s%-8s%-15s%-15s%-12s\n" " ${nodeName}" "FAILED"   
        fi
    fi
}

speed() {
    if [ "$ROUTING_TEST" = "china" ]; then
        china_routing_test
        return
    fi
    
    if [ -n "$ROUTING_TEST" ]; then
        routing_test "$ROUTING_TEST"
        return
    fi
    
    DL_USED=0
    UL_USED=0

    AVG_DL_SPEED=0
    AVG_UL_SPEED=0
    SUCCESS_TEST=0

    speed_test '' 'Nearest'
    echo -e

    if [ "$REGION" = "india" ]; then
        speed_test '15171' 'Mumbai, MH'
        speed_test '6879' 'Mumbai, MH'
        speed_test '33603' 'Pune, MH'
        speed_test '12939' 'Hyderabad, AP/TL' 
        speed_test '52216' 'Bangalore, KA'
        speed_test '7379' 'Bangalore, KA'
        speed_test '35402' 'Mangalore, KA'
        #speed_test '19117' 'Chennai, TN'
        #speed_test '22796' 'Chennai, TN'
        speed_test '67859' 'Chennai, TN'
        # speed_test '20107' 'Coimbatore, TN'
        speed_test '9286' 'Coimbatore, TN'
        speed_test '34444' 'Madurai, TN'
        speed_test '10112' 'Kochi, KL' 
        speed_test '29372' 'Kochi, KL'
        speed_test '62260' 'Trivandrum, KL'
        speed_test '12221' 'Kolkata, WB'
        speed_test '16273' 'Ahmedabad, GJ'
        speed_test '47162' 'Jaipur, RJ'
        speed_test '36668' 'Lucknow, UP'
        speed_test '29658' 'Delhi, DL'
        speed_test '10020'  'Gurgaon, HR' 
        speed_test '49231' 'Patna, BH'
        speed_test '60294' 'Aizawl, MZ'
    elif [ "$REGION" = "asia" ]; then
        speed_test '50686' 'Tokyo, JP'
        speed_test '18445' 'Tapei, TW'
        #speed_test '24447' 'China Unicom'
        #speed_test '3633'  'China Telecom'
        speed_test '26352' 'China Telecom'
        speed_test '24447' 'China Unicom'
        # speed_test '41910' 'China Mobile'
        speed_test '25858' 'China Mobile'
        speed_test '22126' 'Hong Kong, CN'
        echo -e 
        # speed_test '18250' 'Ho Chi Minh, VN'
        speed_test '17758' 'Ho Chi Minh, VN'
        speed_test '2552' 'Hanoi, VN'
        speed_test '8990'  'Bangkok, TH' 
        speed_test '7167' 'Manila, PH'
        echo -e
        speed_test '5935'  'Singapore, SG'
        speed_test '4235'  'Singapore, SG'
        speed_test '13039' 'Jakarta, ID'
        speed_test '56633' 'Surabaya, ID'   
        speed_test '19302' 'Kuala Lum, MY'
        echo -e
        speed_test '23647' 'Mumbai, IN'
        speed_test '67859'  'Chennai, IN' 
        speed_test '52216' 'Bangalore, IN'
        speed_test '32238' 'Karachi, PK'
        # speed_test '9716'  'Lahore, PK' 
        speed_test '35816'  'Islamabad, PK'
        speed_test '54919' 'Kathmandu, NP'
        speed_test '60180' 'Colombo, SL'
        speed_test '30815' 'Dhaka, BD'
        echo -e
        speed_test '6430' 'Novosibirsk, RU'
        speed_test '38516' 'Almaty, KZ'
        echo -e
        speed_test '4317' 'Tehran, IR'
        speed_test '17336' 'Dubai, AE'
        speed_test '1733' 'Jeddah, SA'
        speed_test '3151' 'Istanbul, TR'
    elif [ "$REGION" = "middle-east" ]; then
        speed_test '1692' 'Abu Dhabi, AE'
        speed_test '22129' 'Dubai, AE'
        speed_test '34240' 'Fujairah, AE'
        speed_test '1717'  'Muscat, OM' 
        speed_test '11271' 'Seeb, OM'
        speed_test '15570' 'Sanaa, YE'
        speed_test '6193' 'Doha, QA'
        # speed_test '51657' 'Rayan, QA'
        speed_test '51669' 'Lusail, QA'
        speed_test '17574'  'Manama, BH' 
        speed_test '52650' 'Rifa, BH'
        speed_test '25444' 'Kuwait, KW'
        speed_test '3290' 'Kuwait, KW'
        speed_test '1402' 'Riyadh, SA'
        speed_test '16051' 'Dammam, SA'
        speed_test '3196'  'Jeddah, SA' 
        speed_test '14580' 'Jeddah, SA'
        echo -e
        speed_test '4317' 'Tehran, IR'
        speed_test '39247' 'Baghdad, IQ'
        speed_test '27570' 'Beirut, LB'
        speed_test '54384' 'Nicosia, CY'
        speed_test '38212' 'Tel Aviv, IL' 
        speed_test '31160' 'Amman, JO'
        speed_test '41251' 'Cairo, EG'
        speed_test '34283' 'Cairo, EG'
        speed_test '3151' 'Istanbul, TR'
    elif [ "$REGION" = "na" ]; then
        speed_test '3049' 'Vancouver, BC'
        #speed_test '3575'  'Toronto, ON' 
        speed_test '4207'  'Calgary, AB'
        speed_test '1493'  'Winnipeg, MB'
        speed_test '53393' 'Toronto, ON'
        speed_test '46416' 'Montreal, QC'
        echo -e
        speed_test '36817' 'New York, NY'
        speed_test '32493' 'Ashburn, VA'
        speed_test '58326' 'Durham, NC' 
        speed_test '35608' 'Atlanta, GA'
        speed_test '35987' 'Miami, FL'
        speed_test '22288' 'Dallas, TX'
        speed_test '1763' 'Houston, TX'
        speed_test '13628' 'Kansas, MO'
        speed_test '15869' 'Minneapolis, MN'
        speed_test '34707' 'Chicago, IL' 
        speed_test '15062' 'Cleveland, OH'
        speed_test '1773' 'Albuquerque, NM'
        speed_test '56839' 'Denver, CO'
        speed_test '10162' 'Portland, OR'
        speed_test '53984' 'Las Vegas, NV'
        speed_test '54751' 'Salt Lake, UT'  
        speed_test '27746' 'Phoenix, AZ' 
        speed_test '34840' 'Los Angeles, CA'
        #speed_test '48240' 'Santa Clara, CA'
        speed_test '49365' 'San Jose, CA'
        speed_test '58291' 'Spokane, WA'
        speed_test '50679' 'Seattle, WA'
        # speed_test '980' 'Anchorage, AK'
        echo -e
        speed_test '3499' 'Hermosillo, MX'
        speed_test '7945'  'Guadalajara, MX'
        speed_test '54754' 'Mexico City, MX' 
        #speed_test '9176' 'Merida, MX'
    elif [ "$REGION" = "sa" ]; then
        speed_test '21568' 'Sao Paulo, BR'
        speed_test '3065' 'Rio, BR'
        speed_test '21836' 'Salvador, BR'
        speed_test '5181'  'Buenos, AR' 
        speed_test '46678' 'Buenos, AR'
        speed_test '58966' 'Cordoba, AR'
        speed_test '58822' 'Rosario, AR' 
        speed_test '20212' 'Montevideo, UY'
        speed_test '8017' 'Santiago, CL'
        speed_test '21436' 'Santiago, CL'
        speed_test '3455' 'Lima, PE'
        speed_test '4992' 'Lima, PE'
        speed_test '21800' 'Quito, EC'
        speed_test '49339'  'Caracas, VE' 
        speed_test '44095' 'Bogota, CO'
    elif [ "$REGION" = "eu" ]; then
        speed_test '31183' 'London, UK'
        # speed_test '38157' 'Edinburgh, UK'
        speed_test '23968' 'Manchester, UK'
        speed_test '38092' 'Dublin, IE' 
        speed_test '37363' 'Amsterdam, NL'
        # speed_test '60666' 'Eygelshoen, NL'
        # speed_test '62493' 'Paris, FR'
        speed_test '61933' 'Paris, FR'
        speed_test '61301' 'Marseille, FR'
        speed_test '14979' 'Madrid, ES'
        speed_test '1695' 'Barcelona, ES'
        speed_test '29467' 'Lisbon, PT' 
        speed_test '3243' 'Rome, IT'
        #speed_test '4302' 'Milan, IT'
        speed_test '7839' 'Milan, IT'
        speed_test '23969' 'Zurich, CH'
        speed_test '23095' 'Frankfurt, DE'
        speed_test '55665' 'Berlin, DE'
        speed_test '50599' 'Vienna, AT'  
        speed_test '7842' 'Budapest, HU' 
        speed_test '23123' 'Krakow, PL'
        speed_test '4166'  'Warsaw, PL'
        speed_test '29259' 'Lviv, UA'   
        speed_test '62769' 'Kyiv, UA'
        # speed_test '27486' 'Minsk, BY'
        # speed_test '16457' 'Bucharest, RO'
        speed_test '45318' 'Bucharest, RO'
        speed_test '11500' 'Timisoara, RO'
        speed_test '22669' 'Helsinki, FI'
        speed_test '34024' 'Stockholm, SE'
        speed_test '31861' 'Oslo, NO'
        # speed_test '3682' 'Moscow, RU'
        speed_test '1907' 'Moscow, RU'
        speed_test '6051' 'Petersburg, RU'
        speed_test '31851' 'Istanbul, TR'
        # speed_test '11945' 'Tbilisi, GE'
    elif [ "$REGION" = "au" ]; then
        speed_test '18473' 'Brisbane'
        speed_test '44735' 'Sydney'
        speed_test '12492' 'Sydney'
        speed_test '15136' 'Perth'
        speed_test '12494' 'Perth' 
        speed_test '43024' 'Melbourne'
        speed_test '12491' 'Melbourne'
        speed_test '13277' 'Adelaide'
        speed_test '18711' 'Canberra'
        echo -e
        speed_test '4953'  'Auckland' 
        speed_test '5749' 'Auckland'
        speed_test '11327' 'Auckland'
    elif [ "$REGION" = "africa" ]; then
        speed_test '2962' 'Cape Town, ZA'
        speed_test '1491' 'Cape Town, ZA'
        speed_test '21570' 'Johannesburg, ZA'
        speed_test '56612' 'Harare, ZW'
        speed_test '28816' 'Maputo, MZ' 
        speed_test '7755' 'Antananarivo, MG'
        speed_test '3846' 'Darusalaam, TZ'
        speed_test '8402' 'Nairobi, KE'
        speed_test '48973' 'Addis Ababa, ET'
        speed_test '34283'  'Cairo, EG' 
        speed_test '26790' 'Alexandria, EG' 
        speed_test '54524' 'Rabat, MA' 
        speed_test '15631' 'Algiers, DZ' 
        speed_test '33159' 'Lagos, NG'    
    elif [ "$REGION" = "iran" ]; then
        speed_test '4317'  'Tehran' 
        speed_test '21031' 'Tehran'
        speed_test '19534' 'Tehran'
        speed_test '43844'  'Tehran' 
        speed_test '10076'  'Mashhad' 
        speed_test '22295'  'Mashhad'
        speed_test '22297' 'Shiraz'
        speed_test '22245' 'Isfahan'
        speed_test '9888' 'Tabriz'
    elif [ "$REGION" = "russia" ]; then
        speed_test '1907' 'Moscow'
        speed_test '48192' 'Moscow'
        speed_test '10987' 'Moscow'
        speed_test '44806' 'Moscow'
        speed_test '45191' 'Moscow'
        echo -e
        speed_test '6051' 'Petersburg'
        speed_test '42152' 'Petersburg'
        speed_test '39860' 'Kazan'
        speed_test '22240' 'Kazan'
        speed_test '65185' 'Sevastopol'
        speed_test '41096' 'Kaliningrad'
        speed_test '37042' 'Volgograd'
        echo -e
        speed_test '39503' 'Omsk'
        speed_test '6430' 'Novosibirsk'
        speed_test '3545' 'Krasnoyarsk'
        speed_test '9679' 'Yakutsk'
        speed_test '54169' 'Vladivostok' 
    elif [ "$REGION" = "indonesia" ]; then
        speed_test '14325' 'Jakarta'
        speed_test '49585' 'Jakarta'
        speed_test '56632' 'Jakarta'
        speed_test '13039' 'Jakarta'
        speed_test '11118' 'Jakarta'
        echo -e
        speed_test '5065' 'Bandung'
        speed_test '32223' 'Bekasi'
        speed_test '63223' 'Bogor'
        speed_test '40832' 'Malang'
        speed_test '47972' 'Semarang'
        speed_test '46091' 'Surabaya'
        speed_test '24587' 'Yogyakarta'
        echo -e 
        speed_test '59117' 'Banda Aceh'
        speed_test '61882' 'Medan'
        speed_test '50465' 'Palembang'
        speed_test '53101' 'Pekanbaru' 
        echo -e 
        # speed_test '21959' 'Bali'
        speed_test '46113' 'Makassar'
        speed_test '45520' 'Depok'
        speed_test '47361' 'Tangerang'
    elif [ "$REGION" = "china" ]; then
        speed_test '24447' 'CU - Shanghai'
        # speed_test '3633'  'CT - Shanghai' 
        speed_test '25858'  'CM - Beijing' 
        speed_test '43752'  'CU - Beijing'
        speed_test '26352' 'CT - Nanjing'
        speed_test '60584' 'CT - Shenzen'
        speed_test '36663' 'CT - Zhenjiang'
        speed_test '37235' 'CU - Shenyang'
        speed_test '5396' 'CT - Suzhou'
        speed_test '5317' 'CT - Yangzhou'
        speed_test '54312' 'CM - Hangzhou'
        speed_test '59386' 'CT - Hangzhou'
        speed_test '36646' 'CU - Zhengzhou'
        speed_test '28225' 'CT - Changsha'
        speed_test '4870' 'CU - Changsha'
        speed_test '4575' 'CM - Chengdu'
        # speed_test '23844' 'CT - Wuhan'
        speed_test '45170' 'CU - Wu Xi'
        speed_test '17145' 'CT - Hefei'
        speed_test '34115' 'CT - TianJin'
        speed_test '62416' 'CT - XiNing'
        speed_test '59387' 'CT - NingBo'
        speed_test '60794' 'CM - Guangzhou'
        echo -e
        speed_test '32155' 'CM - Kwai Chung'
        speed_test '37639' 'CM - Hong Kong' 
        speed_test '37695' 'CU - Hong Kong' 
        # speed_test '34555' 'Hong Kong'    
        speed_test '28912' 'Hong Kong'
        speed_test '44745' 'Hong Kong'  
        # echo -e
        # speed_test '62147' 'CUG - Tokyo'
        # speed_test '62146' 'CUG - Singapore' 
        # speed_test '61417' 'CUG - LosAngeles' 
        # speed_test '61451' 'CUG - London'
    elif [ "$REGION" = "10gplus" ]; then
        speed_test '55137' 'London, UK'
        speed_test '30376' 'London, UK'
        speed_test '13764' 'Amsterdam, NL'
        speed_test '51395' 'Amsterdam, NL'
        speed_test '61933' 'Paris, FR'
        speed_test '62943' 'Frankfurt, DE'
        speed_test '37492' 'Frankfurt, DE'
        speed_test '7839' 'Milan, IT'
        speed_test '29467' 'Lisbon, PT'
        speed_test '14979' 'Madrid, ES'
        speed_test '65089' 'Warsaw, PL'
        echo -e
        speed_test '8864' 'Seattle, WA'
        speed_test '50081' 'Los Angeles, CA'
        speed_test '14236' 'Los Angeles, CA'
        speed_test '5919' 'Chicago, IL'
        speed_test '14238' 'Dallas, TX'
        speed_test '46120' 'New York, NY' 
        speed_test '62109' 'Miami, FL'
        echo -e
        speed_test '48463' 'Tokyo, JP'
    else
        # speed_test '29372' 'Kochi, IN'
        speed_test '52216' 'Bangalore, IN'
        speed_test '67859' 'Chennai, IN' 
        # speed_test '47668' 'Mumbai, IN'
        speed_test '61281' 'Mumbai, IN'
        # speed_test '29658' 'Delhi, IN'
        echo -e
        speed_test '1782' 'Seattle, US'
        speed_test '34840' 'Los Angeles, US'
        speed_test '22288' 'Dallas, US'
        speed_test '69408' 'Miami, US'
        speed_test '46120' 'New York, US'
        speed_test '46143' 'Toronto, CA'
        speed_test '54754' 'Mexico City, MX'
        echo -e 
        speed_test '37536' 'London, UK'
        speed_test '23094' 'Amsterdam, NL'
        speed_test '28308' 'Paris, FR'
        speed_test '35692' 'Frankfurt, DE'
        speed_test '37249' 'Warsaw, PL'
        speed_test '18902' 'Bucharest, RO'
        # speed_test '22050' 'Moscow, RU'
        speed_test '44487' 'Moscow, RU'
        echo -e 
        speed_test '14580' 'Jeddah, SA'
        # speed_test '4845'  'Dubai, AE'
        speed_test '17336'  'Dubai, AE'
        # speed_test '34240' 'Fujairah, AE'
        speed_test '31851' 'Istanbul, TR'
        speed_test '4317' 'Tehran, IR'
        speed_test '16744' 'Cairo, EG'
        echo -e 
        speed_test '28910' 'Tokyo, JP'
        # speed_test '4575' 'Chengdu, CM-CN'
        # speed_test '48463' 'Tokyo, JP'
        speed_test '24447' 'Shanghai, CU-CN'
        # speed_test '45170' 'Wu Xi, CU-CN'
        # speed_test '37235' 'Shenyang, CU-CN'
        # speed_test '26352' 'Nanjing, CT-CN'
        # speed_test '5396' 'Suzhou, CT-CN'
        # speed_test '1536'  'Hong Kong, CN'
        speed_test '44745'  'Hong Kong, CN'
        speed_test '2054' 'Singapore, SG'
        speed_test '63138' 'Jakarta, ID'
        echo -e
        speed_test '15132' 'Sydney, AU'
    fi 
    

    TOTAL_DATA=$(awk -v dl="$DL_USED" -v ul="$UL_USED" 'BEGIN { total=dl+ul; printf "%.2f\n", total }')
    TOTAL_DATA_IN_GB=$(awk -v total="$TOTAL_DATA" 'BEGIN { printf "%.2f\n", total/1024 }')

    DL_USED_IN_GB=$(awk -v dl="$DL_USED" 'BEGIN { printf "%.2f\n", dl/1024 }')
    UL_USED_IN_GB=$(awk -v ul="$UL_USED" 'BEGIN { printf "%.2f\n", ul/1024 }')

    AVG_DL_SPEED=$(awk -v avg_dl="$AVG_DL_SPEED" -v success="$SUCCESS_TEST" 'BEGIN { if (success != 0) printf "%.2f\n", avg_dl/success; else print "0.00" }')
    AVG_UL_SPEED=$(awk -v avg_ul="$AVG_UL_SPEED" -v success="$SUCCESS_TEST" 'BEGIN { if (success != 0) printf "%.2f\n", avg_ul/success; else print "0.00" }')
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

ip_info() {
    echo " Basic Network Info"
    next
    local net_type="$(wget -T 5 -qO- http://ip6.me/api/ | cut -d, -f1)"

    local ipv4_check=$((ping -4 -c 1 -W 4 ipv4.google.com >/dev/null 2>&1 && echo true) || wget -qO- -T 5 -4 icanhazip.com 2> /dev/null)
    local ipv6_check=$((ping -6 -c 1 -W 4 ipv6.google.com >/dev/null 2>&1 && echo true) || wget -qO- -T 5 -6 icanhazip.com 2> /dev/null)

    local net_ip="$(wget -T 5 -qO- icanhazip.com)"

    # IP-API Details - IPv6/IPv4
    local response=$(wget -qO- -T 5 http://ip-api.com/json/$net_ip)

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

    # IPINFO.IO Details - IPv4 only

    local response_ipv4=$(wget -qO- -T 5 ipinfo.io)

    local ipv4_city=$(echo "$response_ipv4" | grep -Po '"city": *\K"[^"]*"')
    local ipv4_city=${ipv4_city//\"}

    local ipv4_region=$(echo "$response_ipv4" | grep -Po '"region": *\K"[^"]*"')
    local ipv4_region=${ipv4_region//\"}

    local ipv4_country=$(echo "$response_ipv4" | grep -Po '"country": *\K"[^"]*"')
    local ipv4_country=${ipv4_country//\"}

    local ipv4_asn=$(echo "$response_ipv4" | grep -Po '"org": *\K"[^"]*"')
    local ipv4_asn=${ipv4_asn//\"}

    if [[ -n "$net_type" ]]; then
        echo " Primary Network    : $(_green "$net_type")"
    fi

    if [[ -n "$ipv6_check" ]]; then
        echo " IPv6 Access        : $(_green "\xE2\x9C\x94 Online")"
    else
        echo " IPv6 Access        : $(_red "\xE2\x9D\x8C Offline")"
    fi

    if [[ -n "$ipv4_check" ]]; then
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
        url1="https://install.speedtest.net/app/cli/ookla-speedtest-1.2.0-linux-${sys_bit}.tgz"
        url2="https://dl.lamp.sh/files/ookla-speedtest-1.2.0-linux-${sys_bit}.tgz"
        wget --no-check-certificate -q -T10 -O speedtest.tgz ${url1}
        if [ $? -ne 0 ]; then
            wget --no-check-certificate -q -T10 -O speedtest.tgz ${url2}
            [ $? -ne 0 ] && _red "Error: Failed to download speedtest-cli.\n" && exit 1
        fi
        mkdir -p speedtest-cli && tar zxf speedtest.tgz -C ./speedtest-cli && chmod +x ./speedtest-cli/speedtest
        rm -f speedtest.tgz
    fi
    echo " Speedtest.net (Region: $REGION_NAME)"
    next
    printf "%-18s%-12s%-8s%-15s%-15s%-12s\n" " Location" "Latency" "Loss" "DL Speed" "UP Speed" "Server"
}

print_intro() {
    #echo "---------------------------- network-speed.xyz ----------------------------"
    echo "---------------------------------- nws.sh ---------------------------------"
    echo "      A simple script to bench network performance using speedtest-cli     "
    next
    echo " Version            : $(_green v2025.08.30)"
    echo " Global Speedtest   : $(_red "wget -qO- nws.sh | bash")"
    echo " Region Speedtest   : $(_red "wget -qO- nws.sh | bash -s -- -r <region>")"
    echo " Ping & Routing     : $(_red "wget -qO- nws.sh | bash -s -- -rt <region>")"
}

# Get Disk Data
get_disk_data() {
    disk_total_size=0
    disk_used_size=0
    fs_list=("simfs" "ext2" "ext3" "ext4" "btrfs" "xfs" "ntfs" "swap")
    known_path=()
    for fs_type in "${fs_list[@]}"; do
        while read -r fs_info; do
            fs_path=$(echo "$fs_info" | awk '{ print $1 }')
            fs_size=$(echo "$fs_info" | awk '{ print $2 }')
            fs_used=$(echo "$fs_info" | awk '{ print $3 }')
            is_skip=0
            # Skip if path aleardy passed before
            for i in "${known_path[@]}"; do
                if [ "$i" == "$fs_path" ] ; then
                    is_skip=1
                    break
                fi
            done
            if [ $is_skip -eq 1 ]; then
                continue
            fi
            known_path+=($fs_path)
            ((disk_total_size += fs_size))
            ((disk_used_size += fs_used))
            # df(1) return 512 instead 1K blocks for btrfs
            if [ "$fs_type" == "btrfs" ]; then
                ((disk_total_size = disk_total_size / 2))
                ((disk_used_size = disk_used_size / 2))
            fi
        done < <(LANG=C; df -t "$fs_type" 2>/dev/null | tail -n +2)
    done
    echo -n "$disk_total_size $disk_used_size"
}

# Get System information
get_system_info() {
    cname=$( awk -F: '/model name/ {name=$2} END {print name}' /proc/cpuinfo | sed 's/^[ \t]*//;s/[ \t]*$//' )
    cores=$( awk -F: '/model name/ {core++} END {print core}' /proc/cpuinfo )
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
    disk_used_size=$( LANG=C; df -t simfs -t ext2 -t ext3 -t ext4 -t btrfs -t xfs -t vfat -t ntfs -t swap --total 2>/dev/null | grep total | awk '{ print $3 }' )
    if [[ -z "$disk_total_size" || -z "$disk_used_size" ]]; then
        disk_data=$( get_disk_data )
        disk_total_size=$( echo "$disk_data" | awk '{ print $1 }' )
        disk_used_size=$( echo "$disk_data" | awk '{ print $2 }' )
    fi
    disk_total_size=$( calc_size $disk_total_size )
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

print_network_statistics() {
    echo " Avg DL Speed       : $AVG_DL_SPEED Mbps"
    echo " Avg UL Speed       : $AVG_UL_SPEED Mbps"
    echo -e
    echo " Total DL Data      : $DL_USED_IN_GB GB"
    echo " Total UL Data      : $UL_USED_IN_GB GB"
    echo " Total Data         : $TOTAL_DATA_IN_GB GB"  
}

print_end_time() {
    end_time=$(date +%s)
    time=$(( ${end_time} - ${start_time} ))
    if [ ${time} -gt 60 ]; then
        min=$(expr $time / 60)
        sec=$(expr $time % 60)
        echo " Duration           : ${min} min ${sec} sec"
    else
        echo " Duration           : ${time} sec"
    fi
    date_time=$(date '+%d/%m/%Y - %H:%M:%S %Z')
    echo " System Time        : $date_time"

}

get_runs_counter() {
    local counter=$(wget -qO- https://runs.nws.sh/)

    if [[ -n "$counter" ]]; then
        echo " Total Script Runs  : $(_green "$counter")"
    fi
}

# China Network Routing Test Functions
declare -A TIER1_ISPS=(
    [AS174]="Cogent"
    [AS3356]="Lumen"
    [AS2914]="NTT"
    [AS3257]="GTT"
    [AS6453]="TATA"
    [AS1299]="Arelion"
    [AS3491]="PCCW Global"
    [AS6762]="Telecom Italia"
    [AS1239]="Sprint"
    [AS701]="Verizon"
    [AS6939]="Hurricane Electric"
    [AS6830]="Liberty Global"
    [AS6461]="Zayo"
    [AS3320]="Deutsche Telekom"
    [AS5511]="Orange France"
)

declare -a CN_LOCATION_NAMES
declare -a CN_LOCATION_IPS

# Initialize China routing test locations
init_cn_locations() {
    # Beijing
    CN_LOCATION_NAMES+=("Beijing - China Telecom")
    CN_LOCATION_IPS+=("219.141.136.12")
    CN_LOCATION_NAMES+=("Beijing - China Unicom")
    CN_LOCATION_IPS+=("202.106.50.1")
    CN_LOCATION_NAMES+=("Beijing - China Mobile")
    CN_LOCATION_IPS+=("221.179.155.161")
    CN_LOCATION_NAMES+=("Beijing - CERNET")
    CN_LOCATION_IPS+=("101.6.15.66")
    
    # Shanghai
    CN_LOCATION_NAMES+=("Shanghai - China Telecom")
    CN_LOCATION_IPS+=("202.96.209.133")
    CN_LOCATION_NAMES+=("Shanghai - China Unicom")
    CN_LOCATION_IPS+=("210.22.97.1")
    CN_LOCATION_NAMES+=("Shanghai - China Mobile")
    CN_LOCATION_IPS+=("211.136.112.200")
    
    # Guangzhou
    CN_LOCATION_NAMES+=("Guangzhou - China Telecom")
    CN_LOCATION_IPS+=("58.60.188.222")
    CN_LOCATION_NAMES+=("Guangzhou - China Unicom")
    CN_LOCATION_IPS+=("210.21.196.6")
    CN_LOCATION_NAMES+=("Guangzhou - China Mobile")
    CN_LOCATION_IPS+=("120.196.165.24")
    
    # Chengdu
    CN_LOCATION_NAMES+=("Chengdu - China Telecom")
    CN_LOCATION_IPS+=("61.139.2.69")
    CN_LOCATION_NAMES+=("Chengdu - China Unicom")
    CN_LOCATION_IPS+=("119.6.6.6")
    CN_LOCATION_NAMES+=("Chengdu - China Mobile")
    CN_LOCATION_IPS+=("211.137.96.205")
    
    # Shenzhen
    CN_LOCATION_NAMES+=("Shenzhen - China Telecom")
    CN_LOCATION_IPS+=("106.4.158.58")
    CN_LOCATION_NAMES+=("Shenzhen - China Unicom")
    CN_LOCATION_IPS+=("221.194.154.193")
    CN_LOCATION_NAMES+=("Shenzhen - China Mobile")
    CN_LOCATION_IPS+=("223.111.101.29")
}

cn_ping_test() {
    local ip=$1
    local ping_output
    local ping_result
    local packet_loss
    
    if ! _exists "ping"; then
        echo "N/A"
        return
    fi
    
    ping_output=$(ping -c 5 -W 4 "$ip" 2>/dev/null)
    
    # Extract the average ping time
    ping_result=$(echo "$ping_output" | grep -E 'min/avg/max' | awk -F '/' '{printf "%.0f", $5}')
    
    # Extract the packet loss percentage
    packet_loss=$(echo "$ping_output" | grep -oP '\d+(?=% packet loss)')
    
    if [ -n "$ping_result" ]; then
        if [ "$packet_loss" -eq 0 ] 2>/dev/null; then
            echo "${ping_result}ms [No Loss]"
        else
            echo "${ping_result}ms [${packet_loss}% loss]"
        fi
    else
        echo "Failed"
    fi
}

cn_get_as_path() {
    local ip=$1
    local as_path
    local china_asn
    local preceding_asn

    if ! _exists "mtr"; then
        echo "MTR not available|Unknown"
        return
    fi

    # Extract the AS path using mtr
    as_path=$(timeout 30 mtr -wz -c 3 "$ip" 2>/dev/null | grep "AS[0-9]" | awk '{
        for (i=1; i<=NF; i++) {
            if ($i ~ /^AS/) {
                if (!seen[$i]++) {
                    printf "%s ", $i
                }
            }
        }
    }' | sed 's/ $//')

    # Find the first China ASN and the preceding ASN
    for asn in $as_path; do
        if [[ $asn =~ ^AS(4134|4837|58453|4809|9929|58807)$ ]]; then
            china_asn=$asn
            break
        fi
        preceding_asn=$asn
    done

    # Output the full AS path and the preceding ASN
    echo "$as_path|$preceding_asn"
}

cn_get_line_type() {
    local as_path_info=$1
    local as_path=${as_path_info%|*}
    local preceding_asn=${as_path_info#*|}
    local line_type
    local via_info

    # Determine the line type based on the China ASN in the AS path
    if [[ $as_path =~ AS4809 ]]; then
        line_type="Premium Line |CN2 China Telecom Next Generation"
    elif [[ $as_path =~ AS9929 ]]; then
        line_type="Premium Line |CUIB CHINA UNICOM Industrial Internet"
    elif [[ $as_path =~ AS58807 ]]; then
        line_type="Premium Line |CMIN2 China Mobile International"
    elif [[ $as_path =~ AS4134 ]]; then
        line_type="Standard Line |China Telecom Backbone"
    elif [[ $as_path =~ AS4837 ]]; then
        line_type="Standard Line |China Unicom Backbone 169"
    elif [[ $as_path =~ AS58453 ]]; then
        line_type="Standard Line |China Mobile International"
    else
        line_type="Unknown Line |Path not recognized"
    fi

    # Determine the preceding ASN's information
    if [[ -n $preceding_asn ]]; then
        if [[ ${TIER1_ISPS[$preceding_asn]} ]]; then
            via_info="via ${TIER1_ISPS[$preceding_asn]}"
        else
            via_info="via $preceding_asn"
        fi
    else
        via_info="via Direct Peering"
    fi

    echo "$line_type $via_info"
}

install_china_test() {
    echo " Ping & Routing Test (Region: $REGION_NAME)"
    next
    printf "%-30s | %s\n" " Network" "Details"
    next
}

china_routing_test() {
    init_cn_locations
    install_china_test

    for i in "${!CN_LOCATION_NAMES[@]}"; do
        local location="${CN_LOCATION_NAMES[$i]}"
        local ip="${CN_LOCATION_IPS[$i]}"
        
        # Get results
        local ping_result=$(cn_ping_test "$ip")
        local as_path=$(cn_get_as_path "$ip")
        local actual_as_path=$(echo "${as_path%%|*}")
        local line_type=$(cn_get_line_type "$as_path")
        
        # Print results with consistent formatting
        printf " %-29s | %s\n" "$location" "$ping_result"
        printf " %-29s | %s\n" "$ip" "$actual_as_path"
        printf " %-29s | %s\n" "$(echo "$line_type" | cut -d'|' -f1)" "$(echo "$line_type" | cut -d'|' -f2)"
        next
    done
}

# Routing Test Functions (Generic)
declare -a ROUTING_LOCATION_NAMES
declare -a ROUTING_LOCATION_IPS

# Initialize routing test locations based on region
init_routing_locations() {
    local region="$1"
    
    # Clear previous locations
    ROUTING_LOCATION_NAMES=()
    ROUTING_LOCATION_IPS=()
    
    if [ "$region" = "asia" ]; then
        ROUTING_LOCATION_NAMES+=("SG - Singapore: CDN77")
        ROUTING_LOCATION_IPS+=("89.187.162.1")
        ROUTING_LOCATION_NAMES+=("SG - Singapore: LeaseWeb Asia")
        ROUTING_LOCATION_IPS+=("103.254.153.18")
        ROUTING_LOCATION_NAMES+=("SG - Singapore: Host Universal")
        ROUTING_LOCATION_IPS+=("207.2.122.3")
        ROUTING_LOCATION_NAMES+=("SG - Singapore: HostHatch")
        ROUTING_LOCATION_IPS+=("103.167.150.90")
        ROUTING_LOCATION_NAMES+=("SG - Singapore: HE")
        ROUTING_LOCATION_IPS+=("core2.sin1.he.net")
        ROUTING_LOCATION_NAMES+=("SG - Singapore: ZenLayer")
        ROUTING_LOCATION_IPS+=("001.sin2.sg.k1s.zenlayer.win")
        ROUTING_LOCATION_NAMES+=("SG - Singapore: TATA")
        ROUTING_LOCATION_IPS+=("gin-asina-tcore1.as6453.net")
        ROUTING_LOCATION_NAMES+=("SG - Singapore: Telstra")
        ROUTING_LOCATION_IPS+=("202.84.219.173")

        ROUTING_LOCATION_NAMES+=("JP - Tokyo: xTom")
        ROUTING_LOCATION_IPS+=("103.201.131.131")
        ROUTING_LOCATION_NAMES+=("JP - Tokyo: Shock Hosting")
        ROUTING_LOCATION_IPS+=("43.230.161.31")
        ROUTING_LOCATION_NAMES+=("JP - Tokyo: SoftBank")
        ROUTING_LOCATION_IPS+=("103.214.168.128")
        ROUTING_LOCATION_NAMES+=("JP - Tokyo: CDN77")
        ROUTING_LOCATION_IPS+=("89.187.160.1")
        ROUTING_LOCATION_NAMES+=("JP - Osaka: Vultr")
        ROUTING_LOCATION_IPS+=("64.176.34.94")
        ROUTING_LOCATION_NAMES+=("JP - Tokyo: HE")
        ROUTING_LOCATION_IPS+=("core2.tyo1.he.net")

        ROUTING_LOCATION_NAMES+=("HK - Hong Kong: ZenLayer")
        ROUTING_LOCATION_IPS+=("006.hkg3.hk.k1s.zenlayer.win")
        ROUTING_LOCATION_NAMES+=("HK - Hong Kong: GCore")
        ROUTING_LOCATION_IPS+=("5.188.230.129")
        ROUTING_LOCATION_NAMES+=("HK - Hong Kong: LeaseWeb Asia")
        ROUTING_LOCATION_IPS+=("43.249.36.49")
        ROUTING_LOCATION_NAMES+=("HK - Hong Kong: HE")
        ROUTING_LOCATION_IPS+=("core2.hkg2.he.net")
        ROUTING_LOCATION_NAMES+=("HK - Hong Kong: CDN77")
        ROUTING_LOCATION_IPS+=("84.17.57.129")
        ROUTING_LOCATION_NAMES+=("HK - Hong Kong: Telstra")
        ROUTING_LOCATION_IPS+=("202.84.173.22")

        ROUTING_LOCATION_NAMES+=("SK - Busan: Telstra")
        ROUTING_LOCATION_IPS+=("202.84.149.162")

        ROUTING_LOCATION_NAMES+=("ID - Jakarta: WarnaHost")
        ROUTING_LOCATION_IPS+=("103.157.146.2")

        ROUTING_LOCATION_NAMES+=("IN - Mumbai: Vultr")
        ROUTING_LOCATION_IPS+=("65.20.66.100")
        ROUTING_LOCATION_NAMES+=("IN - Mumbai: Jio")
        ROUTING_LOCATION_IPS+=("49.44.93.128")
        ROUTING_LOCATION_NAMES+=("IN - Kochi: Airtel")
        ROUTING_LOCATION_IPS+=("125.21.255.190")
        ROUTING_LOCATION_NAMES+=("IN - Chennai: Linode")
        ROUTING_LOCATION_IPS+=("speedtest-1.maa1.in.prod.linode.com")
        ROUTING_LOCATION_NAMES+=("IN - Chennai: ZenLayer")
        ROUTING_LOCATION_IPS+=("001.maa2.in.k1s.zenlayer.win")
        ROUTING_LOCATION_NAMES+=("IN - Chennai: Jio")
        ROUTING_LOCATION_IPS+=("49.44.93.133")

        # Vietnam
        ROUTING_LOCATION_NAMES+=("VN - Hanoi: GreenCloud")
        ROUTING_LOCATION_IPS+=("103.199.17.252")
        ROUTING_LOCATION_NAMES+=("VN - Ho Chi Minh: FPT Telecom")
        ROUTING_LOCATION_IPS+=("103.186.65.98")

        # Pakistan
        ROUTING_LOCATION_NAMES+=("PK - Islamabad: Virtury")
        ROUTING_LOCATION_IPS+=("103.151.111.249")
    elif [ "$region" = "na" ]; then
        # United States - West Coast
        ROUTING_LOCATION_NAMES+=("US - Seattle: xTom")
        ROUTING_LOCATION_IPS+=("23.145.48.48")
        ROUTING_LOCATION_NAMES+=("US - Liberty Lake: Crunchbits")
        ROUTING_LOCATION_IPS+=("104.36.84.66")
        ROUTING_LOCATION_NAMES+=("US - San Jose: CDN77")
        ROUTING_LOCATION_IPS+=("156.146.53.53")
        ROUTING_LOCATION_NAMES+=("US - Hillsboro: OVH")
        ROUTING_LOCATION_IPS+=("51.81.154.196")
        ROUTING_LOCATION_NAMES+=("US - Fremont: Hurricane Electric")
        ROUTING_LOCATION_IPS+=("core1.fmt2.he.net")
        ROUTING_LOCATION_NAMES+=("US - Los Angeles: Multacom")
        ROUTING_LOCATION_IPS+=("204.13.154.3")
        ROUTING_LOCATION_NAMES+=("US - Los Angeles: ReliableSite")
        ROUTING_LOCATION_IPS+=("104.238.206.46")
        ROUTING_LOCATION_NAMES+=("US - Los Angeles: WebNX")
        ROUTING_LOCATION_IPS+=("64.185.232.162")
        
        # United States - Central
        ROUTING_LOCATION_NAMES+=("US - Chicago: Psychz Networks")
        ROUTING_LOCATION_IPS+=("108.181.140.235")
        ROUTING_LOCATION_NAMES+=("US - Chicago: VirMach")
        ROUTING_LOCATION_IPS+=("89.33.192.5")
        ROUTING_LOCATION_NAMES+=("US - Kansas City: FreeRangeCloud")
        ROUTING_LOCATION_IPS+=("23.152.226.2")
        ROUTING_LOCATION_NAMES+=("US - Kansas: IncogNET")
        ROUTING_LOCATION_IPS+=("23.137.254.200")
        ROUTING_LOCATION_NAMES+=("US - Dallas: GSL")
        ROUTING_LOCATION_IPS+=("216.146.25.35")
        ROUTING_LOCATION_NAMES+=("US - Salt Lake City: FiberState")
        ROUTING_LOCATION_IPS+=("38.92.25.252")
        
        # United States - East Coast
        ROUTING_LOCATION_NAMES+=("US - Ashburn: ColoCrossing")
        ROUTING_LOCATION_IPS+=("192.3.254.158")
        ROUTING_LOCATION_NAMES+=("US - Buffalo: ColoCrossing")
        ROUTING_LOCATION_IPS+=("192.3.180.103")
        ROUTING_LOCATION_NAMES+=("US - Durham: Cogent")
        ROUTING_LOCATION_IPS+=("38.45.64.1")
        ROUTING_LOCATION_NAMES+=("US - New York: ReliableSite")
        ROUTING_LOCATION_IPS+=("104.243.42.233")
        ROUTING_LOCATION_NAMES+=("US - Secaucus: Royale Hosting")
        ROUTING_LOCATION_IPS+=("45.137.206.1")
        ROUTING_LOCATION_NAMES+=("US - Atlanta: Flexential")
        ROUTING_LOCATION_IPS+=("82.153.68.71")
        ROUTING_LOCATION_NAMES+=("US - Miami: ReliableSite")
        ROUTING_LOCATION_IPS+=("104.238.204.68")
        
        # Canada
        ROUTING_LOCATION_NAMES+=("CA - Vancouver: Hurricane Electric")
        ROUTING_LOCATION_IPS+=("104.218.61.164")
        ROUTING_LOCATION_NAMES+=("CA - Vancouver: FreeRangeCloud")
        ROUTING_LOCATION_IPS+=("23.154.81.1")
        ROUTING_LOCATION_NAMES+=("CA - Calgary: FreeRangeCloud")
        ROUTING_LOCATION_IPS+=("23.133.64.25")
        ROUTING_LOCATION_NAMES+=("CA - Toronto: Amanah")
        ROUTING_LOCATION_IPS+=("172.93.167.178")
        ROUTING_LOCATION_NAMES+=("CA - Montreal: OVH")
        ROUTING_LOCATION_IPS+=("51.222.154.207")
        ROUTING_LOCATION_NAMES+=("CA - Halifax: FreeRangeCloud")
        ROUTING_LOCATION_IPS+=("23.191.80.33")
    elif [ "$region" = "eu" ]; then
        # United Kingdom (West)
        ROUTING_LOCATION_NAMES+=("UK - London: Clouvider")
        ROUTING_LOCATION_IPS+=("185.42.223.1")
        ROUTING_LOCATION_NAMES+=("UK - London: KuroIT")
        ROUTING_LOCATION_IPS+=("178.239.171.5")
        ROUTING_LOCATION_NAMES+=("UK - London: CDN77")
        ROUTING_LOCATION_IPS+=("185.59.221.51")
        ROUTING_LOCATION_NAMES+=("UK - Coventry: UKDedicated")
        ROUTING_LOCATION_IPS+=("94.229.65.150")
        ROUTING_LOCATION_NAMES+=("UK - Manchester: M247")
        ROUTING_LOCATION_IPS+=("89.238.129.146")
        
        # Netherlands
        ROUTING_LOCATION_NAMES+=("NL - Amsterdam: Clouvider")
        ROUTING_LOCATION_IPS+=("194.127.172.33")
        ROUTING_LOCATION_NAMES+=("NL - Amsterdam: CDN77")
        ROUTING_LOCATION_IPS+=("185.102.218.1")
        # ROUTING_LOCATION_NAMES+=("NL - Amsterdam: Hybula")
        # ROUTING_LOCATION_IPS+=("2.58.57.56")
        ROUTING_LOCATION_NAMES+=("NL - Amsterdam: xTom")
        ROUTING_LOCATION_IPS+=("78.142.195.195")
        
        # Germany
        ROUTING_LOCATION_NAMES+=("DE - Hamburg: CSN-Solutions")
        ROUTING_LOCATION_IPS+=("91.108.80.101")
        ROUTING_LOCATION_NAMES+=("DE - Frankfurt: CDN77")
        ROUTING_LOCATION_IPS+=("185.102.219.93")
        ROUTING_LOCATION_NAMES+=("DE - Frankfurt: Clouvider")
        ROUTING_LOCATION_IPS+=("91.199.118.14")
        ROUTING_LOCATION_NAMES+=("DE - Falkenstein: Hetzner")
        ROUTING_LOCATION_IPS+=("fsn1-speed.hetzner.com")
        ROUTING_LOCATION_NAMES+=("DE - Nuremberg: Hetzner")
        ROUTING_LOCATION_IPS+=("nbg1-speed.hetzner.com")
        
        # France
        ROUTING_LOCATION_NAMES+=("FR - Paris: M247")
        ROUTING_LOCATION_IPS+=("185.94.189.162")
        ROUTING_LOCATION_NAMES+=("FR - Marseille: CDN77")
        ROUTING_LOCATION_IPS+=("138.199.14.66")
        
        # Austria
        ROUTING_LOCATION_NAMES+=("AT - Langenzersdorf: Hohl IT")
        ROUTING_LOCATION_IPS+=("86.106.182.189")
        
        # Italy
        ROUTING_LOCATION_NAMES+=("IT - Arezzo: ArubaCloud")
        ROUTING_LOCATION_IPS+=("188.213.160.1")
        
        # Norway
        ROUTING_LOCATION_NAMES+=("NO - Sandefjord: GigaHost")
        ROUTING_LOCATION_IPS+=("185.125.168.212")
        
        # Poland
        ROUTING_LOCATION_NAMES+=("PL - Warsaw: CDN77")
        ROUTING_LOCATION_IPS+=("185.246.208.67")
        
        # Finland (North)
        ROUTING_LOCATION_NAMES+=("FI - Helsinki: Hetzner")
        ROUTING_LOCATION_IPS+=("hel1-speed.hetzner.com")
        
        # Latvia
        ROUTING_LOCATION_NAMES+=("LV - Riga: MLCloud")
        ROUTING_LOCATION_IPS+=("194.26.27.1")
        
        # Romania (East)
        ROUTING_LOCATION_NAMES+=("RO - Bucharest: CDN77")
        ROUTING_LOCATION_IPS+=("185.102.217.170")
        ROUTING_LOCATION_NAMES+=("RO - Bucharest: M247")
        ROUTING_LOCATION_IPS+=("185.45.12.22")
        
        # Russia (East)
        ROUTING_LOCATION_NAMES+=("RU - Moscow: Misaka")
        ROUTING_LOCATION_IPS+=("45.142.246.177")
        ROUTING_LOCATION_NAMES+=("RU - St Petersburg: Misaka")
        ROUTING_LOCATION_IPS+=("45.131.70.138")
        ROUTING_LOCATION_NAMES+=("RU - St Petersburg: MLCloud")
        ROUTING_LOCATION_IPS+=("45.141.84.1")
        ROUTING_LOCATION_NAMES+=("RU - Kazan: MLCloud")
        ROUTING_LOCATION_IPS+=("176.98.187.1")
        
        # Bulgaria (Southeast)
        ROUTING_LOCATION_NAMES+=("BG - Sofia: AlphaVPS")
        ROUTING_LOCATION_IPS+=("79.124.7.8")
    elif [ "$region" = "au" ]; then
        # Australia - Sydney
        ROUTING_LOCATION_NAMES+=("AU - Sydney: CDN77")
        ROUTING_LOCATION_IPS+=("143.244.63.144")
        ROUTING_LOCATION_NAMES+=("AU - Sydney: xTom")
        ROUTING_LOCATION_IPS+=("syd-v4.lg.v.ps")
        
        # Australia - Perth (West Coast)
        ROUTING_LOCATION_NAMES+=("AU - Perth: Telstra")
        ROUTING_LOCATION_IPS+=("202.84.221.242")
        
        # Australia - Brisbane (Northeast)
        ROUTING_LOCATION_NAMES+=("AU - Brisbane: ConXt")
        ROUTING_LOCATION_IPS+=("202.174.110.136")
        
        # Australia - Melbourne (Southeast)
        ROUTING_LOCATION_NAMES+=("AU - Melbourne: BinaryLane")
        ROUTING_LOCATION_IPS+=("103.236.162.1")
        ROUTING_LOCATION_NAMES+=("AU - Melbourne: Aussie Broadband")
        ROUTING_LOCATION_IPS+=("121.200.10.3")
        
        # New Zealand - Auckland
        ROUTING_LOCATION_NAMES+=("NZ - Auckland: Telstra")
        ROUTING_LOCATION_IPS+=("202.84.227.54")
    else        
        # Asia - Japan (Far East)
        ROUTING_LOCATION_NAMES+=("JP - Tokyo: SoftBank")
        ROUTING_LOCATION_IPS+=("103.214.168.128")
        ROUTING_LOCATION_NAMES+=("JP - Tokyo: HE")
        ROUTING_LOCATION_IPS+=("core2.tyo1.he.net")
        
        # Asia - Hong Kong
        ROUTING_LOCATION_NAMES+=("HK - Hong Kong: GCore")
        ROUTING_LOCATION_IPS+=("5.188.230.129")
        ROUTING_LOCATION_NAMES+=("HK - Hong Kong: LeaseWeb Asia")
        ROUTING_LOCATION_IPS+=("43.249.36.49")
        
        # Asia - Vietnam
        ROUTING_LOCATION_NAMES+=("VN - Ho Chi Minh: FPT Telecom")
        ROUTING_LOCATION_IPS+=("103.186.65.98")
        
        # Asia - Singapore
        ROUTING_LOCATION_NAMES+=("SG - Singapore: CDN77")
        ROUTING_LOCATION_IPS+=("89.187.162.1")
        ROUTING_LOCATION_NAMES+=("SG - Singapore: TATA")
        ROUTING_LOCATION_IPS+=("gin-asina-tcore1.as6453.net")
        
        # Asia - India (West Asia)
        ROUTING_LOCATION_NAMES+=("IN - Chennai: Linode")
        ROUTING_LOCATION_IPS+=("speedtest-1.maa1.in.prod.linode.com")
        ROUTING_LOCATION_NAMES+=("IN - Mumbai: Jio")
        ROUTING_LOCATION_IPS+=("49.44.93.128")
        
        # Asia - Iran (Middle East)
        ROUTING_LOCATION_NAMES+=("IR - Tehran: ArvanCloud")
        ROUTING_LOCATION_IPS+=("37.32.0.1")
        ROUTING_LOCATION_NAMES+=("IR - Isfahan: Webdade")
        ROUTING_LOCATION_IPS+=("194.5.50.94")
        
        # Europe - Russia (Eastern Europe)
        ROUTING_LOCATION_NAMES+=("RU - Moscow: Misaka")
        ROUTING_LOCATION_IPS+=("45.142.246.177")
        
        # Europe - Romania
        ROUTING_LOCATION_NAMES+=("RO - Bucharest: M247")
        ROUTING_LOCATION_IPS+=("185.45.12.22")
        
        # Europe - Germany
        ROUTING_LOCATION_NAMES+=("DE - Falkenstein: Hetzner")
        ROUTING_LOCATION_IPS+=("fsn1-speed.hetzner.com")
        
        # Europe - France
        ROUTING_LOCATION_NAMES+=("FR - Paris: M247")
        ROUTING_LOCATION_IPS+=("185.94.189.162")
        
        # Europe - Netherlands
        ROUTING_LOCATION_NAMES+=("NL - Amsterdam: Clouvider")
        ROUTING_LOCATION_IPS+=("194.127.172.33")
        
        # Europe - UK (Western Europe)
        ROUTING_LOCATION_NAMES+=("UK - London: CDN77")
        ROUTING_LOCATION_IPS+=("185.59.221.51")
        
        # North America - Canada (Eastern North America)
        ROUTING_LOCATION_NAMES+=("CA - Montreal: OVH")
        ROUTING_LOCATION_IPS+=("51.222.154.207")
        
        # North America - US East
        ROUTING_LOCATION_NAMES+=("US - Buffalo: ColoCrossing")
        ROUTING_LOCATION_IPS+=("192.3.180.103")
        ROUTING_LOCATION_NAMES+=("US - New York: ReliableSite")
        ROUTING_LOCATION_IPS+=("104.243.42.233")
        ROUTING_LOCATION_NAMES+=("US - Miami: ReliableSite")
        ROUTING_LOCATION_IPS+=("104.238.204.68")
        
        # North America - US Central
        ROUTING_LOCATION_NAMES+=("US - Chicago: Psychz Networks")
        ROUTING_LOCATION_IPS+=("108.181.140.235")
        ROUTING_LOCATION_NAMES+=("US - Dallas: GSL")
        ROUTING_LOCATION_IPS+=("216.146.25.35")
        
        # North America - US West
        ROUTING_LOCATION_NAMES+=("US - Seattle: xTom")
        ROUTING_LOCATION_IPS+=("23.145.48.48")
        ROUTING_LOCATION_NAMES+=("US - Los Angeles: WebNX")
        ROUTING_LOCATION_IPS+=("64.185.232.162")
    fi
}

routing_ping_test() {
    local ip=$1
    local ping_output
    local ping_result
    local packet_loss
    
    if ! _exists "ping"; then
        echo "N/A"
        return
    fi
    
    ping_output=$(ping -c 5 -W 4 "$ip" 2>/dev/null)
    
    # Extract the average ping time
    ping_result=$(echo "$ping_output" | grep -E 'min/avg/max' | awk -F '/' '{printf "%.0f", $5}')
    
    # Extract the packet loss percentage
    packet_loss=$(echo "$ping_output" | grep -oP '\d+(?=% packet loss)')
    
    if [ -n "$ping_result" ]; then
        if [ "$packet_loss" -eq 0 ] 2>/dev/null; then
            echo "${ping_result}ms [No Loss]"
        else
            echo "${ping_result}ms [${packet_loss}% loss]"
        fi
    else
        echo "Failed"
    fi
}

routing_get_as_path() {
    local ip=$1
    local as_path

    if ! _exists "mtr"; then
        echo "MTR not installed"
        return
    fi

    # Extract the AS path using mtr
    as_path=$(timeout 30 mtr -wz -c 3 "$ip" 2>/dev/null | grep "AS[0-9]" | awk '{
        for (i=1; i<=NF; i++) {
            if ($i ~ /^AS/) {
                if (!seen[$i]++) {
                    printf "%s ", $i
                }
            }
        }
    }' | sed 's/ $//')

    echo "$as_path"
}

install_routing_test() {
    echo " Ping & Routing Test (Region: $REGION_NAME)"
    next
    printf "%-40s | %s\n" " Network" "Details"
    next
}

routing_test() {
    local region="$1"
    init_routing_locations "$region"
    install_routing_test

    for i in "${!ROUTING_LOCATION_NAMES[@]}"; do
        local location="${ROUTING_LOCATION_NAMES[$i]}"
        local ip="${ROUTING_LOCATION_IPS[$i]}"
        
        # Get results
        local ping_result=$(routing_ping_test "$ip")
        local as_path=$(routing_get_as_path "$ip")
        
        # Print results with consistent formatting
        printf " %-39s | %s\n" "$location" "$ping_result"
        printf " %-39s | %s\n" "$ip" "$as_path"
        next
    done
}
run_speed_sh() {
    ! _exists "wget" && _red "nws.sh is unable to run.\nError: wget command not found.\n" && kill -INT $$ && exit 1
    ! _exists "free" && _red "nws.sh is unable to run.\nError: free command not found.\n" && kill -INT $$ && exit 1

    start_time=$(date +%s)
    get_system_info
    clear
    print_intro 
    next
    print_system_info
    next
    ip_info
    next
    
    if [ -n "$ROUTING_TEST" ]; then
        ! _exists "mtr" && _red "nws.sh is unable to run.\nError: mtr command not found.\n" && kill -INT $$ && exit 1
        speed
    else
        install_speedtest  
        speed 
        rm -fr speedtest-cli
        next
        print_network_statistics
    fi
    
    next
    print_end_time
    get_runs_counter
    next
}

REGION="global"
REGION_NAME="GLOBAL"
ROUTING_TEST=""

# Handle -rt flag specially (before getopts)
if [ "$1" = "-rt" ]; then
    if [ -n "$2" ] && [[ "$2" != -* ]]; then
        # -rt with argument
        case "$2" in
            china)
                ROUTING_TEST="china"
                REGION_NAME="CHINA | 中華人民共和國"
                ;;
            asia)
                ROUTING_TEST="asia"
                REGION_NAME="ASIA"
                ;;
            na)
                ROUTING_TEST="na"
                REGION_NAME="NORTH AMERICA"
                ;;
            eu)
                ROUTING_TEST="eu"
                REGION_NAME="EUROPE"
                ;;
            au)
                ROUTING_TEST="au"
                REGION_NAME="AUSTRALIA & NZ"
                ;;
            global)
                ROUTING_TEST="global"
                REGION_NAME="GLOBAL"
                ;;
            *)
                echo "Invalid routing test type: $2" >&2
                echo "Valid routing test types: china, asia, na, eu, au, global"
                echo "Usage: -rt [type] (defaults to global)"
                echo "Visit nws.sh for instructions."
                exit 1
                ;;
        esac
        shift 2
    else
        # -rt without argument (default to global)
        ROUTING_TEST="global"
        REGION_NAME="GLOBAL"
        shift 1
    fi
fi

while getopts ":r:" opt; do
  case $opt in
    r)
      case $OPTARG in
        india)
          REGION="india"
          REGION_NAME="INDIA | भारत"
          ;;
        asia)
          REGION="asia"
          REGION_NAME="ASIA"
          ;;
        middle-east)
          REGION="middle-east"
          REGION_NAME="MIDDLE EAST | الشرق الأوسط"
          ;;
        na)
          REGION="na"
          REGION_NAME="NORTH AMERICA"
          ;;
        sa)
          REGION="sa"
          REGION_NAME="SOUTH AMERICA | LA AMÉRICA DEL SUR"
          ;;
        eu)
          REGION="eu"
          REGION_NAME="EUROPE"
          ;;
        au)
          REGION="au"
          REGION_NAME="AUSTRALIA/NZ"
          ;;
        africa)
          REGION="africa"
          REGION_NAME="AFRICA"
          ;;  
        iran)
          REGION="iran"
          REGION_NAME="IRAN | ایران"
          ;;  
        china)
          REGION="china"
          REGION_NAME="CHINA | 中華人民共和國"
          ;;  
        indonesia)
          REGION="indonesia"
          REGION_NAME="INDONESIA"
          ;;   
        russia)
          REGION="russia"
          REGION_NAME="RUSSIA | Россия"
          ;;
        10gplus)
          REGION="10gplus"
          REGION_NAME="GLOBAL - 10G+"
          ;;
        *)
          echo "Invalid REGION: $OPTARG" >&2
          echo "Valid Regions: na, sa, eu, au, asia, africa, middle-east, india, china, iran, russia, 10gplus"
          echo "For routing tests use: -rt china, -rt asia, -rt na, -rt eu, -rt au, or -rt global"
          echo "Visit nws.sh for instructions."
          exit 1
          ;;
      esac
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      echo "Visit nws.sh for instructions."
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      echo "Visit nws.sh for instructions."
      exit 1
      ;;
  esac
done


# run_speed_sh 
run_speed_sh | tee >(sed $'s/\033[[][^A-Za-z]*[A-Za-z]//g' > network-speed.txt)

if command -v curl >/dev/null; then
  share_link=$(curl -s -X POST -F 'file=@network-speed.txt' -F "region=$REGION" https://result.nws.sh/upload)
  if [ $? -ne 0 ]; then
    echo " Unable to share result online"
    echo " Result stored locally in $PWD/network-speed.txt"
  else
    if echo "$share_link" | grep -qE '^https?://.+'; then
        echo " Result             : $share_link"
        rm network-speed.txt
    else
        echo " Unable to share result online - There is some issue with the online uploader."
        echo " Result stored locally in $PWD/network-speed.txt"
    fi    
  fi
else
  echo " curl is not installed, Unable to share result online"
  echo " Result stored locally in $PWD/network-speed.txt"
fi

next
