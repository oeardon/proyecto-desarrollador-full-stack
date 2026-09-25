import { useEffect, useId, useRef, useState } from 'react'

function ReviewThumbnail({ image, index }) {
  const ref = useRef(null)
  useEffect(() => {
    if (!(image instanceof File)) return
    const url = URL.createObjectURL(image)
    ref.current.src = url
    return () => URL.revokeObjectURL(url)
  }, [image])
  return <img ref={ref} src={typeof image === 'string' ? image : undefined} alt={`Imagen ${index + 1} de la reseña`} width={110} height={110} style={{ objectFit: 'contain' }} />
}
export function ReviewGallery({ images = [] }) {
  return <div className="d-flex flex-wrap gap-2">{images.map((image, index) => <a key={image} href={image} target="_blank" rel="noopener noreferrer"><ReviewThumbnail image={image} index={index} /></a>)}</div>
}
export default function ReviewImages({ value = [], onChange, disabled = false }) {
  const id = useId()
  const [error, setError] = useState('')
  const images = Array.isArray(value) ? value : []
  function select(event) {
    const files = [...event.target.files]
    event.target.value = ''
    if (images.length + files.length > 3) { setError('Puedes adjuntar un máximo de 3 imágenes en total. Quita alguna antes de agregar otras.'); return }
    if (files.some((file) => !['image/jpeg', 'image/png', 'image/webp'].includes(file.type) || file.size > 2 * 1024 * 1024)) {
      setError('Cada imagen debe ser JPG, PNG o WebP y pesar como máximo 2 MB.'); return
    }
    setError(''); onChange([...images, ...files])
  }
  return <div className="my-3">
    <label htmlFor={id} className="form-label">Imágenes de la reseña (opcional)</label>
    <input id={id} type="file" multiple accept="image/jpeg,image/png,image/webp" className="form-control" disabled={disabled} onChange={select} aria-describedby={`${id}-help`} />
    <p id={`${id}-help`} className="form-text">Hasta 3 imágenes de 2 MB cada una. {images.length} de 3 seleccionadas. Los cambios se aplican al guardar.</p>
    {error && <p role="alert" className="text-danger">{error}</p>}
    <div className="d-flex flex-wrap gap-3">{images.map((image, index) => <div key={typeof image === 'string' ? image : `${image.name}-${index}`}>
      <ReviewThumbnail image={image} index={index} /><br /><button type="button" className="btn btn-sm btn-outline-danger" disabled={disabled} onClick={() => { setError(''); onChange(images.filter((_, i) => i !== index)) }}>Quitar imagen {index + 1}</button>
    </div>)}</div>
  </div>
}
