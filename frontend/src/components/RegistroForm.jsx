import { useId, useRef, useState } from 'react'
import { useAuth } from '../context/useAuth.js'

const camposIniciales = {Nombres: '', Apellidos: '', Correo: '', Telefono: '', Usuario: '', 
                         Contrasena: '', Confirmacion: ''}

export default function RegistroForm({ onSuccess, onMostrarLogin }) {
     const { registrarUsuario, procesando, cargandoSesion } = useAuth()
     const [campos, setCampos] = useState(camposIniciales)
     const [error, setError] = useState('')
     const [registrado, setRegistrado] = useState(false)
     const [enviando, setEnviando] = useState(false)
     const envioPendiente = useRef(false)
     const id = useId()
     const bloqueado = procesando || cargandoSesion || enviando
     function cambiarCampo(event) {
          const { name, value } = event.target
          setCampos((actuales) => ({ ...actuales, [name]: value }))
          setError('')
     }

     async function manejarEnvio(event) {
          event.preventDefault()
          if (bloqueado || envioPendiente.current || registrado) return
          setError('')
          if (!event.currentTarget.reportValidity()) return
          const datos = {
               Nombres: campos.Nombres.trim(),
               Apellidos: campos.Apellidos.trim(),
               Correo: campos.Correo.trim(),
               Telefono: campos.Telefono.trim(),
               Usuario: campos.Usuario.trim(),
               Contrasena: campos.Contrasena,
          }
          if (Object.values(datos).some((valor) => valor === '')) {
               setError('Completa todos los campos.')
               return
          }
          if (campos.Contrasena !== campos.Confirmacion) {
               setError('Las contraseñas no coinciden.')
               return
          }
          const longitud = new TextEncoder().encode(campos.Contrasena).length
          if (longitud < 8 || longitud > 72 || campos.Contrasena.includes('\0')) {
               setError('La contraseña es demasiado corta, demasiado larga o contiene un carácter no permitido.')
               return
          }
          envioPendiente.current = true
          setEnviando(true)
          let resultado
          try {
               // No se envían Confirmacion, TipoUsuario ni Estado.
               resultado = await registrarUsuario(datos)
               setCampos(camposIniciales)
               setRegistrado(true)
          } catch (fallo) {
               setError(fallo.message || 'No se pudo crear la cuenta. Intenta nuevamente.')
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
               <h2 id={`${id}-titulo`} className="h4 mb-2">Crear cuenta</h2>
               {registrado ? (
                    <div className="alert alert-success" role="status">Cuenta creada. Ya puedes iniciar sesión.</div>
               ) : (
                    <>
                    <p className="text-secondary">Completa tus datos para registrarte en TodoAquí.</p>
                    {error && <div id={`${id}-error`} className="alert alert-danger" role="alert">{error}</div>}
                    {cargandoSesion && <p className="text-secondary" role="status">Comprobando sesión...</p>}
                    <form onSubmit={manejarEnvio} aria-busy={bloqueado} aria-describedby={error ? `${id}-error` : undefined}>
                    <fieldset disabled={bloqueado}>
                         <legend className="visually-hidden">Datos de registro</legend>
                         <div className="row g-3">
                         <div className="col-md-6">
                              <label className="form-label" htmlFor={`${id}-nombres`}>Nombres</label>
                              <input id={`${id}-nombres`} name="Nombres" className="form-control" type="text"
                              autoComplete="given-name" required maxLength={75} value={campos.Nombres} onChange={cambiarCampo} />
                         </div>
                         <div className="col-md-6">
                              <label className="form-label" htmlFor={`${id}-apellidos`}>Apellidos</label>
                              <input id={`${id}-apellidos`} name="Apellidos" className="form-control" type="text"
                              autoComplete="family-name" required maxLength={75} value={campos.Apellidos} onChange={cambiarCampo} />
                         </div>
                         <div className="col-12">
                              <label className="form-label" htmlFor={`${id}-correo`}>Correo electrónico</label>
                              <input id={`${id}-correo`} name="Correo" className="form-control" type="email"
                              autoComplete="email" required maxLength={100} value={campos.Correo} onChange={cambiarCampo} />
                         </div>
                         <div className="col-md-6">
                              <label className="form-label" htmlFor={`${id}-telefono`}>Teléfono</label>
                              <input id={`${id}-telefono`} name="Telefono" className="form-control" type="tel"
                              autoComplete="tel" required maxLength={20} value={campos.Telefono} onChange={cambiarCampo} />
                         </div>
                         <div className="col-md-6">
                              <label className="form-label" htmlFor={`${id}-usuario`}>Nombre de usuario</label>
                              <input id={`${id}-usuario`} name="Usuario" className="form-control" type="text"
                              autoComplete="username" required maxLength={50} value={campos.Usuario} onChange={cambiarCampo} />
                         </div>
                         <div className="col-md-6">
                              <label className="form-label" htmlFor={`${id}-contrasena`}>Contraseña</label>
                              <input id={`${id}-contrasena`} name="Contrasena" className="form-control" type="password"
                              autoComplete="new-password" required maxLength={72} aria-describedby={`${id}-ayuda`}
                              value={campos.Contrasena} onChange={cambiarCampo} />
                         </div>
                         <div className="col-md-6">
                              <label className="form-label" htmlFor={`${id}-confirmacion`}>Confirmar contraseña</label>
                              <input id={`${id}-confirmacion`} name="Confirmacion" className="form-control" type="password"
                              autoComplete="new-password" required maxLength={72}
                              value={campos.Confirmacion} onChange={cambiarCampo} />
                         </div>
                         </div>
                         <p id={`${id}-ayuda`} className="form-text mt-2">Usa una contraseña de al menos 8 caracteres y repítela en ambos campos.</p>
                         <button className="btn btn-primary w-100 mt-2" type="submit">
                         {enviando ? 'Creando cuenta...' : 'Crear cuenta'}
                         </button>
                    </fieldset>
                    </form>
                    </>
               )}
               {onMostrarLogin && (
                    <p className="mt-3 mb-0 text-center">
                    {!registrado && '¿Ya tienes cuenta? '}
                    <button type="button" className="btn btn-link p-0" disabled={bloqueado} onClick={onMostrarLogin}>
                    Ir al inicio de sesión
                    </button>
                    </p>
               )}
               </div>
          </section>
     )
}
