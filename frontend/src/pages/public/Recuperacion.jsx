function RecuperarContrasena() {
  return (
    <form>
      <label htmlFor="correo">
        Correo Electrónico
      </label>

      <input
        type="email"
        id="correo"
        placeholder="Correo usuario"
        required
      />

      <button type="submit">
        Enviar enlace de recuperación
      </button>
    </form>
    
  );
}

export default RecuperarContrasena;