flatpickr("#fecha-reporte", {
            locale: "es",           // Configura el calendario completamente en español
            dateFormat: "d/m/Y",    // Formato de salida visual limpia: Día/Mes/Año (ej: 05/06/2026)
            allowInput: true,       // Permite que el usuario también pueda escribir si lo desea
            disableMobile: "true"   // Fuerza a que en celulares abra este mismo calendario estilizado en vez del nativo si buscas unificar diseño
        });