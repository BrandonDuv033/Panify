
import { Link } from 'react-router-dom';

export default function Hero() {
  return (
    <section className="banner">
      <h1>Distribuidora Oro Pan</h1>
      <p>Horneamos Calidad, Entregamos Confianza</p>
      
      {/* Botón convertido en Link para navegar al catálogo/productos */}
      <Link
        to="/productos"
        className="btn btn-secondary text-decoration-none"
      >
        <i className="fa-solid fa-basket-shopping me-2"></i>Hacer Pedido
      </Link>
    </section>
  );
}