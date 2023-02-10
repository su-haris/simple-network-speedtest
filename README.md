# A simple script for testing network performance with speedtest-cli
[![Hits](https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fnetwork-speed.xyz&count_bg=%2379C83D&title_bg=%23555555&icon=&icon_color=%23E7E7E7&title=Hits&edge_flat=false)](https://hits.seeyoufarm.com)

Just a simple script for testing network performance.
Shows Basic System Info and Basic Network Info before speedtest

Thanks to Teddysun <i@teddysun.com> for the base bench.sh script

## Usage
```
curl -sL network-speed.xyz | bash
```
```
wget -qO- network-speed.xyz | bash
```

## Sample Output
```
------------------------- network-speed.xyz --------------------------
   A simple script to test network performance using speedtest-cli
----------------------------------------------------------------------
 Version            : 27/01/2023
----------------------------------------------------------------------
 Basic System Info
----------------------------------------------------------------------
 CPU Model          : Intel(R) Xeon(R) CPU E5-2698 v4 @ 2.20GHz
 CPU Cores          : 4 @ 2199.986 MHz
 CPU Cache          : 16384 KB
 AES-NI             : ✔ Enabled
 VM-x/AMD-V         : ✔ Enabled
 Total Disk         : 55.1 GB (31.3 GB Used)
 Total Mem          : 7.8 GB (664.5 MB Used)
 Total Swap         : 4.0 GB (43.7 MB Used)
 System uptime      : 44 days, 4 hour 57 min
 Load average       : 0.35, 0.18, 0.12
 OS                 : Ubuntu 22.04.1 LTS
 Arch               : x86_64 (64 Bit)
 Kernel             : 5.15.0-56-generic
 Virtualization     : KVM
----------------------------------------------------------------------
 Basic Network Info
----------------------------------------------------------------------
 Primary Network    : IPv6
 ISP                : Leaseweb Singapore
 ASN                : AS59253 Leaseweb Asia Pacific pte. ltd.
 Host               : 365 Group LLC
 Location           : Singapore, Central Singapore (01)
 Country            : Singapore
----------------------------------------------------------------------
 Speedtest.net
----------------------------------------------------------------------
 Location         Upload Speed    Download Speed  Latency     Server

 ISP: Leaseweb Asia

 Nearest          8951.53 Mbps    8241.48 Mbps    0.77 ms     MyRepublic Singapore - Singapore
 Cochin, IN       1517.51 Mbps    4214.29 Mbps    43.68 ms    Jio - Kochi
 Bangalore, IN    542.26 Mbps     26.31 Mbps      159.18 ms   Bharti Airtel Ltd - Bangalore
 Chennai, IN      2091.43 Mbps    4418.28 Mbps    33.94 ms    Jio - Chennai
 Mumbai, IN       941.68 Mbps     4181.80 Mbps    59.09 ms    i3D.net - Mumbai
 Delhi, IN        392.80 Mbps     5389.25 Mbps    78.64 ms    Tata Play Fiber - New Delhi

 Los Angeles, US  470.49 Mbps     1287.75 Mbps    180.25 ms   DediPath - Los Angeles, CA
 Dallas, US       461.58 Mbps     5.27 Mbps       230.54 ms   Hivelocity - Dallas, TX
 New York, US     375.92 Mbps     2256.83 Mbps    217.52 ms   Clouvider Ltd - New York, NY
 Seattle, US      440.44 Mbps     3350.96 Mbps    207.02 ms   Comcast - Seattle, WA
 Miami, US        408.87 Mbps     1442.22 Mbps    258.61 ms   AT&T - Miami, FL
 Montreal, CA     407.03 Mbps     3179.13 Mbps    225.71 ms   Rogers Wireless - Montréal, QC

 Paris, FR        478.76 Mbps     3063.64 Mbps    235.05 ms   ORANGE FRANCE - Paris
 Amsterdam, NL    251.01 Mbps     940.51 Mbps     159.99 ms   Hivelocity - Amsterdam
 Warsaw, PL       322.92 Mbps     1304.93 Mbps    284.84 ms   UPC Polska - Warszawa
 London, UK       664.44 Mbps     4268.91 Mbps    155.71 ms   VeloxServ Communications - London
 Frankfurt, DE    384.11 Mbps     1663.31 Mbps    237.13 ms   Deutsche Telekom - Frankfurt Am Main

 Dubai, AE        1257.17 Mbps    6326.77 Mbps    82.22 ms    du - Dubai
 Fujairah, AE     348.64 Mbps     1850.77 Mbps    251.79 ms   i3D.net - Dubai
 Jeddah, KSA      751.89 Mbps     1776.97 Mbps    139.26 ms   Saudi Telecom Company

 Shanghai, CN     0.30 Mbps       1875.59 Mbps    184.24 ms   China Unicom 5G - ShangHai
 Hong Kong, SAR   1491.32 Mbps    1501.61 Mbps    33.78 ms    STC - Hong Kong
 Singapore, SG    7290.54 Mbps    3547.77 Mbps    2.58 ms     i3D.net - Singapore
 Tokyo, JP        1206.07 Mbps    2835.69 Mbps    75.98 ms    GSL Networks - Tokyo
----------------------------------------------------------------------
 Finished in        : 13 min 14 sec
 Timestamp          : 2023-01-27 16:29:42 GMT
----------------------------------------------------------------------
```
