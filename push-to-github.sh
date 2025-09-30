#!/bin/bash

# Push to GitHub Script for Synology NAS
# This script handles GitHub authentication for pushing Docker configurations

echo "Pushing Docker configurations to GitHub..."
echo "Repository: https://github.com/krgauthi/nerdskorner-docker.git"
echo ""

# Check if we have a GitHub token
if [ -z "$GITHUB_TOKEN" ]; then
    echo "GitHub Personal Access Token not found."
    echo ""
    echo "To push to GitHub, you have a few options:"
    echo ""
    echo "1. Use GitHub Personal Access Token (Recommended):"
    echo "   - Go to GitHub.com → Settings → Developer settings → Personal access tokens"
    echo "   - Generate a new token with 'repo' permissions"
    echo "   - Set it as environment variable: export GITHUB_TOKEN=your_token_here"
    echo "   - Then run this script again"
    echo ""
    echo "2. Use SSH (if you've added your SSH key to GitHub):"
    echo "   - Run: sudo docker run --rm -v /volume2/docker:/workspace -w /workspace alpine/git:latest remote set-url origin git@github.com:krgauthi/nerdskorner-docker.git"
    echo "   - Then run: sudo docker run --rm -v /volume2/docker:/workspace -w /workspace alpine/git:latest push -u origin master"
    echo ""
    echo "3. Manual push from your local machine:"
    echo "   - Clone the repo locally"
    echo "   - Copy the files from your NAS"
    echo "   - Push from your local machine"
    echo ""
    exit 1
fi

# Use token for authentication
echo "Using GitHub token for authentication..."
sudo docker run --rm -v /volume2/docker:/workspace -w /workspace alpine/git:latest remote set-url origin https://${GITHUB_TOKEN}@github.com/krgauthi/nerdskorner-docker.git

echo "Pushing to GitHub..."
sudo docker run --rm -v /volume2/docker:/workspace -w /workspace alpine/git:latest push -u origin master

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Successfully pushed to GitHub!"
    echo "Repository: https://github.com/krgauthi/nerdskorner-docker"
    echo ""
    echo "Next time you can use:"
    echo "  ./git-helper.sh save 'Your commit message'"
    echo "  ./push-to-github.sh"
else
    echo ""
    echo "❌ Failed to push to GitHub. Check your token and try again."
fi
