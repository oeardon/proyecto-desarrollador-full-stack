import { Link, NavLink } from 'react-router-dom'
import Icon from './Icon.jsx'

export default function Header({ cartCount, favoriteCount, menuOpen, setMenuOpen, search, setSearch, onSearch, categories, activeCategory }) {
  const roots = categories.filter((category) => category.CategoriaPadreID === null)
  const close = () => setMenuOpen(false)
  const categoryUrl = (id) => `/?categoria=${id}#productos`
  return <>
    <div className="topbar-shop"><div className="shop-container topbar-shop__inner"><p>Consulta precios y disponibilidad en nuestro catálogo</p><div className="topbar-shop__links"><Link onClick={close} to="/#ayuda">Ayuda</Link><Link onClick={close} to="/cuenta/usuario/ordenes">Seguimiento</Link><Link onClick={close} to="/cuenta">Mi cuenta</Link></div></div></div>
    <header className="site-header" data-site-header><div className="shop-container header-main">
      <Link onClick={close} className="brand" to="/#inicio" aria-label="TodoAquí inicio"><span className="brand__mark">T</span><span>Todo<span className="brand__accent">Aquí</span></span></Link>
      <form className="header-search" onSubmit={onSearch}>
        <select key={activeCategory} name="categoria" aria-label="Categoría de búsqueda" defaultValue={activeCategory}><option value="todos">Todas las categorías</option>{categories.map((category) => <option key={category.CategoriaID} value={category.CategoriaID}>{category.Nombre}</option>)}</select>
        <input value={search} onChange={(event) => setSearch(event.target.value)} type="search" placeholder="Buscar productos..." aria-label="Buscar productos" />
        <button type="submit" aria-label="Buscar"><Icon name="search" /></button>
      </form>
      <div className="header-actions"><Link onClick={close} className="header-action d-none d-sm-grid" to="/cuenta" aria-label="Mi cuenta"><Icon name="user" /></Link>
        <Link onClick={close} className="header-action d-none d-sm-grid" to="/cuenta/usuario/lista-deseos" aria-label="Favoritos"><Icon name="heart" />{favoriteCount > 0 && <span className="action-badge">{favoriteCount}</span>}</Link>
        <button className="header-action" type="button" data-open-cart aria-label="Abrir carrito"><Icon name="cart" />{cartCount > 0 && <span className="action-badge">{cartCount}</span>}</button>
        <button className={`hamburger ${menuOpen ? 'is-open' : ''}`} type="button" aria-label={menuOpen ? 'Cerrar menú' : 'Abrir menú'} aria-expanded={menuOpen} onClick={() => setMenuOpen(!menuOpen)}><span></span></button>
      </div>
    </div>
    <nav className={`shop-nav ${menuOpen ? 'is-open' : ''}`} aria-label="Navegación principal"><div className="shop-container shop-nav__inner">
      <div className="category-nav dropdown-shop"><button className="category-nav__button dropdown-shop__toggle" type="button"><Icon name="menu" size={18} /><span>Todas las categorías</span><Icon name="chevronDown" size={15} /></button>
        <div className="dropdown-shop__menu category-nav__menu">{roots.map((category) => <Link onClick={close} to={categoryUrl(category.CategoriaID)} key={category.CategoriaID}><span><Icon name="menu" size={17} />{category.Nombre}</span><Icon name="chevronRight" size={14} /></Link>)}</div>
      </div>
      <ul className="main-menu"><li><NavLink onClick={close} to="/" end>Inicio</NavLink></li>
        <li className="dropdown-shop"><button className="menu-dropdown-button dropdown-shop__toggle" type="button">Tienda <Icon name="chevronDown" size={14} /></button><div className="dropdown-shop__menu"><Link onClick={close} to="/#productos">Todos los productos</Link><Link onClick={close} to="/?vista=novedades#productos">Nuevos ingresos</Link><Link onClick={close} to="/?vista=vendidos#productos">Más vendidos</Link><Link onClick={close} to="/?vista=ofertas#productos">Ofertas especiales</Link></div></li>
        <li className="dropdown-shop mega-parent"><button className="menu-dropdown-button dropdown-shop__toggle" type="button">Categorías <Icon name="chevronDown" size={14} /></button><div className="dropdown-shop__menu mega-menu">{roots.map((category) => <div key={category.CategoriaID}><strong><Link onClick={close} to={categoryUrl(category.CategoriaID)}>{category.Nombre}</Link></strong>{categories.filter((child) => Number(child.CategoriaPadreID) === Number(category.CategoriaID)).map((child) => <Link onClick={close} to={categoryUrl(child.CategoriaID)} key={child.CategoriaID}>{child.Nombre}</Link>)}</div>)}</div></li>
        <li><Link onClick={close} to="/?vista=ofertas#productos">Ofertas</Link></li><li><Link onClick={close} to="/?vista=novedades#productos">Novedades</Link></li><li><Link onClick={close} to="/#contacto">Contacto</Link></li>
        <li className="d-sm-none"><Link onClick={close} to="/cuenta/usuario/lista-deseos">Mis favoritos</Link></li>
      </ul><Link onClick={close} className="nav-hot-deal" to="/?vista=ofertas#productos">Ofertas vigentes</Link>
    </div></nav></header>
  </>
}
