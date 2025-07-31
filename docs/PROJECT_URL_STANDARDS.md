# 🌐 Project URL Standards - Lokale Entwicklung

## 📐 Standard URL-Konventionen für alle Projekte

### ✅ **OBLIGATORISCHE URL-MUSTER**

Jedes Projekt MUSS folgende URL-Struktur einhalten:

#### 1. **Frontend / Hauptseite**
```
http://localhost:[PORT]/
```
- Die Hauptseite/Frontend IMMER auf der Root-URL
- Keine Subpaths wie `/app` oder `/frontend`

#### 2. **Admin / Backend Interface**
```
http://localhost:[PORT]/admin
```
- Admin-Interface IMMER unter `/admin`
- NICHT: `/admin/`, `/backend`, `/dashboard`, `/manage`
- Trailing Slash optional, aber `/admin` muss funktionieren

#### 3. **API Endpoints** (falls vorhanden)
```
http://localhost:[PORT]/api/
```
- API-Endpoints unter `/api/`
- RESTful Struktur: `/api/resource/`

#### 4. **Dokumentation** (optional)
```
http://localhost:[PORT]/docs
```
- API-Dokumentation unter `/docs`
- Swagger/OpenAPI Standard

---

## 📊 **Aktuelle Projekt-Status**

### ✅ **KONFORM mit Standards:**

#### **StepUpFundraiser** (Port 8000)
- ❌ Frontend: http://localhost:8000/static/dashboard_fixed.html
- ✅ Admin: http://localhost:8000/admin/
- ✅ API: http://localhost:8000/api/
- **TODO**: Frontend auf Root-URL umleiten

#### **EABW-CMS** (Port 8100)
- ✅ Frontend: http://localhost:8100/
- ✅ Admin: http://localhost:8100/admin/login
- ✅ API Docs: http://localhost:8100/docs

#### **MPM Project Manager** (Port 5100/5101)
- ✅ Frontend: http://localhost:5101/
- ✅ Backend Admin: http://localhost:5100/admin/
- ✅ API: http://localhost:5100/api/

#### **Church-NextJS** (Port 3007)
- ✅ Frontend: http://localhost:3007/
- ✅ Admin: http://localhost:3007/admin
- ✅ API: http://localhost:3007/api/

### ⚠️ **ANPASSUNG ERFORDERLICH:**

#### **Circle of Bluffs** (Port 3100)
- ✅ Frontend: http://localhost:3100/
- ❌ Admin: Nicht vorhanden (sollte hinzugefügt werden)

#### **FaithTranslate** (Port 7500)
- ✅ Frontend: http://localhost:7500/
- ❌ Admin: http://localhost:7500/admin_panel (sollte `/admin` sein)

---

## 🔧 **Implementierungs-Richtlinien**

### **Für neue Projekte:**

1. **Django-Projekte**:
```python
# urls.py
urlpatterns = [
    path('', views.index, name='home'),  # Frontend auf Root
    path('admin/', admin.site.urls),     # Admin unter /admin
    path('api/', include('api.urls')),   # API unter /api
]
```

2. **Node.js/Express**:
```javascript
// Frontend
app.get('/', (req, res) => {
    res.render('index');
});

// Admin
app.use('/admin', adminRouter);

// API
app.use('/api', apiRouter);
```

3. **FastAPI**:
```python
# Frontend
@app.get("/")
async def home():
    return templates.TemplateResponse("index.html", {"request": request})

# Admin
app.mount("/admin", admin_app)

# API
app.include_router(api_router, prefix="/api")
```

### **Für bestehende Projekte:**

1. **Nginx Redirect** (empfohlen):
```nginx
# Redirect non-standard URLs to standard
location /static/dashboard_fixed.html {
    return 301 /;
}

location /admin_panel {
    return 301 /admin;
}
```

2. **Application-Level Redirect**:
```python
# Django
from django.shortcuts import redirect

def redirect_to_home(request):
    return redirect('/')
```

---

## 📝 **Testing Checklist**

Für jedes Projekt prüfen:

- [ ] `http://localhost:[PORT]/` zeigt Frontend
- [ ] `http://localhost:[PORT]/admin` zeigt Admin-Interface
- [ ] `http://localhost:[PORT]/api/` zeigt API (falls vorhanden)
- [ ] `http://localhost:[PORT]/docs` zeigt API-Docs (optional)
- [ ] Keine Legacy-URLs mehr aktiv

---

## 🚀 **Migration Plan**

### **Phase 1: Dokumentation** (DONE)
- ✅ Standards definiert
- ✅ Aktuelle Abweichungen dokumentiert

### **Phase 2: Kritische Fixes**
- [ ] StepUpFundraiser: Frontend auf Root umleiten
- [ ] FaithTranslate: `/admin_panel` → `/admin`

### **Phase 3: Nice-to-have**
- [ ] Circle of Bluffs: Admin-Interface hinzufügen
- [ ] Alle Projekte: Trailing Slash Konsistenz

---

*Erstellt: 2025-07-23*  
*Standard gilt für alle neuen und bestehenden Projekte*