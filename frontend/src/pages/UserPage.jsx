import { useEffect, useState } from 'react'
import { Link, useLocation, useParams, useSearchParams } from 'react-router-dom'
import { useAuth } from '../context/useAuth.js'
import { userSections } from '../data/userSections.js'
import { requestUser } from '../services/userService.js'
import UserProfile from '../components/UserProfile.jsx'
import UserAddresses from '../components/UserAddresses.jsx'
import UserOrders from '../components/UserOrders.jsx'
import UserReturns from '../components/UserReturns.jsx'
import UserWishlist from '../components/UserWishlist.jsx'
import UserReviews from '../components/UserReviews.jsx'

function UserContent({ section, id, orderId }) {
  const [data, setData] = useState(null)
  const [error, setError] = useState('')
  const [attempt, setAttempt] = useState(0)
  function reload() { setData(null); setError(''); setAttempt((value) => value + 1) }
  useEffect(() => {
    const controller = new AbortController()
    async function load() {
      if (section === 'direcciones' && id === 'agregar') return {}
      const newReturn = section === 'devoluciones' && id === 'nueva'
      const result = await requestUser(newReturn ? 'ordenes' : section, { id: newReturn ? orderId || undefined : id, signal: controller.signal })
      const list = (!id && section !== 'perfil') || (newReturn && !orderId)
      if (list !== Array.isArray(result.data)) throw new Error('El servidor devolvió datos con un formato inesperado.')
      return result.data
    }
    load().then((result) => { if (!controller.signal.aborted) setData(result) }).catch((failure) => { if (!controller.signal.aborted) setError(failure.message) })
    return () => controller.abort()
  }, [section, id, orderId, attempt])
  if (error) return <div role="alert" className="alert alert-danger"><p>{error}</p><button className="btn btn-outline-dark" onClick={reload}>Reintentar</button></div>
  if (data === null) return <p role="status">Cargando tus datos…</p>
  if (section === 'perfil') return <UserProfile data={data} />
  if (section === 'direcciones') return <UserAddresses data={data} id={id} reload={reload} />
  if (section === 'ordenes') return <UserOrders data={data} id={id} />
  if (section === 'devoluciones') return <UserReturns data={data} id={id} orderId={orderId} />
  if (section === 'lista-deseos') return <UserWishlist data={data} reload={reload} />
  return <UserReviews data={data} reload={reload} />
}

export default function UserPage() {
  const { seccion, id } = useParams()
  const [params] = useSearchParams()
  const location = useLocation()
  const { usuario, cargandoSesion, error, actualizarSesion } = useAuth()
  const section = userSections.find((item) => item.path === seccion)
  const orderId = params.get('orden')
  const validId = !id || (['direcciones', 'ordenes', 'devoluciones'].includes(seccion) && /^[1-9]\d*$/.test(id)) || (seccion === 'direcciones' && id === 'agregar') || (seccion === 'devoluciones' && id === 'nueva')
  const sessionError = error && (error.tipo === 'conexion' || error.tipo === 'respuesta' || error.status >= 500)
  return <section className="shop-section"><div className="shop-container user-page">
    <Link to="/cuenta">Volver a mi cuenta</Link>
    <h1 className="mt-3 mb-4">{section?.title || 'Sección no encontrada'}</h1>
    {cargandoSesion ? <p role="status">Comprobando sesión…</p> : sessionError ? <div role="alert" className="alert alert-warning"><p>No se pudo comprobar la sesión.</p><button className="btn btn-outline-dark" onClick={() => actualizarSesion().catch(() => {})}>Reintentar</button></div>
      : !usuario ? <p>Inicia sesión para consultar tus datos. <Link to="/cuenta">Ir a mi cuenta</Link></p>
        : !section || !validId || (orderId !== null && !/^[1-9]\d*$/.test(orderId)) ? <p>La página solicitada no existe.</p> : <>
          <nav aria-label="Secciones de mi cuenta" className="d-flex flex-wrap gap-2 mb-4">{userSections.map((item) => <Link key={item.path} className={`btn btn-sm ${item.path === seccion ? 'btn-dark' : 'btn-outline-dark'}`} aria-current={item.path === seccion ? 'page' : undefined} to={`/cuenta/usuario/${item.path}`}>{item.title}</Link>)}</nav>
          {location.state?.mensaje && <div role="status" className="alert alert-success">{location.state.mensaje}</div>}
          <div className="card border-0 shadow-sm"><div className="card-body p-3 p-md-4">
            <UserContent key={`${usuario.UsuarioID}-${location.pathname}-${location.search}`} section={seccion} id={id} orderId={orderId} />
          </div></div>
        </>}
  </div></section>
}
