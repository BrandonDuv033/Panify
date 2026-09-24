// hooks/useModal.js
import { useState, useCallback } from "react";

export default function useModal() {
  const [abierto, setAbierto] = useState(false);
  const [datos, setDatos] = useState(null);

  const abrir = useCallback((payload = null) => {
    setDatos(payload);
    setAbierto(true);
  }, []);

  const cerrar = useCallback(() => {
    setAbierto(false);
    setDatos(null);
  }, []);

  return { abierto, datos, abrir, cerrar };
}
