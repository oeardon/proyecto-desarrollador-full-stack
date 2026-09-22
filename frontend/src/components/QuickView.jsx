import Icon from './Icon.jsx'

const money = (value) => `Q ${value.toLocaleString('es-GT')}`

export default function QuickView({ product, onClose, addToCart }) {
  if (!product) return null
  return (
    <div className="quick-modal" role="dialog" aria-modal="true">
      <button className="quick-modal__overlay" aria-label="Cerrar" onClick={onClose}></button>
      <div className="quick-modal__card">
        <button className="quick-modal__close" onClick={onClose} aria-label="Cerrar"><Icon name="close" /></button>
        <div className="quick-modal__image"><img src={product.image} alt={product.name}/></div>
        <div className="quick-modal__content"><span>{product.label}</span><h2>{product.name}</h2><div className="product-rating">{[1,2,3,4,5].map((star)=><Icon key={star} name="star" size={15} className={star <= product.rating ? 'filled' : ''}/>)}</div><div className="quick-price"><strong>{money(product.price)}</strong><del>{money(product.oldPrice)}</del></div><p>Producto seleccionado por su diseño, practicidad y excelente relación entre funcionalidad y precio.</p><ul><li><Icon name="check" size={16}/> Garantía incluida</li><li><Icon name="check" size={16}/> Entrega disponible</li><li><Icon name="check" size={16}/> Compra protegida</li></ul><button className="shop-btn shop-btn--accent" onClick={() => { addToCart(product); onClose(); }}><Icon name="cart" size={17}/> Agregar al carrito</button></div>
      </div>
    </div>
  )
}
