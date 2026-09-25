import { useState } from 'react'
import Icon from './Icon.jsx'

export default function StoreImage({ src, alt, className = '' }) {
  const [failed, setFailed] = useState('')
  if (!src || failed === src) return <div className={`store-image-placeholder ${className}`} role="img" aria-label={`${alt}: sin imagen`}><Icon name="cart" size={32} /></div>
  return <img className={className} src={src} alt={alt} loading="lazy" onError={() => setFailed(src)} />
}
