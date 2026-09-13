import products from "../../data/Products.js";

export default function ProductsCard() {
  return (
    <section className="container py-5 productos">
      <div className="header-productos text-center mb-5">
        <span className="subtitulo-decorativo">Nuestras Especialidades</span>
        <h2>Nuestros Productos</h2>
        <div className="linea-divisoria"></div>
        <p className="lead-productos">
          Horneamos diariamente con ingredientes seleccionados para llevar la
          mejor frescura y tradición directamente a tu mesa.
        </p>
      </div>
      <div class="row g-4 tarjetas">
        {products.map((product) => (
          <div className="col-md-4">
            <div className="card tarjeta h-100 text-center">
              <img
                src={product.imagen}
                className="tarjeta-img"
                alt={product.nombre}
              />
              <div className="card-body d-flex flex-column justify-content-center">
                <h3>{product.nombre}</h3>
                <p>{product.descripcion} </p>
              </div>
            </div>
          </div>
        ))}
      </div>
    </section>
  );
}
