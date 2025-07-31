# 🧹 VS_Code Ordner Aufräum-Plan

## 📁 Aktuelle Situation
- **144 Dateien/Ordner** insgesamt
- **34 Projekt-Ordner**
- Viele einzelne Dateien im Root

## 🎯 Vorgeschlagene Struktur

### 1. **Aktive Projekte** (behalten)
```
📁 church-nextjs/         - Church Management System
📁 faith-translate/       - Speech-to-Speech Translation  
📁 stepupfundraiser/      - Fundraising Platform
📁 xtts-voice-cloning/    - Voice Cloning Suite
📁 mpm-project-manager/   - Project Management System
📁 eabw-cms/              - Content Management System
📁 studysourceverifier/   - Academic Source Verification
```

### 2. **Claude-Flow & Docs** (NEU organisiert)
```
📁 _CLAUDE_FLOW/
   📁 claude-flow-docs/   → Link zu ~/claude-development/
   📄 CLAUDE_FLOW_QUICK.md - Schnellreferenz
```

### 3. **Archiv** (alte/ungenutzte Projekte)
```
📁 _ARCHIV_2025/
   📁 anlass/
   📁 bldb-webapp/  
   📁 churchtools-projekt/
   📁 gebetsstandorte/
   📁 in-or-out/
   📁 word-translate/
   📁 swiss-german-s2s/
   📁 web-cloner-pro/
   📁 superclaude-dev-system/
```

### 4. **Dokumentation** (zentral)
```
📁 _DOCS/
   📄 CLAUDE.md (global)
   📄 PORT_MANAGER.md
   📄 DOCKER_DEVELOPMENT_GUIDE.md
   📄 PROJECT_URL_STANDARDS.md
   📄 TESTING_FRAMEWORK.md
```

### 5. **Test-Dateien** (aufräumen)
```
📁 _TESTS/
   Alle *.png Screenshots
   Alle test_*.py Dateien
   Alle *_test.* Dateien
```

### 6. **Zu löschen** (unnötig)
```
❌ Alle .bat Dateien (Windows)
❌ Alte Konfigurationsdateien
❌ Temporäre Test-Dateien
❌ Doppelte Dokumentationen
```