export const adminGroups = [
  {
    nombre: 'Catálogo',
    recursos: [
      { ruta: 'categorias', nombre: 'Categorías', descripcion: 'Categorías principales y subcategorías.', icono: 'menu' },
      { ruta: 'productos', nombre: 'Productos', descripcion: 'Productos, precios e inventario.', icono: 'laptop' },
      { ruta: 'proveedores', nombre: 'Proveedores', descripcion: 'Información y contactos de proveedores.', icono: 'truck' },
      { ruta: 'promociones', nombre: 'Promociones', descripcion: 'Descuentos, cupones y vigencias.', icono: 'star' },
      { ruta: 'productos-proveedores', nombre: 'Productos y proveedores', descripcion: 'Costos de compra y proveedor principal.', icono: 'truck' },
      { ruta: 'productos-promociones', nombre: 'Productos y promociones', descripcion: 'Productos incluidos en cada promoción.', icono: 'star' },
    ],
  },
  {
    nombre: 'Usuarios y comunidad',
    recursos: [
      { ruta: 'usuarios', nombre: 'Usuarios', descripcion: 'Cuentas, roles y estado de los usuarios.', icono: 'user' },
      { ruta: 'direcciones', nombre: 'Direcciones', descripcion: 'Direcciones registradas por los clientes.', icono: 'location' },
      { ruta: 'lista-deseos', nombre: 'Listas de deseos', descripcion: 'Productos guardados como favoritos.', icono: 'heart' },
      { ruta: 'resenas', nombre: 'Reseñas', descripcion: 'Calificaciones, comentarios y moderación.', icono: 'star' },
    ],
  },
  {
    nombre: 'Ventas y posventa',
    recursos: [
      { ruta: 'ordenes', nombre: 'Órdenes', descripcion: 'Pedidos y seguimiento de sus estados.', icono: 'cart' },
      { ruta: 'detalle-ordenes', nombre: 'Detalles de órdenes', descripcion: 'Productos y cantidades de cada pedido.', icono: 'menu' },
      { ruta: 'pagos', nombre: 'Pagos', descripcion: 'Pagos registrados y sus referencias.', icono: 'check' },
      { ruta: 'facturas', nombre: 'Facturas', descripcion: 'Facturas emitidas y anuladas.', icono: 'menu' },
      { ruta: 'detalle-facturas', nombre: 'Detalles de facturas', descripcion: 'Conceptos e importes facturados.', icono: 'menu' },
      { ruta: 'devoluciones', nombre: 'Devoluciones', descripcion: 'Solicitudes de devolución y reembolsos.', icono: 'refresh' },
      { ruta: 'detalle-devoluciones', nombre: 'Detalles de devoluciones', descripcion: 'Artículos y cantidades devueltas.', icono: 'refresh' },
    ],
  },
]

export const adminResources = adminGroups.flatMap((grupo) => grupo.recursos)
