#!/bin/bash

# Git Helper Script for Synology NAS Docker Configurations
# Usage: ./git-helper.sh [command] [message]

DOCKER_GIT="sudo docker run --rm -v /volume2/docker:/workspace -v /var/services/homes/mintybacon/.ssh:/root/.ssh:ro -w /workspace alpine/git:latest"

case "$1" in
    "status")
        echo "Git Status:"
        $DOCKER_GIT status
        ;;
    "add")
        if [ -z "$2" ]; then
            echo "Adding all changes..."
            $DOCKER_GIT add .
        else
            echo "Adding $2..."
            $DOCKER_GIT add "$2"
        fi
        ;;
    "commit")
        if [ -z "$2" ]; then
            echo "Please provide a commit message"
            echo "Usage: ./git-helper.sh commit 'Your commit message'"
            exit 1
        fi
        echo "Committing changes..."
        $DOCKER_GIT commit -m "$2"
        ;;
    "log")
        echo "Git Log:"
        $DOCKER_GIT log --oneline -10
        ;;
    "diff")
        echo "Git Diff:"
        $DOCKER_GIT diff
        ;;
    "save")
        if [ -z "$2" ]; then
            echo "Please provide a commit message"
            echo "Usage: ./git-helper.sh save 'Your commit message'"
            exit 1
        fi
        echo "Adding all changes and committing..."
        $DOCKER_GIT add .
        $DOCKER_GIT commit -m "$2"
        ;;
    "push")
        echo "Pushing to GitHub..."
        echo "Note: You may need to set up authentication first."
        echo "Run ./push-to-github.sh for detailed instructions."
        $DOCKER_GIT push -u origin master
        ;;
           "pull")
               echo "Pulling from GitHub..."
               $DOCKER_GIT pull origin master
               ;;
           "fetch")
               echo "Fetching latest changes from GitHub..."
               $DOCKER_GIT fetch origin
               ;;
           "merge")
               if [ -z "$2" ]; then
                   echo "Please provide a branch to merge"
                   echo "Usage: ./git-helper.sh merge <branch-name>"
                   exit 1
               fi
               echo "Merging branch: $2"
               $DOCKER_GIT merge origin/"$2"
               ;;
           "checkout")
               if [ -z "$2" ]; then
                   echo "Please provide a branch name"
                   echo "Usage: ./git-helper.sh checkout <branch-name>"
                   exit 1
               fi
               echo "Checking out branch: $2"
               $DOCKER_GIT checkout "$2"
               ;;
           "branches")
               echo "Available branches:"
               $DOCKER_GIT branch -a
               ;;
    *)
        echo "Git Helper for Synology NAS Docker Configurations"
        echo ""
        echo "Usage: ./git-helper.sh [command] [message]"
        echo ""
        echo "Commands:"
        echo "  status                    - Show git status"
        echo "  add [file]               - Add file(s) to staging"
        echo "  commit 'message'         - Commit staged changes"
        echo "  save 'message'           - Add all changes and commit"
        echo "  push                     - Push to GitHub (requires auth setup)"
        echo "  pull                     - Pull from GitHub"
        echo "  fetch                     - Fetch latest changes from GitHub"
        echo "  merge [branch]           - Merge a branch into current branch"
        echo "  checkout [branch]        - Switch to a different branch"
        echo "  branches                 - List all available branches"
        echo "  log                      - Show recent commits"
        echo "  diff                     - Show changes"
        echo ""
        echo "Examples:"
        echo "  ./git-helper.sh status"
        echo "  ./git-helper.sh save 'Updated Home Assistant configuration'"
        echo "  ./git-helper.sh add compose/docker-compose.yml"
        echo "  ./git-helper.sh commit 'Added new service'"
        ;;
esac
