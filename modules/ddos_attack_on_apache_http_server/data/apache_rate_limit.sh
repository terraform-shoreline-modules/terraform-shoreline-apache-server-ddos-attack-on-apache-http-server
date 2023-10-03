bash

#!/bin/bash



# Set the maximum number of requests per IP address

MAX_REQUESTS=${MAX_REQUESTS}



# Set the time interval for rate limiting in seconds

RATE_INTERVAL=${RATE_INTERVAL}



# Configure iptables to limit the number of connections per IP address

iptables -A INPUT -p tcp --dport 80 -m connlimit --connlimit-above ${MAX_CONNECTIONS} --connlimit-mask 0 -j DROP



# Configure Apache to limit the number of requests per IP address

echo "LimitRequestBody 102400" >> /etc/httpd/conf/httpd.conf # Set the maximum request size

echo "MaxConnectionsPerChild 10000" >> /etc/httpd/conf/httpd.conf # Set the maximum number of connections per child process

echo "MaxRequestsPerChild 100" >> /etc/httpd/conf/httpd.conf # Set the maximum number of requests per child process

echo "${IFMODULE_MOD_EVASIVE_SO}" >> /etc/httpd/conf/httpd.conf

echo "DOSHashTableSize 3097" >> /etc/httpd/conf/httpd.conf

echo "DOSPageCount 10" >> /etc/httpd/conf/httpd.conf

echo "DOSSiteCount 50" >> /etc/httpd/conf/httpd.conf

echo "DOSPageInterval 1" >> /etc/httpd/conf/httpd.conf

echo "DOSSiteInterval 1" >> /etc/httpd/conf/httpd.conf

echo "DOSBlockingPeriod 60" >> /etc/httpd/conf/httpd.conf

echo "${_IFMODULE}" >> /etc/httpd/conf/httpd.conf



# Restart Apache to apply the changes

systemctl restart httpd