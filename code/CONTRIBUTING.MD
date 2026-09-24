# 🤝 Guía de Contribución — Panify

Reglas rápidas para trabajar en equipo sin generar conflictos. Si tienes dudas sobre el "por qué" de algo, revisa el `README.md`; este documento es solo el "cómo".

---

## 1. Ramas

Nunca trabajes directamente sobre `main` o `develop`. Cada módulo tiene su propia rama:

- `feature/gestion-usuarios`
- `feature/gestion-inventario`
- `feature/gestion-pedidos`
- `feature/gestion-recibos`
- `feature/gestion-entrega`

```bash
git checkout -b feature/gestion-recibos
```

Al terminar tu módulo, abre un Pull Request hacia `develop` — nunca hagas merge directo.

---

## 2. Commits semánticos (Conventional Commits, en español)

Formato:

```
<tipo>(<ámbito>): <descripción en imperativo, minúsculas, máx. 50 caracteres>
```

| Tipo       | Uso                                             |
| ---------- | ----------------------------------------------- |
| `feat`     | Nueva funcionalidad                             |
| `fix`      | Corrección de errores                           |
| `style`    | CSS, formato o diseño sin alterar lógica        |
| `docs`     | Documentación o comentarios                     |
| `refactor` | Cambios internos sin alterar comportamiento     |
| `chore`    | Tareas de mantenimiento (configs, dependencias) |

Ámbitos comunes: `(ui)`, `(db)`, `(repo)`, `(trimestre3)`, `(cliente)`, `(admin)`.

**Ejemplos:**

```
feat(admin): agregar tabla de recibos
fix(recibos): corregir cálculo de total en servicio
style(ui): ajustar espaciado del navbar
docs(repo): actualizar guía de contribución
```

## 🤖 Guía para Asistentes de IA

Al trabajar con Inteligencia Artificial para el proyecto, inicia el chat con el siguiente prompt para asegurar el formato de los commits:

```
Actúa como un desarrollador del equipo. Cada vez que generes un commit, debes entregar el resultado en DOS bloques de código independientes para poder copiarlos por separado:

1. Primer bloque de código: Título semántico
Formato: <tipo>(<ámbito>): <descripción en imperativo, minúsculas, máx. 50 caracteres>
- Tipos: feat, fix, style, docs, refactor, chore.
- Ámbitos: (ui), (db), (repo), (cliente), (admin), (trimestre3), etc.
- Reglas del título: Verbo en imperativo, minúsculas, sin punto final.

2. Segundo bloque de código: Descripción detallada
- Debe ser en texto continuo / párrafos estructurados (sin usar viñetas ni guiones).
- Explica qué se cambió y por qué.

Ejemplo de respuesta esperada:

feat(admin): agregar tabla de recibos

Se añade la vista y el componente de la tabla de recibos en el módulo de administración para permitir la visualización del historial de pagos. También se integra la conexión con el endpoint correspondiente para la carga de datos en tiempo real.
```

---

## 3. Convención de nombres

**El código va en inglés. La documentación y los commits van en español.**

Esto aplica a: nombres de carpetas, archivos, componentes, constantes, variables y funciones. Los **comentarios dentro del código sí van en español**, porque documentan el propósito de la lógica para el equipo, no son parte del nombre de nada.

| Elemento              | Convención                             | Ejemplo                                   |
| --------------------- | -------------------------------------- | ----------------------------------------- |
| Componentes           | PascalCase, inglés                     | `ReceiptsTable.jsx`, `ProtectedRoute.jsx` |
| Páginas               | PascalCase, inglés                     | `pages/admin/Receipts.jsx`                |
| Hooks                 | camelCase con prefijo `use`, inglés    | `useReceipts.js`, `useAuth.js`            |
| Servicios             | camelCase con sufijo `Service`, inglés | `receiptsService.js`                      |
| Carpetas              | minúsculas, inglés                     | `components/`, `pages/client/`            |
| Variables y funciones | camelCase, inglés                      | `getReceipts()`, `isAuthenticated`        |
| Comentarios en código | español                                | `// TODO: reemplazar por login real`      |

### Traducción de términos de dominio (para mantener consistencia entre módulos)

| Español      | Inglés (usar en código) |
| ------------ | ----------------------- |
| Recibos      | Receipts                |
| Pedidos      | Orders                  |
| Productos    | Products                |
| Usuarios     | Users                   |
| Cliente      | Client                  |
| Panadero     | Baker                   |
| Domiciliario | DeliveryPerson          |

---

## 4. Estructura al crear un módulo nuevo

Cada módulo, sin importar cuál sea, sigue el mismo patrón de 4 pasos:

1. **Servicio** en `src/services/<modulo>Service.js` — toda la comunicación con el backend pasa por aquí. Ningún componente o página llama a Axios directamente.
2. **Componentes** en `src/components/<zona>/` (`admin/` o `client/`) — piezas visuales reutilizables del módulo.
3. **Página** en `src/pages/<zona>/<Modulo>.jsx` — arma los componentes y consume el servicio.
4. **Ruta** en `src/routes/AppRouter.jsx` — se registra en el casillero ya reservado para ese módulo.

---

## 5. Reglas de convivencia en archivos compartidos

Estos archivos los toca **una sola persona a la vez**, avisando antes al equipo:

- `backend/db.json`
- `src/context/AuthContext.jsx`
- `src/routes/AppRouter.jsx`
- `src/services/api.js`
- `src/components/common/` (Navbar, Footer, ProtectedRoute)

Si necesitas un campo nuevo en `db.json` o un cambio en `AuthContext`, pídelo en el grupo antes de modificarlo directamente.

---

## ☑️ Checklist antes de abrir un Pull Request

- [ ] Mi rama sigue la convención `feature/<nombre-del-modulo>`
- [ ] Mis commits siguen el formato semántico en español
- [ ] Mis nombres de archivos, componentes y variables están en inglés
- [ ] No modifiqué archivos compartidos sin avisar al equipo
- [ ] Mi página/componente usa su `service` correspondiente (nada de Axios directo en componentes)
- [ ] Probé mi módulo con el backend (`json-server`) corriendo
- [ ] No dejé `console.log` de depuración
