# Docker Container Management Workflow

This document outlines how to use AI agents to manage your Docker containers on your Synology NAS.

## 🎯 **Quick Start Commands**

### **Essential Commands**
```bash
# Check status of all containers
./git-helper.sh status

# Save changes and push to GitHub
./git-helper.sh save "Description of changes"

# View recent changes
./git-helper.sh log

# Pull latest changes from GitHub
./git-helper.sh pull
```

## 📋 **Container Management Workflow**

### **1. Adding New Containers**

When adding a new Docker service:

1. **Add to `compose/docker-compose.yml` with proper comment header**
   ```yaml
   # =============================
   #  Service Name
   #  https://hub.docker.com/r/owner/image
   #  Brief description of what this service does
   # =============================
   new-service:
     image: service/image:latest
     container_name: New-Service
     restart: unless-stopped
     environment:
       - TZ=${TZ}
       - PUID=${PUID}
       - PGID=${PGID}
     volumes:
       - ${DOCK_ROOT}/new-service:/config
     ports:
       - "8080:8080"
   ```

2. **Create configuration directory**
   ```bash
   mkdir -p new-service/config
   ```

3. **Update `.gitignore`** if needed
   ```bash
   # Add service-specific exclusions
   new-service/config/data/
   new-service/logs/
   ```

4. **Update README.md** with service information
   ```markdown
   ## New Service
   - **Purpose**: Brief description
   - **Access**: http://localhost:8080
   - **Config**: `new-service/config/`
   - **Documentation**: [Link to docs]
   - **External Access**: https://new-service.nerdskorner.tech (if applicable)
   ```

5. **Update service documentation in README.md**
   - Add to the services list
   - Include access URLs (local and external)
   - Document any special configuration requirements
   - Add troubleshooting notes if needed

6. **Commit and push**
   ```bash
   ./git-helper.sh save "Added new-service container"
   ```

### **2. Modifying Existing Containers**

When updating container configurations:

1. **Edit the relevant files**
   - `compose/docker-compose.yml` for Docker settings
   - Service-specific config files for application settings

2. **Test the changes**
   ```bash
   # Restart specific container
   sudo docker-compose -f compose/docker-compose.yml restart service-name
   
   # Check logs
   sudo docker logs service-name --follow
   ```

3. **Commit changes**
   ```bash
   ./git-helper.sh save "Updated service-name configuration"
   ```

### **3. Troubleshooting Containers**

When containers aren't working:

1. **Check container status**
   ```bash
   sudo docker ps -a
   sudo docker logs container-name
   ```

2. **Check configuration files**
   - Verify `docker-compose.yml` syntax
   - Check service-specific config files
   - Ensure volumes and ports are correct

3. **Common fixes**
   - Restart container: `sudo docker-compose restart service-name`
   - Rebuild container: `sudo docker-compose up -d --build service-name`
   - Check file permissions: `ls -la service-directory/`

## 🔧 **Service-Specific Management**

### **Cloudflare Tunnel**
- **Config**: `cloudflared/config.yml`
- **Restart**: `sudo docker-compose restart cloudflared`
- **Logs**: `sudo docker logs Cloudflare-Tunnel --follow`
- **DNS Setup**: Ensure CNAME records point to `{tunnel-id}.cfargotunnel.com`

### **Home Assistant**
- **Config**: `homeassistant/config/configuration.yaml`
- **Restart**: `sudo docker-compose restart homeassistant`
- **Logs**: `sudo docker logs HomeAssistant --follow`
- **Access**: `http://192.168.1.88:8123` or `https://homeassistant.nerdskorner.tech`

### **Nginx Proxy Manager**
- **Config**: `nginx-proxy-manager/data/`
- **Restart**: `sudo docker-compose restart nginx-proxy-manager`
- **Access**: `http://192.168.1.88:81`

### **Media Services (Radarr, Sonarr, etc.)**
- **Configs**: `{service}/config/`
- **Restart**: `sudo docker-compose restart {service}`
- **Logs**: `sudo docker logs {service} --follow`

## 📁 **File Organization**

### **Configuration Files (Tracked in Git)**
```
compose/
├── docker-compose.yml          # Main Docker Compose file
├── backup/                     # Backup configurations
└── vpn.ovpn                   # VPN configuration

cloudflared/
└── config.yml                 # Cloudflare tunnel config

homeassistant/config/
└── configuration.yaml         # Home Assistant config

proxy/config/
└── nginx.conf                 # Nginx configuration

nzbget/config/
└── nzbget.conf               # NZBGet configuration

transmission/config/
└── settings.json             # Transmission settings

couchdb/
└── local.ini                 # CouchDB configuration
```

### **Excluded Files (Not in Git)**
- `*/data/` - All data directories
- `*/logs/` - All log files
- `*.db` - Database files
- `*.json` - Credential files (except safe configs)
- `*.pem`, `*.key` - Certificate files
- `*/config/data/` - Service data directories

## 🚀 **Deployment Workflow**

### **Initial Setup**
1. Clone repository: `git clone git@github.com:krgauthi/nerdskorner-docker.git`
2. Set up environment variables
3. Configure Cloudflare tunnel credentials
4. Start services: `sudo docker-compose up -d`

### **Regular Maintenance**
1. **Weekly**: Check container health and logs
2. **Monthly**: Update container images
3. **As needed**: Add new services or modify configurations

### **Backup Strategy**
- **Git**: All configuration files are version controlled
- **Data**: Regular backups of data directories (not in Git)
- **Credentials**: Secure backup of certificate and credential files

## 🔍 **Troubleshooting Guide**

### **Common Issues**

#### **Container Won't Start**
```bash
# Check logs
sudo docker logs container-name

# Check configuration
sudo docker-compose config

# Restart with rebuild
sudo docker-compose up -d --build service-name
```

#### **Permission Issues**
```bash
# Fix ownership
sudo chown -R 1000:1000 service-directory/

# Check permissions
ls -la service-directory/
```

#### **Network Issues**
```bash
# Check network connectivity
sudo docker network ls
sudo docker network inspect docker_default

# Test port accessibility
netstat -tlnp | grep :port
```

#### **Volume Mount Issues**
```bash
# Check volume mounts
sudo docker inspect container-name | grep -A 10 "Mounts"

# Verify directory exists
ls -la /volume2/docker/service-directory/
```

### **Service-Specific Troubleshooting**

#### **Cloudflare Tunnel**
- **Error 1033**: Check DNS CNAME records
- **521 errors**: Verify service is running on correct port
- **Tunnel offline**: Check credentials and network connectivity

#### **Home Assistant**
- **400 Bad Request**: Check `trusted_proxies` configuration
- **Can't access**: Verify `external_url` and `internal_url` settings

#### **Media Services**
- **Permission denied**: Check file ownership and permissions
- **Can't access files**: Verify volume mounts and paths

## 📚 **Useful Commands Reference**

### **Docker Management**
```bash
# View all containers
sudo docker ps -a

# View container logs
sudo docker logs container-name --follow

# Restart container
sudo docker-compose restart service-name

# Stop all services
sudo docker-compose down

# Start all services
sudo docker-compose up -d

# Update container images
sudo docker-compose pull
sudo docker-compose up -d
```

### **Git Management**
```bash
# Check status
./git-helper.sh status

# Save changes
./git-helper.sh save "Description"

# View history
./git-helper.sh log

# Push to GitHub
./git-helper.sh push

# Pull from GitHub
./git-helper.sh pull
```

### **System Monitoring**
```bash
# Check disk usage
df -h

# Check memory usage
free -h

# Check running processes
ps aux | grep docker

# Check network connections
netstat -tlnp
```

## 🔒 **Security Guidelines**

### **CRITICAL: Never Commit Sensitive Information**
- ❌ **API Keys** - Use environment variables or secrets files
- ❌ **Passwords** - Store in `.env` files (excluded from Git)
- ❌ **Certificates** - Keep in secure locations, not in Git
- ❌ **Database credentials** - Use environment variables
- ❌ **OAuth tokens** - Store securely outside Git
- ❌ **Private keys** - Never commit `.pem`, `.key` files

### **Safe Configuration Practices**
- ✅ **Use environment variables** for sensitive data
- ✅ **Create `.env.example`** files with dummy values
- ✅ **Document required environment variables** in README
- ✅ **Use Docker secrets** for production deployments
- ✅ **Regular security audits** of configuration files

### **Environment Variables Example**
```yaml
# docker-compose.yml
services:
  app:
    environment:
      - API_KEY=${API_KEY}  # Safe - references env var
      - DB_PASSWORD=${DB_PASSWORD}  # Safe - references env var
```

```bash
# .env (excluded from Git)
API_KEY=your-actual-api-key-here
DB_PASSWORD=your-actual-password-here
```

## 📝 **Container Task List**

### **Planned Additions**
- [ ] **Watchtower** - Automatic container updates
  - Purpose: Auto-update containers
  - Config: Environment variables only
  
- [ ] **Grafana** - Monitoring dashboard
  - Purpose: System monitoring and metrics
  - Port: 3000
  - Config: `grafana/data/`
  
- [ ] **Prometheus** - Metrics collection
  - Purpose: Metrics storage for Grafana
  - Port: 9090
  - Config: `prometheus/data/`
  
- [ ] **Uptime Kuma** - Uptime monitoring
  - Purpose: Website/service uptime monitoring
  - Port: 3001
  - Config: `uptime-kuma/data/`

### **Completed Services**
- ✅ **Cloudflare Tunnel** - Secure external access
- ✅ **Home Assistant** - Smart home automation
- ✅ **Nginx Proxy Manager** - Reverse proxy
- ✅ **Radarr** - Movie collection management
- ✅ **Sonarr** - TV show collection management
- ✅ **Bazarr** - Subtitle management
- ✅ **NZBGet** - Usenet downloader
- ✅ **Transmission** - Torrent client
- ✅ **Ombi** - Media request management
- ✅ **CouchDB** - Database server

## 🎯 **Best Practices**

### **Configuration Management**
1. **Always test changes** before committing
2. **Use descriptive commit messages**
3. **Keep sensitive data out of Git**
4. **Document configuration changes**
5. **Include comment headers for all services**
6. **Update README.md when adding services**

### **Container Management**
1. **Use specific image tags** (not `latest`)
2. **Set resource limits** for production
3. **Monitor container health**
4. **Keep containers updated**
5. **Use proper service naming conventions**

### **Security**
1. **Use environment variables** for secrets
2. **Limit container privileges**
3. **Use read-only filesystems** where possible
4. **Regular security updates**
5. **Audit configuration files for sensitive data**

## 📞 **Getting Help**

### **When to Use AI Agents**
- Adding new services
- Troubleshooting configuration issues
- Optimizing container performance
- Setting up monitoring and logging

### **Information to Provide**
- Container logs and error messages
- Current configuration files
- What you were trying to accomplish
- Steps you've already tried

### **Quick Diagnostics**
```bash
# System info
uname -a
docker --version
docker-compose --version

# Container status
sudo docker ps -a
sudo docker-compose ps

# Recent logs
sudo docker logs container-name --tail 50
```

---

**Remember**: Always backup your data before making significant changes, and test configurations in a safe environment when possible.
