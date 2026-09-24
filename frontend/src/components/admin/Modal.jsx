// components/Modal.jsx
import { useEffect } from "react";
import { createPortal } from "react-dom";
import "../../assets/css/components/modal.css";

export default function ModalEditarUsuario({ abierto, titulo, onCerrar, children }) {
  useEffect(() => {
    if (!abierto) return;

    const onKeyDown = (e) => e.key === "Escape" && onCerrar();
    document.addEventListener("keydown", onKeyDown);
    const overflowPrevio = document.body.style.overflow;
    document.body.style.overflow = "hidden";

    return () => {
      document.removeEventListener("keydown", onKeyDown);
      document.body.style.overflow = overflowPrevio;
    };
  }, [abierto, onCerrar]);

  if (!abierto) return null;

  return createPortal(
    <div className="modal-overlay" onMouseDown={onCerrar}>
      <div
        className="modal-contenido"
        role="dialog"
        aria-modal="true"
        aria-labelledby="modal-titulo"
        onMouseDown={(e) => e.stopPropagation()}
      >
        <header className="modal-header">
          <h2 id="modal-titulo">{titulo}</h2>
          <button
            type="button"
            className="modal-cerrar"
            onClick={onCerrar}
            aria-label="Cerrar"
          >
            ×
          </button>
        </header>
        {children}
      </div>
    </div>,
    document.body,
  );
}
