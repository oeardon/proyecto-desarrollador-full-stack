import { Link } from 'react-router-dom'
import { adminGroups } from '../data/adminResources.js'
import Icon from './Icon.jsx'

export default function AdminPanel() {
  return (
    <section className="mt-5" aria-labelledby="admin-titulo">
      <h2 id="admin-titulo" className="h3">Panel de administración</h2>
      <p className="text-secondary mb-4">Selecciona el área que deseas administrar.</p>
      <nav aria-label="Administración de la tienda">
        {adminGroups.map((grupo) => (
          <section key={grupo.nombre} className="mb-4">
            <h3 className="h5 mb-3">{grupo.nombre}</h3>
            <div className="row g-3">
              {grupo.recursos.map((recurso) => (
                <div className="col-12 col-md-6 col-xl-4" key={recurso.ruta}>
                  <Link to={`/cuenta/admin/${recurso.ruta}`} className="admin-card">
                    <span className="admin-card__icon"><Icon name={recurso.icono} size={24} /></span>
                    <span className="flex-grow-1">
                      <span className="d-block fw-semibold mb-1">{recurso.nombre}</span>
                      <span className="d-block small text-secondary">{recurso.descripcion}</span>
                    </span>
                    <Icon name="chevronRight" size={18} />
                  </Link>
                </div>
              ))}
            </div>
          </section>
        ))}
      </nav>
    </section>
  )
}
