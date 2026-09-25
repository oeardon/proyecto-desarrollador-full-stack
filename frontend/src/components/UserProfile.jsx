import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { useAuth } from '../context/useAuth.js'
import { requestUser } from '../services/userService.js'
import { UserFacts, UserForm } from './UserShared.jsx'

const fields = [
  { name: 'Nombres', label: 'Nombres', required: true, maxLength: 75, autoComplete: 'given-name' },
  { name: 'Apellidos', label: 'Apellidos', required: true, maxLength: 75, autoComplete: 'family-name' },
  { name: 'Correo', label: 'Correo electrónico', type: 'email', required: true, maxLength: 100, autoComplete: 'email' },
  { name: 'Telefono', label: 'Teléfono', type: 'tel', required: true, maxLength: 20, autoComplete: 'tel' },
  { name: 'Usuario', label: 'Nombre de usuario', required: true, maxLength: 50, autoComplete: 'username' },
  { name: 'Contrasena', label: 'Nueva contraseña', type: 'password', minLength: 8, maxLength: 72, autoComplete: 'new-password', help: 'Déjala vacía para conservar tu contraseña actual.' },
  { name: 'Confirmacion', label: 'Confirmar nueva contraseña', type: 'password', maxLength: 72, autoComplete: 'new-password' },
]
export default function UserProfile({ data }) {
  const [editing, setEditing] = useState(false)
  const { actualizarSesion } = useAuth()
  const navigate = useNavigate()
  async function save(values) {
    if ((values.Contrasena || '') !== (values.Confirmacion || '')) throw new Error('Las contraseñas no coinciden.')
    if (values.Contrasena && (new TextEncoder().encode(values.Contrasena).length > 72 || values.Contrasena.includes('\0'))) throw new Error('La contraseña debe tener entre 8 y 72 bytes y no contener caracteres nulos.')
    const payload = Object.fromEntries(fields.slice(0, 5).map(({ name }) => [name, values[name].trim()]))
    if (values.Contrasena) payload.Contrasena = values.Contrasena
    await requestUser('perfil', { method: 'PUT', data: payload })
    navigate('/cuenta/usuario/perfil', { replace: true, state: { mensaje: 'Tus datos se guardaron correctamente.' } })
    try { await actualizarSesion() } catch { /* El estado de sesión ofrece reintento. */ }
  }
  if (editing) return <UserForm fields={fields} initial={data} onSave={save} onCancel={() => setEditing(false)} />
  return <><UserFacts record={data} fields={fields.slice(0, 5).map(({ name, label }) => [name, label])} />
    <p className="text-secondary">Por seguridad, tu contraseña no se muestra.</p>
    <button className="btn btn-primary" onClick={() => setEditing(true)}>Editar mis datos</button></>
}
