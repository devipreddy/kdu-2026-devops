#!/bin/bash

REPO_URL="https://github.com/devipreddy/kdu-2026-devops"
REPO_NAME="kdu-2026-devops"

git clone "$REPO_URL"

cd "$REPO_NAME" || exit 1

cd phase-2 || exit 1

ls

echo "Hello from automation" > auto2.txt

git checkout -b new-branch2

git add .
git commit -m "Automated commit"

git push origin new-branch2