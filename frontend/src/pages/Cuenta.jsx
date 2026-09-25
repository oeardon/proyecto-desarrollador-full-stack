import { useState } from 'react'
import { Link, useSearchParams } from 'react-router-dom'
import LoginForm from '../components/LoginForm.jsx'
import RegistroForm from '../components/RegistroForm.jsx'
import AdminPanel from '../components/AdminPanel.jsx'
import UserPanel from '../components/UserPanel.jsx'
import { useAuth } from '../context/useAuth.js'

export default function Cuenta() {
  const [params] = useSearchParams()
  const {usuario,cargandoSesion,procesando,error,actualizarSesion,cerrarSesion} = useAuth()
  const [formulario, setFormulario] = useState('login')
  const [errorCuenta, setErrorCuenta] = useState('')
  const errorConsulta = error?.tipo === 'conexion' ||
                        error?.tipo === 'respuesta' ||
                        error?.status >= 500
  const esAdministrador = usuario?.TipoUsuario === 'Administrador' && !errorConsulta
  async function reintentarSesion() {
    setErrorCuenta('')
    try {
      await actualizarSesion()
    } catch {
      // AuthContext conserva el error de la consulta.
    }
  }
  async function manejarCerrarSesion() {
    setErrorCuenta('')
    try {
      await cerrarSesion()
      setFormulario('login')
    } catch (fallo) {
      setErrorCuenta(
        fallo.message || 'No se pudo cerrar la sesión.'
      )
    }
  }
  function mostrarLogin() {
    setErrorCuenta('')
    setFormulario('login')
  }
  function mostrarRegistro() {
    setErrorCuenta('')
    setFormulario('registro')
  }

  return (
    <section className="shop-section" aria-labelledby="cuenta-titulo">
      <div className="shop-container">
        <div className="row justify-content-center">
          <div className={usuario ? 'col-12' : 'col-12 col-md-10 col-lg-7'}>
            <h1 id="cuenta-titulo" className="mb-4">Mi cuenta</h1>
            {params.get('volver') === 'checkout' && <p><Link to="/checkout">Volver a finalizar mi compra</Link></p>}
            {cargandoSesion ? (
              <p role="status">Comprobando sesión...</p>
            ) : (
              <>
                {errorConsulta && (
                  <div className="alert alert-warning" role="alert">
                    <p>
                      No se pudo confirmar el estado de la sesión.
                      Comprueba tu conexión e intenta nuevamente.
                    </p>
                    <button type="button"
                            className="btn btn-outline-dark"
                            disabled={procesando}
                            onClick={reintentarSesion}>
                      Reintentar
                    </button>
                  </div>
                )}
                {errorCuenta && (
                  <div className="alert alert-danger" role="alert">
                    {errorCuenta}
                  </div>
                )}
                {usuario ? (
                  <>
                  <div className="card border-0 shadow-sm">
                    <div className="card-body p-4">
                      <h2 className="h4">Hola, {usuario.Usuario}</h2>
                      <p>Tipo de cuenta: {usuario.TipoUsuario}</p>
                      <button type="button"
                              className="btn btn-outline-danger" 
                              disabled={procesando} 
                              onClick={manejarCerrarSesion}>
                        {procesando ? 'Procesando...' : 'Cerrar sesión'}
                      </button>
                    </div>
                  </div>
                  {!errorConsulta && <UserPanel />}
                  {esAdministrador && <AdminPanel />}
                  </>
                ) : formulario === 'registro' ? (
                  <RegistroForm onMostrarLogin={mostrarLogin} />
                ) : (
                  <LoginForm onMostrarRegistro={mostrarRegistro} />
                )}
              </>
            )}
          </div>
        </div>
      </div>
    </section>
  )
}