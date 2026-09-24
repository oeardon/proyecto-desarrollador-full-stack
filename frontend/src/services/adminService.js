import { adminSchemas } from '../data/adminSchemas.js'

export function recordQuery(resource, record) {
  return new URLSearchParams(Object.fromEntries(adminSchemas[resource].keys.map((key) => [key, record[key]]))).toString()
}
export async function requestAdmin(resource, { method = 'GET', record, data, signal } = {}) {
  const schema = adminSchemas[resource]
  const params = new URLSearchParams(schema.auxiliary ? { recurso: resource } : {})
  if (record) schema.keys.forEach((key) => params.set(schema.auxiliary ? key : 'id', record[key]))
  const options = { method, credentials: 'include', cache: 'no-store', signal, headers: { Accept: 'application/json' } }
  if (data !== undefined) {
    options.headers['Content-Type'] = 'application/json'
    options.body = JSON.stringify(data)
  }
  let response
  try {
    response = await fetch(`/tienda_online/api/${schema.auxiliary ? 'admin' : resource}/index.php?${params}`, options)
  } catch (error) {
    if (error.name === 'AbortError') throw error
    throw new Error('No se pudo conectar con el servidor. Vuelve a intentarlo.', { cause: error })
  }
  let result
  try { result = await response.json() } catch { throw new Error('El servidor no devolvió una respuesta válida.') }
  if (!response.ok || result?.success !== true) throw new Error(result?.message || 'No se pudo completar la operación.')
  if (method === 'GET' && (!result.data || typeof result.data !== 'object')) throw new Error('Los datos recibidos no tienen el formato esperado.')
  return result
}
