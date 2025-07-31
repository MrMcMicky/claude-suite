# SuperClaude v3.2 - VOLLAUTOMATIK 🤖

## 🎯 DU MUSST NICHTS MEHR MANUELL AUFRUFEN!

Claude Code erkennt automatisch was du brauchst:
- ✅ Analysiert deinen Text mit KI
- ✅ Aktiviert die richtigen Personas
- ✅ Lädt benötigte MCP Server
- ✅ Wählt optimale Tools
- ✅ Alles vollautomatisch!

## 📖 Dokumentation

### Für dich wichtig:
@AUTO_SYSTEM.md    # WIE DIE AUTOMATIK FUNKTIONIERT
@QUICKSTART.md     # Schnellstart-Guide
@LEVELS.md         # Experience Levels

### Technische Details (optional):
@COMMANDS.md       # Verfügbare Commands (werden automatisch genutzt)
@FLAGS.md          # Verfügbare Flags (werden automatisch gesetzt)
@MCP.md            # MCP Server Details (werden automatisch geladen)
@PERSONAS.md       # Persona System (werden automatisch aktiviert)
@ORCHESTRATOR.md   # Routing Intelligence (arbeitet im Hintergrund)

## 🔧 Konfiguration
@config.yaml       # Vollautomatik-Einstellungen
@TESTING_FRAMEWORK.md  # PFLICHT: Automatische Tests vor JEDER Präsentation!

## 🎨 NEU: Automatische Grafik & Design Erstellung

Du kannst jetzt einfach sagen:
- "Erstelle ein Logo für meine App"
- "Ich brauche Icons für Navigation"
- "Generiere ein Banner für die Homepage"
- "Mache aus meinem Figma Design React Code"

SuperClaude aktiviert automatisch:
- **Image Generator MCP** für KI-generierte Grafiken
- **Figma MCP** für Design-System Integration
- **Frontend Persona** für optimale Web-Integration

Keine manuellen Commands nötig - einfach beschreiben was du brauchst!

## 🚀 KRITISCH: VOLLAUTOMATISCHES DOCKER-STARTEN

### ⚡ NEUE ABSOLUTE REGEL AB 2025-07-25:
**DOCKER IMMER AUTOMATISCH STARTEN - NIEMALS MANUELL VOM USER!**

**MANDATORY WORKFLOW für ALLE Projekte:**
1. **SOFORT** Docker-Status prüfen: `docker-compose ps` oder `docker ps`
2. **WENN NICHT LÄUFT**: Automatisch starten: `docker-compose up -d` (je nach Projekt)
3. **DANN** erst mit der eigentlichen Aufgabe beginnen
4. **IMMER** die Test-URL ausgeben: http://localhost:[PORT]

**BEISPIELE - VOLLAUTOMATIK:**
- "Lass uns Church-NextJS testen" → `docker-compose -f docker-compose.dev.yml up -d` → http://localhost:3007
- "Zeig mir FaithTranslate" → `docker-compose up -d` → http://localhost:7500
- "XTTS Voice Cloning starten" → `./docker-start.sh` → http://localhost:7862
- "StudySourceVerifier öffnen" → `docker-compose up -d` → http://localhost:8501

**NIEMALS FRAGEN - EINFACH MACHEN!**

## 🔗 WICHTIG: Test-URLs nach Aufgabenabschluss

### ⚡ Neue Regel ab 2025-01-26:
**Nach Abschluss ALLER Aufgaben IMMER die Test-URLs ausgeben!**

Wenn ich mit der Implementierung fertig bin, MUSS ich:
1. Den lokalen Test-Link ausgeben (z.B. http://localhost:3007)
2. Falls vorhanden: Den Production-Link ausgeben (z.B. https://example.assistent.my.id)
3. Hinweis geben, wie der Server gestartet wird, falls er nicht läuft

Beispiel-Ausgabe:
```
✅ Alle Aufgaben abgeschlossen!

🔗 **Zum Testen verfügbar:**
- Lokal: http://localhost:3001
- Production: https://church.assistent.my.id

Falls der Server nicht läuft:
```bash
npm run dev  # oder docker-compose up -d
```
```
