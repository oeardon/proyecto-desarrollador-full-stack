import { useEffect, useRef, useState } from 'react'
import { Link, useNavigate, useSearchParams } from 'react-router-dom'
import { useAuth } from '../context/useAuth.js'
import { requestUser } from '../services/userService.js'
import { crearOrden, consultarPedido, guardarIntento, leerIntento, quitarIntento } from '../services/orderService.js'
import { money } from '../services/userFormat.js'
import CountrySelect from '../components/CountrySelect.jsx'
import StoreImage from '../components/StoreImage.jsx'
import LoginForm from '../components/LoginForm.jsx'
import { UserFacts, UserTable } from '../components/UserShared.jsx'

function Receipt({ token }) {
  const [data, setData] = useState(null)
  const [error, setError] = useState('')
  const [attempt, setAttempt] = useState(0)
  useEffect(() => {
    const controller = new AbortController()
    consultarPedido(token, controller.signal).then((result) => { if (!controller.signal.aborted) setData(result.data) }).catch((failure) => { if (!controller.signal.aborted) setError(failure.message) })
    return () => controller.abort()
  }, [token, attempt])
  if (error) return <div className="alert alert-warning" role="alert"><p>{error}</p><button className="btn btn-outline-dark" onClick={() => { setError(''); setAttempt((value) => value + 1) }}>Reintentar consulta</button> <Link to="/cuenta/usuario/ordenes">Consultar mis órdenes</Link></div>
  if (!data) return <p role="status">Consultando tu pedido…</p>
  return <div className="card border-0 shadow-sm"><div className="card-body p-4">
    <div className="alert alert-success" role="status"><h2 className="h4">Pedido #{data.OrdenID} registrado</h2><p className="mb-0">Gracias por tu compra. Tu pago está {data.EstadoPago.toLowerCase()}.</p></div>
    <p>{data.CorreoEstado === 'enviado' ? `Enviamos la confirmación a ${data.Correo}.` : 'Tu pedido está guardado. El correo de confirmación no se ha enviado; puedes consultar aquí todos los datos.'}</p>
    <UserFacts record={data} fields={[
      ['FechaOrden', 'Fecha'], ['MetodoPago', 'Forma de pago'], ['DireccionEnvio', 'Dirección de envío'], ['DireccionPago', 'Dirección de facturación'], ['Total', 'Total', money],
    ]} />
    <p><strong>Factura:</strong> {data.Factura.NumeroFactura}<br /><strong>Nombre:</strong> {data.Factura.Nombre} · <strong>NIT:</strong> {data.Factura.NIT}</p>
    <UserTable rows={data.Detalles} rowKey="DetalleOrdenID" columns={[
      ['Producto', 'Producto'], ['Cantidad', 'Cantidad'], ['PrecioUnitario', 'Precio unitario', money], ['Subtotal', 'Subtotal', money],
    ]} />
    <div className="d-flex flex-wrap gap-2"><Link className="btn btn-primary" to={`/cuenta/usuario/ordenes/${data.OrdenID}`}>Ver mi orden</Link><Link className="btn btn-outline-dark" to="/#productos">Seguir comprando</Link></div>
  </div></div>
}

const addressText = (address) => [address.Direccion, address.Ciudad, address.Subnacional, address.Pais, address.CodigoPostal].filter(Boolean).join(', ')
function AddressField({ label, name, addresses, selected, text, onSelect, onText, country, onCountry }) {
  return <div className="mb-3"><label htmlFor={`${name}-select`} className="form-label">{label}</label>
    <select id={`${name}-select`} className="form-select mb-2" value={selected} onChange={(event) => onSelect(event.target.value)}>
      <option value="">Escribir otra dirección</option>{addresses.map((address) => <option key={address.DireccionID} value={address.DireccionID}>{address.TipoDireccion}: {address.Direccion}</option>)}
    </select>
    <textarea id={name} aria-label={`${label} completa`} className="form-control" required maxLength={selected ? 255 : 255 - country.length - 2} rows={2} value={text} readOnly={Boolean(selected)} onChange={(event) => onText(event.target.value)} />
    {!selected && <><label htmlFor={`${name}-country`} className="form-label mt-2">País de {name === 'shipping' ? 'envío' : 'facturación'}</label><CountrySelect id={`${name}-country`} value={country} required onChange={(event) => onCountry(event.target.value)} /></>}
  </div>
}

function CheckoutForm({ profile, addresses, userId, cart, updateQuantity, removeFromCart, completeCart, catalog }) {
  const primary = addresses.find((address) => Number(address.EsPrincipal) === 1) || addresses[0]
  const [shippingId, setShippingId] = useState(primary ? String(primary.DireccionID) : '')
  const [shipping, setShipping] = useState(primary ? addressText(primary) : '')
  const [billingId, setBillingId] = useState('')
  const [billing, setBilling] = useState('')
  const [shippingCountry, setShippingCountry] = useState('Guatemala')
  const [billingCountry, setBillingCountry] = useState('Guatemala')
  const shippingFull = shippingId ? shipping.trim() : `${shipping.trim()}, ${shippingCountry}`
  const billingFull = billingId ? billing.trim() : `${billing.trim()}, ${billingCountry}`
  const [sameAddress, setSameAddress] = useState(true)
  const [name, setName] = useState(`${profile.Nombres} ${profile.Apellidos}`)
  const [nit, setNit] = useState('CF')
  const [method, setMethod] = useState('Efectivo')
  const [busy, setBusy] = useState(false)
  const [error, setError] = useState('')
  const [pending, setPending] = useState(() => leerIntento(userId))
  const inFlight = useRef(false)
  const navigate = useNavigate()
  const total = cart.reduce((sum, item) => sum + Math.round(item.price * 100) * item.quantity, 0) / 100
  const invalid = !cart.length || cart.some((item) => item.unavailable || item.quantity > item.stock)
  function finish(data, token) {
    if (!data?.OrdenID || !Array.isArray(data.Detalles)) throw new Error('No se pudo leer la confirmación. Reintenta para recuperar tu pedido.')
    completeCart(data.Detalles)
    quitarIntento(userId)
    setPending(null)
    navigate(`/checkout?pedido=${token}`, { replace: true })
    catalog.reload()
  }
  async function send(payload) {
    if (inFlight.current) return
    inFlight.current = true
    setBusy(true); setError('')
    try {
      guardarIntento(userId, payload)
      setPending(payload)
      const result = await crearOrden(payload)
      finish(result.data, payload.SolicitudID)
    } catch (failure) {
      setError(failure.message)
      if ([400, 401, 403, 409, 415].includes(failure.status)) { quitarIntento(userId); setPending(null) }
    } finally { inFlight.current = false; setBusy(false) }
  }
  async function submit(event) {
    event.preventDefault()
    if (pending || invalid || catalog.loading || catalog.error) return
    await send({ SolicitudID: crypto.randomUUID().replaceAll('-', ''), NombreFactura: name.trim(), NIT: nit.trim(), MetodoPago: method,
      DireccionEnvio: shippingFull, DireccionPago: sameAddress ? shippingFull : billingFull, DireccionEnvioID: shippingId || null, DireccionPagoID: (sameAddress ? shippingId : billingId) || null,
      Detalles: cart.map((item) => ({ ProductoID: item.id, Cantidad: item.quantity, PrecioEsperado: item.price.toFixed(2) })) })
  }
  if (pending) return <div className="card"><div className="card-body"><h2 className="h4">{busy ? 'Registrando tu pedido…' : 'Verifica el resultado de tu compra'}</h2><p>Conservamos este intento para poder recuperarlo sin crear otra orden.</p>{error && <div className="alert alert-warning" role="alert">{error}</div>}<button className="btn btn-primary" disabled={busy} onClick={() => send(pending)}>{busy ? 'Procesando…' : 'Recuperar o completar este pedido'}</button> <Link to="/cuenta/usuario/ordenes">Mis órdenes</Link></div></div>
  if (!cart.length) return <p>Tu carrito está vacío. <Link to="/#productos">Explorar productos</Link></p>
  return <form onSubmit={submit} className="checkout-layout">
    <fieldset disabled={busy} className="checkout-details">
      <section className="card mb-4"><div className="card-body"><h2 className="h4">1. Revisa tus productos</h2>
        {catalog.loading ? <p role="status">Actualizando precios y existencias…</p> : cart.map((item) => <article className="checkout-item" key={item.id}>
          <StoreImage src={item.image} alt={item.name} /><div className="flex-grow-1"><h3 className="h6">{item.name}</h3><p className="mb-1">{money(item.price)} por unidad</p><p className="small text-secondary mb-1">{item.stock} disponibles</p>{item.quantity > item.stock && <p className="text-danger">Reduce la cantidad o elimina este producto.</p>}
            <div className="d-flex flex-wrap gap-2 align-items-center"><button className="btn btn-sm btn-outline-dark" type="button" disabled={item.quantity <= 1} aria-label={`Reducir ${item.name}`} onClick={() => updateQuantity(item.id, -1)}>−</button><span aria-label={`Cantidad de ${item.name}`}>{item.quantity}</span><button className="btn btn-sm btn-outline-dark" type="button" disabled={item.quantity >= item.stock} aria-label={`Aumentar ${item.name}`} onClick={() => updateQuantity(item.id, 1)}>+</button><button className="btn btn-sm btn-outline-danger" type="button" onClick={() => removeFromCart(item.id)}>Eliminar</button></div>
          </div><strong>{money(item.price * item.quantity)}</strong>
        </article>)}
        <button type="button" className="btn btn-outline-secondary mt-3" disabled={catalog.loading} onClick={catalog.reload}>Actualizar precios y existencias</button>
        {catalog.error && <p role="alert" className="text-danger">{catalog.error}</p>}
      </div></section>
      <section className="card mb-4"><div className="card-body"><h2 className="h4">2. Envío y facturación</h2>
        <p className="text-secondary">Confirmación por correo: {profile.Correo}</p>
        <AddressField label="Dirección de envío" name="shipping" addresses={addresses} selected={shippingId} text={shipping} onSelect={(id) => { setShippingId(id); setShipping(id ? addressText(addresses.find((address) => String(address.DireccionID) === id)) : '') }} onText={setShipping} country={shippingCountry} onCountry={setShippingCountry} />
        <div className="form-check mb-3"><input className="form-check-input" type="checkbox" id="same-address" checked={sameAddress} onChange={(event) => setSameAddress(event.target.checked)} /><label className="form-check-label" htmlFor="same-address">Usar la misma dirección para facturación</label></div>
        {!sameAddress && <AddressField label="Dirección de facturación" name="billing" addresses={addresses} selected={billingId} text={billing} onSelect={(id) => { setBillingId(id); setBilling(id ? addressText(addresses.find((address) => String(address.DireccionID) === id)) : '') }} onText={setBilling} country={billingCountry} onCountry={setBillingCountry} />}
        <div className="row g-3"><div className="col-12 col-md-8"><label className="form-label" htmlFor="billing-name">Nombre para la factura</label><input className="form-control" id="billing-name" required maxLength={150} value={name} onChange={(event) => setName(event.target.value)} /></div><div className="col-12 col-md-4"><label className="form-label" htmlFor="billing-nit">NIT o CF</label><input className="form-control" id="billing-nit" required maxLength={20} value={nit} onChange={(event) => setNit(event.target.value)} /></div></div>
      </div></section>
      <section className="card"><div className="card-body"><h2 className="h4">3. Forma de pago</h2><label className="form-label" htmlFor="payment-method">Método de pago</label><select className="form-select" id="payment-method" value={method} onChange={(event) => setMethod(event.target.value)}><option value="Efectivo">Efectivo al recibir</option><option value="Transferencia">Transferencia bancaria</option></select><p className="small text-secondary mt-2">{method === 'Efectivo' ? 'El pago queda pendiente hasta recibir el pedido.' : 'El pago quedará pendiente de verificación. Comunícate con la tienda para coordinar la transferencia.'}</p></div></section>
    </fieldset>
    <aside className="checkout-summary card"><div className="card-body"><h2 className="h4">Resumen de compra</h2><dl><div><dt>Productos</dt><dd>{cart.reduce((sum, item) => sum + item.quantity, 0)}</dd></div><div><dt>Subtotal</dt><dd>{catalog.loading ? '…' : money(total)}</dd></div><div><dt>Envío</dt><dd>{money(0)}</dd></div><div><dt>Impuestos adicionales</dt><dd>{money(0)}</dd></div><div className="border-top pt-3"><dt>Total</dt><dd className="fw-bold">{catalog.loading ? '…' : money(total)}</dd></div></dl><p className="small text-secondary">Los precios incluyen las promociones aplicables. Revisa todos los datos antes de realizar el pedido.</p>
      {error && <div role="alert" className="alert alert-danger">{error}</div>}
      <button className="btn btn-primary w-100" type="submit" disabled={busy || invalid || catalog.loading || Boolean(catalog.error)}>Realizar pedido</button><Link className="d-block mt-3 text-center" to="/#productos">Seguir comprando</Link>
    </div></aside>
  </form>
}
function CheckoutData(props) {
  const [data, setData] = useState(null)
  const [error, setError] = useState('')
  const [attempt, setAttempt] = useState(0)
  useEffect(() => {
    const controller = new AbortController()
    Promise.all([requestUser('perfil', { signal: controller.signal }), requestUser('direcciones', { signal: controller.signal })]).then(([profile, addresses]) => {
      if (!controller.signal.aborted) setData({ profile: profile.data, addresses: addresses.data })
    }).catch((failure) => { if (!controller.signal.aborted) setError(failure.message) })
    return () => controller.abort()
  }, [attempt])
  if (error) return <div role="alert" className="alert alert-warning"><p>{error}</p><button className="btn btn-outline-dark" onClick={() => { setError(''); setAttempt((value) => value + 1) }}>Reintentar</button></div>
  if (!data) return <p role="status">Cargando tus datos…</p>
  return <CheckoutForm {...props} {...data} />
}
export default function Checkout(props) {
  const { usuario, cargandoSesion, error, actualizarSesion } = useAuth()
  const [params] = useSearchParams()
  const navigate = useNavigate()
  const token = params.get('pedido')
  const sessionError = error && (error.tipo === 'conexion' || error.tipo === 'respuesta' || error.status >= 500)
  return <section className="shop-section"><div className="shop-container"><h1 className="mb-4">{token ? 'Confirmación del pedido' : 'Finalizar compra'}</h1>
    {cargandoSesion ? <p role="status">Comprobando sesión…</p> : sessionError ? <div role="alert" className="alert alert-warning"><p>No se pudo verificar la sesión.</p><button className="btn btn-outline-dark" onClick={() => actualizarSesion().catch(() => {})}>Reintentar sesión</button></div> : !usuario ? <><p>Inicia sesión para continuar con tu compra. Conservaremos tu carrito.</p><LoginForm onMostrarRegistro={() => navigate('/cuenta?volver=checkout')} /></> : token ? <Receipt key={`${usuario.UsuarioID}-${token}`} token={token} /> : <CheckoutData key={usuario.UsuarioID} userId={usuario.UsuarioID} {...props} />}
  </div></section>
}
