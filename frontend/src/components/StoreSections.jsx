import { Link } from 'react-router-dom'
import { useState } from 'react'
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

export function Deals() {
  return (
    <section className="shop-section" id="ofertas">
      <div className="shop-container deal-grid">
        <article className="deal-card deal-card--main reveal-item">
          <div className="deal-card__content"><span>SEMANA TECH</span><h2>Hasta 35% de descuento</h2><p>Actualiza tus dispositivos favoritos con precios especiales por tiempo limitado.</p><a href="#productos" className="shop-btn shop-btn--dark">Ver ofertas <Icon name="arrowRight" size={17} /></a></div>
        </article>
        <article className="deal-card deal-card--small deal-card--watch reveal-item"><span>NUEVO</span><h3>Smartwatch para cada día</h3><a href="#productos">Explorar <Icon name="arrowRight" size={14} /></a></article>
        <article className="deal-card deal-card--small deal-card--desk reveal-item"><span>HOME OFFICE</span><h3>Mejora tu espacio de trabajo</h3><a href="#productos">Ver selección <Icon name="arrowRight" size={14} /></a></article>
      </div>
    </section>
  )
}

export function Newsletter() {
  const [email, setEmail] = useState('')
  const [sent, setSent] = useState(false)
  const submit = (event) => { event.preventDefault(); if (email.trim()) { setSent(true); setEmail('') } }
  return (
    <section className="newsletter-shop" id="novedades">
      <div className="shop-container newsletter-shop__inner reveal-item">
        <div className="newsletter-icon"><Icon name="mail" size={29} /></div>
        <div><span>Únete a TodoAquí</span><h2>Recibe ofertas y novedades</h2><p>Promociones, nuevos productos y recomendaciones directamente en tu correo.</p></div>
        <form onSubmit={submit}><input value={email} onChange={(e) => setEmail(e.target.value)} type="email" required placeholder="Tu correo electrónico"/><button type="submit">Suscribirme</button></form>
        {sent && <div className="newsletter-success">¡Gracias! Tu suscripción fue registrada.</div>}
      </div>
    </section>
  )
}

export function Footer() {
  return (
    <footer className="footer-shop" id="contacto">
      <div className="shop-container footer-shop__grid">
        <div className="footer-brand"><Link className="brand" to="/#inicio"><span className="brand__mark">T</span><span>Todo<span className="brand__accent">Aquí</span></span></Link><p>Una tienda en línea moderna para encontrar tecnología, hogar y accesorios desde un solo lugar.</p><div className="social-row"><a href="#instagram" aria-label="Instagram"><Icon name="instagram" /></a><a href="#facebook" aria-label="Facebook"><Icon name="facebook" /></a><a href="#tiktok" aria-label="TikTok"><Icon name="tiktok" /></a></div></div>
        <div><h3>Comprar</h3><Link to="/#productos">Tienda</Link><Link to="/#ofertas">Ofertas</Link><Link to="/#productos">Nuevos ingresos</Link><Link to="/#productos">Más vendidos</Link></div>
        <div id="ayuda"><h3>Ayuda</h3><a href="#envios">Envíos</a><a href="#devoluciones">Cambios y devoluciones</a><a href="#preguntas">Preguntas frecuentes</a><a href="#contacto">Contáctanos</a></div>
        <div><h3>Contacto</h3><p className="footer-contact"><Icon name="location" size={17}/> Ciudad de Guatemala, Guatemala</p><p className="footer-contact"><Icon name="mail" size={17}/> hola@todoaqui.com</p><p className="footer-contact"><Icon name="clock" size={17}/> Lun–Sáb, 8:00–18:00</p></div>
      </div>
      <div className="shop-container footer-bottom"><span>© 2026 TodoAquí. Todos los derechos reservados.</span><span>Compra fácil. Compra seguro.</span></div>
    </footer>
  )
}
