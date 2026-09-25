import { Link } from 'react-router-dom'
import Icon from './Icon.jsx'
import { userSections } from '../data/userSections.js'

export default function UserPanel() {
  return <section className="mt-5" aria-labelledby="usuario-titulo">
    <h2 id="usuario-titulo" className="h3">Panel de usuario</h2>
    <p className="text-secondary">Administra tu información y consulta tus compras.</p>
    <nav aria-label="Panel de usuario" className="row g-3">
      {userSections.map((section) => <div className="col-12 col-md-6 col-xl-4" key={section.path}>
        <Link className="admin-card h-100" to={`/cuenta/usuario/${section.path}`}>
          <span className="admin-card__icon"><Icon name={section.icon} size={24} /></span>
          <span className="flex-grow-1"><span className="d-block fw-semibold mb-1">{section.title}</span><span className="d-block small text-secondary">{section.description}</span></span>
          <Icon name="chevronRight" size={18} />
        </Link>
      </div>)}
    </nav>
  </section>
}
