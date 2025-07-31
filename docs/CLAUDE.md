# Global Project Context - VS Code Entwicklungsumgebung

## 🚀 WICHTIG: Automatisches Starten von Test-Servern

### ⚡ Neue Regel ab 2025-01-24:
**Wenn der User etwas testen, weiterentwickeln oder anschauen will, starte ich AUTOMATISCH die entsprechende Applikation und gebe die Test-URL aus!**

Beispiele:
- "Lass uns FaithTranslate testen" → Ich starte `python app_with_gemini.py` und zeige http://localhost:7500/
- "Zeig mir die Mobile App" → Ich starte die React Native App
- "Ich möchte die Übersetzung ausprobieren" → Server starten + URL anzeigen

## 🌐 URL-Standards für Lokale Entwicklung

### ⚡ WICHTIG: Alle Projekte müssen diese URL-Konventionen befolgen!

**Standard URL-Muster:**
- ✅ **Frontend/Hauptseite**: `http://localhost:[PORT]/`
- ✅ **Admin/Backend**: `http://localhost:[PORT]/admin`
- ✅ **API Endpoints**: `http://localhost:[PORT]/api/`
- ✅ **API Docs**: `http://localhost:[PORT]/docs` (optional)

**Beispiel korrekte URLs:**
```
http://localhost:8000/        # Frontend
http://localhost:8000/admin   # Admin-Interface
http://localhost:8000/api/    # API Endpoints
```

**Siehe**: `PROJECT_URL_STANDARDS.md` für Details und Migration

## 🎨 Professional Design Standards - State-of-the-Art UI/UX

### ⚡ WICHTIG: Alle Projekte müssen moderne, professionelle Design-Standards befolgen!

**🎯 Design-Philosophie:**
- ✅ **State-of-the-Art Design** - Moderne, zeitgemäße UI/UX-Patterns
- ✅ **Professional Icons** - KEINE Emoji-Icons, nur professionelle Icon-Libraries
- ✅ **Consistent Design System** - Einheitliche Komponenten und Styling
- ✅ **Accessibility First** - WCAG 2.1 AA Compliance als Minimum
- ✅ **Mobile-First Approach** - Responsive Design für alle Bildschirmgrößen

### 🛠️ **Standard Design Stack:**

#### **CSS Framework & Component Library:**
```bash
# REQUIRED: Tailwind CSS + shadcn/ui (State-of-the-Art)
npm install tailwindcss @tailwindcss/forms @tailwindcss/typography
npx shadcn-ui@latest init

# Component Installation
npx shadcn-ui@latest add button card input form
npx shadcn-ui@latest add navigation menu dropdown-menu
npx shadcn-ui@latest add dialog sheet toast
```

#### **Icon System (Professional Only):**
```bash
# PRIMARY: Lucide React (Modern, Consistent)
npm install lucide-react

# ALTERNATIVE: Heroicons (Tailwind-designed)
npm install @heroicons/react

# ❌ VERBOTEN: Emoji-Icons (🚫 NICHT professionell)
```

#### **Color Schemes & Themes:**
```css
/* Modern Professional Color Palette */
:root {
  /* Primary Colors - Professional Blue */
  --primary-50: hsl(214, 100%, 97%);
  --primary-100: hsl(214, 95%, 93%);
  --primary-500: hsl(214, 84%, 56%);
  --primary-600: hsl(214, 84%, 46%);
  --primary-900: hsl(214, 100%, 27%);
  
  /* Neutral Colors - Modern Gray Scale */
  --neutral-50: hsl(210, 40%, 98%);
  --neutral-100: hsl(210, 40%, 96%);
  --neutral-500: hsl(210, 11%, 71%);
  --neutral-700: hsl(210, 9%, 31%);
  --neutral-900: hsl(210, 24%, 16%);
  
  /* Semantic Colors */
  --success: hsl(142, 76%, 36%);
  --warning: hsl(38, 92%, 50%);
  --error: hsl(0, 84%, 60%);
}
```

### 📐 **Typography Standards:**
```css
/* Modern Typography Scale */
font-family: 
  'Inter', 'SF Pro Display', -apple-system, BlinkMacSystemFont, 
  'Segoe UI', Roboto, sans-serif;

/* Heading Scale */
h1: 2.25rem (36px) - font-weight: 800
h2: 1.875rem (30px) - font-weight: 700  
h3: 1.5rem (24px) - font-weight: 600
h4: 1.25rem (20px) - font-weight: 600

/* Body Text */
body: 1rem (16px) - font-weight: 400 - line-height: 1.5
small: 0.875rem (14px) - font-weight: 400
```

### 🎛️ **Component Design Principles:**

#### **Button Design:**
```jsx
// Professional Button Examples
<Button variant="default" size="default">
  <CheckIcon className="w-4 h-4 mr-2" />
  Primary Action
</Button>

<Button variant="outline" size="sm">
  <PlusIcon className="w-4 h-4 mr-1" />
  Secondary Action  
</Button>
```

#### **Card Layouts:**
```jsx
// Modern Card Design
<Card className="shadow-sm border-0 bg-white/50 backdrop-blur">
  <CardHeader className="pb-2">
    <div className="flex items-center gap-2">
      <IconComponent className="w-5 h-5 text-primary-600" />
      <CardTitle className="text-lg font-semibold">Title</CardTitle>
    </div>
  </CardHeader>
  <CardContent>
    {/* Professional content layout */}
  </CardContent>
</Card>
```

#### **Navigation Design:**
```jsx
// Professional Navigation
<nav className="bg-white/95 backdrop-blur border-b border-neutral-200">
  <div className="flex items-center justify-between px-6 py-3">
    <div className="flex items-center gap-8">
      <Logo className="h-8 w-auto" />
      <NavigationMenu>
        {/* Professional nav items */}
      </NavigationMenu>
    </div>
  </div>
</nav>
```

### 🏗️ **Layout & Spacing Standards:**
```css
/* Consistent Spacing Scale (Tailwind-based) */
xs: 0.25rem (4px)   /* gap-1, p-1 */
sm: 0.5rem (8px)    /* gap-2, p-2 */
md: 1rem (16px)     /* gap-4, p-4 */
lg: 1.5rem (24px)   /* gap-6, p-6 */
xl: 2rem (32px)     /* gap-8, p-8 */
2xl: 3rem (48px)    /* gap-12, p-12 */

/* Container Standards */
max-width: 1280px (max-w-7xl)
padding: 1.5rem (px-6)
margin: 0 auto (mx-auto)
```

### 📱 **Responsive Design Breakpoints:**
```css
/* Tailwind CSS Standard Breakpoints */
sm: 640px   /* @media (min-width: 640px) */
md: 768px   /* @media (min-width: 768px) */
lg: 1024px  /* @media (min-width: 1024px) */
xl: 1280px  /* @media (min-width: 1280px) */
2xl: 1536px /* @media (min-width: 1536px) */
```

### ♿ **Accessibility Requirements:**
- ✅ **Color Contrast**: Minimum 4.5:1 ratio for text
- ✅ **Touch Targets**: Minimum 44x44px for interactive elements
- ✅ **Keyboard Navigation**: Full keyboard accessibility
- ✅ **Screen Reader Support**: Proper ARIA labels and semantic HTML
- ✅ **Focus Indicators**: Visible focus states for all interactive elements

### 🎨 **Visual Hierarchy Guidelines:**
```css
/* Professional Visual Hierarchy */
.primary-content {
  font-size: 1rem;
  font-weight: 400;
  color: hsl(210, 24%, 16%); /* --neutral-900 */
}

.secondary-content {
  font-size: 0.875rem;
  font-weight: 400;
  color: hsl(210, 9%, 31%); /* --neutral-700 */
}

.meta-content {
  font-size: 0.75rem;
  font-weight: 400;
  color: hsl(210, 11%, 71%); /* --neutral-500 */
}
```

### 🔍 **Design Quality Checklist:**
- ✅ **Konsistente Abstände** - Spacing folgt dem definierten Scale
- ✅ **Professionelle Icons** - Lucide/Heroicons, keine Emojis
- ✅ **Moderne Typografie** - Inter-Font mit korrekten Weights
- ✅ **Semantische Farben** - CSS Custom Properties verwendet
- ✅ **Responsive Layout** - Mobile-First Design umgesetzt
- ✅ **Accessibility** - WCAG 2.1 AA Standards erfüllt
- ✅ **Component Consistency** - shadcn/ui Komponenten verwendet

### 📚 **Design System Referenzen:**

#### **Approved Component Libraries:**
- **Primary**: [shadcn/ui](https://ui.shadcn.com/) - React + Tailwind CSS
- **Icons**: [Lucide React](https://lucide.dev/) - Consistent, professional icons
- **Alternative**: [Heroicons](https://heroicons.com/) - Tailwind-designed icons
- **Typography**: [Inter Font](https://rsms.me/inter/) - Modern, legible typeface

#### **Design Inspiration Standards:**
- **Component Style**: Modern, clean, professional
- **Visual Language**: Minimal, functional, accessible
- **Color Usage**: Subtle, purposeful, high contrast
- **Layout**: Spacious, organized, grid-based
- **Animation**: Subtle, performant, purposeful

#### **❌ AVOID at all costs:**
- Emoji icons (🚫 Not professional)
- Comic Sans or playful fonts
- Rainbow color schemes
- Cluttered layouts
- Excessive animations
- Poor color contrast (<4.5:1 ratio)
- Non-responsive designs

### 🎯 **Project-Specific Design Implementation:**
Jedes Projekt MUSS diese Standards befolgen. Siehe Projekt-spezifische CLAUDE.md Dateien für:
- **Church-NextJS**: Vollständige shadcn/ui + Tailwind Implementation ✅
- **StepUpFundraiser**: Professional Dashboard mit modernen Standards ✅
- **FaithTranslate**: Responsive Multi-User Interface Standards
- **MPM Project Manager**: Django + React mit shadcn/ui Integration
- **XTTS**: Clean Professional UI mit modernem Design ✅

---

## 🎨 SuperDesign Integration

**KI-gesteuerte UI-Generierung mit SuperDesign für VS Code:**
- **Detaillierte Dokumentation**: `SUPERDESIGN_INTEGRATION.md`
- **Features**: Automatische shadcn/ui + Tailwind CSS Compliance
- **Workflow**: Design → Code → Backend Integration → Testing → Deployment

---

## 🐳 Docker-First Development Policy & Standard Workflow

### ⚡ WICHTIG: Alle Projekte müssen in Docker entwickelt und ausgeführt werden!

**Grundsätze:**
- ✅ **Neue Projekte**: Immer mit Docker-Setup beginnen
- ✅ **Bestehende Projekte**: Schrittweise auf Docker migrieren
- ✅ **Keine lokalen Installationen**: Alles läuft in Containern
- ✅ **docker-compose.yml**: Standard für alle Projekte

**Vorteile:**
- 🔧 Konsistente Entwicklungsumgebung
- 📦 Einfaches Deployment
- 🛡️ Keine Dependency-Konflikte
- 🚀 Portabel zwischen Systemen
- 👥 Team-kompatibel

### 🔄 Standard Docker-Workflow (Build → Test → Deploy)

#### 1. 🏗️ **LOCAL DEVELOPMENT** (WSL2 + Docker Desktop)

**🔧 Einmalige Setup (Docker Desktop + WSL2):**
```bash
# 1. Docker Desktop starten (Windows)
# 2. Settings → Resources → WSL Integration → Enable Ubuntu-22.04-LTS
# 3. WSL2 neu starten
wsl --shutdown && wsl

# 4. Docker in WSL2 testen
docker --version && docker-compose --version
```

**✅ Current Status (2025-07-24):**
- **Docker Desktop**: ✅ Aktiv (Version 28.1.1)
- **Docker Compose**: ✅ Verfügbar (v2.35.1-desktop.1)
- **WSL2 Integration**: ✅ Konfiguriert
- **Test Status**: ✅ `docker run hello-world` erfolgreich
- **Sudo Privileges**: ✅ User michael hat erweiterte Rechte für System-Services

**🔐 Sudo Configuration:**
```bash
# User michael verfügt über erweiterte sudo-Rechte für:
- Docker: /usr/bin/docker, /usr/bin/docker-compose
- Nginx: systemctl commands, config management
- System Services: systemctl, service commands
- PostgreSQL: su - postgres, psql commands
- General: (ALL) NOPASSWD: ALL
```

**🚀 Standard Projekt-Workflow:**
```bash
# Projekt starten
cd /mnt/c/Projekte/VS_Code/[PROJECT]
docker-compose up -d

# Logs verfolgen
docker-compose logs -f

# Health-Check
curl http://localhost:[PORT]/

# Container Status
docker-compose ps
docker stats
```

#### 2. 🧪 **TESTING** (Obligatorisch vor Deployment)
```bash
# Playwright/Puppeteer Browser-Tests
python3 real_browser_test.py

# API-Tests 
curl -f http://localhost:[PORT]/api/health

# Container-Health prüfen
docker-compose ps
docker inspect [container] | grep Health
```

#### 3. 🚀 **VPS DEPLOYMENT** (Production)
```bash
# Auf VPS (Ubuntu)
git pull origin main
docker-compose -f docker-compose.prod.yml up -d --build

# SSL/Nginx Setup
docker-compose -f docker-compose.nginx.yml up -d

# Production Health-Check
curl -f https://[domain]/api/health
```

### 🏗️ Standard Docker-Struktur Templates

#### **Basis Template** (docker-compose.yml):
```yaml
version: '3.8'
services:
  app:
    build: .
    container_name: [project]_app
    ports:
      - "[PORT]:[PORT]"  # Port aus PORT_MANAGER.md
    volumes:
      - .:/app
      - [data]:/app/data  # Persistente Daten
    environment:
      - NODE_ENV=development
      - PYTHONUNBUFFERED=1
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:[PORT]/"]
      interval: 30s
      timeout: 10s
      retries: 3
    networks:
      - [project]_network

networks:
  [project]_network:
    name: [project]_network
```

#### **Production Template** (docker-compose.prod.yml):
```yaml
version: '3.8'
services:
  app:
    build: 
      context: .
      dockerfile: Dockerfile.prod
    ports:
      - "[PORT]:[PORT]"
    environment:
      - NODE_ENV=production
    volumes:
      - app_data:/app/data
    deploy:
      resources:
        limits:
          memory: 2G
          cpus: '1.0'
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"

  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx/nginx.conf:/etc/nginx/nginx.conf
      - ./ssl:/etc/ssl/certs
    depends_on:
      - app

volumes:
  app_data:
```

## 🎯 Professional Web Cloning Tools - Standard-Workflow

### 🛠️ Installierte Tools für 1:1 Website-Nachbau

**Zweck**: Professionelles Nachbauen und Verbessern von Websites mit KI-Unterstützung

**Tools-Übersicht**:
- **Playwright**: 2K/4K Screenshots und Browser-Automation mit Scrolling
- **OpenCV**: Computer Vision für Layout-Analyse
- **Tesseract OCR**: Text- und Font-Erkennung
- **ColorThief**: Professionelle Farbpaletten-Extraktion
- **BeautifulSoup4 & cssutils**: HTML/CSS Parsing
- **Anthropic SDK**: Claude API Integration

### 🖥️ WICHTIG: Viewport-Größen für vollständige Erfassung

**Problem**: Standard HD (1920x1080) zeigt nur 20-30% moderner Websites!

**Empfohlene Viewports**:
- **4K**: 3840x2160 (Maximum Visibility)
- **2K**: 2560x1440 (Optimal für die meisten Sites)
- **HD**: 1920x1080 (Minimum, oft unzureichend)

### 📋 Standard-Workflow für Website-Klonen

1. **Analyse mit 2K/4K Viewport starten**:
   ```bash
   cd /mnt/c/Projekte/VS_Code/web-cloner-pro
   # Einfache Analyse
   python3 capture_2k_simple.py
   
   # Für lange Seiten mit Scrolling
   python3 capture_long_pages.py
   
   # Deep Analysis
   python3 deep_analysis_eabw.py
   ```

2. **Ergebnisse**:
   - 2K/4K Screenshots in `/screenshots`
   - Vollständiger Content in JSON-Dateien
   - Scrolling-Captures für lange Seiten
   - Background-Images aus CSS extrahiert
   - Versteckter/Lazy-loaded Content erfasst

3. **Clone-Strategie**:
   - Verwende größere Viewports (2K/4K)
   - Implementiere Scrolling für Seiten > 2000px
   - Extrahiere Background-Images separat
   - Prüfe Lazy-Loading und dynamischen Content

**Installation**: Siehe `/web-cloner-pro/README.md`

## 📋 Projekt-Dokumentationen

**Projekt-spezifische Details befinden sich in den jeweiligen CLAUDE.md Dateien:**

- **StepUpFundraiser**: `/stepupfundraiser/CLAUDE.md` - Ultimate 2025 Fundraising Platform
- **XTTS Voice Cloning**: `/xtts-voice-cloning/CLAUDE.md` - Professional Voice Cloning Suite  
- **FaithTranslate**: `/faith-translate/CLAUDE.md` - Multi-User Speech-to-Speech Translation
- **MPM Project Manager**: `/mpm-project-manager/CLAUDE.md` - Django + React Management System
- **EABW-CMS**: `/eabw-cms/CLAUDE.md` - Content Management System (1:1 Clone)
- **StudySourceVerifier**: `/studysourceverifier/CLAUDE.md` - Academic Source Verification
- **Church-NextJS**: `/church-nextjs/CLAUDE.md` - Central Hub NextJS Application

**Diese globale CLAUDE.md** fokussiert sich auf:
- ✅ SuperClaude Automatik-Konfiguration
- ✅ 🎨 Professional Design Standards (State-of-the-Art UI/UX)
- ✅ Docker-First Development Policy
- ✅ Port Management für alle Projekte
- ✅ Standard-Workflows (Build → Test → Deploy)
- ✅ Obligatorische Testing-Policy mit Design Quality Checks

---

## 🌐 Port Management System

**Detaillierte Port-Übersicht und Projekt-Details befinden sich in separaten Dateien:**
- **Port-Übersicht**: `PORT_MANAGER.md` - Zentrale Port-Verwaltung für alle Projekte
- **Projekt-Details**: Siehe jeweilige `/[projekt]/CLAUDE.md` Dateien

## 📋 Projekt-Dokumentationen

**Detaillierte Projekt-Informationen befinden sich in separaten Dateien:**

### ✅ Production Ready:
- **StepUpFundraiser**: `/stepupfundraiser/CLAUDE.md` - Ultimate 2025 Fundraising Platform
- **XTTS Voice Cloning**: `/xtts-voice-cloning/CLAUDE.md` - Professional Voice Cloning Suite  
- **FaithTranslate**: `/faith-translate/CLAUDE.md` - Multi-User Speech-to-Speech Translation
- **MPM Project Manager**: `/mpm-project-manager/CLAUDE.md` - Django + React Management System
- **EABW-CMS**: `/eabw-cms/CLAUDE.md` - Content Management System (1:1 Clone)
- **StudySourceVerifier**: `/studysourceverifier/CLAUDE.md` - Academic Source Verification
- **Church-NextJS**: `/church-nextjs/CLAUDE.md` - Central Hub NextJS Application

### 🟡 In Entwicklung:
- **BLDB-Webapp**: Laravel Backend + Vue.js Frontend
- **Anlass-System**: Event Management Platform  
- **Gebetsstandorte**: Location Management System
- **ChurchTools Integration**: Search Interface
- **In or Out**: Multi-Device Party Game

## 🧪 Testing Policy - ABSOLUT OBLIGATORISCH

### 🚨 KRITISCH: ZWINGEND Browser-Tests vor JEDER Antwort mit URLs/Links!

**NEUE POLICY (2025-07-24): KEINE Ausnahmen mehr!**

✅ **MUSS ZWINGEND getan werden VOR jeder Antwort mit URLs/Links:**
- **COMPREHENSIVE Browser-Test**: Playwright/Puppeteer mit echter Browser-Engine
- **ALLE Funktionen testen**: Navigation, Buttons, Forms, APIs, JavaScript
- **GUI-Validierung**: Screenshots, Layout-Check, Responsive Design
- **🎨 DESIGN QUALITY CHECK**: Professional Icons (NO emojis), Modern UI/UX, shadcn/ui components
- **MCP-Integration**: Wenn MCPs verwendet werden, diese explizit testen
- **Error-Detection**: 404s, JavaScript-Errors, Console-Warnings, Network-Failures
- **Performance-Check**: Load-Times, Resource-Usage
- **User-Journey**: Vollständige End-to-End Workflows
- **♿ Accessibility**: WCAG 2.1 AA compliance, keyboard navigation, screen reader support

✅ **Test-Framework Standards:**
```python
# Beispiel: Comprehensive Test vor Antwort
def comprehensive_test_before_response():
    # 1. Browser-Engine Test
    playwright_test = run_full_browser_test()
    
    # 2. Funktional-Tests
    gui_test = validate_all_ui_elements()
    api_test = test_all_endpoints()
    
    # 3. MCP-Integration (falls verwendet)
    mcp_test = validate_mcp_responses()
    
    # 4. Performance & Error-Detection
    performance = check_load_times()
    errors = scan_for_errors()
    
    # NUR wenn ALLE Tests erfolgreich:
    if all([playwright_test, gui_test, api_test, mcp_test, performance, errors]):
        return "✅ SAFE TO RESPOND"
    else:
        return "❌ FIX ISSUES FIRST"
```

❌ **ABSOLUT VERBOTEN:**
- curl-Tests allein (zeigen JavaScript-Probleme NICHT)
- Theoretische Analyse ohne Browser-Verifikation
- "Sollte funktionieren" ohne echten Test
- Links/URLs ausgeben ohne vorherige Validierung
- Annahmen über Funktionalität ohne Beweis

### 🎯 **ZEIT-INVESTITION RECHTFERTIGUNG:**
**"Keine Zeit verschwenden"** bedeutet: **EINMAL richtig testen statt mehrfach nachbessern!**

**Vollständige Policy:** `TESTING_POLICY.md`

**Beispiel-Tests verfügbar:**
- `real_browser_test.py` - Comprehensive Browser Testing
- `fix_javascript_test.py` - JavaScript Functionality Testing

### ✅ Projekt-Spezifische Test-Status 

**Details zu umfassenden Tests finden sich in den jeweiligen Projekt-CLAUDE.md Dateien:**
- **FaithTranslate**: `faith-translate/CLAUDE.md` - 65/65 Tests erfolgreich
- **StepUpFundraiser**: `stepupfundraiser/CLAUDE.md` - Comprehensive Test Suite
- **XTTS**: `xtts-voice-cloning/CLAUDE.md` - Puppeteer UI-Tests validiert
- **MPM**: `mpm-project-manager/CLAUDE.md` - Backend + Frontend Tests

---

---

*Dokumentation erstellt: 2025-07-24*  
*Letzte Aktualisierung: 2025-07-24*  
*Status: Multi-Project Port Management + Docker-First Development + SuperClaude Automation ✅*

