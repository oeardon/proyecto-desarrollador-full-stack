import { money } from '../services/userFormat.js'
import { useRef, useState } from 'react'
import { requestUser } from '../services/userService.js'
import { ProductImage } from './UserShared.jsx'

export default function UserWishlist({ data, reload }) {
  const [busy, setBusy] = useState(false)
  const [error, setError] = useState('')
  const pending = useRef(false)
  async function remove(product) {
    if (pending.current || !window.confirm(`¿Quitar ${product.Nombre} de tu lista de deseos?`)) return
    pending.current = true
    setBusy(true)
    setError('')
    try { await requestUser('lista-deseos', { method: 'DELETE', id: product.ProductoID }); reload() }
    catch (failure) { setError(failure.message) }
    finally { pending.current = false; setBusy(false) }
  }
  return <>
    {error && <div className="alert alert-danger" role="alert">{error}</div>}
    {!data.length && <p role="status">Tu lista de deseos está vacía.</p>}
    <div className="row g-3">{data.map((product) => <div className="col-12 col-md-6 col-xl-4" key={product.ProductoID}><article className="card h-100"><div className="card-body">
      <ProductImage src={product.Imagen} name={product.Nombre} />
      <h2 className="h5 mt-3">{product.Nombre}</h2>
      <p className="fw-semibold">{money(product.Precio)}</p><p className="small text-secondary">{product.Estado === 'Activo' ? 'Producto activo' : 'Producto no disponible'}</p>
      <button className="btn btn-outline-danger" disabled={busy} onClick={() => remove(product)}>Quitar de mi lista</button>
    </div></article></div>)}</div>
  </>
}
