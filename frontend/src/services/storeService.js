export async function storeRequest(path, { method = 'GET', data, signal } = {}) {
  let response
  try {
    response = await fetch(`/proyecto-desarrollador-full-stack/api/${path}`, { method, signal, credentials: 'include', cache: 'no-store', headers: { Accept: 'application/json', ...(data === undefined ? {} : { 'Content-Type': 'application/json' }) }, ...(data === undefined ? {} : { body: JSON.stringify(data) }) })
  } catch (cause) { throw new Error('No se pudo conectar. Puedes reintentar sin duplicar tu pedido.', { cause }) }
  let result
  try { result = await response.json() } catch (cause) { throw new Error('El servidor no devolvió una respuesta válida.', { cause }) }
  if (!response.ok || result?.success !== true) {
    const error = new Error(result?.message || 'No se pudo completar la operación.')
    error.status = response.status
    throw error
  }
  return result
}
export function catalogProduct(row) {
  const rawImage = row.Imagen || ''
  const image = /^(https?:\/\/|\/)/i.test(rawImage) ? rawImage : rawImage ? `/proyecto-desarrollador-full-stack/${rawImage.replace(/^\.\//, '')}` : ''
  return { id: Number(row.ProductoID), category: String(row.CategoriaID), name: row.Nombre, description: row.Descripcion, label: row.Categoria, price: Number(row.PrecioVenta), oldPrice: Number(row.Precio), image,
    reviewsAvailable: row.ResenasDisponibles !== false, stock: Number(row.Cantidad), rating: Number(row.Calificacion), reviews: Number(row.Resenas), sold: Number(row.Vendidos), date: row.FechaRegistro, promotion: row.Promocion }
}
export function belongsToCategory(product, id, categories) {
  if (id === 'todos') return true
  let category = categories.find((item) => String(item.CategoriaID) === product.category)
  const seen = new Set()
  while (category && !seen.has(category.CategoriaID)) {
    if (String(category.CategoriaID) === String(id)) return true
    seen.add(category.CategoriaID)
    category = categories.find((item) => Number(item.CategoriaID) === Number(category.CategoriaPadreID))
  }
  return false
}
