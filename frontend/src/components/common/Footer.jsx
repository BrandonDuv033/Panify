import "../../assets/css/layout/footer.css";

export default function Footer() {
  return (
    <footer id="contacto">
      <div className="container">
        <div className="row text-center g-4">
          <div className="col-md-9 footer-logo">
            Panify - Distribuciones Oro Pan
          </div>
          <div className="col-md-3 foter-info">
            <p>3315796 | ADSO - Grupo 4</p>
            <p>SENA - Centro de Formación</p>
          </div>
        </div>
        <div className="row text-center footer-rights">
          <div className="col-md-12">
            &copy; {new Date().getFullYear()} Panify. Todos los derechos
            reservados.
          </div>
        </div>
      </div>
    </footer>
  );
}
