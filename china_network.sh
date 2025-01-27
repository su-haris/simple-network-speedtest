#!/bin/bash

# Color definitions
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Set width for each side of the separator
SEPARATOR_WIDTH=83  # Total width of separator line
LEFT_PADDING=30

# List of known Tier 1 ISPs and their AS numbers
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
)

# Function to print separator line
print_separator() {
    printf "%${SEPARATOR_WIDTH}s\n" | tr ' ' '-'
}

# Function to print header
print_header() {
    # printf "%${SEPARATOR_WIDTH}s\n" | tr ' ' '='
    echo -e "\n${BOLD}${BLUE}nws.sh - China Network Test (v2025.01.27)${NC}"
    printf "%${SEPARATOR_WIDTH}s\n" | tr ' ' '='
    echo -e "${BOLD}Network                        | Details${NC}"
    print_separator
}

# Function to perform ping test
do_ping() {
    local ip=$1
    ping_output=$(ping -c 5 $ip)
    
    # Extract the average ping time
    ping_result=$(echo "$ping_output" | grep -E 'min/avg/max' | awk -F '/' '{printf "%.0f", $5}')
    
    # Extract the packet loss percentage
    packet_loss=$(echo "$ping_output" | grep -oP '\d+(?=% packet loss)')
    
    if [ -n "$ping_result" ]; then
        if [ "$packet_loss" -eq 0 ]; then
            echo "${ping_result}ms [No Loss]"
        else
            echo "${ping_result}ms [${packet_loss}% loss]"
        fi
    else
        echo "Failed"
    fi
}

# Function to get AS path and the ISP before the first China ASN
get_as_path() {
    local ip=$1
    local as_path
    local china_asn
    local preceding_asn

    # Extract the AS path
    as_path=$(mtr -wz $ip | grep "AS[0-9]" | awk '{
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

get_line_type() {
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

    # Determine the preceding ASN's information only for non-premium lines
    if [[ ! $line_type =~ ^Premium ]]; then
        if [[ ${TIER1_ISPS[$preceding_asn]} ]]; then
            via_info="via ${TIER1_ISPS[$preceding_asn]}"
        else
            via_info="via $preceding_asn"
        fi
        line_type="$line_type $via_info"
    fi

    echo "$line_type"
}

# Array of locations and IPs
declare -A locations=(
    ["Beijing - China Telecom"]="219.141.136.12"
    ["Beijing - China Unicom"]="202.106.50.1"
    ["Beijing - China Mobile"]="221.179.155.161"
    ["Shanghai - China Telecom"]="202.96.209.133"
    ["Shanghai - China Unicom"]="210.22.97.1"
    ["Shanghai - China Mobile"]="211.136.112.200"
    ["Guangzhou - China Telecom"]="58.60.188.222"
    ["Guangzhou - China Unicom"]="210.21.196.6"
    ["Guangzhou - China Mobile"]="120.196.165.24"
    ["Chengdu - China Telecom"]="61.139.2.69"
    ["Chengdu - China Unicom"]="119.6.6.6"
    ["Chengdu - China Mobile"]="211.137.96.205"
    ["Shanghai - China Telecom"]="106.4.158.58"
    ["Shanghai - China Unicom"]="221.194.154.193"
    ["Shanghai - China Mobile"]="223.111.101.29"
)

# Main execution
print_header

for location in "${!locations[@]}"; do
    ip=${locations[$location]}
    
    # Get results
    ping_result=$(do_ping "$ip")

    as_path=$(get_as_path "$ip")
    actual_as_path=$(echo "${as_path%%|*}")

    line_type=$(get_line_type "$as_path")
    
    # Print all lines with consistent formatting
    printf "%-${LEFT_PADDING}s | %s\n" "$location" "$ping_result"
    printf "%-${LEFT_PADDING}s | %s\n" "$ip" "$actual_as_path"
    printf "%-${LEFT_PADDING}s | %s\n" "$(echo "$line_type" | cut -d'|' -f1)" "$(echo "$line_type" | cut -d'|' -f2)"
    print_separator
done
