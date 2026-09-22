import { useEffect, useMemo, useState } from 'react'
import Header from './components/Header.jsx'
import Hero from './components/Hero.jsx'
import CategorySection from './components/CategorySection.jsx'
import ProductSection from './components/ProductSection.jsx'
import { Benefits, Deals, Newsletter, Footer } from './components/StoreSections.jsx'
import CartDrawer from './components/CartDrawer.jsx'
import QuickView from './components/QuickView.jsx'
import Icon from './components/Icon.jsx'
import { iniciarInteraccionesGlobales } from './js/interacciones.js'

function App() {
  const [menuOpen, setMenuOpen] = useState(false)
  const [cartOpen, setCartOpen] = useState(false)
  const [cart, setCart] = useState([])
  const [favorites, setFavorites] = useState([])
  const [quickView, setQuickView] = useState(null)
  const [search, setSearch] = useState('')
  const [activeCategory, setActiveCategory] = useState('todos')
  const [activeSlide, setActiveSlide] = useState(0)
  const cartCount = useMemo(() => cart.reduce((sum, item) => sum + item.quantity, 0), [cart])

  useEffect(() => iniciarInteraccionesGlobales(), [])

  useEffect(() => {
    const openCart = () => setCartOpen(true)
    const escape = () => { setCartOpen(false); setQuickView(null); setMenuOpen(false) }
    document.addEventListener('click', (event) => {
      if (event.target.closest('[data-open-cart]')) openCart()
    })
    window.addEventListener('todoaqui:escape', escape)
    return () => window.removeEventListener('todoaqui:escape', escape)
  }, [])

  useEffect(() => {
    const timer = window.setInterval(() => setActiveSlide((current) => (current + 1) % 3), 6500)
    return () => window.clearInterval(timer)
  }, [])

  useEffect(() => {
    document.body.classList.toggle('no-scroll', cartOpen || Boolean(quickView) || menuOpen)
    return () => document.body.classList.remove('no-scroll')
  }, [cartOpen, quickView, menuOpen])

  const addToCart = (product) => {
    setCart((current) => {
      const existing = current.find((item) => item.id === product.id)
      if (existing) return current.map((item) => item.id === product.id ? { ...item, quantity:item.quantity + 1 } : item)
      return [...current, { ...product, quantity:1 }]
    })
    setCartOpen(true)
  }

  const updateQuantity = (id, delta) => {
    setCart((current) => current.map((item) => item.id === id ? { ...item, quantity:Math.max(1, item.quantity + delta) } : item))
  }

  const removeFromCart = (id) => setCart((current) => current.filter((item) => item.id !== id))
  const toggleFavorite = (id) => setFavorites((current) => current.includes(id) ? current.filter((item) => item !== id) : [...current, id])

  const chooseCategory = (category) => {
    setActiveCategory(category)
    setSearch('')
    document.querySelector('#productos')?.scrollIntoView({ behavior:'smooth', block:'start' })
  }

  const submitSearch = (event) => {
    event.preventDefault()
    setActiveCategory('todos')
    document.querySelector('#productos')?.scrollIntoView({ behavior:'smooth', block:'start' })
  }

  return (
    <div className="todoaqui-app">
      <Header cartCount={cartCount} favoriteCount={favorites.length} menuOpen={menuOpen} setMenuOpen={setMenuOpen} search={search} setSearch={setSearch} onSearch={submitSearch}/>
      <main>
        <Hero activeSlide={activeSlide} setActiveSlide={setActiveSlide}/>
        <Benefits/>
        <CategorySection onCategory={chooseCategory}/>
        <ProductSection activeCategory={activeCategory} setActiveCategory={setActiveCategory} search={search} favorites={favorites} toggleFavorite={toggleFavorite} addToCart={addToCart} openQuickView={setQuickView}/>
        <Deals/>
        <Newsletter/>
      </main>
      <Footer/>
      <CartDrawer open={cartOpen} setOpen={setCartOpen} cart={cart} updateQuantity={updateQuantity} removeFromCart={removeFromCart}/>
      <QuickView product={quickView} onClose={() => setQuickView(null)} addToCart={addToCart}/>
      <button data-back-to-top className="back-to-top" type="button" aria-label="Volver arriba" onClick={() => window.scrollTo({ top:0, behavior:'smooth' })}><Icon name="arrowLeft" size={18}/></button>
    </div>
  )
}

export default App
