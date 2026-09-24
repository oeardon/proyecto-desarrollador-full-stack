import { useEffect, useRef, useState } from 'react'
import Hero from '../components/Hero.jsx'
import CategorySection from '../components/CategorySection.jsx'
import ProductSection from '../components/ProductSection.jsx'
import QuickView from '../components/QuickView.jsx'
import { Benefits, Deals, Newsletter } from '../components/StoreSections.jsx'

export default function Inicio({search = '', favorites = [], toggleFavorite, addToCart, 
                                cartOpen = false, menuOpen = false,}) {
  const [activeCategory, setActiveCategory] = useState('todos')
  const [activeSlide, setActiveSlide] = useState(0)
  const [quickView, setQuickView] = useState(null)
  const contenido = useRef(null)

  useEffect(() => {
    const timer = window.setInterval(() => {
      setActiveSlide((actual) => (actual + 1) % 3)
    }, 6500)
    return () => window.clearInterval(timer)
  }, [])

  useEffect(() => {
    function cerrarConEscape(event) {
      if (event.key === 'Escape') {
        setQuickView(null)
      }
    }
    document.addEventListener('keydown', cerrarConEscape)
    return () => {
      document.removeEventListener('keydown', cerrarConEscape)
    }
  }, [])

  // Sincroniza la animación con las tarjetas que React agrega al filtrar.
  useEffect(() => {
    const seccion = contenido.current
    if (!seccion) return
    if (!('IntersectionObserver' in window)) {
      function mostrarElementos() {
        seccion.querySelectorAll('.reveal-item').forEach((elemento) => {
          elemento.classList.add('is-visible')
        })
      }
      mostrarElementos()
      const cambios = new MutationObserver(mostrarElementos)
      cambios.observe(seccion, { childList: true, subtree: true })
      return () => cambios.disconnect()
    }
    const observador = new IntersectionObserver((entradas) => {
      entradas.forEach((entrada) => {
        if (entrada.isIntersecting) {
          entrada.target.classList.add('is-visible')
          observador.unobserve(entrada.target)
        }
      })
    }, { threshold: 0.12 })
    function observarElementos() {
      seccion
        .querySelectorAll('.reveal-item:not(.is-visible)')
        .forEach((elemento) => observador.observe(elemento))
    }
    observarElementos()
    const cambios = new MutationObserver(observarElementos)
    cambios.observe(seccion, { childList: true, subtree: true })
    return () => {
      observador.disconnect()
      cambios.disconnect()
    }
  }, [])

  // Usa una clase exclusiva para no interferir con el carrito y el menú.
  useEffect(() => {
    const modalVisible = Boolean(quickView) && !cartOpen && !menuOpen
    document.body.classList.toggle('quick-view-open', modalVisible)
    return () => {
      document.body.classList.remove('quick-view-open')
    }
  }, [quickView, cartOpen, menuOpen])

  function elegirCategoria(categoria) {
    setActiveCategory(categoria)
    document.querySelector('#productos')?.scrollIntoView({
      behavior: 'smooth',
      block: 'start',
    })
  }

  return (
    <div ref={contenido}>
      <Hero activeSlide={activeSlide} setActiveSlide={setActiveSlide} />
      <Benefits />
      <CategorySection onCategory={elegirCategoria} />
      <ProductSection activeCategory={activeCategory}
                      setActiveCategory={setActiveCategory}
                      search={search}
                      favorites={favorites}
                      toggleFavorite={toggleFavorite}
                      addToCart={addToCart}
                      openQuickView={setQuickView} />
      <Deals />
      <Newsletter />
      <QuickView product={!cartOpen && !menuOpen ? quickView : null}
                 onClose={() => setQuickView(null)}
                 addToCart={addToCart} />
    </div>
  )
}