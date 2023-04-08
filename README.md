# A simple script for testing network performance with speedtest-cli
[![Hits](https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fnetwork-speed.xyz&count_bg=%2379C83D&title_bg=%23555555&icon=&icon_color=%23E7E7E7&title=Visitors&edge_flat=false)](https://hits.seeyoufarm.com)

Just a simple script for testing network performance.

Shows the following info:
   - Basic System Info - like CPU, RAM, Disk etc
   - Basic Network Info - Protocol (IPv4/v6), ISP, Location etc
   - Global Ookla speedtest.net to servers around the world with speed, ping, packet loss etc
   - Regional Ookla speedtest.net for below regions
      - North America
      - South America
      - Europe
      - Asia
      - GCC Middle East
      - India
      - More coming soon!
   - Statistics from the speedtest
   - Shareable Link (FroCDN) of the result 


Thanks to Teddysun <i@teddysun.com> for the base bench.sh script

## Usage

### Global Speedtest (default)
```
curl -sL network-speed.xyz | bash
```
```
wget -qO- network-speed.xyz | bash
```

### Regional Speedtest
region_name = na, sa, eu, asia, india, middle-east
```
curl -sL network-speed.xyz | bash -s -- -r region_name
```
```
wget -qO- network-speed.xyz | bash -s -- -r region_name
```

### Example:
```
wget -qO- network-speed.xyz | bash -s -- -r india
```

## Sample Output (Global)
```
---------------------------- network-speed.xyz ----------------------------
      A simple script to test network performance using speedtest-cli
---------------------------------------------------------------------------
 Version            : v2023.04.08
---------------------------------------------------------------------------
 Basic System Info
---------------------------------------------------------------------------
 CPU Model          : Intel Core Processor (Skylake, IBRS)
 CPU Cores          : 1 @ 3408.020 MHz
 CPU Cache          : 16384 KB
 AES-NI             : ✔ Enabled
 VM-x/AMD-V         : ✔ Enabled
 Total Disk         : 726.8 GB (158.8 GB Used)
 Total RAM          : 1.9 GB (418.0 MB Used)
 System uptime      : 9 days, 21 hour 37 min
 Load average       : 0.61, 0.47, 0.40
 OS                 : Ubuntu 20.04.6 LTS
 Arch               : x86_64 (64 Bit)
 Kernel             : 5.4.0-146-generic
 Virtualization     : KVM
---------------------------------------------------------------------------
 Basic Network Info
---------------------------------------------------------------------------
 Primary Network    : IPv6
 ISP                : Kuroit Limited
 ASN                : AS203363 Kuroit Limited
 Host               : Kuroit Limited
 Location           : City of London, England-ENG, United Kingdom
---------------------------------------------------------------------------
 Speedtest.net (Region: GLOBAL)
---------------------------------------------------------------------------
 Location         Latency     Loss    DL Speed       UP Speed       Server

 ISP: Kuroit Limited

 Nearest          22.94 ms    0.0%    787.87 Mbps    266.47 Mbps    ADD39 - Coding SRL - Abbadia San Salvatore

 Kochi, IN        155.99 ms   0.0%    393.09 Mbps    425.00 Mbps    Asianet Broadband - Cochin
 Bangalore, IN    148.29 ms   0.0%    364.72 Mbps    513.14 Mbps    Bharti Airtel Ltd - Bangalore
 Chennai, IN      143.94 ms   N/A     434.88 Mbps    570.51 Mbps    Jio - Chennai
 Mumbai, IN       164.21 ms   0.0%    408.45 Mbps    380.88 Mbps    i3D.net - Mumbai
 Delhi, IN        149.62 ms   0.0%    415.04 Mbps    310.55 Mbps    Tata Play Fiber - New Delhi

 Los Angeles, US  126.31 ms   0.0%    447.56 Mbps    216.76 Mbps    ReliableSite Hosting - Los Angeles, CA
 Dallas, US       106.54 ms   0.0%    669.37 Mbps    682.99 Mbps    Hivelocity - Dallas, TX
 New York, US     70.31 ms    0.0%    683.20 Mbps    703.36 Mbps    Clouvider Ltd - New York, NY
 Seattle, US      133.63 ms   N/A     654.15 Mbps    408.42 Mbps    Comcast - Seattle, WA
 Miami, US        103.08 ms   0.0%    569.01 Mbps    377.75 Mbps    AT&T - Miami, FL
 Toronto, CA      84.16 ms    0.0%    536.03 Mbps    644.44 Mbps    Rogers - Toronto, ON

 Paris, FR        8.00 ms     0.0%    751.90 Mbps    854.37 Mbps    ORANGE FRANCE - Paris
 Amsterdam, NL    5.44 ms     0.0%    875.18 Mbps    908.46 Mbps    Clouvider Ltd - Amsterdam
 Warsaw, PL       32.57 ms    0.0%    815.58 Mbps    694.72 Mbps    UPC Polska - Warszawa
 London, UK       4.34 ms     0.3%    608.95 Mbps    922.42 Mbps    VeloxServ Communications - London
 Frankfurt, DE    14.56 ms    0.0%    913.87 Mbps    423.48 Mbps    23M GmbH - Frankfurt Am Main

 Dubai, AE        135.32 ms   0.0%    637.74 Mbps    632.98 Mbps    du - Dubai
 Fujairah, AE     117.99 ms   0.0%    951.56 Mbps    265.95 Mbps    ETISALAT-UAE - Fujairah
 Jeddah, KSA      81.15 ms    0.0%    911.54 Mbps    495.46 Mbps    Saudi Telecom Company

 Shanghai, CU-CN  226.14 ms   0.0%    439.63 Mbps    377.51 Mbps    China Unicom 5G - ShangHai
 Nanjing, CT-CN   205.47 ms   0.0%    415.15 Mbps    345.48 Mbps    China Telecom JiangSu 5G - Nanjing
 Hong Kong, HKG   171.44 ms   N/A     594.13 Mbps    467.51 Mbps    STC - Hong Kong
 Singapore, SG    153.71 ms   0.0%    356.85 Mbps    532.06 Mbps    i3D.net - Singapore
 Jakarta, ID      190.70 ms   0.0%    352.16 Mbps    275.85 Mbps    PT Indosat Tbk - Jakarta
 Tokyo, JP        242.39 ms   N/A     608.89 Mbps    303.57 Mbps    fdcservers.net - Tokyo
---------------------------------------------------------------------------
 Avg DL Speed       : 599.87 Mbps
 Avg UL Speed       : 500.01 Mbps

 Total DL Data      : 21.77 GB
 Total UL Data      : 15.72 GB
 Total Data         : 37.49 GB
---------------------------------------------------------------------------
 Duration           : 12 min 30 sec
 System Time        : 08/04/2023 - 15:51:29 IST
 Total Script Runs  : 822
---------------------------------------------------------------------------
 Result             : https://cdn1.frocdn.ch/pBBRfnvcE2LtQ4D.txt
---------------------------------------------------------------------------
```

## Sample Output (Regional)
```
---------------------------------------------------------------------------
 Basic System Info
---------------------------------------------------------------------------
 CPU Model          : Intel(R) Xeon(R) CPU E5-2697 v2 @ 2.70GHz
 CPU Cores          : 2 @ 2699.998 MHz
 CPU Cache          : 16384 KB
 AES-NI             : ✔ Enabled
 VM-x/AMD-V         : ❌ Disabled
 Total Disk         : 52.1 GB (27.0 GB Used)
 Total RAM          : 2.4 GB (588.9 MB Used)
 Total Swap         : 2.0 GB (173.1 MB Used)
 System uptime      : 9 days, 15 hour 17 min
 Load average       : 0.15, 0.24, 0.26
 OS                 : Ubuntu 22.04.2 LTS
 Arch               : x86_64 (64 Bit)
 Kernel             : 5.15.0-69-generic
 Virtualization     : KVM
---------------------------------------------------------------------------
 Basic Network Info
---------------------------------------------------------------------------
 Primary Network    : IPv6
 ISP                : Multacom Corporation
 ASN                : AS35916 MULTACOM CORPORATION
 Host               : Multacom Corporation
 Location           : Los Angeles, California-CA, United States
---------------------------------------------------------------------------
 Speedtest.net (Region: NORTH AMERICA)
---------------------------------------------------------------------------
 Location         Latency     Loss    DL Speed       UP Speed       Server
 
 ISP: Multacom Corporation
 
 Nearest          0.41 ms     N/A     845.42 Mbps    838.63 Mbps    Netprotect - Los Angeles, CA
 
 Vancouver, BC    29.30 ms    N/A     870.78 Mbps    927.13 Mbps    TELUS - Vancouver, BC
 Toronto, ON      63.05 ms    0.0%    812.79 Mbps    908.82 Mbps    TELUS - Toronto, ON
 Toronto, ON      77.07 ms    0.0%    908.32 Mbps    899.99 Mbps    Bell Canada - Toronto, ON
 Montreal, QC     76.53 ms    0.0%    633.67 Mbps    861.93 Mbps    Rogers Wireless - Montréal, QC
 
 New York, NY     59.54 ms    0.0%    478.24 Mbps    75.13 Mbps     Hivelocity - New York, NY
 Ashburn, VA      67.78 ms    0.0%    784.45 Mbps    570.35 Mbps    Rackdog - Ashburn, VA
 Secaucus, NJ     76.62 ms    0.0%    500.53 Mbps    717.75 Mbps    DediPath - Secaucus, NJ
 Charlotte, NC    70.80 ms    0.0%    729.53 Mbps    705.66 Mbps    Windstream - Charlotte, NC
 Atlanta, GA      50.27 ms    N/A     830.06 Mbps    826.84 Mbps    fdcservers.net - Atlanta, GA
 Miami, FL        63.07 ms    0.0%    848.39 Mbps    832.22 Mbps    AT&T - Miami, FL
 Dallas, TX       30.62 ms    0.0%    777.35 Mbps    918.87 Mbps    Hivelocity - Dallas, TX
 Kansas, MO       58.10 ms    N/A     829.47 Mbps    812.14 Mbps    Dish Wireless - Kansas City, MO
 Minneapolis, MN  49.68 ms    0.0%    806.88 Mbps    812.78 Mbps    US Internet - Minneapolis, MN
 Chicago, IL      44.62 ms    0.0%    895.92 Mbps    818.54 Mbps    GSL Networks - Chicago, IL
 Cleveland, OH    63.56 ms    0.0%    822.55 Mbps    816.39 Mbps    Windstream - Cleveland, OH
 Albuquerque, NM  35.53 ms    N/A     875.21 Mbps    916.09 Mbps    Comcast - Albuquerque, NM
 Denver, CO       37.24 ms    0.0%    869.77 Mbps    827.46 Mbps    DediPath - Denver, CO
 Portland, OR     22.16 ms    N/A     878.51 Mbps    832.33 Mbps    CenturyLink - Portland, OR
 Las Vegas, NV    6.54 ms     N/A     874.95 Mbps    838.97 Mbps    Dish Wireless - Las Vegas, NV
 Phoenix, AZ      8.13 ms     0.0%    921.62 Mbps    913.26 Mbps    GSL Networks - Phoenix, AZ
 Los Angeles, CA  1.07 ms     0.0%    907.39 Mbps    908.98 Mbps    i3D.net - Los Angeles, CA
 Los Angeles, CA  0.58 ms     0.0%    907.89 Mbps    909.39 Mbps    ReliableSite Hosting - Los Angeles, CA
 Seattle, WA      29.99 ms    0.0%    931.17 Mbps    916.48 Mbps    GSL Networks - Seattle, WA
 
 Mexico City, MX  58.88 ms    0.0%    832.17 Mbps    781.18 Mbps    AT&T México - Mexico City
 Guadalajara, MX  30.61 ms    N/A     888.92 Mbps    916.53 Mbps    INFINITUM - Guadalajara
 Hermosillo, MX   25.51 ms    0.0%    876.43 Mbps    836.21 Mbps    Totalplay - Hermosillo
---------------------------------------------------------------------------
 Avg DL Speed       : 821.50 Mbps
 Avg UL Speed       : 813.50 Mbps
 
 Total DL Data      : 28.39 GB
 Total UL Data      : 25.99 GB
 Total Data         : 54.38 GB
---------------------------------------------------------------------------
 Duration           : 11 min 13 sec
 System Time        : 08/04/2023 - 13:30:36 IST
 Total Script Runs  : 813
---------------------------------------------------------------------------
```

## Bandwidth Usage 
The script usually takes around 10-15 minutes to complete execution for global speedtest.\
Data usage is hard to estimate since it is completely dependant on the connection and location.\
However, below is a very rough estimate - based on a few tests on different networks.

| Port Speed (DL/UL) | Data Used | Country 
|--|--|--|
|10Gbps Symmetric    | ~130GB | SG |
|5Gbps Symmetric     | ~60GB  | KR |
|1Gbps Symmetric     | ~40GB  | US |
|750Mbps Symmetric   | ~35GB  | DE |
|500Mbps Symmetric   | ~25GB  | IN |
|100Mbps Symmetric   | ~6GB   | US |
|--|--|--|
|2Gbps/250Mbps       | ~50GB  | DE |
|1Gbps/250Mbps       | ~35GB  | CA |