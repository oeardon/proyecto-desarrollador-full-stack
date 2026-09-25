import { useEffect, useState } from 'react'
import ReviewImages, { ReviewGallery } from './ReviewImages.jsx'
import { requestAdmin } from '../services/adminService.js'
import { requestUser } from '../services/userService.js'

function ReviewForm({ record, products, onCancel, onSaved }) {
  const editing = Boolean(record.ResenaID)
  const [product, setProduct] = useState(String(record.ProductoID || products[0]?.ProductoID || ''))
  const [rating, setRating] = useState(record.Calificacion || 5)
  const [comment, setComment] = useState(record.Comentario || '')
  const [images, setImages] = useState(record.Imagenes || [])
  const [busy, setBusy] = useState(false)
  const [error, setError] = useState('')
  async function submit(event) {
    event.preventDefault()
    if (busy) return
    setBusy(true); setError('')
    try {
      const data = { Calificacion: Number(rating), Comentario: comment || null, Imagenes: images }
      if (!editing) data.ProductoID = Number(product)
      await requestAdmin('resenas', { method: editing ? 'PUT' : 'POST', record: editing ? record : undefined, data })
      onSaved()
    } catch (failure) { setError(failure.message) } finally { setBusy(false) }
  }
  return <form onSubmit={submit} className="border rounded p-3 mb-4">
    <h2 className="h5">{editing ? 'Editar reseña' : 'Agregar reseña'}</h2>
    {error && <p role="alert" className="alert alert-danger">{error}</p>}
    <fieldset disabled={busy}>
      {editing ? <p>{record.Producto}</p> : <><label htmlFor="review-product" className="form-label">Producto comprado</label><select id="review-product" required className="form-select mb-3" value={product} onChange={(event) => setProduct(event.target.value)}><option value="">Selecciona un producto</option>{products.map((item) => <option key={item.ProductoID} value={item.ProductoID}>{item.Nombre}</option>)}</select></>}
      <label htmlFor="review-rating" className="form-label">Calificación</label><select id="review-rating" className="form-select mb-3" value={rating} onChange={(event) => setRating(event.target.value)}>{[1, 2, 3, 4, 5].map((n) => <option key={n} value={n}>{n} de 5</option>)}</select>
      <label htmlFor="review-comment" className="form-label">Comentario</label><textarea id="review-comment" className="form-control" rows={3} maxLength={10000} value={comment} onChange={(event) => setComment(event.target.value)} />
      <ReviewImages value={images} onChange={setImages} />
      <div className="d-flex gap-2"><button type="submit" className="btn btn-primary">{busy ? 'Guardando…' : 'Guardar reseña'}</button><button type="button" className="btn btn-outline-secondary" onClick={onCancel}>Cancelar</button></div>
    </fieldset>
  </form>
}
export default function UserReviews({ data, reload }) {
  const [products, setProducts] = useState(null)
  const [error, setError] = useState('')
  const [editing, setEditing] = useState(null)
  useEffect(() => {
    const controller = new AbortController()
    requestUser('productos-resenables', { signal: controller.signal }).then((result) => { if (!controller.signal.aborted) setProducts(result.data) }).catch((failure) => { if (!controller.signal.aborted) setError(failure.message) })
    return () => controller.abort()
  }, [])
  const available = (products || []).filter((product) => !data.some((review) => Number(review.ProductoID) === Number(product.ProductoID)))
  return <>
    {error && <p role="alert" className="alert alert-danger">{error}</p>}
    {editing ? <ReviewForm key={editing.ResenaID || 'new'} record={editing} products={available} onCancel={() => setEditing(null)} onSaved={reload} /> : <button className="btn btn-primary mb-3" disabled={!available.length} onClick={() => setEditing({})}>Agregar reseña</button>}
    {products && !available.length && <p className="text-secondary">Puedes agregar una reseña por cada producto de tus órdenes entregadas.</p>}
    {!data.length && <p>Todavía no has colocado reseñas.</p>}
    {data.map((review) => <article className="border rounded p-3 mb-3" key={review.ResenaID}>
      <h2 className="h5">{review.Producto}</h2><p>{review.Calificacion} / 5 · {review.Estado} · {review.FechaResena}</p><p style={{ whiteSpace: 'pre-wrap' }}>{review.Comentario}</p>
      <ReviewGallery images={review.Imagenes || []} />
      <button type="button" className="btn btn-outline-primary mt-2" onClick={() => setEditing(review)}>Editar reseña de {review.Producto}</button>
    </article>)}
  </>
}
