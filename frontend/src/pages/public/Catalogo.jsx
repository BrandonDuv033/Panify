import { obtenerProductos } from "../../services/inventario.js";
import { useState, useEffect } from "react";
import Swal from "sweetalert2";

const Catalogo = () => {
  const [productos, setProductos] = useState([]);
  const [loading, setLoading] = useState(true);
  const [busqueda, setBusqueda] = useState("");
  const [categoriaFiltro, setCategoriaFiltro] = useState("");
  const [carrito, setCarrito] = useState([]);
  const [reciboData, setReciboData] = useState(null);

  useEffect(() => {
    async function cargarProductos() {
      try {
        const productos = await obtenerProductos();
        setProductos(productos);
      } catch (error) {
        console.error("Error al cargar los productos:", error);
      } finally {
        setLoading(false);
      }
    }

    cargarProductos();
  }, []);
  
  useEffect(() => {
  localStorage.setItem("carrito", JSON.stringify(carrito));
}, [carrito]);

  // Filtrar productos reactivamente
  const productosFiltrados = productos.filter((prod) => {
    const coincideBusqueda = prod.nombre
      .toLowerCase()
      .includes(busqueda.toLowerCase());
    const coincideCategoria =
      categoriaFiltro === "" ||
      (prod.descripcion &&
        prod.descripcion.toLowerCase().includes(categoriaFiltro.toLowerCase()));
    return coincideBusqueda && coincideCategoria;
  });

  // Agregar producto al carrito
  const agregarAlCarrito = (producto) => {
    setCarrito((prevCarrito) => {
      const existe = prevCarrito.find(
        (item) => item.id === producto.id,
      );
      if (existe) {
        return prevCarrito.map((item) =>
          item.id === producto.id
            ? { ...item, cantidad: item.cantidad + 1 }
            : item,
        );
      }
      return [...prevCarrito, { ...producto, cantidad: 1 }];
    });
  };

  // Cambiar cantidad de un producto en el carrito (+ / -)
  const cambiarCantidad = (id, delta) => {
    setCarrito((prevCarrito) =>
      prevCarrito
        .map((item) => {
          if (item.id === id) {
            const nuevaCantidad = item.cantidad + delta;
            return nuevaCantidad > 0
              ? { ...item, cantidad: nuevaCantidad }
              : null;
          }
          return item;
        })
        .filter(Boolean),
    );
  };

  // Calcular precio total
  const calcularTotal = () => {
    return carrito.reduce((acc, item) => acc + item.precio * item.cantidad, 0);
  };

  // Vaciar carrito
  const vaciarCarrito = () => {
    setCarrito([]);
    setReciboData(null);
  };

  // Finalizar compra
  const finalizarCompra = () => {
    if (carrito.length === 0) {
      Swal.fire({
        icon: "warning",
        title: "Carrito vacío",
        text: "Agrega productos antes de finalizar la compra.",
        confirmButtonColor: "#e5a93c",
      });
      return;
    }
    Swal.fire({
      icon: "success",
      title: "¡Compra exitosa!",
      text: "Tu pedido ha sido registrado correctamente.",
      confirmButtonColor: "#e5a93c",
    });
    setCarrito([]);
  };

  // Generar recibo
  const generarRecibo = () => {
    if (carrito.length === 0) {
      Swal.fire({
        icon: "warning",
        title: "Carrito vacío",
        text: "No hay productos para generar un recibo.",
        confirmButtonColor: "#e5a93c",
      });
      return;
    }
    setReciboData([...carrito]);
    Swal.fire({
      icon: "success",
      title: "Recibo Generado",
      text: "Consulta el detalle al final de la página.",
      confirmButtonColor: "#e5a93c",
    });
  };

  return (
    <div>
      {/* CONTENIDO PRINCIPAL */}
      <main className="productos container py-5" style={{ marginTop: "80px" }}>
        <div className="header-productos text-center mb-5">
          <span className="subtitulo-decorativo">Distribuciones Oro Pan</span>
          <h2>Nuestros Productos</h2>
          <div className="linea-divisoria"></div>
          <p className="lead-productos">
            Escoge tus productos favoritos y agrégos al carrito.
          </p>
        </div>

        {/* Buscador y Filtro */}
        <div className="row mb-4">
          <div className="col-md-8 mb-2 mb-md-0">
            <input
              type="text"
              className="form-control"
              placeholder="Buscar producto..."
              value={busqueda}
              onChange={(e) => setBusqueda(e.target.value)}
            />
          </div>
          <div className="col-md-4">
            <select
              className="form-select"
              value={categoriaFiltro}
              onChange={(e) => setCategoriaFiltro(e.target.value)}
            >
              <option value="">Todas las descripciones</option>
              <option value="artesanal">Artesanal</option>
              <option value="queso">Queso</option>
            </select>
          </div>
        </div>

        {/* Lista de Productos y Carrito */}
        <div className="row">
          {/* Productos Grid con datos de la API */}
          <div className="col-lg-8 row g-4" id="listaProductos">
            {loading ? (
              <p className="text-white text-center">
                Cargando productos desde la base de datos...
              </p>
            ) : (
              productosFiltrados.map((prod) => (
                <div className="col-md-6" key={prod.id}>
                  <div className="tarjeta h-100 d-flex flex-column justify-content-between p-3">
                    <div>
                      <div className="text-center pt-2 fs-1">🍞</div>
                      <div className="card-body px-0">
                        <h3 className="text-white">{prod.nombre}</h3>
                        <p className="text-light opacity-75 mb-2">
                          {prod.descripcion}
                        </p>
                        <p className="fw-bold text-warning fs-5 mb-3">
                          $ {prod.precio.toLocaleString()}
                        </p>
                      </div>
                    </div>
                    <button
                      className="btn w-100 mt-2 text-dark fw-bold py-2"
                      style={{ backgroundColor: "#e5a93c", border: "none" }}
                      onClick={() => agregarAlCarrito(prod)}
                    >
                      <i className="fa-solid fa-cart-plus me-1"></i> Agregar al
                      carrito
                    </button>
                  </div>
                </div>
              ))
            )}
            {!loading && productosFiltrados.length === 0 && (
              <p className="text-white text-center">
                No se encontraron productos.
              </p>
            )}
          </div>

          {/* Carrito de Compras */}
          <div className="col-lg-4 mt-4 mt-lg-0">
            <div className="p-4 tarjeta shadow bg-white rounded text-dark">
              <div className="tarjeta-header mb-3 border-bottom pb-2">
                <h4 className="text-dark">
                  <i className="fa-solid fa-cart-shopping me-2"></i> Carrito
                </h4>
              </div>

              <div className="tarjeta-body p-0" style={{ minHeight: "150px" }}>
                {carrito.length === 0 ? (
                  <p className="text-center text-muted">
                    El carrito está vacío.
                  </p>
                ) : (
                  carrito.map((item) => (
                    <div
                      key={item.id}
                      className="d-flex justify-content-between align-items-center mb-2 border-bottom pb-2"
                    >
                      <div>
                        <h6 className="m-0 text-dark">{item.nombre}</h6>
                        <small className="text-muted">
                          $ {item.precio} c/u
                        </small>
                      </div>
                      <div className="d-flex align-items-center gap-2">
                        <button
                          className="btn btn-sm btn-outline-secondary"
                          onClick={() => cambiarCantidad(item.id, -1)}
                        >
                          -
                        </button>
                        <span>{item.cantidad}</span>
                        <button
                          className="btn btn-sm btn-outline-secondary"
                          onClick={() => cambiarCantidad(item.id, 1)}
                        >
                          +
                        </button>
                      </div>
                    </div>
                  ))
                )}
              </div>

              <div className="tarjeta-footer border-top pt-3 mt-3">
                <button
                  className="btn btn-danger w-100 mb-2"
                  onClick={vaciarCarrito}
                >
                  Vaciar carrito
                </button>
                <h5 className="text-dark">
                  Total:{" "}
                  <span id="total">$ {calcularTotal().toLocaleString()}</span>
                </h5>
                <button
                  className="btn btn-success w-100 mt-2"
                  onClick={finalizarCompra}
                >
                  Finalizar compra
                </button>
                <button
                  className="btn btn-primary w-100 mt-2"
                  onClick={generarRecibo}
                >
                  Generar recibo
                </button>
              </div>
            </div>
          </div>
        </div>

        {/* Sección de Recibo Dinámico */}
        {reciboData && (
          <div
            id="recibo"
            className="tarjeta mt-4 p-4 bg-light rounded shadow-sm text-dark"
          >
            <h4 className="border-bottom pb-2 mb-3">Recibo de compra</h4>
            <ul className="list-group mb-3">
              {reciboData.map((item, idx) => (
                <li
                  key={idx}
                  className="list-group-item d-flex justify-content-between align-items-center"
                >
                  <span>
                    {item.nombre} (x{item.cantidad})
                  </span>
                  <span>
                    $ {(item.precio * item.cantidad).toLocaleString()}
                  </span>
                </li>
              ))}
            </ul>
            <h5 id="reciboTotal" className="fw-bold">
              Total Pagado: ${" "}
              {reciboData
                .reduce((acc, i) => acc + i.precio * i.cantidad, 0)
                .toLocaleString()}
            </h5>
          </div>
        )}
      </main>
    </div>
  );
};

export default Catalogo;
