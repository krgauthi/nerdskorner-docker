# NerdsKorner Docker Configurations

This repository contains the Docker configurations for the NerdsKorner Synology NAS setup.

## Services

- **Cloudflare Tunnel** - Secure tunnel for external access
- **Home Assistant** - Home automation platform
- **Synology DSM** - NAS management interface
- **Photo Station** - Photo management and sharing
- **Portainer** - Docker container management
- **Nginx Proxy Manager** - Reverse proxy management
- **Transmission** - BitTorrent client (VPN-routed)
- **Sonarr/Radarr** - Media management
- **Ombi** - Media request system
- **Code Server** - VS Code in browser
- **Obsidian** - Note-taking application
- **Rustdesk** - Remote desktop solution

## Subdomains

- `https://synology.nerdskorner.tech` - Synology DSM
- `https://photos.nerdskorner.tech/photos` - Photo Station
- `https://homeassistant.nerdskorner.tech` - Home Assistant

## Git Usage

This repository uses Git via Docker container since Git is not natively installed on Synology NAS.

### Quick Commands

```bash
# Check status
./git-helper.sh status

# Save all changes
./git-helper.sh save "Your commit message"

# Add specific file
./git-helper.sh add compose/docker-compose.yml

# View recent commits
./git-helper.sh log
```

### Manual Git Commands

```bash
# Using Docker container
sudo docker run --rm -v /volume2/docker:/workspace -w /workspace alpine/git:latest [git-command]

# Examples:
sudo docker run --rm -v /volume2/docker:/workspace -w /workspace alpine/git:latest status
sudo docker run --rm -v /volume2/docker:/workspace -w /workspace alpine/git:latest add .
sudo docker run --rm -v /volume2/docker:/workspace -w /workspace alpine/git:latest commit -m "Message"
```

## Important Notes

- Sensitive files (certificates, credentials) are excluded via `.gitignore`
- The Cloudflare tunnel configuration includes documentation for DNS setup
- Home Assistant is configured with trusted proxies for Cloudflare tunnel
- All services use host networking for optimal performance

## Setup Requirements

1. **Cloudflare Dashboard**: Add CNAME records for each subdomain pointing to `{tunnel-id}.cfargotunnel.com`
2. **Docker Compose**: Run `sudo docker-compose up -d` in the compose directory
3. **Tunnel Credentials**: Ensure Cloudflare tunnel credentials are in place

## Security

- All external access goes through Cloudflare tunnels
- No direct port exposure to the internet
- Trusted proxy configuration for reverse proxy scenarios
- Sensitive data excluded from version control
