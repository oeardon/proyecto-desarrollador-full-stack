import { useState } from 'react'
import Icon from './Icon.jsx'  
  
const money = (value) => `Q ${value.toLocaleString('es-GT')}`  
  
export default function CartDrawer({ open, setOpen, cart, updateQuantity, removeFromCart, userName = 'Cliente' }) {  
  const [mensajeCompra, setMensajeCompra] = useState('')
  const total = cart.reduce((sum, item) => sum + item.price * item.quantity, 0)  

  const finalizarCompra = () => {
    setMensajeCompra(`${userName} ¡Gracias! por tu compra`)
  }

  return (  
    <>  
      <div className={`drawer-overlay ${open ? 'is-open' : ''}`} onClick={() => setOpen(false)}></div>  
      <aside className={`cart-drawer ${open ? 'is-open' : ''}`} aria-hidden={!open}>  
        <div className="cart-drawer__head"><div><span>Tu compra</span><h2>Carrito ({cart.reduce((sum,item)=>sum+item.quantity,0)})</h2></div><button type="button" onClick={() => setOpen(false)} aria-label="Cerrar"><Icon name="close" /></button></div>  
        <div className="cart-drawer__body">  
          {cart.length ? cart.map((item) => (  
            <article className="cart-item" key={item.id}>  
              <img src={item.image} alt={item.name}/>  
              <div className="cart-item__info"><strong>{item.name}</strong><span>{money(item.price)}</span><div className="quantity-control"><button type="button" onClick={() => updateQuantity(item.id,-1)}><Icon name="minus" size={13}/></button><b>{item.quantity}</b><button type="button" onClick={() => updateQuantity(item.id,1)}><Icon name="plus" size={13}/></button></div></div>  
              <button type="button" className="cart-remove" onClick={() => removeFromCart(item.id)} aria-label="Eliminar"><Icon name="trash" size={17}/></button>  
            </article>  
          )) : <div className="empty-cart"><span><Icon name="cart" size={32}/></span><h3>Tu carrito está vacío</h3><p>Agrega algunos productos para comenzar</p><button type="button" className="shop-btn shop-btn--accent" onClick={() => setOpen(false)}>Seguir comprando</button></div>}  
        </div>  
        {cart.length > 0 && <div className="cart-drawer__footer"><div><span>Subtotal</span><strong>{money(total)}</strong></div><button type="button" className="checkout-btn" onClick={finalizarCompra}>Finalizar compra</button>{mensajeCompra && <div className="alert alert-success mt-3 mb-2 text-center" role="alert">{mensajeCompra}</div>}<small>Impuestos y envío se calculan al finalizar</small></div>}  
      </aside>  
    </>  
  )  
}  