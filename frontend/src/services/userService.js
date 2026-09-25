export async function requestUser(resource, { method = 'GET', id, data, signal } = {}) {
  const params = new URLSearchParams({ recurso: resource })
  if (id !== undefined) params.set('id', id)
  const options = { method, signal, credentials: 'include', cache: 'no-store', headers: { Accept: 'application/json' } }
  if (data !== undefined) {
    options.headers['Content-Type'] = 'application/json'
    options.body = JSON.stringify(data)
  }
  let response
  try {
    response = await fetch(`/tienda_online/api/cuenta/index.php?${params}`, options)
  } catch (error) {
    if (error.name === 'AbortError') throw error
    throw new Error('No se pudo conectar con el servidor. Intenta nuevamente.', { cause: error })
  }
  let result
  try { result = await response.json() } catch { throw new Error('El servidor no devolvió una respuesta válida.') }
  if (!response.ok || result?.success !== true) throw new Error(result?.message || 'No se pudo completar la operación.')
  if (method === 'GET' && (!result.data || typeof result.data !== 'object')) throw new Error('Los datos recibidos no son válidos.')
  return result
}
