# 🤖 Claude Code Sub-Agents - VOLLSTÄNDIGE LISTE (16 Agents)

## ✅ Alle verfügbaren Sub-Agent Typen

### Technische Spezialisten (11)

1. **solution-architect** ⭐⭐⭐⭐⭐
   - Systems design, long-term architecture, scalability
   - MCP: Sequential, Context7

2. **frontend-engineer** ⭐⭐⭐⭐⭐
   - React/Next.js, accessibility, performance
   - MCP: Magic, Playwright

3. **backend-engineer** ⭐⭐⭐⭐⭐
   - API design, reliability, data integrity
   - MCP: Context7, Sequential

4. **database-engineer** ⭐⭐⭐⭐⭐
   - Schema design, optimization, migrations
   - Spezialgebiete: PostgreSQL, MongoDB, Redis

5. **mobile-engineer** ⭐⭐⭐⭐⭐ ✅ NEU
   - iOS/Android, React Native, Flutter
   - App Store Optimization

6. **devops-engineer** ⭐⭐⭐⭐⭐
   - CI/CD, Docker, Kubernetes, Infrastructure
   - MCP: Sequential, Context7

7. **security-specialist** ⭐⭐⭐⭐⭐ ✅ NEU
   - Threat modeling, vulnerability assessment, compliance
   - Über Code Review hinaus

8. **ml-engineer** ⭐⭐⭐⭐⭐ ✅ NEU
   - Machine Learning, MLOps, Production ML
   - PyTorch, TensorFlow, LLMs

9. **cloud-architect** ⭐⭐⭐⭐⭐ ✅ NEU
   - AWS, Azure, GCP, Multi-Cloud
   - Cost optimization, FinOps

10. **data-scientist** ⭐⭐⭐⭐⭐ ✅ NEU
    - Statistical analysis, predictive modeling
    - Business insights, A/B testing

11. **ux-designer** ⭐⭐⭐⭐⭐ ✅ NEU
    - User research, prototyping, design systems
    - Figma, accessibility, usability

### Prozess & Qualität (5)

12. **qa-engineer** ⭐⭐⭐⭐⭐
    - Testing strategies, E2E, edge cases
    - MCP: Playwright, Sequential

13. **code-reviewer** ⭐⭐⭐⭐⭐
    - Code quality, security, best practices
    - Auto-aktiviert nach Code-Erstellung

14. **systems-analyst** ⭐⭐⭐⭐⭐
    - Performance analysis, metrics, optimization
    - MCP: Sequential

15. **technical-writer** ⭐⭐⭐⭐⭐
    - Documentation, tutorials, API docs
    - Multi-language support

16. **project-manager** ⭐⭐⭐⭐⭐
    - Agile, sprint planning, coordination
    - Task breakdown, estimation

## 🎯 Neue Agent-Capabilities

### security-specialist
```bash
# Aktivierung
Task(subagent_type="security-specialist", 
     description="Conduct security audit",
     prompt="Analyze authentication system for vulnerabilities")
```

### ml-engineer
```bash
# Aktivierung
Task(subagent_type="ml-engineer",
     description="Build ML pipeline",
     prompt="Create production-ready model serving API")
```

### ux-designer
```bash
# Aktivierung
Task(subagent_type="ux-designer",
     description="Design user flow",
     prompt="Create intuitive onboarding experience")
```

### cloud-architect
```bash
# Aktivierung
Task(subagent_type="cloud-architect",
     description="Design cloud infrastructure",
     prompt="Create scalable AWS architecture with cost optimization")
```

### data-scientist
```bash
# Aktivierung
Task(subagent_type="data-scientist",
     description="Analyze user behavior",
     prompt="Build churn prediction model with interpretable results")
```

## 🐝 Perfekte Hive Mind Integration

### Erweiterte Worker-Agent Mappings

| Hive Mind Worker | Claude Code Agents | Use Case |
|------------------|-------------------|----------|
| researcher | systems-analyst, data-scientist | Analyse & Insights |
| coder | backend/frontend/mobile-engineer | Implementation |
| analyst | systems-analyst, data-scientist | Datenanalyse |
| tester | qa-engineer | Quality Assurance |
| architect | solution-architect, cloud-architect | System Design |
| security | security-specialist, code-reviewer | Security Audit |
| ml | ml-engineer, data-scientist | AI/ML Tasks |
| designer | ux-designer | User Experience |
| devops | devops-engineer, cloud-architect | Infrastructure |

## 💡 Optimale Team-Kombinationen

### Full Stack Web App
```
solution-architect + frontend-engineer + backend-engineer + 
database-engineer + ux-designer + qa-engineer
```

### Machine Learning Project
```
ml-engineer + data-scientist + backend-engineer + 
cloud-architect + devops-engineer
```

### Mobile App Development
```
mobile-engineer + ux-designer + backend-engineer + 
qa-engineer + devops-engineer
```

### Enterprise Cloud Migration
```
cloud-architect + solution-architect + security-specialist + 
devops-engineer + database-engineer
```

### Security Audit
```
security-specialist + code-reviewer + systems-analyst + 
cloud-architect + backend-engineer
```

## 🚀 Status

✅ **16 Agents total** (6 neue hinzugefügt)
✅ **Alle mit professionellen Beschreibungen**
✅ **Volle Abdeckung aller Domains**
✅ **Perfekte Hive Mind Integration**
✅ **Production Ready**

Die Claude Code Sub-Agent Sammlung ist jetzt vollständig und deckt alle wichtigen Entwicklungsbereiche ab!

---

Speicherort: `~/claude-development/local-development-hub/CLAUDE_CODE_AGENTS_COMPLETE.md`