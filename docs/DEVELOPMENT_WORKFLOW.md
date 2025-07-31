# Local-to-VPS Development Workflow

## Overview
This workflow enables seamless coordination between local development and remote VPS deployment with automated synchronization and testing.

## 🎯 Workflow Components

### 1. Git-Based Version Control Strategy

#### Branch Structure
```
main          → Production (deployed to VPS)
├── develop   → Integration branch
├── feature/* → Feature development
└── hotfix/*  → Emergency fixes
```

#### Workflow Steps
1. **Local Development**: Work on feature branches
2. **Testing**: Run local tests before pushing
3. **Integration**: Merge to develop for staging tests
4. **Deployment**: Merge to main triggers VPS deployment

### 2. Synchronization Architecture

```
┌─────────────────┐     Git Push      ┌─────────────────┐
│                 │ ─────────────────► │                 │
│  Local Machine  │                    │  Git Repository │
│                 │ ◄───────────────── │   (GitHub/Lab)  │
└─────────────────┘     Git Pull       └─────────────────┘
                                               │
                                               │ Webhook
                                               ▼
                                       ┌─────────────────┐
                                       │                 │
                                       │   VPS Server    │
                                       │                 │
                                       └─────────────────┘
```

### 3. Environment Configuration

#### Local Development (.env.local)
```env
NODE_ENV=development
API_URL=http://localhost:3000
DATABASE_URL=postgresql://user:pass@localhost:5432/dev_db
REDIS_URL=redis://localhost:6379
```

#### VPS Production (.env.production)
```env
NODE_ENV=production
API_URL=https://your-domain.com
DATABASE_URL=postgresql://user:pass@localhost:5432/prod_db
REDIS_URL=redis://localhost:6379
```

### 4. Testing Strategy

#### Local Testing Suite
- **Unit Tests**: Run before every commit
- **Integration Tests**: Run before pushing to develop
- **E2E Tests**: Run on develop branch

#### VPS Testing
- **Smoke Tests**: After deployment
- **Health Checks**: Continuous monitoring
- **Performance Tests**: Scheduled runs

### 5. Deployment Pipeline

#### Automated Deployment Script
```bash
#!/bin/bash
# deploy.sh - Run on VPS via webhook or CI/CD

# Pull latest changes
git pull origin main

# Install dependencies
npm ci --production

# Run database migrations
npm run migrate:prod

# Build application
npm run build

# Restart services
pm2 restart all

# Run smoke tests
npm run test:smoke
```

### 6. Monitoring & Rollback

#### Health Monitoring
- Service uptime checks every 5 minutes
- Error rate monitoring
- Performance metrics collection

#### Rollback Strategy
```bash
# Quick rollback to previous version
git revert HEAD
npm ci --production
pm2 restart all
```

## 🚀 Quick Start Commands

### Initial Setup
```bash
# Local machine
git clone <repository>
npm install
cp .env.example .env.local
npm run dev

# VPS setup
git clone <repository>
npm ci --production
cp .env.example .env.production
pm2 start ecosystem.config.js
```

### Daily Workflow
```bash
# Start new feature
git checkout -b feature/new-feature
npm run dev

# Before committing
npm test
npm run lint

# Push to remote
git push origin feature/new-feature

# Deploy to VPS (from main branch)
git checkout main
git merge develop
git push origin main
# Webhook triggers automatic deployment
```

## 📋 Best Practices

1. **Always test locally** before pushing
2. **Use feature branches** for all changes
3. **Document environment differences** in README
4. **Monitor deployments** for 15 minutes post-deploy
5. **Keep secrets in environment variables**
6. **Use database migrations** for schema changes
7. **Implement graceful shutdowns** in applications

## 🔧 Troubleshooting

### Common Issues
1. **Port conflicts**: Check local ports match development config
2. **Database sync**: Ensure migrations run on both environments
3. **Module differences**: Use exact versions in package.json
4. **Environment variables**: Verify all required vars are set

### Debug Commands
```bash
# Check VPS logs
pm2 logs
journalctl -u nginx -f

# Test connectivity
curl http://localhost:3000/health

# Check service status
pm2 status
systemctl status nginx
```

## 📚 Additional Resources

- [Git Flow Documentation](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow)
- [PM2 Process Manager](https://pm2.keymetrics.io/)
- [GitHub Actions CI/CD](https://docs.github.com/en/actions)