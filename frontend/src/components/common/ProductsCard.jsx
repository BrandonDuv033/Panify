export default function ProductsCard() {
  const products = [
    {
      nombre: "Blandito",
      descripcion:
        "El infaltable de la mañana. Masa extra suave, esponjosa y con un delicioso toque de mantequilla fresca.",
      imagen:
        "https://images.unsplash.com/photo-1509440159596-0249088772ff?q=80&w=600&auto=format&fit=crop",
    },
    {
      nombre: "Rollo",
      descripcion:
        "Dorado por fuera y tierno por dentro. Corteza crujiente con el sabor tradicional de siempre.",
      imagen:
        "https://images.unsplash.com/photo-1549931319-a545dcf3bc73?q=80&w=600&auto=format&fit=crop",
    },
    {
      nombre: "Hojaldre",
      descripcion:
        "Capas crujientes y livianas. El balance perfecto horneado hasta lograr un dorado ideal.",
      imagen:
        "https://images.unsplash.com/photo-1555507036-ab1f4038808a?q=80&w=600&auto=format&fit=crop",
    },
  ];

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
