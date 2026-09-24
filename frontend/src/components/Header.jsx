import { Link, NavLink } from 'react-router-dom'
import Icon from './Icon.jsx'

export default function Header({ cartCount, favoriteCount, menuOpen, setMenuOpen, search, setSearch, onSearch }) {
  return (
    <>
      <div className="topbar-shop">
        <div className="shop-container topbar-shop__inner">
          <p><strong>Envío gratis</strong> en compras seleccionadas mayores a Q500</p>
          <div className="topbar-shop__links">
            <Link onClick={() => setMenuOpen(false)} to="/#ayuda">Ayuda</Link>
            <Link onClick={() => setMenuOpen(false)} to="/#seguimiento">Seguimiento</Link>
            <Link onClick={() => setMenuOpen(false)} to="/cuenta">Mi cuenta</Link>
          </div>
        </div>
      </div>

      <header className="site-header" data-site-header>
        <div className="shop-container header-main">
          <Link onClick={() => setMenuOpen(false)} className="brand" to="/#inicio" aria-label="TodoAquí inicio">
            <span className="brand__mark">T</span>
            <span>Todo<span className="brand__accent">Aquí</span></span>
          </Link>

          <form className="header-search" onSubmit={onSearch}>
            <select aria-label="Categoría de búsqueda" defaultValue="todas">
              <option value="todas">Todas las categorías</option>
              <option value="celulares">Celulares</option>
              <option value="computacion">Computación</option>
              <option value="audio">Audio</option>
              <option value="gaming">Gaming</option>
              <option value="hogar">Hogar inteligente</option>
            </select>
            <input
              value={search}
              onChange={(event) => setSearch(event.target.value)}
              type="search"
              placeholder="Buscar productos..."
              aria-label="Buscar productos"
            />
            <button type="submit" aria-label="Buscar"><Icon name="search" /></button>
          </form>

          <div className="header-actions">
            <Link onClick={() => setMenuOpen(false)} className="header-action d-none d-sm-grid" to="/cuenta" aria-label="Mi cuenta"><Icon name="user" /></Link>
            <Link onClick={() => setMenuOpen(false)} className="header-action d-none d-sm-grid" to="/#favoritos" aria-label="Favoritos">
              <Icon name="heart" />
              {favoriteCount > 0 && <span className="action-badge">{favoriteCount}</span>}
            </Link>
            <button className="header-action" type="button" data-open-cart aria-label="Abrir carrito">
              <Icon name="cart" />
              {cartCount > 0 && <span className="action-badge">{cartCount}</span>}
            </button>
            <button
              className={`hamburger ${menuOpen ? 'is-open' : ''}`}
              type="button"
              aria-label={menuOpen ? 'Cerrar menú' : 'Abrir menú'}
              aria-expanded={menuOpen}
              onClick={() => setMenuOpen(!menuOpen)}
            >
              <span></span>
            </button>
          </div>
        </div>

        <nav className={`shop-nav ${menuOpen ? 'is-open' : ''}`} aria-label="Navegación principal">
          <div className="shop-container shop-nav__inner">
            <div className="category-nav dropdown-shop">
              <button className="category-nav__button dropdown-shop__toggle" type="button">
                <Icon name="menu" size={18} />
                <span>Todas las categorías</span>
                <Icon name="chevronDown" size={15} />
              </button>
              <div className="dropdown-shop__menu category-nav__menu">
                {[
                  ['phone','Celulares y tablets'],['laptop','Computación'],['audio','Audio y video'],
                  ['game','Gaming'],['home','Hogar inteligente'],['accessory','Accesorios']
                ].map(([icon, label]) => (
                  <Link onClick={() => setMenuOpen(false)} to="/#categorias" key={label}><span><Icon name={icon} size={17} />{label}</span><Icon name="chevronRight" size={14} /></Link>
                ))}
              </div>
            </div>

            <ul className="main-menu">
              <li><NavLink onClick={() => setMenuOpen(false)} to="/" end>Inicio</NavLink></li>
              <li className="dropdown-shop">
                <button className="menu-dropdown-button dropdown-shop__toggle" type="button">Tienda <Icon name="chevronDown" size={14} /></button>
                <div className="dropdown-shop__menu">
                  <Link onClick={() => setMenuOpen(false)} to="/#productos">Todos los productos</Link>
                  <Link onClick={() => setMenuOpen(false)} to="/#productos">Nuevos ingresos</Link>
                  <Link onClick={() => setMenuOpen(false)} to="/#productos">Más vendidos</Link>
                  <Link onClick={() => setMenuOpen(false)} to="/#ofertas">Ofertas especiales</Link>
                </div>
              </li>
              <li className="dropdown-shop mega-parent">
                <button className="menu-dropdown-button dropdown-shop__toggle" type="button">Categorías <Icon name="chevronDown" size={14} /></button>
                <div className="dropdown-shop__menu mega-menu">
                  <div><strong>Tecnología</strong><Link onClick={() => setMenuOpen(false)} to="/#productos">Celulares</Link><Link onClick={() => setMenuOpen(false)} to="/#productos">Laptops</Link><Link onClick={() => setMenuOpen(false)} to="/#productos">Tablets</Link></div>
                  <div><strong>Entretenimiento</strong><Link onClick={() => setMenuOpen(false)} to="/#productos">Audio</Link><Link onClick={() => setMenuOpen(false)} to="/#productos">Gaming</Link><Link onClick={() => setMenuOpen(false)} to="/#productos">TV y video</Link></div>
                  <div><strong>Para tu hogar</strong><Link onClick={() => setMenuOpen(false)} to="/#productos">Hogar inteligente</Link><Link onClick={() => setMenuOpen(false)} to="/#productos">Accesorios</Link><Link onClick={() => setMenuOpen(false)} to="/#productos">Oficina</Link></div>
                </div>
              </li>
              <li><Link onClick={() => setMenuOpen(false)} to="/#ofertas">Ofertas</Link></li>
              <li><Link onClick={() => setMenuOpen(false)} to="/#novedades">Novedades</Link></li>
              <li><Link onClick={() => setMenuOpen(false)} to="/#contacto">Contacto</Link></li>
            </ul>

            <Link onClick={() => setMenuOpen(false)} className="nav-hot-deal" to="/#ofertas">🔥 Oferta del día</Link>
          </div>
        </nav>
      </header>
    </>
  )
}
