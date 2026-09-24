# Panify

**"Horneamos Calidad, Entregamos Confianza y Unimos Lazos"**

![React](https://img.shields.io/badge/React-18-61DAFB?logo=react&logoColor=white)
![Vite](https://img.shields.io/badge/Vite-Build_Tool-646CFF?logo=vite&logoColor=white)
![JSON Server](https://img.shields.io/badge/JSON_Server-Mock_API-000000)
![Axios](https://img.shields.io/badge/Axios-HTTP_Client-5A29E4?logo=axios&logoColor=white)
![Estado](https://img.shields.io/badge/Estado-En_desarrollo-yellow)
![SENA](https://img.shields.io/badge/SENA-ADSO_3315796-39A900)

Sistema web de gestión de pedidos, inventario y recibos para el caso de estudio **Distribuciones Oro Pan**. Proyecto formativo del programa Análisis y Desarrollo de Software (SENA), Ficha 3315796, Grupo 4.

---

## 📑 Tabla de contenidos

1. [Stack tecnológico](#-stack-tecnológico)
2. [Requisitos previos](#-requisitos-previos)
3. [Instalación y arranque](#-instalación-y-arranque)
4. [Estructura del proyecto](#-estructura-del-proyecto)
5. [Qué va en cada carpeta](#️-qué-debo-poner-en-cada-carpeta-y-cómo-trabajar-en-ella)
6. [Roles del sistema](#-roles-del-sistema)
7. [Tutorial: cómo empezar un nuevo módulo](#️-tutorial-cómo-empezar-a-desarrollar-un-nuevo-módulo)
8. [Convenciones de Git y commits](#-convenciones-de-git-y-commits)
9. [Checklist antes de abrir un Pull Request](#-checklist-antes-de-abrir-un-pull-request)
10. [Problemas comunes (Troubleshooting)](#-problemas-comunes-troubleshooting)
11. [Equipo](#-equipo)

---

## 🛠 Stack tecnológico

| Capa | Tecnología |
|---|---|
| Frontend | React 18 + Vite |
| Ruteo | React Router DOM |
| HTTP Client | Axios |
| Backend simulado | JSON Server |
| Estilos | CSS (organizado por módulo, ver [sección de carpetas](#️-qué-debo-poner-en-cada-carpeta-y-cómo-trabajar-en-ella)) |
| Control de versiones | Git + GitHub (Feature Branches + Commits Semánticos) |
| Base de datos (diseño) | MySQL 3FN, patrón ISA — ver Diccionario de Datos |

---

## ✅ Requisitos previos

- [Node.js](https://nodejs.org/) v18 o superior
- npm (viene con Node.js)
- Git

---

## 🚀 Instalación y arranque

El proyecto corre en **dos procesos simultáneos**: el backend simulado y el frontend. Necesitas dos terminales abiertas.

### 1. Clonar el repositorio

```bash
git clone https://github.com/BrandonDuv033/Panify.git
cd Panify/panify-app
```

### 2. Levantar el backend simulado (Terminal 1)

```bash
cd backend
npm install
npm run server
```

Esto levanta JSON Server en `http://localhost:1511` (o el puerto configurado en `package.json`).

### 3. Levantar el frontend (Terminal 2)

```bash
cd frontend
npm install
npm run server
```

Esto levanta Vite, normalmente en `http://localhost:5173`.

> Verifica que la `baseURL` de `frontend/src/services/api.js` coincida con el puerto en el que corre tu `backend/`.

---

## 📁 Estructura del proyecto

```text
panify-app/
├── 📁 backend/                # Servidor API simulado (json-server)
│   ├── db.json               # Base de datos central en JSON
│   ├── routes.json           # Rutas personalizadas de la API
│   ├── middlewares/          # Lógica intermedia (ej. control horario, validación de stock)
│   └── package.json          # Dependencias del backend
│
└── 📁 frontend/               # Aplicación cliente (React + Vite)
    ├── 📁 public/
    │   └── img/              # Imágenes estáticas globales (logos, banners)
    │
    ├── 📁 src/
    │   ├── 📁 assets/
    │   │   └── css/
    │   │       ├── base/      # variables.css, reset.css
    │   │       ├── layout/    # navbar.css, footer.css
    │   │       └── pages/     # estilos específicos por módulo/página
    │   │
    │   ├── 📁 components/    # Componentes reutilizables (piezas de UI)
    │   │   ├── 📁 common/    # Navbar, Footer, RutaProtegida, Botones compartidos
    │   │   ├── 📁 cliente/   # Componentes exclusivos de clientes (ej: TarjetaProducto)
    │   │   └── 📁 admin/     # Componentes exclusivos de admin (ej: TablaRecibos)
    │   │
    │   ├── 📁 context/       # Estado global (AuthContext.jsx para la sesión)
    │   │
    │   ├── 📁 hooks/         # Custom Hooks (ej: useRecibos, usePedidos, useStock)
    │   │
    │   ├── 📁 layouts/       # Estructuras principales de página (MainLayout, AdminLayout)
    │   │
    │   ├── 📁 pages/         # Vistas completas que se cargan según la URL
    │   │   ├── 📁 public/    # Home, Login, Registro, Catalogo, Recuperacion
    │   │   ├── 📁 cliente/   # MisPedidos, PerfilCliente
    │   │   └── 📁 admin/     # Dashboard, Recibos, Inventario, Pedidos
    │   │
    │   ├── 📁 routes/        # Configuración del enrutador principal (AppRouter.jsx)
    │   │
    │   └── 📁 services/      # Conexión con el backend (api.js, recibosService.js, etc.)
    │
    └── package.json          # Dependencias del frontend
```

---

## 🗺️ ¿Qué debo poner en cada carpeta y cómo trabajar en ella?

### 1. `backend/`

- **`db.json`**: nuestra base de datos simulada. Aquí viven las colecciones (`usuarios`, `clientes`, `domiciliarios`, `panaderos`, `productos`, `pedidos`, `detallePedido`, `recibos`, `direcciones`).
- Es **compartida** por todo el equipo — cualquier cambio de estructura aquí afecta a los 5 módulos. Avisa antes de modificar colecciones existentes.

### 2. `frontend/src/pages/` vs `frontend/src/components/`

- **`pages/`** (páginas completas): corresponden directamente a una URL. Ejemplo: `pages/admin/Recibos.jsx` se carga en `/admin/recibos`.
- **`components/`** (piezas pequeñas): bloques de construcción de una página. Ejemplo: `TablaRecibos.jsx`, `FiltroFecha.jsx`. Se importan dentro de la página correspondiente.

### 3. `frontend/src/layouts/`

- **`MainLayout.jsx`**: Navbar público/cliente arriba, Footer abajo.
- **`AdminLayout.jsx`**: menú administrativo (compartido Panadero/Domiciliario) + panel principal.

### 4. `frontend/src/services/`

Toda la comunicación con el servidor vive aquí, usando Axios.

- **`api.js`**: instancia base con la URL del backend.
- **Servicios específicos**: cada módulo crea el suyo (`recibosService.js`, `pedidosService.js`, etc.). **Ningún componente o página hace `axios` directamente — siempre pasa por su `service`.**

### 5. `frontend/src/context/`

Guarda el estado global. Aquí vive `AuthContext.jsx`, que expone la sesión del usuario a toda la app.

### 6. `frontend/src/routes/`

`AppRouter.jsx` centraliza todas las rutas de la aplicación, incluyendo cuáles están protegidas por rol vía `RutaProtegida`.

---

## 👥 Roles del sistema

| Rol | Acceso | Interfaz |
|---|---|---|
| Visitante (sin sesión) | Zona pública: catálogo, contacto, login, registro | `pages/public/` |
| Cliente | Su historial de pedidos, perfil, hacer pedidos | `pages/cliente/` |
| Panadero | Producción, stock, recibos, panel de prioridades | `pages/admin/` (Opción A) |
| Domiciliario | Panel de prioridades, entregas, rutas | `pages/admin/` (Opción A) |

> Los valores exactos de `idRol` para cada uno deben confirmarse contra el **Diccionario de Datos** antes de codificar validaciones definitivas en `RutaProtegida`.

---

## 🛠️ Tutorial: ¿cómo empezar a desarrollar un nuevo módulo?

Si te asignaron un módulo (ejemplo: **Recibos**), sigue este flujo:

### Paso 1 — Usa tu rama

Nunca trabajes directamente sobre `main` o `develop`:

```bash
git checkout -b feature/gestion-recibos
```

### Paso 2 — Crear el servicio en `services/`

```javascript
// frontend/src/services/recibosService.js
import api from "./api";

export const getRecibos = async () => {
  const response = await api.get("/recibos");
  return response.data;
};
```

### Paso 3 — Crear los componentes visuales

Dentro de `frontend/src/components/admin/`:
- `TablaRecibos.jsx`
- `DetalleReciboModal.jsx`

### Paso 4 — Armar la vista en `pages/`

```javascript
// frontend/src/pages/admin/Recibos.jsx
import { useEffect, useState } from "react";
import { getRecibos } from "../../services/recibosService";
import TablaRecibos from "../../components/admin/TablaRecibos";

export default function RecibosPage() {
  const [recibos, setRecibos] = useState([]);

  useEffect(() => {
    getRecibos().then(setRecibos);
  }, []);

  return (
    <div>
      <h2>Gestión de Recibos</h2>
      <TablaRecibos datos={recibos} />
    </div>
  );
}
```

### Paso 5 — Registrar la ruta

En `frontend/src/routes/AppRouter.jsx`, dentro del bloque protegido de admin:

```javascript
<Route path="/admin/recibos" element={<RecibosPage />} />
```

---

## 📝 Convenciones de Git y commits

### Ramas por módulo

- `feature/gestion-usuarios`
- `feature/gestion-inventario`
- `feature/gestion-pedidos`
- `feature/gestion-recibos`
- `feature/gestion-entrega`

### Commits semánticos

Formato: `<tipo>(<ámbito>): <descripción en imperativo, minúsculas, máx. 50 caracteres>`

| Tipo | Uso |
|---|---|
| `feat` | Nueva funcionalidad |
| `fix` | Corrección de errores |
| `style` | CSS, formato o diseño sin alterar lógica |
| `docs` | Documentación o comentarios |
| `refactor` | Cambios internos sin alterar comportamiento |
| `chore` | Tareas de mantenimiento (configs, dependencias) |

Ámbitos comunes: `(ui)`, `(db)`, `(repo)`, `(trimestre3)`, `(cliente)`, `(admin)`.

**Ejemplos:**
```
feat(admin): agregar tabla de recibos
fix(recibos): corregir cálculo de total en servicio
style(ui): ajustar espaciado del navbar
docs(repo): actualizar guía de arquitectura
```

---

## ☑️ Checklist antes de abrir un Pull Request

- [ ] Mi rama sigue la convención `feature/<nombre-del-modulo>`
- [ ] Mis commits siguen el formato semántico en español
- [ ] No modifiqué `services/api.js` ni `AuthContext.jsx` sin avisar al equipo
- [ ] Si agregué colecciones a `db.json`, lo comuniqué al resto
- [ ] Mi página/componente usa su `service` correspondiente (nada de `axios` directo en componentes)
- [ ] Probé mi módulo con el backend (`json-server`) corriendo
- [ ] No dejé `console.log` de depuración

---

## 🐛 Problemas comunes (Troubleshooting)

| Problema | Causa probable | Solución |
|---|---|---|
| `Network Error` al hacer peticiones | El backend (`json-server`) no está corriendo | Verifica que `npm run dev` esté activo en `backend/` |
| Error de CORS | Puerto del frontend no coincide con lo esperado | Revisa configuración de `json-server` o `vite.config.js` |
| Los datos no cambian tras editar `db.json` | JSON Server no detectó el cambio | Reinicia `npm run dev` en `backend/` |
| `useAuth debe usarse dentro de <AuthProvider>` | Falta envolver la app con `<AuthProvider>` en `main.jsx` | Verifica que `AppRouter` esté dentro de `<AuthProvider>` |

---

## 👥 Equipo

| Módulo | Responsable |
|---|---|
| Gestión de Usuarios | Kevin González |
| Productos e Inventario | Martín Cruz |
| Gestión de Pedidos | Brayan Devia |
| Gestión de Recibos | Brandon Guevara |
| Entregas y Rutas | Jeison Diaz |

---

*SENA — Análisis y Desarrollo de Software (ADSO), Ficha 3315796, Grupo 4.*
