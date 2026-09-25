import { Link, useNavigate } from 'react-router-dom'
import { useRef, useState } from 'react'
import { requestUser } from '../services/userService.js'
import { UserFacts, UserForm } from './UserShared.jsx'

const fields = [
  { name: 'Direccion', label: 'Dirección', required: true, maxLength: 255, wide: true },
  { name: 'Ciudad', label: 'Ciudad', required: true, maxLength: 75 },
  { name: 'Subnacional', label: 'Departamento / Estado', required: true, maxLength: 100 },
  { name: 'Pais', label: 'País', required: true, maxLength: 50 },
  { name: 'CodigoPostal', label: 'Código postal', maxLength: 15 },
  { name: 'TipoDireccion', label: 'Tipo de dirección', options: ['Casa', 'Trabajo', 'Otro'] },
  { name: 'EsPrincipal', label: 'Usar como dirección principal', type: 'checkbox' },
]
export default function UserAddresses({ data, id, reload }) {
  const navigate = useNavigate()
  const [busy, setBusy] = useState(false)
  const [error, setError] = useState('')
  const pending = useRef(false)
  async function remove(row) {
    if (pending.current || !window.confirm(`¿Eliminar la dirección ${row.Direccion}?`)) return
    pending.current = true
    setBusy(true)
    setError('')
    try { await requestUser('direcciones', { method: 'DELETE', id: row.DireccionID }); reload() }
    catch (failure) { setError(failure.message) }
    finally { pending.current = false; setBusy(false) }
  }
  if (id) return <UserForm fields={fields} initial={id === 'agregar' ? { Pais: 'Guatemala', TipoDireccion: 'Casa', EsPrincipal: false } : { ...data, EsPrincipal: Number(data.EsPrincipal) === 1 }}
    onCancel={() => navigate('/cuenta/usuario/direcciones')} submitLabel={id === 'agregar' ? 'Agregar dirección' : 'Guardar cambios'}
    onSave={async (values) => {
      const payload = Object.fromEntries(fields.map(({ name }) => [name, name === 'EsPrincipal' ? Boolean(values[name]) : (values[name] ?? '').trim()]))
      await requestUser('direcciones', { method: id === 'agregar' ? 'POST' : 'PUT', id: id === 'agregar' ? undefined : id, data: payload })
      navigate('/cuenta/usuario/direcciones', { state: { mensaje: 'Dirección guardada correctamente.' } })
    }} />
  return <>
    <Link className="btn btn-primary mb-4" to="/cuenta/usuario/direcciones/agregar">Agregar dirección</Link>
    {error && <div role="alert" className="alert alert-danger">{error}</div>}
    {!data.length && <p role="status">Todavía no tienes direcciones guardadas.</p>}
    <div className="row g-3">{data.map((row) => <div className="col-12 col-lg-6" key={row.DireccionID}><article className="card h-100"><div className="card-body">
      <h2 className="h5">{row.TipoDireccion} {Number(row.EsPrincipal) === 1 && <span className="badge text-bg-light">Principal</span>}</h2>
      <UserFacts record={row} fields={fields.slice(0, 5).map(({ name, label }) => [name, label])} />
      <div className="d-flex gap-2"><Link className={`btn btn-outline-primary${busy ? ' disabled' : ''}`} to={`/cuenta/usuario/direcciones/${row.DireccionID}`}>Editar</Link>
        <button className="btn btn-outline-danger" disabled={busy} onClick={() => remove(row)}>Eliminar</button></div>
    </div></article></div>)}</div>
  </>
}
