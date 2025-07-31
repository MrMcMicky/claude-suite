# 👑 Queen Modes & Agent Configuration Guide

## 🎯 Queen Types Erklärt

### 1. **Strategic Queen** (Default)
**Charakteristik**: Langfristige Planung, systematisch, gründlich
- **Fokus**: Big Picture, Architektur, nachhaltige Lösungen
- **Arbeitsweise**: Plant vollständig bevor Ausführung beginnt
- **Entscheidungen**: Bedacht, evidenzbasiert, risikobewusst

**Ideal für**:
- Neue Projekte von Grund auf
- System-Architekturen
- Refactoring großer Codebasen
- Langfristige Technologie-Entscheidungen

**Beispiel**:
```bash
npx claude-flow@alpha hive-mind spawn \
  "Design complete microservices architecture" \
  --queen-type strategic \
  --max-workers 16 \
  --claude
```

### 2. **Adaptive Queen**
**Charakteristik**: Flexibel, lernfähig, iterativ
- **Fokus**: Anpassung an sich ändernde Anforderungen
- **Arbeitsweise**: Startet schnell, passt Plan während Ausführung an
- **Entscheidungen**: Pragmatisch, experimentell, fail-fast

**Ideal für**:
- Agile Entwicklung
- MVP/Prototypen
- Unklare Anforderungen
- Explorative Projekte

**Beispiel**:
```bash
npx claude-flow@alpha hive-mind spawn \
  "Build MVP for startup idea" \
  --queen-type adaptive \
  --max-workers 12 \
  --auto-scale \
  --claude
```

### 3. **Tactical Queen**
**Charakteristik**: Kurzfristig, aktionsorientiert, effizient
- **Fokus**: Schnelle Ergebnisse, konkrete Probleme lösen
- **Arbeitsweise**: Minimal viable planning, maximale Ausführung
- **Entscheidungen**: Schnell, praktisch, ergebnisorientiert

**Ideal für**:
- Bug Fixes
- Kleine Features
- Performance Optimierungen
- Deadline-kritische Aufgaben

**Beispiel**:
```bash
npx claude-flow@alpha hive-mind spawn \
  "Fix critical production bug in auth system" \
  --queen-type tactical \
  --max-workers 6 \
  --claude
```

### 4. **Exploratory Queen**
**Charakteristik**: Forschend, kreativ, innovativ
- **Fokus**: Neue Technologien, Best Practices, Innovation
- **Arbeitsweise**: Breite Recherche, viele Experimente
- **Entscheidungen**: Evidenzbasiert, wissenschaftlich, dokumentiert

**Ideal für**:
- Technology Research
- Best Practice Analyse
- Neue Framework Evaluierung
- Innovation Labs

**Beispiel**:
```bash
npx claude-flow@alpha hive-mind spawn \
  "Research and evaluate AI development frameworks" \
  --queen-type exploratory \
  --max-workers 10 \
  --worker-types "researcher,analyst" \
  --claude
```

## 📊 Agent-Anzahl Empfehlungen

### Nach Projekt-Größe

| Projekt-Typ | Workers | Queen Type | Begründung |
|------------|---------|------------|------------|
| **Kleines Feature** | 4-6 | Tactical | Schnelle Ausführung, wenig Koordination |
| **Bug Fix** | 4 | Tactical | Fokussiert, schnell |
| **Neues Modul** | 8-10 | Strategic | Balance zwischen Planung und Ausführung |
| **MVP/Prototype** | 10-12 | Adaptive | Flexibilität für Änderungen |
| **Full Stack App** | 16-20 | Strategic | Viele parallele Aufgaben |
| **System Refactoring** | 20+ | Strategic | Komplexe Abhängigkeiten |
| **Research Project** | 8-12 | Exploratory | Breite Recherche |
| **Enterprise Migration** | 20+ | Strategic | Höchste Komplexität |

### Nach Aufgaben-Typ

| Aufgabe | Workers | Spezialisierung |
|---------|---------|-----------------|
| **Frontend Only** | 6-8 | UI/UX fokussiert |
| **Backend API** | 8-10 | Server/DB fokussiert |
| **Full Stack** | 12-16 | Ausgewogen |
| **DevOps/Infra** | 8-12 | Automation fokussiert |
| **Data Science** | 10-14 | Analyse fokussiert |
| **Security Audit** | 12-16 | Security fokussiert |

### Worker-Types Konfiguration

```bash
# Standard (ausgewogen)
--worker-types "researcher,coder,analyst,tester"

# Frontend-fokussiert
--worker-types "frontend,ux,tester,researcher"

# Backend-fokussiert
--worker-types "backend,database,api,tester"

# Full Stack
--worker-types "architect,frontend,backend,database,devops,tester"

# Research
--worker-types "researcher,analyst,documenter"

# Security
--worker-types "security,pentester,analyst,auditor"
```

## 🔗 Claude Code Integration

### Wie Hive Mind mit Claude Code interagiert:

1. **Hive Mind Agents ≠ Claude Code Sub-Agents**
   - Hive Mind Agents sind abstrakte Rollen
   - Claude Code führt die eigentliche Arbeit aus
   - Keine direkte 1:1 Beziehung

2. **Die Verbindung:**
   ```
   Hive Mind Queen
       ↓ (koordiniert)
   Hive Mind Workers
       ↓ (delegieren an)
   Claude Code (mit MCP Tools)
       ↓ (kann spawnen)
   Claude Code Sub-Agents (Task tool)
   ```

3. **Namen-Kompatibilität:**
   - **NICHT NÖTIG!** Namen müssen nicht übereinstimmen
   - Hive Mind "researcher" ≠ Claude Code "researcher" sub-agent
   - Die Queen übersetzt automatisch zwischen den Systemen

### Beispiel-Workflow:

```bash
# 1. Hive Mind Spawn
npx claude-flow@alpha hive-mind spawn \
  "Build REST API with auth" \
  --claude \
  --max-workers 12 \
  --worker-types "architect,backend,tester,security"

# 2. Was passiert intern:
# - Queen koordiniert 12 Hive Mind Workers
# - Claude Code wird mit Kontext gestartet
# - Queen kann Claude Code anweisen:
#   "Use the Task tool to delegate database design"
# - Claude Code kann dann Sub-Agents spawnen:
#   Task(subagent_type="database-engineer", ...)
```

## 💡 Best Practices

### 1. **Queen Type Wahl**
- **Unsicher?** → Start mit Adaptive
- **Klare Anforderungen?** → Strategic
- **Zeitdruck?** → Tactical
- **Neu & Unbekannt?** → Exploratory

### 2. **Worker Anzahl**
- **Start klein**: Beginne mit 8-10, skaliere bei Bedarf
- **Auto-Scale**: Nutze `--auto-scale` für dynamische Anpassung
- **Overhead beachten**: Mehr Workers = mehr Koordination

### 3. **Worker Types**
- **Match zur Aufgabe**: Frontend-Tasks brauchen Frontend-Workers
- **Balance**: Immer mindestens 1 Tester und 1 Researcher
- **Spezialisierung**: Besser 6 spezialisierte als 20 generische

### 4. **Praktische Beispiele**

#### Kleines Projekt (Todo App)
```bash
npx claude-flow@alpha hive-mind spawn \
  "Create simple todo app with React" \
  --queen-type tactical \
  --max-workers 6 \
  --worker-types "frontend,tester" \
  --claude
```

#### Mittleres Projekt (E-Commerce)
```bash
npx claude-flow@alpha hive-mind spawn \
  "Build e-commerce platform with payment" \
  --queen-type strategic \
  --max-workers 16 \
  --worker-types "architect,frontend,backend,database,payment,security,tester" \
  --claude
```

#### Großes Projekt (Enterprise Migration)
```bash
npx claude-flow@alpha hive-mind spawn \
  "Migrate legacy system to microservices" \
  --queen-type strategic \
  --max-workers 24 \
  --worker-types "architect,analyst,backend,devops,database,security,tester,documenter" \
  --auto-scale \
  --memory-size 500 \
  --claude
```

#### Research Projekt
```bash
npx claude-flow@alpha hive-mind spawn \
  "Evaluate and compare AI frameworks for production use" \
  --queen-type exploratory \
  --max-workers 10 \
  --worker-types "researcher,analyst,benchmarker,documenter" \
  --claude
```

## 🎯 Zusammenfassung

1. **Queen Mode** bestimmt den Führungsstil
2. **Worker Anzahl** richtet sich nach Projekt-Größe
3. **Worker Types** sollten zur Aufgabe passen
4. **Keine Namen-Abhängigkeit** zu Claude Code Sub-Agents
5. **Start konservativ**, nutze Auto-Scaling

---

Speicherort: `~/claude-development/local-development-hub/QUEEN_MODES_GUIDE.md`