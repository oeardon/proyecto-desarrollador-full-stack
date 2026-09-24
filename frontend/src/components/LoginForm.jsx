import { useId, useRef, useState } from 'react'
import { useAuth } from '../context/useAuth.js'

export default function LoginForm({ onSuccess, onMostrarRegistro }) {
     const { iniciarSesion, procesando, cargandoSesion } = useAuth()
     const [correo, setCorreo] = useState('')
     const [contrasena, setContrasena] = useState('')
     const [error, setError] = useState('')
     const [mensaje, setMensaje] = useState('')
     const [enviando, setEnviando] = useState(false)
     const envioPendiente = useRef(false)
     const id = useId()
     const bloqueado = procesando || cargandoSesion || enviando
     async function manejarEnvio(event) {
          event.preventDefault()
          if (bloqueado || envioPendiente.current) return
          setError('')
          setMensaje('')
          if (!event.currentTarget.reportValidity()) return
          if (!correo.trim() || !contrasena) {
               setError('Ingresa tu correo y contraseña.')
               return
          }
          if (new TextEncoder().encode(contrasena).length > 72 || contrasena.includes('\0')) {
               setError('La contraseña es demasiado larga o contiene un carácter no permitido.')
               return
          }
          envioPendiente.current = true
          setEnviando(true)
          let resultado
          try {
               resultado = await iniciarSesion({ Correo: correo.trim(), Contrasena: contrasena })
               setContrasena('')
               setMensaje('Inicio de sesión correcto.')
          } catch (fallo) {
               // Error propio del formulario: no arrastra errores de registro o consulta de sesión.
               setError(fallo.message || 'No se pudo iniciar sesión. Intenta nuevamente.')
               return
          } finally {
               envioPendiente.current = false
               setEnviando(false)
          }
          onSuccess?.(resultado)
     }

     return (
          <section className="card border-0 shadow-sm" aria-labelledby={`${id}-titulo`}>
               <div className="card-body p-4">
               <h2 id={`${id}-titulo`} className="h4 mb-2">Iniciar sesión</h2>
               <p className="text-secondary">Ingresa a tu cuenta de TodoAquí.</p>
               {error && <div id={`${id}-error`} className="alert alert-danger" role="alert">{error}</div>}
               {mensaje && <div className="alert alert-success" role="status">{mensaje}</div>}
               {cargandoSesion && <p className="text-secondary" role="status">Comprobando sesión...</p>}
               <form onSubmit={manejarEnvio} aria-busy={bloqueado} aria-describedby={error ? `${id}-error` : undefined}>
                    <fieldset disabled={bloqueado}>
                    <legend className="visually-hidden">Datos de acceso</legend>
                    <div className="mb-3">
                    <label className="form-label" htmlFor={`${id}-correo`}>Correo electrónico</label>
                    <input id={`${id}-correo`} name="Correo" className="form-control"
                         type="email" autoComplete="username" required maxLength={100}
                         value={correo} onChange={(event) => { setCorreo(event.target.value); setError(''); setMensaje('') }} />
                    </div>
                    <div className="mb-3">
                    <label className="form-label" htmlFor={`${id}-contrasena`}>Contraseña</label>
                    <input id={`${id}-contrasena`} name="Contrasena" className="form-control"
                         type="password" autoComplete="current-password" required maxLength={72}
                         value={contrasena} onChange={(event) => { setContrasena(event.target.value); setError(''); setMensaje('') }} />
                    </div>
                    <button className="btn btn-primary w-100" type="submit">
                    {enviando ? 'Iniciando sesión...' : 'Iniciar sesión'}
                    </button>
                    </fieldset>
               </form>
               {onMostrarRegistro && (
                    <p className="mt-3 mb-0 text-center">
                    ¿No tienes cuenta?{' '}
                    <button type="button" className="btn btn-link p-0" disabled={bloqueado} onClick={onMostrarRegistro}>
                    Crear cuenta
                    </button>
                    </p>
               )}
               </div>
          </section>
          )
}