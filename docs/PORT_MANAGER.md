# 🌐 Port Management System - Alle Projekte

## 📋 Port-Übersicht (Stand: 2025-07-31)

### 🎯 **StepUpFundraiser** (Port 8000) ✅ AKTIV
- **Frontend**: http://localhost:8000/static/dashboard_fixed.html ⚠️ Needs fix (should be /)
- **Admin**: http://localhost:8000/admin ✅ Conforms to standards
- **API**: http://localhost:8000/api/ ✅ Conforms to standards
- **Status**: ⚠️ Frontend needs migration to root URL
- **Service**: StepUpFundraiser Backend (Django)
- **Docker**: `docker-compose -f stepupfundraiser/docker-compose.simple.yml up -d`

### 🎤 **XTTS Voice Cloning** (Ports 7860/7862) ✅ AKTIV
- **Frontend**: http://localhost:7860/ (local) / http://localhost:7862/ (docker) ✅ Conforms to standards
- **Admin**: N/A - Gradio interface has no separate admin
- **API**: N/A - Gradio interface handles everything
- **Status**: ✅ Conforms to standards (single-page app)
- **Service**: XTTS Voice Cloning UI (Gradio)

### 🎯 **In or Out** (Port 3101) ✅ AKTIV
- **Frontend**: http://localhost:3101/ ✅ Conforms to standards
- **Admin**: N/A - Game server has no admin interface
- **API**: http://localhost:3101/api/ (WebSocket) ✅ Conforms to standards
- **Status**: ✅ Conforms to standards
- **Service**: In or Out Backend (Node.js + Socket.io)
- **Location**: `/mnt/c/Projekte/VS_Code/in-or-out/`
- **Start**: `cd /mnt/c/Projekte/VS_Code/in-or-out && PORT=3101 node server.js`
- **Docker**: 🚧 TODO - Docker-Setup erforderlich

### 📚 **BLDB-Webapp** (Ports 3000/3001) 🟡 ENTWICKLUNG
- **Frontend**: http://localhost:3000/ ✅ Conforms to standards
- **Admin**: http://localhost:3001/admin ⚠️ Needs verification (Laravel admin)
- **API**: http://localhost:3001/api/ ✅ Conforms to standards
- **Status**: 🟡 In Entwicklung - Standards compliance TBD
- **Services**: 
  - Port 3000: Frontend (Vite/Vue.js)
  - Port 3001: Backend (Laravel API)
  - Port 5432: PostgreSQL Database (internal)
  - Port 6379: Redis Cache (internal)
- **Docker**: 🚧 TODO - Docker-Setup erforderlich

### 🎪 **Anlass-System** (Ports 4000/4001) 🟡 ENTWICKLUNG
- **Frontend**: http://localhost:4001/ (planned) ⏳ To be implemented
- **Admin**: http://localhost:4000/admin (planned) ⏳ To be implemented
- **API**: http://localhost:4000/api/ (planned) ⏳ To be implemented
- **Status**: 🟡 In Entwicklung - Will follow standards
- **Services**: 
  - Port 4000: PHP Backend (reserved)
  - Port 4001: Frontend (reserved)
- **Docker**: 🚧 TODO - Von Anfang an mit Docker entwickeln

### 🙏 **Gebetsstandorte** (Ports 5000/5001) 🟡 ENTWICKLUNG
- **Frontend**: http://localhost:5001/ (planned) ⏳ To be implemented
- **Admin**: http://localhost:5000/admin (planned) ⏳ To be implemented
- **API**: http://localhost:5000/api/ (planned) ⏳ To be implemented
- **Status**: 🟡 In Entwicklung - Will follow standards
- **Services**: 
  - Port 5000: PHP Backend (reserved)
  - Port 5001: Frontend (reserved)
- **Docker**: 🚧 TODO - Von Anfang an mit Docker entwickeln

### 🙏 **FaithTranslate** (Port 7500) ✅ AKTIV - SUPERCLAUDE COMPLIANT
- **Frontend**: http://localhost:7500/ ✅ SuperClaude Design Standards
- **Admin**: http://localhost:7500/admin ✅ Conforms to standards
- **API**: http://localhost:7500/api/ ✅ Conforms to standards
- **API Docs**: http://localhost:7500/docs ✅ Swagger/OpenAPI
- **Status**: ✅ **96.7% SuperClaude Test Success Rate**
- **Service**: FaithTranslate Multi-User System (FastAPI)
- **Location**: `/mnt/c/Projekte/VS_Code/faith-translate/`
- **Start**: 
  - Production: `cd /mnt/c/Projekte/VS_Code/faith-translate && python3 app_production_complete.py`
  - Docker: `cd faith-translate && docker-compose up -d`
- **Features**: 
  - ✅ Modern UI mit Glassmorphism Design
  - ✅ Card-based Layout mit Professional Navigation
  - ✅ Voice Translation, Text Translation, Bible Search
  - ✅ Voice Cloning mit XTTS Integration
  - ✅ WebSocket Real-time Translation
  - ✅ Performance: <1.5s Page Load, <500ms API Response

### 🔍 **StudySourceVerifier** (Port 8501/8502) ✅ NEU - PRODUCTION READY
- **Frontend**: http://localhost:8501/ (Streamlit) / http://localhost:8502/ (via Nginx) ✅ Conforms to standards
- **Admin**: N/A - Single-page Streamlit app
- **API**: N/A - Streamlit handles everything
- **Status**: ✅ **Production Ready - Academic Source Verification Tool**
- **Service**: StudySourceVerifier (Streamlit + Playwright + Firecrawl)
- **Location**: `/mnt/c/Projekte/VS_Code/studysourceverifier/`
- **Features**: 
  - ✅ Multi-API verification (Crossref, OpenAlex, Unpaywall, Semantic Scholar, Google Books, CORE)
  - ✅ Web scraping with Firecrawl + Playwright for library access
  - ✅ AI-powered claim validation
  - ✅ Beautiful Streamlit UI with reports
- **Docker**: `cd studysourceverifier && docker-compose up -d`
- **Test**: `python test_local.py` for basic functionality test

### 🔍 **ChurchTools Integration** (Port 8080) 🟡 ENTWICKLUNG
- **Frontend**: http://localhost:8080/ (planned) ⏳ To be implemented
- **Admin**: N/A - Search interface only
- **API**: http://localhost:8080/api/ (planned) ⏳ To be implemented
- **Status**: 🟡 In Entwicklung - Will follow standards
- **Service**: ChurchTools Search Interface
- **Docker**: 🚧 TODO - Von Anfang an mit Docker entwickeln

### ⛪ **EABW-CMS** (Port 8100) ✅ PRODUCTION READY
- **Frontend**: http://localhost:8100/ ✅ Conforms to standards (1:1 Clone of eabw.ch)
- **Admin**: http://localhost:8100/admin ✅ Conforms to standards
- **API**: http://localhost:8100/api/ ✅ Conforms to standards
- **Status**: ✅ **100% COMPLETE - Perfect 1:1 Clone, fully conforms to standards**
- **Service**: EABW Content Management System (FastAPI)
- **Location**: `/mnt/c/Projekte/VS_Code/eabw-cms/`
- **Features**: ✅ All 5 pages functional (/, /uber-uns, /veranstaltungen, /medien, /spenden)
- **Clone Quality**: ✅ Exact navigation, images, colors, fonts, meta data
- **Docker**: `docker-compose up -d` (Container: eabw-cms-dev)
- **Optional**: Port 8101 - Nginx Reverse Proxy

### 🏗️ **MPM - Mäx's Project Manager** (Ports 5100/5101) ✅ PRODUCTION READY
- **Frontend**: http://localhost:5101/ ✅ Conforms to standards (React)
- **Admin**: http://localhost:5100/admin ✅ Conforms to standards (Django)
- **API**: http://localhost:5100/api/ ✅ Conforms to standards
- **Status**: ✅ Production Ready - Fully conforms to standards
- **Services**:
  - Port 5100: Django Backend API ✅ Running (17 apps)
  - Port 5101: React Frontend (Vite) ✅ Running
  - Port 5102: Nginx Reverse Proxy (Available)
  - Port 5433: PostgreSQL Database ✅ Running & Healthy
  - Port 6380: Redis Cache ✅ Running & Healthy
- **Location**: `/mnt/c/Projekte/VS_Code/mpm-project-manager/`
- **Docker**: `cd mpm-project-manager && docker-compose -f docker-compose.dev.yml up -d`

### 🏛️ **Church-NextJS Central Hub** (Ports 3001/3010) ✅ AKTIV
- **Frontend**: http://localhost:3001/ (dev) / http://localhost:3010/ (prod) ✅ Conforms to standards
- **Admin**: http://localhost:3001/admin (dev) / http://localhost:3010/admin (prod) ✅ Conforms to standards
- **API**: http://localhost:3001/api/ (dev) / http://localhost:3010/api/ (prod) ✅ Conforms to standards
- **Status**: ✅ Production Ready - Fully conforms to standards
- **Services**:
  - Port 3001: Development Environment
  - Port 3010: Production Environment  
  - Port 5433: PostgreSQL Database (shared)
  - Port 6380: Redis Cache (shared)
- **Location**: `/mnt/c/Projekte/VS_Code/church-nextjs/`
- **Docker Dev**: `cd church-nextjs && docker-compose -f docker-compose.dev.yml up -d`
- **Docker Prod**: `cd church-nextjs && docker-compose up -d`

### 🔄 **Claude-Flow** (Ports 9000/3008) 🟡 ENTWICKLUNG
- **Frontend**: http://localhost:3008/ ✅ Conforms to standards
- **Admin**: N/A - Development tool has no admin interface
- **API**: http://localhost:9000/api/ ✅ Conforms to standards
- **WebSocket**: ws://localhost:9000/ws ✅ For real-time updates
- **Status**: 🟡 In Entwicklung - Conversation Management Tool
- **Service**: Claude-Flow MCP Server & UI
- **Services**:
  - Port 9000: MCP Server & WebSocket (Development Tools Range)
  - Port 3008: Web UI (Frontend Services Range)
- **Location**: `/mnt/c/Projekte/VS_Code/claude-flow/`
- **Category**: Development Tools
- **Docker**: 🚧 TODO - Docker-Setup in Entwicklung

## Port-Reservierung System:

### ✅ Belegte Ports:
```
8000 - StepUpFundraiser Django API  ✅ AKTIV
7860 - XTTS Voice UI (Local)        ✅ AKTIV  
7862 - XTTS Voice UI (Docker)       ✅ AKTIV
7500 - FaithTranslate API           ✅ AKTIV
8501 - StudySourceVerifier UI       ✅ AKTIV
8502 - StudySourceVerifier Nginx    ✅ AKTIV
3000 - BLDB Frontend               🟡 DEV
3001 - Church-NextJS (Dev)         ✅ AKTIV
3008 - Claude-Flow UI              🟡 DEV
3010 - Church-NextJS (Prod)        ✅ AKTIV
3101 - In or Out Game             ✅ AKTIV
5433 - PostgreSQL (Docker)         ✅ AKTIV
6380 - Redis (Docker)              ✅ AKTIV
8080 - ChurchTools                 🟡 DEV
8100 - EABW-CMS FastAPI           ✅ AKTIV
8101 - EABW-CMS Nginx             ✅ AKTIV
5100 - MPM Backend                ✅ AKTIV
5101 - MPM Frontend               ✅ AKTIV
9000 - Claude-Flow MCP Server      🟡 DEV
```

### 🆓 Verfügbare Port-Ranges:
- **3002-3099** - Frontend Services
- **4000-4999** - Event Management (Anlass)
- **5000-5099** - Location Services (Gebetsstandorte)
- **5110-5999** - Weitere Business Services
- **6000-6999** - Cache/Queue Services (internal)
- **7000-7859** - AI/ML Services (vor XTTS)
- **7870-7999** - AI/ML Services (nach XTTS)
- **8001-8079** - Backend APIs (vor ChurchTools)
- **8090-8999** - Backend APIs (nach ChurchTools)
- **9000-9999** - Development Tools

## 🔧 Port-Management-Befehle

### Port-Status prüfen:
```bash
# Alle aktiven Ports
netstat -tuln

# Spezifischen Port prüfen
netstat -tuln | grep :8000

# Prozess auf Port finden
lsof -i :8000

# Alle Python/PHP-Prozesse mit Ports
ps aux | grep -E "(python|php)"
```

### Port freigeben:
```bash
# Prozess beenden (StepUpFundraiser Ultimate 2025)
docker-compose -f stepupfundraiser/docker-compose.enhanced.yml down

# Prozess beenden (XTTS)
pkill -f "python xtts_simple_ui.py"

# Forciert beenden
sudo kill -9 $(lsof -t -i:8000)
```

### WSL2 Port-Weiterleitung (Windows):
```powershell
# Port für Windows zugänglich machen
netsh interface portproxy add v4tov4 listenport=8000 listenaddress=0.0.0.0 connectport=8000 connectaddress=[WSL2-IP]

# WSL2-IP ermitteln
wsl hostname -I
```

## 📋 Service-Monitoring

### Health-Check-URLs:
- **StepUpFundraiser:** http://localhost:8000
- **XTTS Voice (Local):** http://localhost:7860
- **XTTS Voice (Docker):** http://localhost:7862
- **Circle of Bluffs:** 🎪 http://circle-of-bluffs.local (Browser-Test: `python3 test_circle_of_bluffs.py`)
- **BLDB Frontend:** http://localhost:3000
- **BLDB Backend:** http://localhost:3001/api/health
- **ChurchTools Search:** http://localhost:8080
- **FaithTranslate:** http://localhost:7500
- **StudySourceVerifier:** http://localhost:8501
- **EABW-CMS:** http://localhost:8100
- **MPM Backend:** http://localhost:5100
- **MPM Frontend:** http://localhost:5101
- **Church-NextJS Dev:** http://localhost:3001
- **Church-NextJS Prod:** http://localhost:3010
- **Claude-Flow UI:** http://localhost:3008
- **Claude-Flow MCP:** http://localhost:9000

### Monitoring-Script:
```bash
#!/bin/bash
# check_services.sh
echo "=== Service Status ==="
curl -s http://localhost:8000 > /dev/null && echo "✓ StepUpFundraiser (8000)" || echo "✗ StepUpFundraiser (8000)"
curl -s http://localhost:7860 > /dev/null && echo "✓ XTTS Local (7860)" || echo "✗ XTTS Local (7860)"
curl -s http://localhost:7862 > /dev/null && echo "✓ XTTS Docker (7862)" || echo "✗ XTTS Docker (7862)"
curl -s http://localhost:3000 > /dev/null && echo "✓ BLDB Frontend (3000)" || echo "✗ BLDB Frontend (3000)"
curl -s http://localhost:3001 > /dev/null && echo "✓ Church-NextJS Dev (3001)" || echo "✗ Church-NextJS Dev (3001)"
curl -s http://localhost:3008 > /dev/null && echo "✓ Claude-Flow UI (3008)" || echo "✗ Claude-Flow UI (3008)"
curl -s http://localhost:7500 > /dev/null && echo "✓ FaithTranslate (7500)" || echo "✗ FaithTranslate (7500)"
curl -s http://localhost:8501 > /dev/null && echo "✓ StudySourceVerifier (8501)" || echo "✗ StudySourceVerifier (8501)"
curl -s http://localhost:8100 > /dev/null && echo "✓ EABW-CMS (8100)" || echo "✗ EABW-CMS (8100)"
curl -s http://localhost:5100 > /dev/null && echo "✓ MPM Backend (5100)" || echo "✗ MPM Backend (5100)"
curl -s http://localhost:5101 > /dev/null && echo "✓ MPM Frontend (5101)" || echo "✗ MPM Frontend (5101)"
curl -s http://localhost:9000 > /dev/null && echo "✓ Claude-Flow MCP (9000)" || echo "✗ Claude-Flow MCP (9000)"
```

---

*Dokumentation erstellt: 2025-07-24*  
*Letzte Aktualisierung: 2025-07-31*  
*Status: Zentrales Port Management für alle Projekte ✅*