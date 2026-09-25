import Icon from './Icon.jsx'
import StoreImage from './StoreImage.jsx'
import { belongsToCategory } from '../services/storeService.js'

export default function CategorySection({ onCategory, catalog }) {
  const roots = catalog.categories.filter((category) => category.CategoriaPadreID === null)
  return <section className="shop-section" id="categorias"><div className="shop-container">
    <div className="section-heading reveal-item"><div><span>Compra por categoría</span><h2>Encuentra lo que necesitas</h2><p>Explora las categorías disponibles en nuestra tienda.</p></div><button type="button" className="text-link" onClick={() => onCategory('todos')}>Ver todos <Icon name="arrowRight" size={15} /></button></div>
    <div className="category-grid-shop">{roots.map((category) => {
      const products = catalog.products.filter((product) => belongsToCategory(product, category.CategoriaID, catalog.categories))
      return <button className="category-card-shop reveal-item" type="button" key={category.CategoriaID} onClick={() => onCategory(String(category.CategoriaID))}>
        <div className="category-card-shop__image"><StoreImage src={products.find((product) => product.image)?.image} alt={category.Nombre} /></div><div className="category-card-shop__icon"><Icon name="menu" size={21} /></div><strong>{category.Nombre}</strong><span>{products.length} productos</span>
      </button>
    })}</div>
  </div></section>
}
