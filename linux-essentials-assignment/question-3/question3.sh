#!/bin/bash

get_url="https://jsonplaceholder.typicode.com/posts/1"
post_url="https://jsonplaceholder.typicode.com/posts"
post_data='{"title":"foo","body":"bar","userId":1}'

echo "GET Request:"
curl -X GET "$get_url"

echo ""
echo "POST Request:"
curl -X POST "$post_url" \
     -H "Content-Type: application/json" \
     -d "$post_data"
