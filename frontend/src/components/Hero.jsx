import Icon from './Icon.jsx'

const slides = [
  {
    eyebrow: 'Nueva colección tecnológica',
    title: 'Tecnología que se adapta a tu ritmo',
    text: 'Encuentra celulares, laptops, audio y accesorios seleccionados para hacer más simple tu día a día',
    image: 'https://images.unsplash.com/photo-1498049794561-7780e7231661?auto=format&fit=crop&w=1600&q=85',
  },
  {
    eyebrow: 'Descubre nuestro catálogo',
    title: 'Actualiza tu espacio con mejores equipos',
    text: 'Productos para trabajar, estudiar y disfrutar, con promociones especiales y entrega rápida',
    image: 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?auto=format&fit=crop&w=1600&q=85',
  },
  {
    eyebrow: 'Audio y entretenimiento',
    title: 'Más potencia para cada momento',
    text: 'Descubre audífonos, bocinas y accesorios con diseño moderno y una experiencia de compra sencilla',
    image: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=1600&q=85',
  },
  {
  eyebrow: 'Electrodomésticos para tu hogar',
  title: 'Haz de cada espacio un lugar mejor',
  text: 'Encuentra refrigeradoras, lavadoras, estufas y equipos pensados para facilitar las tareas de todos los días',
  image: 'https://images.unsplash.com/photo-1556911220-bff31c812dba?auto=format&fit=crop&w=1600&q=85',
},
{
  eyebrow: 'Gaming y entretenimiento',
  title: 'Lleva tu experiencia al siguiente nivel',
  text: 'Descubre equipos, accesorios y tecnología para jugar, conectarte y disfrutar tus momentos de entretenimiento',
  image: 'https://images.unsplash.com/photo-1542751371-adc38448a05e?auto=format&fit=crop&w=1600&q=85',
},
{
  eyebrow: 'Tecnología para el hogar',
  title: 'Más comodidad para tu día a día',
  text: 'Encuentra dispositivos y soluciones inteligentes que combinan funcionalidad, diseño y tecnología para tu hogar',
  image: 'https://images.unsplash.com/photo-1558002038-1055907df827?auto=format&fit=crop&w=1600&q=85',
},
]

export default function Hero({ activeSlide, setActiveSlide }) {
  const slide = slides[activeSlide]

  const go = (direction) => {
    setActiveSlide((current) => (current + direction + slides.length) % slides.length)
  }

  return (
    <section className="hero-shop" id="inicio">
      <div className="shop-container hero-shop__grid">
        <article className="hero-main-card reveal-item">
          <img src={slide.image} alt="Tecnología y dispositivos modernos" className="hero-main-card__image" />
          <div className="hero-main-card__overlay"></div>
          <div className="hero-main-card__content">
            <span className="hero-kicker">{slide.eyebrow}</span>
            <h1>{slide.title}</h1>
            <p>{slide.text}</p>
            <div className="hero-actions">
              <a className="shop-btn shop-btn--accent" href="#productos">Comprar ahora <Icon name="arrowRight" size={17} /></a>
              <a className="shop-btn shop-btn--light" href="#categorias">Ver categorías</a>
            </div>
          </div>

          <button className="hero-arrow hero-arrow--left" onClick={() => go(-1)} aria-label="Anterior"><Icon name="arrowLeft" /></button>
          <button className="hero-arrow hero-arrow--right" onClick={() => go(1)} aria-label="Siguiente"><Icon name="arrowRight" /></button>

          <div className="hero-dots" aria-label="Seleccionar banner">
            {slides.map((item, index) => (
              <button
                key={item.title}
                className={index === activeSlide ? 'active' : ''}
                onClick={() => setActiveSlide(index)}
                aria-label={`Ir al banner ${index + 1}`}
              ></button>
            ))}
          </div>
        </article>

        <div className="hero-promos">
          <article className="hero-promo hero-promo--phone reveal-item">
            <span>EXPLORA LA TIENDA</span>
            <h2>Encuentra tu próximo equipo</h2>
            <a href="#productos">Comprar ahora <Icon name="arrowRight" size={15} /></a>
          </article>
          <article className="hero-promo hero-promo--audio reveal-item">
            <span>AUDIO PREMIUM</span>
            <h2>Escucha cada detalle</h2>
            <a href="#productos">Explorar productos <Icon name="arrowRight" size={15} /></a>
          </article>
        </div>
      </div>
    </section>
  )
}
