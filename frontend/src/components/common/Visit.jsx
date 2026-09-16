export default function Visit() {
  return (
    <section className="py-5 visita">
      <div className="container">
        <div className="header-visita text-center mb-5">
          <h2 className="text-white">Visítanos</h2>
          <div className="linea-divisoria"></div>
          <span className="mx-60">
            <p className="lead-visita">
              Retira tu pedido directamente en nuestra fábrica. Llevas el pan
              más fresco, recién horneado y listo para disfrutar. ¡Te esperamos!
            </p>
          </span>
        </div>
        <div className="row g-4">
          <div className="col-md-4">
            <div className="mb-4 p-4">
              <h5 className="mb-2">
                <i className="fa-solid fa-location-dot me-2"></i>
                Dirección
              </h5>
              <p className="mb-0">Cl. 15a #10-26</p>
              <p>Soacha, Cundinamarca</p>
            </div>
            <div className="p-4 horarios">
              <h5 className="mb-3">
                <i className="fa-solid fa-clock me-2"></i>Horarios de Atención
              </h5>
              <p className="mb-0">
                <strong>Lunes a Domingo:</strong> 7:00 AM - 2:00 PM
              </p>
            </div>
          </div>
          <div className="col-md-8">
            <div className="h-20">
              <div className="mapa-container">
                <iframe
                  src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d994.2614857367814!2d-74.21789329908684!3d4.585776308800547!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x8e3f9fd5f8329ebf%3A0xe24729a4d3b22890!2sCl.%2015a%20%23%2011A-68%2C%20Soacha%2C%20Cundinamarca!5e0!3m2!1ses-419!2sco!4v1782761193677!5m2!1ses-419!2sco"
                  width="100%"
                  height="450px"
                  style={{ border: 0 }}
                  allowFullScreen
                  loading="lazy"
                  referrerPolicy="no-referrer-when-downgrade"
                ></iframe>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}
