import Icon from './Icon.jsx'
import StoreImage from './StoreImage.jsx'
import { money } from '../services/userFormat.js'
import { belongsToCategory } from '../services/storeService.js'

export default function ProductSection({ catalog, activeCategory, setActiveCategory, search, view = 'todos', favorites, toggleFavorite, favoriteBusy, addToCart, openQuickView }) {
  const query = search.trim().toLocaleLowerCase('es')
  const filtered = catalog.products.filter((product) => belongsToCategory(product, activeCategory, catalog.categories) && (!query || `${product.name} ${product.label} ${product.description || ''}`.toLocaleLowerCase('es').includes(query)) && (view !== 'ofertas' || product.price < product.oldPrice))
  if (view === 'novedades') filtered.sort((a, b) => String(b.date).localeCompare(String(a.date)) || b.id - a.id)
  if (view === 'vendidos') filtered.sort((a, b) => b.sold - a.sold)
  const roots = catalog.categories.filter((category) => category.CategoriaPadreID === null)
  return <section className="shop-section shop-section--soft" id="productos"><div className="shop-container">
    <div className="section-heading section-heading--products reveal-item"><div><span>Catálogo TodoAquí</span><h2>{view === 'ofertas' ? 'Ofertas vigentes' : view === 'novedades' ? 'Nuevos ingresos' : view === 'vendidos' ? 'Más vendidos' : 'Nuestros productos'}</h2><p>Precios, disponibilidad y opiniones de nuestra tienda.</p></div>
      <div className="product-filters" aria-label="Filtrar productos"><button className={activeCategory === 'todos' ? 'active' : ''} onClick={() => setActiveCategory('todos')}>Todos</button>{roots.map((category) => <button key={category.CategoriaID} className={String(category.CategoriaID) === activeCategory ? 'active' : ''} onClick={() => setActiveCategory(String(category.CategoriaID))}>{category.Nombre}</button>)}</div>
    </div>
    {catalog.loading ? <p role="status">Cargando catálogo…</p> : catalog.error ? <div className="alert alert-danger" role="alert"><p>{catalog.error}</p><button className="btn btn-outline-dark" onClick={catalog.reload}>Reintentar catálogo</button></div> : filtered.length ? <>
      <p className="small text-secondary">{filtered.length} productos encontrados</p>
      <div className="product-grid-shop">{filtered.map((product) => <article className="product-card-shop reveal-item" key={product.id}>
        <div className="product-card-shop__media">
          {product.promotion && <span className="product-badge-shop">Oferta</span>}
          <button className={`product-heart ${favorites.includes(product.id) ? 'active' : ''}`} type="button" disabled={favoriteBusy} onClick={() => toggleFavorite(product.id)} aria-label={favorites.includes(product.id) ? `Quitar ${product.name} de favoritos` : `Agregar ${product.name} a favoritos`}><Icon name="heart" size={18} /></button>
          <StoreImage src={product.image} alt={product.name} />
          <div className="product-hover-actions"><button type="button" onClick={() => openQuickView(product)}><Icon name="eye" size={17} /> Vista rápida</button><button type="button" disabled={!product.stock} onClick={() => addToCart(product)}><Icon name="cart" size={17} /> Agregar</button></div>
        </div>
        <div className="product-card-shop__body"><span className="product-category-label">{product.label}</span><button className="product-name" type="button" onClick={() => openQuickView(product)}>{product.name}</button>
          <div className="product-rating" aria-label={product.reviews ? `${product.rating.toFixed(1)} de 5 estrellas, ${product.reviews} reseñas` : 'Sin reseñas'}>{[1,2,3,4,5].map((star) => <Icon key={star} name="star" size={13} className={star <= Math.round(product.rating) ? 'filled' : ''} />)}<small>({product.reviews})</small></div>
          <p className="small text-secondary">{product.stock > 0 ? `${product.stock} disponibles` : 'Agotado'}</p>
          <div className="product-price-row"><div><strong>{money(product.price)}</strong>{product.oldPrice > product.price && <del>{money(product.oldPrice)}</del>}</div><button className="round-add" type="button" disabled={!product.stock} onClick={() => addToCart(product)} aria-label={`Agregar ${product.name} al carrito`}><Icon name="plus" size={18} /></button></div>
        </div>
      </article>)}</div>
    </> : <div className="empty-products"><Icon name="search" size={30} /><h3>No encontramos productos</h3><p>Prueba con otra búsqueda o categoría.</p></div>}
  </div></section>
}
