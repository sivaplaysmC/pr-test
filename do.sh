#!/bin/bash

# Check if gh CLI is installed
if ! command -v gh &> /dev/null; then
    echo "GitHub CLI (gh) is not installed. Please install it first."
    exit 1
fi

# Check if user is authenticated with gh
if ! gh auth status &> /dev/null; then
    echo "Please authenticate with GitHub first using 'gh auth login'"
    exit 1
fi

# Create a new branch with current timestamp
branch_name="random-data-$(date +%s)"
git checkout -b "$branch_name"

# Create file with 10 lines of base64 encoded random data
# Each line is exactly 10 characters
for i in {1..10}; do
    head -c 7 /dev/random | base64 | cut -c1-10 >> cool
done

# Add, commit and push changes
git add cool
git commit -m "Added random data file"
git push origin HEAD

# Create pull request using GitHub CLI
gh pr create \
    --title "Add random data file" \
    --body "This PR adds a file containing 10 lines of base64 encoded random data." \
    --base main \
    --head "$branch_name"

# Switch back to main branch
git checkout main

echo "Pull request created successfully and returned to main branch!"
