import { useCallback, useEffect, useState } from 'react'
const key = 'todoaqui.cart.v1'
function initialCart() {
  try {
    const saved = JSON.parse(localStorage.getItem(key) || '[]')
    if (!Array.isArray(saved)) return []
    const seen = new Set()
    return saved.filter((item) => {
      if (!Number.isSafeInteger(item.id) || item.id < 1 || !Number.isSafeInteger(item.quantity) || item.quantity < 1 || item.quantity > 100000 || seen.has(item.id)) return false
      seen.add(item.id)
      return true
    }).slice(0, 100).map(({ id, quantity }) => ({ id, quantity }))
  } catch { return [] }
}
export function useCart(products) {
  const [items, setItems] = useState(initialCart)
  useEffect(() => { try { localStorage.setItem(key, JSON.stringify(items)) } catch { /* El carrito continúa funcionando en memoria. */ } }, [items])
  const cart = items.map((item) => ({ ...(products.find((product) => product.id === item.id) || { id: item.id, name: `Producto #${item.id} no disponible`, price: 0, stock: 0, image: '', unavailable: true }), quantity: item.quantity }))
  const add = (product) => setItems((current) => {
    if (product.stock < 1) return current
    const existing = current.find((item) => item.id === product.id)
    if (existing) return current.map((item) => item.id === product.id ? { ...item, quantity: Math.min(product.stock, item.quantity + 1) } : item)
    return current.length >= 100 ? current : [...current, { id: product.id, quantity: 1 }]
  })
  const updateQuantity = (id, delta) => setItems((current) => current.map((item) => item.id === id ? { ...item, quantity: Math.max(1, Math.min(products.find((product) => product.id === id)?.stock || 1, item.quantity + delta)) } : item))
  const remove = (id) => setItems((current) => current.filter((item) => item.id !== id))
  const complete = useCallback((details) => setItems((current) => current.map((item) => ({ ...item, quantity: item.quantity - Number(details.find((line) => Number(line.ProductoID) === item.id)?.Cantidad || 0) })).filter((item) => item.quantity > 0)), [])
  return { cart, add, updateQuantity, remove, complete }
}
