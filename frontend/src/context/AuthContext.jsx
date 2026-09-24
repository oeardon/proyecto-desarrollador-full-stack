import { useCallback, useEffect, useRef, useState } from 'react'
import { AuthContext } from './useAuth.js'
import { consultarSesion,
         iniciarSesion as iniciarSesionApi,
         registrarUsuario as registrarUsuarioApi,
         cerrarSesion as cerrarSesionApi } from '../services/authService.js'

export function AuthProvider({ children }) {
     const [usuario, setUsuario] = useState(null)
     const [cargandoSesion, setCargandoSesion] = useState(true)
     const [procesando, setProcesando] = useState(false)
     const [error, setError] = useState(null)
     // Identifica la solicitud más reciente y evita actualizaciones al desmontar.
     const solicitudActual = useRef(0)
     const montado = useRef(false)
     const operacionPendiente = useRef(false)
     useEffect(() => {
          montado.current = true
          const solicitud = ++solicitudActual.current
          consultarSesion().then((resultado) => {
               if (montado.current && solicitud === solicitudActual.current) {
                    setUsuario(resultado.usuario)
                    setError(null)
               }
          }).catch((fallo) => {
               if (montado.current && solicitud === solicitudActual.current) setError(fallo)
               }
          ).finally(() => {
               if (montado.current && solicitud === solicitudActual.current) setCargandoSesion(false)
               }
          )
          return () => {
               montado.current = false
          }
     }, [])
     const actualizarSesion = useCallback(async () => {
     // Una consulta no debe interferir con una escritura de la sesión.
          if (operacionPendiente.current) {
               throw new Error('Espere a que termine la operación de autenticación.')
          }
          const solicitud = ++solicitudActual.current
          setCargandoSesion(true)
          setError(null)
          try {
               const resultado = await consultarSesion()
               if (montado.current && solicitud === solicitudActual.current) setUsuario(resultado.usuario)
               return resultado
          } catch (fallo) {
               if (montado.current && solicitud === solicitudActual.current) setError(fallo)
               throw fallo
          } finally {
               if (montado.current && solicitud === solicitudActual.current) setCargandoSesion(false)
          }
     }, [])
     // Solo una operación de autenticación a la vez para evitar cookies contradictorias.
     const ejecutarOperacion = useCallback(async (operacion, datos) => {
          if (operacionPendiente.current) {
               throw new Error('Espere a que termine la operación de autenticación.')
          }
          operacionPendiente.current = true
          const solicitud = ++solicitudActual.current
          setProcesando(true)
          setError(null)
          try {
               let resultado
               if (operacion === 'login') {
                    resultado = await iniciarSesionApi(datos)
               } else if (operacion === 'registro') {
                    resultado = await registrarUsuarioApi(datos)
               } else {
                    resultado = await cerrarSesionApi()
               }
               if (montado.current && solicitud === solicitudActual.current) {
                    if (operacion === 'login') setUsuario(resultado.usuario)
                    if (operacion === 'logout') setUsuario(null)
               }
               // Registro no inicia sesión. Recupera cualquier sesión previa del navegador.
               if (operacion === 'registro') {
                    try {
                         const sesion = await consultarSesion()
                         if (montado.current && solicitud === solicitudActual.current) setUsuario(sesion.usuario)
                    } catch (fallo) {
                         // El registro ya se completó: no debe mostrarse como un registro fallido.
                         if (montado.current && solicitud === solicitudActual.current) setError(fallo)
                    }
               }
               return resultado
          } catch (fallo) {
               if (montado.current && solicitud === solicitudActual.current) {
                    setError(fallo)
                    // PHP vacía la sesión si rechaza las credenciales con 401.
                    if (fallo.status === 401) setUsuario(null)
               }
               throw fallo
          } finally {
               operacionPendiente.current = false
               if (montado.current && solicitud === solicitudActual.current) {
                    setProcesando(false)
                    setCargandoSesion(false)
               }
          }
     }, [])
     const iniciarSesion = useCallback((datos) => ejecutarOperacion('login', datos), [ejecutarOperacion])
     const registrarUsuario = useCallback((datos) => ejecutarOperacion('registro', datos), [ejecutarOperacion])
     const cerrarSesion = useCallback(() => ejecutarOperacion('logout'), [ejecutarOperacion])
     return (
          <AuthContext.Provider value={{usuario,
                                        autenticado: usuario !== null,
                                        cargandoSesion,
                                        procesando,
                                        error,
                                        actualizarSesion,
                                        iniciarSesion,
                                        registrarUsuario,
                                        cerrarSesion,}}>
               {children}
          </AuthContext.Provider>
     )
}