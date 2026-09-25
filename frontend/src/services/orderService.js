import { storeRequest } from './storeService.js'
export function crearOrden(data) {
  return storeRequest('checkout/index.php', { method: 'POST', data })
}
export function consultarPedido(token, signal) {
  return storeRequest(`checkout/index.php?solicitud=${encodeURIComponent(token)}`, { signal })
}
export function leerIntento(userId) {
  try { return JSON.parse(sessionStorage.getItem(`todoaqui.checkout.${userId}`) || 'null') } catch { return null }
}
export function guardarIntento(userId, data) {
  // Si no se puede conservar el identificador, no se envía una compra que no podamos recuperar.
  sessionStorage.setItem(`todoaqui.checkout.${userId}`, JSON.stringify(data))
}
export function quitarIntento(userId) {
  try { sessionStorage.removeItem(`todoaqui.checkout.${userId}`) } catch { /* El servidor conserva la protección contra duplicados. */ }
}
