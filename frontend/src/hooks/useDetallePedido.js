import { useState, useCallback } from "react";
import { obtenerDetallePedido } from "../services/recibos.js";
import Swal from "sweetalert2";

export default function useDetallePedido() {
  const [detalle, setDetalle] = useState({
    idPedido: null,
    productos: [],
    cargando: false,
  });

  const abrirDetalle = useCallback(async (idPedido) => {
    try {
      setDetalle({ idPedido, productos: [], cargando: true });
      const productos = await obtenerDetallePedido(idPedido);
      setDetalle({ idPedido, productos, cargando: false });
    } catch (error) {
      console.error("Error al cargar el detalle:", error);
      Swal.fire("Error", "No se pudo cargar el detalle del recibo.", "error");
      setDetalle({ idPedido: null, productos: [], cargando: false });
    }
  }, []);

  const cerrarDetalle = useCallback(() => {
    setDetalle({ idPedido: null, productos: [], cargando: false });
  }, []);

  return { detalle, abrirDetalle, cerrarDetalle };
}
