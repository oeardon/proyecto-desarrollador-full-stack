import { useEffect, useRef, useState } from 'react'
import { storeRequest } from '../services/storeService.js'
export function useWishlist(userId, revision, onError, onLogin) {
  const [state, setState] = useState({ userId: null, ids: [] })
  const [busy, setBusy] = useState(false)
  const pending = useRef(false)
  const currentUser = useRef(userId)
  useEffect(() => {
    currentUser.current = userId
    if (!userId) return
    const controller = new AbortController()
    storeRequest('wishlist/index.php', { signal: controller.signal }).then((result) => {
      if (!Array.isArray(result.data)) throw new Error('La lista de deseos recibida no es válida.')
      if (!controller.signal.aborted) setState({ userId, ids: result.data.map((item) => Number(item.ProductoID)) })
    }).catch((failure) => { if (!controller.signal.aborted) onError(failure.message) })
    return () => controller.abort()
  }, [userId, revision, onError])
  const favorites = state.userId === userId ? state.ids : []
  async function toggle(id) {
    if (!userId) { onLogin(); return }
    if (pending.current) return
    pending.current = true
    setBusy(true)
    const exists = favorites.includes(id)
    try {
      await storeRequest(`wishlist/index.php${exists ? `?id=${id}` : ''}`, { method: exists ? 'DELETE' : 'POST', data: exists ? undefined : { ProductoID: id } })
      if (currentUser.current === userId) setState({ userId, ids: exists ? favorites.filter((value) => value !== id) : [...favorites, id] })
    } catch (failure) { onError(failure.message) }
    finally { pending.current = false; setBusy(false) }
  }
  return { favorites, toggle, busy }
}
