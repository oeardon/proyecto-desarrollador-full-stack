import Icon from './Icon.jsx'

export default function Header({ cartCount, favoriteCount, menuOpen, setMenuOpen, search, setSearch, onSearch }) {
  return (
    <>
      <div className="topbar-shop">
        <div className="shop-container topbar-shop__inner">
          <p><strong>Envío gratis</strong> en compras seleccionadas mayores a Q500</p>
          <div className="topbar-shop__links">
            <a href="#ayuda">Ayuda</a>
            <a href="#seguimiento">Seguimiento</a>
            <a href="#cuenta">Mi cuenta</a>
          </div>
        </div>
      </div>

      <header className="site-header" data-site-header>
        <div className="shop-container header-main">
          <a className="brand" href="#inicio" aria-label="TodoAquí inicio">
            <span className="brand__mark">T</span>
            <span>Todo<span className="brand__accent">Aquí</span></span>
          </a>

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
            <a className="header-action d-none d-sm-grid" href="#cuenta" aria-label="Mi cuenta"><Icon name="user" /></a>
            <a className="header-action d-none d-sm-grid" href="#favoritos" aria-label="Favoritos">
              <Icon name="heart" />
              {favoriteCount > 0 && <span className="action-badge">{favoriteCount}</span>}
            </a>
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
                  <a href="#categorias" key={label}><span><Icon name={icon} size={17} />{label}</span><Icon name="chevronRight" size={14} /></a>
                ))}
              </div>
            </div>

            <ul className="main-menu">
              <li><a className="active" href="#inicio">Inicio</a></li>
              <li className="dropdown-shop">
                <button className="menu-dropdown-button dropdown-shop__toggle" type="button">Tienda <Icon name="chevronDown" size={14} /></button>
                <div className="dropdown-shop__menu">
                  <a href="#productos">Todos los productos</a>
                  <a href="#productos">Nuevos ingresos</a>
                  <a href="#productos">Más vendidos</a>
                  <a href="#ofertas">Ofertas especiales</a>
                </div>
              </li>
              <li className="dropdown-shop mega-parent">
                <button className="menu-dropdown-button dropdown-shop__toggle" type="button">Categorías <Icon name="chevronDown" size={14} /></button>
                <div className="dropdown-shop__menu mega-menu">
                  <div><strong>Tecnología</strong><a href="#productos">Celulares</a><a href="#productos">Laptops</a><a href="#productos">Tablets</a></div>
                  <div><strong>Entretenimiento</strong><a href="#productos">Audio</a><a href="#productos">Gaming</a><a href="#productos">TV y video</a></div>
                  <div><strong>Para tu hogar</strong><a href="#productos">Hogar inteligente</a><a href="#productos">Accesorios</a><a href="#productos">Oficina</a></div>
                </div>
              </li>
              <li><a href="#ofertas">Ofertas</a></li>
              <li><a href="#novedades">Novedades</a></li>
              <li><a href="#contacto">Contacto</a></li>
            </ul>

            <a className="nav-hot-deal" href="#ofertas">🔥 Oferta del día</a>
          </div>
        </nav>
      </header>
    </>
  )
}
