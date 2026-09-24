export default function Contacto() {
  return (
    <main className="contacto-page">
      <section className="contacto-hero">
        <h1>Contáctenos</h1>

        <div className="linea-dorada"></div>

        <h2>Estamos para atenderte</h2>

        <p>
          En Oro Pan trabajamos con compromiso para brindarte la mejor calidad.
          <br />
          Si tienes dudas, pedidos especiales o deseas más información,
          escríbenos.
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
              <span>+57 310 1176 1270 </span>
              <small>Lunes a sábado de 7:00 a.m. a 2:00 p.m.</small>
            </div>
          </div>

          <div className="dato-contacto">
            <div className="icono-contacto">
              <i className="fa-solid fa-envelope"></i>
            </div>

            <div>
              <strong>Correo electrónico</strong>
              <span>brayan@panify.com</span>
              <small>Te responderemos lo más pronto posible.</small>
            </div>
          </div>

          <div className="dato-contacto">
            <div className="icono-contacto">
              <i className="fa-solid fa-location-dot"></i>
            </div>

            <div>
              <strong>Dirección</strong>
              <span>Cl. 15a #10-26</span>
              <small>Soacha, Cundinamarca</small>
            </div>
          </div>

          <div className="dato-contacto">
            <div className="icono-contacto">
              <i className="fa-regular fa-clock"></i>
            </div>

            <div>
              <strong>Horario de atención</strong>
              <span>Lunes a sábado</span>
              <small>7:00 a.m. - 2:00 p.m.</small>
            </div>
          </div>

          <div className="frase-contacto">
            Horneamos calidad, entregamos confianza y unimos lazos
          </div>
        </div>

        {/* FORMULARIO */}
        <div className="contacto-card">
          <div className="contacto-titulo">
            <i className="fa-regular fa-comment-dots"></i>

            <div>
              <h3>Envíanos un mensaje</h3>
              <p>Completa el formulario y nos pondremos en contacto contigo.</p>
            </div>
          </div>

          <form>
            <div className="campo-contacto">
              <label>Nombre</label>

              <input type="text" placeholder="Tu nombre completo" />
            </div>

            <div className="campo-contacto">
              <label>Correo electrónico</label>

              <input type="email" placeholder="tucorreo@ejemplo.com" />
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

            <button type="submit" className="btn-enviar-contacto">
              <i className="fa-solid fa-paper-plane"></i>
              Enviar mensaje
            </button>
          </form>
        </div>
      </section>

      {/* VISÍTANOS */}
      <section className="visitanos">
        <div className="">
          <iframe
            src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d994.2614857367814!2d-74.21789329908684!3d4.585776308800547!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x8e3f9fd5f8329ebf%3A0xe24729a4d3b22890!2sCl.%2015a%20%23%2011A-68%2C%20Soacha%2C%20Cundinamarca!5e0!3m2!1ses-419!2sco!4v1782761193677!5m2!1ses-419!2sco"
            width="100%"
            height="250px"
            style={{ border: 0 }}
            allowFullScreen
            loading="lazy"
            referrerPolicy="no-referrer-when-downgrade"
          ></iframe>

          <div>
            <strong>Oro Pan</strong>
            <span>Cl. 15a #10-26</span>
          </div>
        </div>

        <div className="visitanos-info">
          <div className="titulo-visitanos">
            <i className="fa-solid fa-location-dot"></i>

            <h3>Visítanos</h3>
          </div>

          <p>
            Te invitamos a conocer nuestras instalaciones y disfrutar de la
            frescura y calidad de nuestros productos.
          </p>

          <button className="btn-como-llegar">
            <i className="fa-solid fa-map-location-dot me-2"></i>
            Cómo llegar
          </button>
        </div>
      </section>
    </main>
  );
}
