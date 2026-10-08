const API_AUTH = '/proyecto-desarrollador-full-stack/api/auth'
// Todas las respuestas conservan la estructura JSON enviada por PHP.
async function solicitarAuth(archivo, metodo, datos) {
     const opciones = {
          method: metodo,
          credentials: 'include',
          cache: 'no-store',
          headers: { Accept: 'application/json' },
     }
     if (datos !== undefined) {
          opciones.headers['Content-Type'] = 'application/json'
          opciones.body = JSON.stringify(datos)
     }
     let respuesta
     try {
          respuesta = await fetch(`${API_AUTH}/${archivo}`, opciones)
     } catch {
          const error = new Error('No se pudo conectar con el servidor. Intente nuevamente.')
          error.tipo = 'conexion'
          error.status = 0
          throw error
     }
     let resultado
     try {
          resultado = await respuesta.json()
     } catch {
          const error = new Error('El servidor no devolvió una respuesta JSON válida.')
          error.tipo = 'respuesta'
          error.status = respuesta.status
          throw error
     }
     if (!resultado || typeof resultado !== 'object' || Array.isArray(resultado) ||
         typeof resultado.success !== 'boolean') {
          const error = new Error('La respuesta del servidor tiene un formato inesperado.')
          error.tipo = 'respuesta'
          error.status = respuesta.status
          throw error
     }
     if (!respuesta.ok || !resultado.success) {
          const error = new Error(typeof resultado.message === 'string' &&
                                  resultado.message.trim() ? resultado.message :
                                  'No se pudo completar la operación.')
          error.tipo = 'api'
          error.status = respuesta.status
          throw error
     }
     return resultado
}
// Devuelve autenticado y usuario. Un error de red no se convierte en "sin sesión".
export async function consultarSesion() {
     const resultado = await solicitarAuth('sesion.php', 'GET')
     if (typeof resultado.autenticado !== 'boolean' ||
         (resultado.autenticado && (!resultado.usuario ||
         typeof resultado.usuario !== 'object' ||
         Array.isArray(resultado.usuario))) ||
         (!resultado.autenticado && resultado.usuario !== null)) {
               const error = new Error('La respuesta de sesión tiene un formato inesperado.')
               error.tipo = 'respuesta'
               error.status = 200
               throw error
     }
     return resultado
}
// datos: { Correo, Contrasena } o { Usuario, Contrasena }, nunca ambos.
export function iniciarSesion(datos) {
     return solicitarAuth('login.php', 'POST', datos)
}
// datos: { Nombres, Apellidos, Correo, Telefono, Usuario, Contrasena }.
// Registrarse no inicia sesión automáticamente.
export function registrarUsuario(datos) {
     return solicitarAuth('registro.php', 'POST', datos)
}
export function cerrarSesion() {
     return solicitarAuth('logout.php', 'POST')
}