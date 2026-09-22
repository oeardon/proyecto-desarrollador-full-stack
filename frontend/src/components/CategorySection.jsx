import Icon from './Icon.jsx'

const categories = [
  { id:'celulares', name:'Celulares', count:'24 productos', icon:'phone', image:'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=600&q=85' },
  { id:'computacion', name:'Computación', count:'18 productos', icon:'laptop', image:'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?auto=format&fit=crop&w=600&q=85' },
  { id:'audio', name:'Audio', count:'31 productos', icon:'audio', image:'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=600&q=85' },
  { id:'gaming', name:'Gaming', count:'16 productos', icon:'game', image:'https://images.unsplash.com/photo-1592840496694-26d035b52b48?auto=format&fit=crop&w=600&q=85' },
  { id:'hogar', name:'Hogar inteligente', count:'22 productos', icon:'home', image:'https://images.unsplash.com/photo-1558002038-1055907df827?auto=format&fit=crop&w=600&q=85' },
  { id:'accesorios', name:'Accesorios', count:'44 productos', icon:'accessory', image:'https://images.unsplash.com/photo-1587829741301-dc798b83add3?auto=format&fit=crop&w=600&q=85' },
]

export default function CategorySection({ onCategory }) {
  return (
    <section className="shop-section" id="categorias">
      <div className="shop-container">
        <div className="section-heading reveal-item">
          <div><span>Compra por categoría</span><h2>Encuentra lo que necesitas</h2><p>Explora nuestras categorías más buscadas y descubre productos para cada momento.</p></div>
          <button type="button" className="text-link" onClick={() => onCategory('todos')}>Ver todos <Icon name="arrowRight" size={15} /></button>
        </div>

        <div className="category-grid-shop">
          {categories.map((category) => (
            <button className="category-card-shop reveal-item" type="button" key={category.id} onClick={() => onCategory(category.id)}>
              <div className="category-card-shop__image"><img src={category.image} alt={category.name} /></div>
              <div className="category-card-shop__icon"><Icon name={category.icon} size={21} /></div>
              <strong>{category.name}</strong>
              <span>{category.count}</span>
            </button>
          ))}
        </div>
      </div>
    </section>
  )
}
