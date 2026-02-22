#!/bin/bash

echo "System CPU Usage:"
top -l 1 | grep "CPU usage"

echo ""

echo "User CPU Percentage:"
top -l 1 | grep "CPU usage" | awk '{print $3}'

echo ""

echo "Idle CPU Percentage:"
top -l 1 | grep "CPU usage" | awk '{print $7}'

echo ""

echo "Number of running processes:"
ps aux | wc -l

echo ""

echo "Kernel Name:"
uname -r

echo ""

echo "Free Storage:"
df -h /