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
    if (resource === 'resenas') {
      const { Imagenes, ...fields } = data
      const images = Imagenes || []
      if (Imagenes !== undefined) fields.Imagenes = images.filter((image) => typeof image === 'string')
      const body = new FormData()
      body.append('datos', JSON.stringify(fields))
      images.filter((image) => image instanceof File).forEach((image) => body.append('Imagenes[]', image))
      options.body = body
      if (method === 'PUT') { options.method = 'POST'; params.set('_method', 'PUT') }
    } else if (resource === 'productos') {
      const { Imagen, ...fields } = data
      const body = new FormData()
      body.append('datos', JSON.stringify(fields))
      if (Imagen instanceof File) body.append('Imagen', Imagen)
      options.body = body
      // PHP procesa archivos multipart en POST; la API valida esta operación explícita.
      if (method === 'PUT') { options.method = 'POST'; params.set('_method', 'PUT') }
    } else {
      options.headers['Content-Type'] = 'application/json'
      options.body = JSON.stringify(data)
    }
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
