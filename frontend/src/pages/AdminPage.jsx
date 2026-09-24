import { Link, Navigate, useParams, useLocation } from 'react-router-dom'
import { useAuth } from '../context/useAuth.js'
import { adminResources } from '../data/adminResources.js'
import Icon from '../components/Icon.jsx'
import AdminCrud from '../components/AdminCrud.jsx'

const operaciones = [
  { ruta: 'mostrar', nombre: 'Mostrar todos los registros', descripcion: 'Consultar el listado completo de la tabla.', icono: 'menu' },
  { ruta: 'buscar', nombre: 'Buscar un registro', descripcion: 'Localizar un registro por su identificador.', icono: 'search' },
  { ruta: 'agregar', nombre: 'Agregar', descripcion: 'Registrar un nuevo elemento.', icono: 'plus' },
  { ruta: 'editar', nombre: 'Editar', descripcion: 'Modificar los datos de un registro.', icono: 'refresh' },
  { ruta: 'eliminar', nombre: 'Eliminar', descripcion: 'Seleccionar un registro para eliminarlo.', icono: 'trash' },
]

export default function AdminPage() {
  const { recurso, operacion } = useParams()
  const location = useLocation()
  const { usuario, cargandoSesion, error, actualizarSesion } = useAuth()
  const errorConsulta = error?.tipo === 'conexion' || error?.tipo === 'respuesta' || error?.status >= 500
  const area = adminResources.find((item) => item.ruta === recurso)

  const accion = operaciones.find((item) => item.ruta === operacion)

  if (cargandoSesion) {
    return <section className="shop-section shop-container"><p role="status">Comprobando sesión...</p></section>
  }

  async function reintentar() {
    try {
      await actualizarSesion()
    } catch {
      // AuthContext conserva el error y permite volver a intentarlo.
    }
  }

  if (errorConsulta) {
    return (
      <section className="shop-section shop-container">
        <div className="alert alert-warning" role="alert">
          <h1 className="h4">No se pudo comprobar la sesión</h1>
          <p>Vuelve a intentarlo para acceder a la administración.</p>
          <button type="button" className="btn btn-outline-dark" onClick={reintentar}>Reintentar</button>
        </div>
        <Link to="/cuenta">Volver a Mi cuenta</Link>
      </section>
    )
  }

  if (!usuario) return <Navigate to="/cuenta" replace />

  if (usuario.TipoUsuario !== 'Administrador') {
    return (
      <section className="shop-section shop-container">
        <h1 className="h3">Acceso restringido</h1>
        <p>Esta sección está disponible únicamente para administradores.</p>
        <Link to="/cuenta" className="btn btn-outline-dark">Volver a Mi cuenta</Link>
      </section>
    )
  }

  const destinoValido = area && (!operacion || accion)

  return (
    <section className="shop-section shop-container" aria-labelledby="admin-area-titulo">
      <Link to="/cuenta" className="d-inline-flex align-items-center gap-2 mb-4">
        <Icon name="arrowLeft" size={18} /> Volver al panel de administración
      </Link>
      <div className="card border-0 shadow-sm">
        <div className="card-body p-4 p-md-5">
          <h1 id="admin-area-titulo" className="h3">
            {destinoValido ? (accion ? `${accion.nombre} · ${area.nombre}` : area.nombre) : 'Sección no encontrada'}
          </h1>
          {!destinoValido ? (
            <p className="mb-0">Selecciona una de las secciones disponibles en el panel.</p>
          ) : operacion ? (
            <>
              <p className="text-secondary">{accion.descripcion}</p>
              <AdminCrud key={`${recurso}-${operacion}-${location.search}`} resource={recurso} operation={operacion} />
            </>
          ) : (
            <>
              <p className="text-secondary">{area.descripcion}</p>
              <p className="mb-4">Selecciona la operación que deseas realizar.</p>
              <nav aria-label={`Operaciones de ${area.nombre}`}>
                <div className="row g-3">
                  {operaciones.map((item) => (
                    <div className="col-12 col-md-6 col-xl-4" key={item.ruta}>
                      <Link to={`/cuenta/admin/${area.ruta}/${item.ruta}`} className="admin-card">
                        <span className="admin-card__icon"><Icon name={item.icono} size={24} /></span>
                        <span className="flex-grow-1">
                          <span className="d-block fw-semibold mb-1">{item.nombre}</span>
                          <span className="d-block small text-secondary">{item.descripcion}</span>
                        </span>
                        <Icon name="chevronRight" size={18} />
                      </Link>
                    </div>
                  ))}
                </div>
              </nav>
            </>
          )}
        </div>
      </div>
    </section>
  )
}
