#!/bin/bash

URL="https://www.kickdrum.com/case-studies"

echo "Downloading using wget..."
wget "$URL" -O case_studies.html

echo "Downloading using curl with progress..."
curl -O "$URL"
