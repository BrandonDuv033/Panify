<div align="center">

# 🥖 Panify — Entregables Trimestre 4

**_"Horneamos Calidad, Entregamos Confianza."_**

![SENA](https://img.shields.io/badge/SENA-ADSO-39A900?style=for-the-badge)
![Ficha](https://img.shields.io/badge/Ficha-3315796-orange?style=for-the-badge)
![Trimestre](https://img.shields.io/badge/Trimestre-4-blue?style=for-the-badge)
![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white)
![React](https://img.shields.io/badge/React-20232A?style=for-the-badge&logo=react&logoColor=61DAFB)
![Git](https://img.shields.io/badge/Git-F05032?style=for-the-badge&logo=git&logoColor=white)

Sistema web de gestión de pedidos, inventario y entregas para la panadería **Distribuciones Oro Pan**.

</div>

---

## 📑 Tabla de contenido

1. [Base de datos (DML y consultas)](#-1-base-de-datos-dml-y-consultas)
2. [Seguridad en base de datos](#-2-seguridad-en-base-de-datos)
3. [Front-End funcional](#-3-front-end-funcional)
4. [Control de versiones](#-4-control-de-versiones)
5. [Mapa del repositorio](#-5-mapa-del-repositorio)

---

## 🗄️ 1. Base de datos (DML y consultas)

> Evidencia del uso de sentencias **DML (SQL)**: datos de prueba insertados, **Joins**, consultas y subconsultas.

| 📄 Entregable     | 📝 Qué contiene                                        | 🔗 Ubicación                                                           |
| :---------------- | :----------------------------------------------------- | :--------------------------------------------------------------------- |
| **Base de Datos** | Estructura, datos de prueba (`INSERT`) y Joins         | [`Base de Datos.sql`](Base%20de%20Datos/scripts/Base%20de%20Datos.sql) |
| **Consultas**     | Consultas `SELECT` con filtros, agrupaciones y Joins   | [`Consultas.sql`](Base%20de%20Datos/scripts/Consultas.sql)             |
| **Subconsultas**  | Subconsultas anidadas sobre pedidos, productos y stock | [`Subconsultas.sql`](Base%20de%20Datos/scripts/Subconsultas.sql)       |

**Tecnologías:** `SQL (DML)` · `Joins` · `Subconsultas` · `MySQL Workbench`

---

## 🔐 2. Seguridad en base de datos

> Las contraseñas **no se almacenan en texto plano**: se protegen con hash **SHA-256** y salt.

| 📄 Entregable    | 📝 Qué contiene                                                            | 🔗 Ubicación                                                     |
| :--------------- | :------------------------------------------------------------------------- | :--------------------------------------------------------------- |
| **Encriptación** | Hash de contraseñas con `SHA2` y salt, aplicado en el registro de usuarios | [`Encriptacion.sql`](Base%20de%20Datos/scripts/Encriptacion.sql) |

**Tecnologías:** `Hash` · `SHA-256` · `Salt`

---

## 💻 3. Front-End funcional

> Interfaz construida con **React + Vite** y **Bootstrap**, conectada a un backend simulado con **JSON Server**, con autenticación simulada en `localStorage`.

| 📄 Entregable              | 📝 Qué contiene                                              | 🔗 Ubicación             |
| :------------------------- | :----------------------------------------------------------- | :----------------------- |
| **Aplicación React**       | Componentes, páginas y servicios (Axios)                     | [`frontend/`](frontend/) |
| **Backend simulado**       | JSON Server con `db.json` (puerto `1511`)                    | [`backend/`](backend/)   |
| **Autenticación simulada** | Sesión guardada en `localStorage` y rutas protegidas por rol | [`frontend/`](frontend/) |

**Tecnologías:** `React` · `Vite` · `Bootstrap` · `JSON Server` · `Axios` · `localStorage`

### ▶️ Cómo ejecutarlo

```bash
# 1. Backend simulado (JSON Server)
cd backend
npm install
npm run server

# 2. Frontend (en otra terminal)
cd frontend
npm install
npm run server
```

---

## 🌿 4. Control de versiones

> Evidencia de uso de **Git y GitHub**: historial de commits, ramas y flujo de trabajo por módulos.

| 📄 Evidencia         | 🔗 Enlace                                                       |
| :------------------- | :-------------------------------------------------------------- |
| Repositorio          | [BrandonDuv033/Panify](https://github.com/BrandonDuv033/Panify) |
| Historial de commits | [Ver commits](https://github.com/BrandonDuv033/Panify/commits)  |
| Ramas                | [Ver ramas](https://github.com/BrandonDuv033/Panify/branches)   |

**Flujo de trabajo:**

- 🌱 **Feature branches** por módulo: `feature/gestion-usuarios`, `feature/gestion-inventario`, `feature/gestion-pedidos`, `feature/gestion-recibos`, `feature/gestion-entrega`.
- ✍️ **Commits semánticos** (Conventional Commits): `tipo(ámbito): descripción`.

---

## 🗂️ 5. Mapa del repositorio

```text
Panify/
├── 📁 Base de Datos/
│   └── 📁 scripts/
│       ├── 📄 Base de Datos.sql     → estructura, INSERT y Joins
│       ├── 📄 Consultas.sql         → consultas
│       ├── 📄 Subconsultas.sql      → subconsultas
│       └── 📄 Encriptacion.sql      → hash SHA-256 con salt
├── 📁 backend/                      → JSON Server (db.json)
├── 📁 frontend/                     → React + Vite + Bootstrap
└── 📄 README.md
```

---

<div align="center">

**Proyecto formativo SENA · ADSO · Ficha 3315796 · Grupo 4**
Hecho con 🥖 para **Distribuciones Oro Pan**

</div>
