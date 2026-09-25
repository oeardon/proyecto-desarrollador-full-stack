import { useEffect, useMemo, useState } from 'react'
import { Link, Route, Routes, useLocation, useNavigate } from 'react-router-dom'
import Header from './components/Header.jsx'
import { Footer } from './components/StoreSections.jsx'
import CartDrawer from './components/CartDrawer.jsx'
import Icon from './components/Icon.jsx'
import Inicio from './pages/Inicio.jsx'
import Cuenta from './pages/Cuenta.jsx'
import AdminPage from './pages/AdminPage.jsx'
import UserPage from './pages/UserPage.jsx'
import Checkout from './pages/Checkout.jsx'
import { useCatalog } from './context/useCatalog.js'
import { useCart } from './context/useCart.js'
import { useWishlist } from './context/useWishlist.js'
import { useAuth } from './context/useAuth.js'
import { iniciarInteraccionesGlobales } from './js/interacciones.js'

function App() {
  const [menuOpen, setMenuOpen] = useState(false)
  const [cartOpen, setCartOpen] = useState(false)
  const [search, setSearch] = useState('')
  const [storeNotice, setStoreNotice] = useState('')
  const location = useLocation()
  const navigate = useNavigate()
  const catalog = useCatalog()
  const { cart, add, updateQuantity, remove: removeFromCart, complete: completeCart } = useCart(catalog.products)
  const { usuario } = useAuth()
  const { favorites, toggle: toggleFavorite, busy: favoriteBusy } = useWishlist(usuario?.UsuarioID, location.pathname, setStoreNotice, () => navigate('/cuenta'))
  const query = new URLSearchParams(location.search)
  const activeCategory = query.get('categoria') || 'todos'
  const view = query.get('vista') || 'todos'
  const setActiveCategory = (id) => { setSearch(''); navigate(`/?categoria=${id}#productos`) }
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
    add(product)
    setMenuOpen(false)
    setCartOpen(true)
  }
  const submitSearch = (event) => {
    event.preventDefault()
    const category = new FormData(event.currentTarget).get('categoria') || 'todos'
    setMenuOpen(false)
    navigate(`/?categoria=${category}&q=${encodeURIComponent(search.trim())}#productos`)
  }

  return (
    <div className="todoaqui-app">
      <Header categories={catalog.categories} activeCategory={activeCategory} cartCount={cartCount} favoriteCount={favorites.length} menuOpen={menuOpen} setMenuOpen={setMenuOpen} search={search} setSearch={setSearch} onSearch={submitSearch} />
      <main>
        {storeNotice && <div className="alert alert-warning shop-container mt-3" role="alert">{storeNotice} <button type="button" className="btn btn-sm btn-outline-dark" onClick={() => setStoreNotice('')}>Cerrar</button></div>}
        <Routes>
          <Route path="/" element={
            <Inicio catalog={catalog} view={view} favoriteBusy={favoriteBusy} search={query.get('q') || ''} setSearch={setSearch} activeCategory={activeCategory} setActiveCategory={setActiveCategory} favorites={favorites} toggleFavorite={toggleFavorite}
                    addToCart={addToCart} cartOpen={cartOpen} menuOpen={menuOpen} />
          } />
          <Route path="/checkout" element={<Checkout cart={cart} updateQuantity={updateQuantity} removeFromCart={removeFromCart} completeCart={completeCart} catalog={catalog} />} />
          <Route path="/cuenta" element={<Cuenta />} />
          <Route path="/cuenta/usuario/:seccion" element={<UserPage />} />
          <Route path="/cuenta/usuario/:seccion/:id" element={<UserPage />} />
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
      <CartDrawer loading={catalog.loading} open={cartOpen} setOpen={setCartOpen} cart={cart} updateQuantity={updateQuantity} removeFromCart={removeFromCart} />
      <button data-back-to-top className="back-to-top" type="button" aria-label="Volver arriba" onClick={() => window.scrollTo({ top: 0, behavior: 'smooth' })}><Icon name="arrowLeft" size={18} /></button>
    </div>
  )
}

export default App
