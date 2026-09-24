import { useEffect, useMemo, useState } from 'react'
import { Link, Route, Routes, useLocation, useNavigate } from 'react-router-dom'
import Header from './components/Header.jsx'
import { Footer } from './components/StoreSections.jsx'
import CartDrawer from './components/CartDrawer.jsx'
import Icon from './components/Icon.jsx'
import Inicio from './pages/Inicio.jsx'
import Cuenta from './pages/Cuenta.jsx'
import AdminPage from './pages/AdminPage.jsx'
import { iniciarInteraccionesGlobales } from './js/interacciones.js'

function App() {
  const [menuOpen, setMenuOpen] = useState(false)
  const [cartOpen, setCartOpen] = useState(false)
  const [cart, setCart] = useState([])
  const [favorites, setFavorites] = useState([])
  const [search, setSearch] = useState('')
  const [activeCategory, setActiveCategory] = useState('todos')
  const location = useLocation()
  const navigate = useNavigate()
  const cartCount = useMemo(() => cart.reduce((sum, item) => sum + item.quantity, 0), [cart])

  useEffect(() => iniciarInteraccionesGlobales(), [])

  useEffect(() => {
    const openCart = (event) => {
      if (event.target.closest('[data-open-cart]')) setCartOpen(true)
    }
    const escape = () => {
      setCartOpen(false)
      setMenuOpen(false)
    }
    document.addEventListener('click', openCart)
    window.addEventListener('todoaqui:escape', escape)
    return () => {
      document.removeEventListener('click', openCart)
      window.removeEventListener('todoaqui:escape', escape)
    }
  }, [])

  useEffect(() => {
    document.body.classList.toggle('no-scroll', cartOpen || menuOpen)
    return () => document.body.classList.remove('no-scroll')
  }, [cartOpen, menuOpen])

  // Espera a que React muestre la página antes de buscar la sección de destino.
  useEffect(() => {
    if (location.hash) {
      document.getElementById(location.hash.slice(1))?.scrollIntoView({
        behavior: 'smooth', block: 'start',
      })
    } else {
      window.scrollTo({ top: 0, behavior: 'instant' })
    }
  }, [location])

  const addToCart = (product) => {
    setCart((current) => {
      const existing = current.find((item) => item.id === product.id)
      if (existing) return current.map((item) => item.id === product.id ? { ...item, quantity: item.quantity + 1 } : item)
      return [...current, { ...product, quantity: 1 }]
    })
    setMenuOpen(false)
    setCartOpen(true)
  }

  const updateQuantity = (id, delta) => {
    setCart((current) => current.map((item) => item.id === id ? { ...item, quantity: Math.max(1, item.quantity + delta) } : item))
  }

  const removeFromCart = (id) => setCart((current) => current.filter((item) => item.id !== id))
  const toggleFavorite = (id) => setFavorites((current) => current.includes(id) ? current.filter((item) => item !== id) : [...current, id])

  const submitSearch = (event) => {
    event.preventDefault()
    setMenuOpen(false)
    setActiveCategory('todos')
    navigate('/#productos')
  }

  return (
    <div className="todoaqui-app">
      <Header cartCount={cartCount} favoriteCount={favorites.length} menuOpen={menuOpen} setMenuOpen={setMenuOpen} search={search} setSearch={setSearch} onSearch={submitSearch} />
      <main>
        <Routes>
          <Route path="/" element={
            <Inicio search={search} setSearch={setSearch} activeCategory={activeCategory} setActiveCategory={setActiveCategory} favorites={favorites} toggleFavorite={toggleFavorite}
                    addToCart={addToCart} cartOpen={cartOpen} menuOpen={menuOpen} />
          } />
          <Route path="/cuenta" element={<Cuenta />} />
          <Route path="/cuenta/admin/:recurso" element={<AdminPage />} />
          <Route path="/cuenta/admin/:recurso/:operacion" element={<AdminPage />} />
          <Route path="*" element={
            <section className="shop-section shop-container">
              <h1>Página no encontrada</h1>
              <Link to="/">Volver al inicio</Link>
            </section>
          } />
        </Routes>
      </main>
      <Footer />
      <CartDrawer open={cartOpen} setOpen={setCartOpen} cart={cart} updateQuantity={updateQuantity} removeFromCart={removeFromCart} />
      <button data-back-to-top className="back-to-top" type="button" aria-label="Volver arriba" onClick={() => window.scrollTo({ top: 0, behavior: 'smooth' })}><Icon name="arrowLeft" size={18} /></button>
    </div>
  )
}

export default App
