#!/bin/bash

# Set width for each side of the separator
SEPARATOR_WIDTH=83 
LEFT_PADDING=40 

# Function to print separator line
print_separator() {
    printf "%${SEPARATOR_WIDTH}s\n" | tr ' ' '-'
}

# Function to print header
print_header() {
    echo -e "\nws.sh - Ping and Routing Test (v2025.02.25)"
    printf "%${SEPARATOR_WIDTH}s\n" | tr ' ' '='
    echo -e "Network                                  | Details"
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

# Function to get AS path
get_as_path() {
    local ip=$1
    local as_path

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

    echo "$as_path"
}

# Use arrays to maintain order
declare -a location_names
declare -a location_ips

# Singapore
location_names+=("SG - Singapore: CDN77")
location_ips+=("89.187.162.1")
location_names+=("SG - Singapore: LeaseWeb Asia")
location_ips+=("103.254.153.18")
location_names+=("SG - Singapore: Host Universal")
location_ips+=("27.0.234.239")
location_names+=("SG - Singapore: GSL")
location_ips+=("103.167.150.90")
location_names+=("SG - Singapore: HE")
location_ips+=("core2.sin1.he.net")
location_names+=("SG - Singapore: ZenLayer")
location_ips+=("001.sin2.sg.k1s.zenlayer.win")
location_names+=("SG - Singapore: TATA")
location_ips+=("gin-asina-tcore1.as6453.net")
location_names+=("SG - Singapore: Telstra")
location_ips+=("202.84.219.173")

# Japan
location_names+=("JP - Tokyo: xTom")
location_ips+=("103.201.131.131")
location_names+=("JP - Tokyo: Shock Hosting")
location_ips+=("43.230.161.31")
location_names+=("JP - Tokyo: SoftBank")
location_ips+=("103.214.168.128")
location_names+=("JP - Tokyo: CDN77")
location_ips+=("89.187.160.1")
location_names+=("JP - Osaka: Vultr")
location_ips+=("64.176.34.94")
location_names+=("JP - Tokyo: HE")
location_ips+=("core2.tyo1.he.net")

# Hong Kong
location_names+=("HK - Hong Kong: ZenLayer")
location_ips+=("006.hkg3.hk.k1s.zenlayer.win")
location_names+=("HK - Hong Kong: GCore")
location_ips+=("5.188.230.129")
location_names+=("HK - Hong Kong: LeaseWeb Asia")
location_ips+=("43.249.36.49")
location_names+=("HK - Hong Kong: HE")
location_ips+=("core2.hkg2.he.net")
location_names+=("HK - Hong Kong: CDN77")
location_ips+=("84.17.57.129")
location_names+=("HK - Hong Kong: Telstra")
location_ips+=("202.84.173.22")

# South Korea
location_names+=("SK - Busan: Telstra")
location_ips+=("202.84.149.162")

# Indonesia
location_names+=("ID - Jakarta: WarnaHost")
location_ips+=("103.157.146.2")

# India
location_names+=("IN - Mumbai: Vultr")
location_ips+=("65.20.66.100")
location_names+=("IN - Mumbai: Jio")
location_ips+=("49.44.93.128")
location_names+=("IN - Kochi: Airtel")
location_ips+=("125.21.255.190")
location_names+=("IN - Chennai: Linode")
location_ips+=("speedtest-1.maa1.in.prod.linode.com")
location_names+=("IN - Chennai: ZenLayer")
location_ips+=("001.maa2.in.k1s.zenlayer.win")
location_names+=("IN - Chennai: Jio")
location_ips+=("49.44.93.133")

# Pakistan
location_names+=("PK - Islamabad: Virtury")
location_ips+=("103.151.111.249")

# Main execution
print_header

for i in "${!location_names[@]}"; do
    location="${location_names[$i]}"
    ip="${location_ips[$i]}"
    
    # Get results
    ping_result=$(do_ping "$ip")
    as_path=$(get_as_path "$ip")
    
    # Print results with consistent formatting
    printf "%-${LEFT_PADDING}s | %s\n" "$location" "$ping_result"
    printf "%-${LEFT_PADDING}s | %s\n" "$ip" "$as_path"
    print_separator
done
