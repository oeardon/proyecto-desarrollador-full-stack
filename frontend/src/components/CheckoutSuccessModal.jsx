import Icon from './Icon.jsx'

export default function CheckoutSuccessModal({ open, message, orderId, onClose }) {
  if (!open) return null

  return (
    <div className="checkout-success" role="dialog" aria-modal="true" aria-labelledby="checkout-success-title">
      <button className="checkout-success__backdrop" type="button" onClick={onClose} aria-label="Cerrar confirmación" />
      <div className="checkout-success__card card border-0 shadow-lg">
        <div className="card-body p-4 p-md-5 text-center">
          <div className="checkout-success__icon mx-auto mb-3">
            <Icon name="check" size={30} />
          </div>
          <span className="text-uppercase fw-bold text-primary checkout-success__eyebrow">Compra confirmada</span>
          <h2 id="checkout-success-title" className="h3 fw-bold mt-2 mb-3">{message}</h2>
          {orderId && <p className="text-secondary mb-4">Pedido #{orderId} Registrado correctamente</p>}
          <button type="button" className="btn btn-primary px-4" onClick={onClose}>Seguir comprando</button>
        </div>
      </div>
    </div>
  )
}
