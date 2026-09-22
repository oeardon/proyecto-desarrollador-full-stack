import Icon from './Icon.jsx'

import { products } from '../data/products.js'

const filters = [
  ['todos','Todos'],['celulares','Celulares'],['computacion','Computación'],['audio','Audio'],['gaming','Gaming'],['hogar','Hogar']
]

const money = (value) => `Q ${value.toLocaleString('es-GT')}`

export default function ProductSection({ activeCategory, setActiveCategory, search, favorites, toggleFavorite, addToCart, openQuickView }) {
  const query = search.trim().toLowerCase()
  const filtered = products.filter((product) => {
    const categoryMatch = activeCategory === 'todos' || product.category === activeCategory
    const searchMatch = !query || `${product.name} ${product.label}`.toLowerCase().includes(query)
    return categoryMatch && searchMatch
  })

  return (
    <section className="shop-section shop-section--soft" id="productos">
      <div className="shop-container">
        <div className="section-heading section-heading--products reveal-item">
          <div><span>Selección destacada</span><h2>Productos populares</h2><p>Una selección de tecnología, accesorios y productos para el hogar.</p></div>
          <div className="product-filters" aria-label="Filtrar productos">
            {filters.map(([id,label]) => <button key={id} className={activeCategory === id ? 'active' : ''} onClick={() => setActiveCategory(id)}>{label}</button>)}
          </div>
        </div>

        {filtered.length ? (
          <div className="product-grid-shop">
            {filtered.map((product) => (
              <article className="product-card-shop reveal-item" key={product.id}>
                <div className="product-card-shop__media">
                  <span className="product-badge-shop">{product.badge}</span>
                  <button
                    className={`product-heart ${favorites.includes(product.id) ? 'active' : ''}`}
                    type="button"
                    onClick={() => toggleFavorite(product.id)}
                    aria-label="Agregar a favoritos"
                  ><Icon name="heart" size={18} /></button>
                  <img src={product.image} alt={product.name} />
                  <div className="product-hover-actions">
                    <button type="button" onClick={() => openQuickView(product)}><Icon name="eye" size={17} /> Vista rápida</button>
                    <button type="button" onClick={() => addToCart(product)}><Icon name="cart" size={17} /> Agregar</button>
                  </div>
                </div>
                <div className="product-card-shop__body">
                  <span className="product-category-label">{product.label}</span>
                  <button className="product-name" type="button" onClick={() => openQuickView(product)}>{product.name}</button>
                  <div className="product-rating" aria-label={`${product.rating} de 5 estrellas`}>
                    {[1,2,3,4,5].map((star) => <Icon key={star} name="star" size={13} className={star <= product.rating ? 'filled' : ''} />)}
                    <small>({18 + product.id * 3})</small>
                  </div>
                  <div className="product-price-row">
                    <div><strong>{money(product.price)}</strong><del>{money(product.oldPrice)}</del></div>
                    <button className="round-add" type="button" onClick={() => addToCart(product)} aria-label="Agregar al carrito"><Icon name="plus" size={18} /></button>
                  </div>
                </div>
              </article>
            ))}
          </div>
        ) : (
          <div className="empty-products"><Icon name="search" size={30} /><h3>No encontramos productos</h3><p>Prueba con otra búsqueda o selecciona una categoría diferente.</p></div>
        )}
      </div>
    </section>
  )
}
