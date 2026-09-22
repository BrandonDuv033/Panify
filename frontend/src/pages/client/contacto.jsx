import "../../assets/css/pages/contacto.css";

export default function Contacto() {
  return (
    <main className="contacto-page">

      {/* ENCABEZADO */}
      <section className="contacto-hero">
        <h1>Contáctenos</h1>

        <div className="linea-dorada"></div>

        <h2>Estamos para atenderte</h2>

        <p>
          En Oro Pan trabajamos con compromiso para brindarte la mejor calidad.
          <br />
          Si tienes dudas, pedidos especiales o deseas más información, escríbenos.
        </p>
      </section>

      {/* INFORMACIÓN + FORMULARIO */}
      <section className="contacto-contenido">

        {/* INFORMACIÓN DE CONTACTO */}
        <div className="contacto-card">

          <div className="contacto-titulo">
            <i className="fa-solid fa-phone"></i>

            <div>
              <h3>Información de Contacto</h3>
              <p>Puedes comunicarte con nosotros a través de:</p>
            </div>
          </div>

          <div className="dato-contacto">
            <div className="icono-contacto">
              <i className="fa-solid fa-phone"></i>
            </div>

            <div>
              <strong>Teléfono</strong>
              <span>+57 310 123 4567</span>
              <small>Lunes a sábado de 7:00 a.m. a 6:00 p.m.</small>
            </div>
          </div>

          <div className="dato-contacto">
            <div className="icono-contacto">
              <i className="fa-solid fa-envelope"></i>
            </div>

            <div>
              <strong>Correo electrónico</strong>
              <span>ventas@oropan.com</span>
              <small>Te responderemos lo más pronto posible.</small>
            </div>
          </div>

          <div className="dato-contacto">
            <div className="icono-contacto">
              <i className="fa-solid fa-location-dot"></i>
            </div>

            <div>
              <strong>Dirección</strong>
              <span>Cra. 25 # 72 - 15</span>
              <small>Bogotá, Colombia</small>
            </div>
          </div>

          <div className="dato-contacto">
            <div className="icono-contacto">
              <i className="fa-regular fa-clock"></i>
            </div>

            <div>
              <strong>Horario de atención</strong>
              <span>Lunes a sábado</span>
              <small>7:00 a.m. - 6:00 p.m.</small>
            </div>
          </div>

          <div className="frase-contacto">
            Pan que une personas ♥
          </div>

        </div>

        {/* FORMULARIO */}
        <div className="contacto-card">

          <div className="contacto-titulo">
            <i className="fa-regular fa-comment-dots"></i>

            <div>
              <h3>Envíanos un mensaje</h3>
              <p>
                Completa el formulario y nos pondremos en contacto contigo.
              </p>
            </div>
          </div>

          <form>

            <div className="campo-contacto">
              <label>Nombre</label>

              <input
                type="text"
                placeholder="Tu nombre completo"
              />
            </div>

            <div className="campo-contacto">
              <label>Correo electrónico</label>

              <input
                type="email"
                placeholder="tucorreo@ejemplo.com"
              />
            </div>

            <div className="campo-contacto">
              <label>Asunto</label>

              <input
                type="text"
                placeholder="¿Sobre qué deseas contactarnos?"
              />
            </div>

            <div className="campo-contacto">
              <label>Mensaje</label>

              <textarea
                rows="4"
                placeholder="Escribe tu mensaje aquí..."
              ></textarea>
            </div>

            <button
              type="submit"
              className="btn-enviar-contacto"
            >
              <i className="fa-solid fa-paper-plane"></i>
              Enviar mensaje
            </button>

          </form>

        </div>

      </section>

      {/* VISÍTANOS */}
      <section className="visitanos">

        <div className="mapa-falso">
          <div className="marcador-mapa">
            <i className="fa-solid fa-location-dot"></i>

            <div>
              <strong>Oro Pan</strong>
              <span>Cra. 25 # 72 - 15</span>
            </div>
          </div>
        </div>

        <div className="visitanos-info">

          <div className="titulo-visitanos">
            <i className="fa-solid fa-location-dot"></i>

            <h3>Visítanos</h3>
          </div>

          <p>
            Te invitamos a conocer nuestras instalaciones y disfrutar de
            la frescura y calidad de nuestros productos.
          </p>

          <button className="btn-como-llegar">
            <i className="fa-solid fa-map-location-dot"></i>
            Cómo llegar
          </button>

        </div>

      </section>

    </main>
  );
}