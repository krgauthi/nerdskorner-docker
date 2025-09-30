# GitHub Actions Workflow Guide

This guide explains how to use GitHub Actions with Gemini CLI for automated Docker configuration management.

## 🚀 **Setup Requirements**

### **1. GitHub Secrets**
Add these secrets to your GitHub repository:
- `GEMINI_API_KEY` - Your Gemini API key from Google AI Studio

### **2. Repository Settings**
- Enable GitHub Actions in repository settings
- Ensure Actions have write permissions for issues and pull requests

## 📋 **Workflow Overview**

### **Issue-to-PR Workflow**
1. **Create GitHub Issue** with `gemini-fix` label
2. **GitHub Action triggers** automatically
3. **Gemini generates** Docker configuration fixes
4. **Pull Request created** with automated changes
5. **Review and merge** the PR

### **PR Review Workflow**
1. **Create Pull Request** (manual or automated)
2. **Gemini reviews** the changes automatically
3. **Review comments** posted on the PR
4. **Address feedback** and update PR

## 🔧 **Using the Workflows**

### **Creating Issues for Gemini Fixes**

#### **Issue Template:**
```markdown
## Problem Description
[Describe the Docker configuration issue]

## Current Configuration
[Paste relevant docker-compose.yml sections]

## Expected Behavior
[What should happen]

## Additional Context
[Any other relevant information]
```

#### **Issue Labels:**
- Add `gemini-fix` label to trigger automated fixing
- Use other labels for categorization

### **Example Issues:**

#### **Add New Service**
```markdown
## Problem Description
I want to add Portainer for Docker management

## Current Configuration
[Current docker-compose.yml]

## Expected Behavior
Portainer should be accessible at http://localhost:9000

## Additional Context
- Use port 9000
- Store data in portainer/data/
- Include proper comment header
```

#### **Fix Configuration Issue**
```markdown
## Problem Description
Home Assistant container keeps restarting

## Current Configuration
[Current homeassistant service config]

## Expected Behavior
Container should start and stay running

## Additional Context
- Check logs show permission errors
- May need to adjust volume mounts
```

## 🔄 **Git Commands for Managing Changes**

### **Pull Changes from GitHub**
```bash
# Fetch latest changes
./git-helper.sh fetch

# Pull changes to current branch
./git-helper.sh pull

# List all branches (including PR branches)
./git-helper.sh branches

# Checkout a specific branch (e.g., from a PR)
./git-helper.sh checkout fix/issue-123

# Merge a branch into master
./git-helper.sh merge fix/issue-123
```

### **Workflow for Reviewing PRs**
```bash
# 1. Fetch latest changes
./git-helper.sh fetch

# 2. List available branches
./git-helper.sh branches

# 3. Checkout the PR branch
./git-helper.sh checkout fix/issue-123

# 4. Test the changes locally
sudo docker-compose -f compose/docker-compose.yml config

# 5. If changes look good, merge them
./git-helper.sh checkout master
./git-helper.sh merge fix/issue-123

# 6. Push the merged changes
./git-helper.sh push
```

## 🛠️ **Troubleshooting GitHub Actions**

### **Common Issues**

#### **Action Not Triggering**
- ✅ Check issue has `gemini-fix` label
- ✅ Verify GitHub Actions are enabled
- ✅ Check repository permissions

#### **Gemini API Errors**
- ✅ Verify `GEMINI_API_KEY` secret is set
- ✅ Check API key has proper permissions
- ✅ Ensure API quota isn't exceeded

#### **Generated Code Issues**
- ✅ Review generated YAML syntax
- ✅ Test configuration with `docker-compose config`
- ✅ Check for missing environment variables

### **Debugging Steps**
1. **Check Action Logs** in GitHub Actions tab
2. **Review Generated Code** in the PR
3. **Test Locally** before merging
4. **Validate YAML** syntax

## 📝 **Best Practices**

### **Writing Good Issues**
- ✅ **Be specific** about the problem
- ✅ **Include current configuration** 
- ✅ **Describe expected behavior**
- ✅ **Add relevant context**

### **Reviewing Generated PRs**
- ✅ **Test configuration** locally first
- ✅ **Check for security issues**
- ✅ **Verify all services are included**
- ✅ **Ensure proper formatting**

### **Managing Branches**
- ✅ **Clean up merged branches**
- ✅ **Use descriptive branch names**
- ✅ **Test before merging**
- ✅ **Keep master branch stable**

## 🔒 **Security Considerations**

### **API Key Security**
- ✅ Store `GEMINI_API_KEY` as repository secret
- ✅ Never commit API keys to code
- ✅ Use least-privilege access

### **Generated Code Review**
- ✅ **Always review** generated configurations
- ✅ **Check for hardcoded secrets**
- ✅ **Verify security best practices**
- ✅ **Test in safe environment first**

## 📊 **Monitoring and Maintenance**

### **Action Monitoring**
- Check GitHub Actions tab regularly
- Monitor for failed runs
- Review generated PRs promptly

### **Repository Maintenance**
- Clean up merged PR branches
- Update GitHub Actions as needed
- Monitor API usage and costs

## 🎯 **Example Workflows**

### **Adding a New Service**
1. Create issue: "Add Grafana monitoring"
2. Add `gemini-fix` label
3. Wait for automated PR
4. Review generated configuration
5. Test locally if needed
6. Merge PR
7. Pull changes to local repository

### **Fixing Configuration Issues**
1. Create issue: "Fix Home Assistant permissions"
2. Add `gemini-fix` label  
3. Review automated fix
4. Test the solution
5. Merge if working
6. Update local repository

---

**Remember**: Always test generated configurations in a safe environment before deploying to production!
