import { useCallback, useEffect, useState } from 'react'
import { catalogProduct, storeRequest } from '../services/storeService.js'

export function useCatalog() {
  const [data, setData] = useState(null)
  const [error, setError] = useState('')
  const [revision, setRevision] = useState(0)
  const reload = useCallback(() => { setData(null); setError(''); setRevision((value) => value + 1) }, [])
  useEffect(() => {
    const controller = new AbortController()
    storeRequest('catalogo/index.php', { signal: controller.signal }).then((result) => {
      if (!Array.isArray(result.data?.Productos) || !Array.isArray(result.data?.Categorias)) throw new Error('El catálogo recibido no es válido.')
      if (!controller.signal.aborted) setData({ products: result.data.Productos.map(catalogProduct), categories: result.data.Categorias })
    }).catch((failure) => { if (!controller.signal.aborted) setError(failure.message) })
    return () => controller.abort()
  }, [revision])
  return { products: data?.products || [], categories: data?.categories || [], loading: !data && !error, error, reload }
}
