import { Link } from 'react-router-dom'
import Icon from './Icon.jsx'

export function Benefits() {
  const items = [
    ['truck','Envíos rápidos','Entrega segura a tu puerta'],
    ['shield','Compra protegida','Pagos y datos seguros'],
    ['headset','Soporte cercano','Atención cuando la necesitas'],
    ['refresh','Cambios sencillos','Proceso claro y rápido'],
  ]
  return <section className="benefits-strip"><div className="shop-container benefits-grid">{items.map(([icon,title,text]) => <div className="benefit-shop reveal-item" key={title}><span><Icon name={icon} /></span><div><strong>{title}</strong><small>{text}</small></div></div>)}</div></section>
}

export function Deals({ products = [] }) {
  const offers = products.filter((product) => product.promotion).slice(0, 3)
  return <section className="shop-section" id="ofertas"><div className="shop-container">
    <div className="section-heading"><div><span>Promociones vigentes</span><h2>Ofertas de la tienda</h2></div><Link className="text-link" to="/?vista=ofertas#productos">Ver ofertas <Icon name="arrowRight" size={15} /></Link></div>
    {offers.length ? <div className="row g-3">{offers.map((product) => <div className="col-12 col-md-4" key={product.id}><div className="card h-100"><div className="card-body"><p className="text-primary">{product.promotion}</p><h3 className="h5">{product.name}</h3><Link to={`/?q=${encodeURIComponent(product.name)}#productos`}>Ver producto</Link></div></div></div>)}</div> : <p className="text-secondary">Consulta el catálogo para ver los precios disponibles.</p>}
  </div></section>
}

export function Newsletter() {
  return <section className="newsletter-shop" id="novedades"><div className="shop-container newsletter-shop__inner reveal-item"><div className="newsletter-icon"><Icon name="cart" size={29} /></div><div><span>Descubre TodoAquí</span><h2>Novedades del catálogo</h2><p>Explora los productos agregados recientemente a nuestra tienda.</p></div><Link className="shop-btn shop-btn--accent" to="/?vista=novedades#productos">Ver nuevos ingresos</Link></div></section>
}

export function Footer() {
  return (
    <footer className="footer-shop" id="contacto">
      <div className="shop-container footer-shop__grid">
        <div className="footer-brand"><Link className="brand" to="/#inicio"><span className="brand__mark">T</span><span>Todo<span className="brand__accent">Aquí</span></span></Link><p>Una tienda en línea moderna para encontrar tecnología, hogar y accesorios desde un solo lugar.</p><div className="social-row"><a href="#instagram" aria-label="Instagram"><Icon name="instagram" /></a><a href="#facebook" aria-label="Facebook"><Icon name="facebook" /></a><a href="#tiktok" aria-label="TikTok"><Icon name="tiktok" /></a></div></div>
        <div><h3>Comprar</h3><Link to="/#productos">Tienda</Link><Link to="/?vista=ofertas#productos">Ofertas</Link><Link to="/?vista=novedades#productos">Nuevos ingresos</Link><Link to="/?vista=vendidos#productos">Más vendidos</Link></div>
        <div id="ayuda"><h3>Ayuda</h3><a href="#envios">Envíos</a><Link to="/cuenta/usuario/devoluciones">Cambios y devoluciones</Link><a href="#preguntas">Preguntas frecuentes</a><a href="#contacto">Contáctanos</a></div>
        <div><h3>Contacto</h3><p className="footer-contact"><Icon name="location" size={17}/> Ciudad de Guatemala, Guatemala</p><p className="footer-contact"><Icon name="mail" size={17}/> hola@todoaqui.com</p><p className="footer-contact"><Icon name="clock" size={17}/> Lun–Sáb, 8:00–18:00</p></div>
      </div>
      <div className="shop-container footer-bottom"><span>© 2026 TodoAquí | Todos los derechos reservados | Realizado por Oscar Ardon y Gabriela Ortega</span><span>Compra fácil. Compra seguro.</span></div>
    </footer>
  )
}
