import { useNavigate } from 'react-router-dom'
import Icon from './Icon.jsx'
import StoreImage from './StoreImage.jsx'
import { money } from '../services/userFormat.js'

export default function CartDrawer({ open, setOpen, cart, updateQuantity, removeFromCart, loading }) {
  const navigate = useNavigate()
  const total = cart.reduce((sum, item) => sum + Math.round(item.price * 100) * item.quantity, 0) / 100
  return <>
    <div className={`drawer-overlay ${open ? 'is-open' : ''}`} onClick={() => setOpen(false)}></div>
    <aside className={`cart-drawer ${open ? 'is-open' : ''}`} aria-hidden={!open} inert={!open}>
      <div className="cart-drawer__head"><div><span>Tu compra</span><h2>Carrito ({cart.reduce((sum, item) => sum + item.quantity, 0)})</h2></div><button type="button" onClick={() => setOpen(false)} aria-label="Cerrar carrito"><Icon name="close" /></button></div>
      <div className="cart-drawer__body">{loading ? <p role="status">Actualizando productos…</p> : cart.length ? cart.map((item) => <article className="cart-item" key={item.id}>
        <StoreImage src={item.image} alt={item.name} /><div className="cart-item__info"><strong>{item.name}</strong><span>{money(item.price)}</span><div className="quantity-control"><button type="button" disabled={item.quantity <= 1} onClick={() => updateQuantity(item.id, -1)} aria-label={`Reducir ${item.name}`}><Icon name="minus" size={13} /></button><b>{item.quantity}</b><button type="button" disabled={item.quantity >= item.stock} onClick={() => updateQuantity(item.id, 1)} aria-label={`Aumentar ${item.name}`}><Icon name="plus" size={13} /></button></div>{item.quantity > item.stock && <small className="text-danger">Revisa la disponibilidad</small>}</div>
        <button type="button" className="cart-remove" onClick={() => removeFromCart(item.id)} aria-label={`Eliminar ${item.name}`}><Icon name="trash" size={17} /></button>
      </article>) : <div className="empty-cart"><span><Icon name="cart" size={32} /></span><h3>Tu carrito está vacío</h3><p>Agrega algunos productos para comenzar.</p><button type="button" className="shop-btn shop-btn--accent" onClick={() => setOpen(false)}>Seguir comprando</button></div>}</div>
      {cart.length > 0 && <div className="cart-drawer__footer"><div><span>Subtotal</span><strong>{loading ? '…' : money(total)}</strong></div><button type="button" className="checkout-btn" disabled={loading} onClick={() => { setOpen(false); navigate('/checkout') }}>Finalizar compra</button><small>Revisa tus productos, direcciones y forma de pago.</small></div>}
    </aside>
  </>
}
