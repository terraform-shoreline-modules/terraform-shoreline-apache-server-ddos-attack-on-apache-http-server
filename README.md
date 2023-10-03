
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# DDoS Attack on Apache HTTP Server.
---

This incident type refers to a distributed denial-of-service (DDoS) attack on an Apache HTTP server. In a DDoS attack, a large number of requests are sent to the server, overwhelming its capacity to respond to legitimate requests. This can cause the server to become inaccessible to users and disrupt normal operations. Apache HTTP Server is a popular open-source web server software used by millions of websites, making it a common target for cyber attacks.

### Parameters
```shell
export INTERFACE="PLACEHOLDER"

export MAX_CONNECTIONS="PLACEHOLDER"

export MAX_REQUESTS="PLACEHOLDER"

export RATE_INTERVAL="PLACEHOLDER"
```

## Debug

### Check if Apache HTTP Server is running
```shell
systemctl status apache2
```

### Check Apache HTTP Server logs for any suspicious requests
```shell
tail -f /var/log/apache2/access.log
```

### Show connections per IP address to the web server
```shell
netstat -ntu | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | sort -n
```

### Show which network interfaces are receiving the most traffic
```shell
iftop -i ${INTERFACE}
```

### Show the top 10 IP addresses with the most connections to the server
```shell
netstat -ntu | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | sort -nr | head
```

### Show the top 10 IPs with the most requests to the server
```shell
cat /var/log/apache2/access.log | awk '{print $1}' | sort | uniq -c | sort -nr | head
```

### Check if there are any open connections to the server
```shell
netstat -an | grep :80 | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | sort -n
```

### Check if there are any SYN packets flooding the server
```shell
tcpdump -i ${INTERFACE} 'tcp[tcpflags] & tcp-syn != 0' | wc -l
```

## Repair

### Implement rate limiting: Implement rate-limiting to limit the number of requests a single IP address can make to the server.
```shell
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


```