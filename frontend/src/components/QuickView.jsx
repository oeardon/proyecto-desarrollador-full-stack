import Icon from './Icon.jsx'
import StoreImage from './StoreImage.jsx'
import { money } from '../services/userFormat.js'
export default function QuickView({ product, onClose, addToCart }) {
  if (!product) return null
  return <div className="quick-modal" role="dialog" aria-modal="true" aria-labelledby="quick-title">
    <button className="quick-modal__overlay" aria-label="Cerrar vista rápida" onClick={onClose}></button>
    <div className="quick-modal__card"><button className="quick-modal__close" onClick={onClose} aria-label="Cerrar"><Icon name="close" /></button>
      <div className="quick-modal__image"><StoreImage src={product.image} alt={product.name} /></div>
      <div className="quick-modal__content"><span>{product.label}</span><h2 id="quick-title">{product.name}</h2><p>{product.reviews ? `${product.rating.toFixed(1)} / 5 · ${product.reviews} reseñas` : 'Sin reseñas todavía'}</p>
        <div className="quick-price"><strong>{money(product.price)}</strong>{product.oldPrice > product.price && <del>{money(product.oldPrice)}</del>}</div>
        <p>{product.description || 'Este producto no tiene descripción adicional.'}</p>{product.promotion && <p>Promoción: {product.promotion}</p>}<p>{product.stock} unidades disponibles</p>
        <button className="shop-btn shop-btn--accent" disabled={!product.stock} onClick={() => { addToCart(product); onClose() }}><Icon name="cart" size={17} /> {product.stock ? 'Agregar al carrito' : 'Agotado'}</button>
      </div>
    </div>
  </div>
}
