const text = (name, maxLength = 255, required = true) => ({ name, type: 'text', maxLength, required })
const number = (name, min = 1, required = true) => ({ name, type: 'number', min, step: 1, required })
const money = (name, required = true) => ({ ...number(name, 0, required), step: '0.01', max: 99999999.99 })
const select = (name, options) => ({ name, type: 'select', options, required: true, default: options[0] })
const boolean = (name) => ({ name, type: 'checkbox', default: false })
const state = select('Estado', ['Activo', 'Inactivo'])
const note = (name = 'Descripcion') => ({ ...text(name, 255, false), type: 'textarea' })
const date = (name, required = true) => ({ name, type: 'datetime-local', required })
const resource = (id, fields, extra = {}) => ({ keys: [id], fields, ...extra })
const auxiliary = { auxiliary: true }
export const adminSchemas = {
  categorias: resource('CategoriaID', [text('Nombre', 100), note(), state, number('CategoriaPadreID', 1, false)]),
  productos: resource('ProductoID', [number('CategoriaID'), text('SKU', 50, false), text('Nombre', 150), note(), money('Precio'), number('Cantidad', 0), text('Imagen', 255, false), state]),
  proveedores: resource('ProveedorID', [text('Nombre', 150), text('NIT', 20, false), text('Contacto', 100, false), { ...text('Correo', 100, false), type: 'email' }, text('Telefono', 20, false), text('Direccion', 255, false), state]),
  promociones: resource('PromocionID', [text('Nombre'), note(), select('TipoDescuento', ['Porcentaje', 'Monto']), money('ValorDescuento'), date('FechaInicio'), date('FechaFin', false), boolean('RequiereCupon'), text('CodigoCupon', 40, false), boolean('AplicaTodosProductos'), state]),
  usuarios: resource('UsuarioID', [text('Nombres', 75), text('Apellidos', 75), { ...text('Correo', 100), type: 'email' }, text('Telefono', 20), text('Usuario', 50), { ...text('Contrasena', 72), type: 'password', minLength: 8 }, select('TipoUsuario', ['Cliente', 'Administrador']), state]),
  direcciones: resource('DireccionID', [number('UsuarioID'), text('Direccion'), text('Ciudad', 75), text('Subnacional', 100), { ...text('Pais', 50), default: 'Guatemala' }, text('CodigoPostal', 15, false), select('TipoDireccion', ['Casa', 'Trabajo', 'Otro']), boolean('EsPrincipal')], { immutable: ['UsuarioID'] }),
  'productos-proveedores': { keys: ['ProductoID', 'ProveedorID'], fields: [number('ProductoID'), number('ProveedorID'), money('CostoCompra', false), boolean('EsPrincipal')], ...auxiliary },
  'productos-promociones': { keys: ['ProductoID', 'PromocionID'], fields: [number('ProductoID'), number('PromocionID')], ...auxiliary },
  'lista-deseos': { keys: ['UsuarioID', 'ProductoID'], fields: [number('UsuarioID'), number('ProductoID')], ...auxiliary },
  ordenes: resource('OrdenID', [number('UsuarioID'), text('DireccionPago'), text('DireccionEnvio')], { editFields: [select('Estado', ['Pendiente', 'Confirmada', 'Procesando', 'Enviada', 'Entregada', 'Cancelada'])], lines: [number('ProductoID'), number('Cantidad')], hint: 'Los precios y totales se calculan con los productos seleccionados. Al crear el pedido se reservan las existencias.' }),
  pagos: resource('PagoID', [number('OrdenID'), { ...money('Monto'), min: '0.01' }, text('MetodoPago', 30), text('ReferenciaPago', 100, false), note('Notas'), select('Estado', ['Pendiente', 'Completado'])], { editFields: [select('Estado', ['Pendiente', 'Completado', 'Rechazado', 'Reembolsado'])], hint: 'El importe debe ser menor o igual al saldo de la orden. Solo se pueden eliminar pagos pendientes o rechazados.' }),
  facturas: resource('FacturaID', [number('OrdenID'), text('NumeroFactura', 50), text('Nombre', 150), { ...text('NIT', 20), default: 'CF' }, text('Direccion'), note('Notas')], { editFields: [select('Estado', ['Emitida', 'Anulada'])], hint: 'Al crear la factura se copian los detalles y totales de la orden. Solo se pueden eliminar facturas anuladas.' }),
  devoluciones: resource('DevolucionID', [number('OrdenID'), text('Motivo')], { editFields: [select('Estado', ['Solicitada', 'Aprobada', 'Rechazada', 'Procesada']), note('Notas')], lines: [number('DetalleOrdenID'), number('Cantidad'), note('Motivo')], hint: 'La orden debe estar entregada. El reembolso se calcula según las cantidades y los importes originales. Solo se pueden eliminar devoluciones rechazadas.' }),
  resenas: resource('ResenaID', [number('ProductoID'), { ...number('Calificacion'), max: 5 }, { ...note('Comentario'), maxLength: 10000 }], { editFields: [select('Estado', ['Publicada', 'Oculta'])], hint: 'Las reseñas nuevas se registran a nombre de tu usuario y requieren una compra entregada. La edición administrativa permite moderar su estado.' }),
  'detalle-ordenes': resource('DetalleOrdenID', [number('OrdenID'), number('ProductoID'), number('Cantidad')], { ...auxiliary, immutable: ['OrdenID', 'ProductoID'], hint: 'Solo órdenes pendientes sin pagos, facturas ni devoluciones. Se ajustan inventario y totales automáticamente; debe quedar al menos una línea.' }),
  'detalle-facturas': resource('DetalleFacturaID', [number('FacturaID'), number('DetalleOrdenID'), text('Descripcion'), number('Cantidad')], { ...auxiliary, immutable: ['FacturaID', 'DetalleOrdenID'], hint: 'Solo facturas emitidas de órdenes pendientes sin pagos. La línea debe pertenecer a la orden facturada y la cantidad no puede superar la original. Se recalculan los importes; debe quedar al menos una línea.' }),
  'detalle-devoluciones': resource('DetalleDevolucionID', [number('DevolucionID'), number('DetalleOrdenID'), number('Cantidad'), note('Motivo')], { ...auxiliary, immutable: ['DevolucionID', 'DetalleOrdenID'], hint: 'Solo devoluciones solicitadas. Se comprueba la cantidad disponible y se recalcula el reembolso; debe quedar al menos una línea.' }),
}
export const transitions = {
  ordenes: { Pendiente: ['Confirmada', 'Cancelada'], Confirmada: ['Procesando', 'Cancelada'], Procesando: ['Enviada'], Enviada: ['Entregada'], Entregada: [], Cancelada: [] },
  pagos: { Pendiente: ['Completado', 'Rechazado'], Completado: ['Reembolsado'], Rechazado: [], Reembolsado: [] },
  facturas: { Emitida: ['Anulada'], Anulada: [] },
  devoluciones: { Solicitada: ['Aprobada', 'Rechazada'], Aprobada: ['Procesada', 'Rechazada'], Rechazada: [], Procesada: [] },
}
const labels = { Contrasena: 'Contraseña', ResenaID: 'ID de reseña', CategoriaPadreID: 'ID de categoría principal', Subnacional: 'Departamento / provincia', SKU: 'SKU', NIT: 'NIT', EsPrincipal: 'Es principal', AplicaTodosProductos: 'Aplica a todos los productos' }
export function fieldLabel(name) {
  return labels[name] ?? name.replace(/ID$/, ' ID').replace(/([a-z])([A-Z])/g, '$1 $2')
}
export function initialValues(fields, record = {}) {
  return Object.fromEntries(fields.map((field) => {
    let value = record[field.name] ?? field.default ?? ''
    if (field.type === 'password') value = ''
    if (field.type === 'checkbox') value = value === true || value === 1 || value === '1'
    if (field.type === 'datetime-local') value = String(value).replace(' ', 'T')
    return [field.name, value]
  }))
}
export function formPayload(fields, values, editing = false) {
  return Object.fromEntries(fields.filter((f) => !(editing && f.type === 'password' && !values[f.name])).map((f) => {
    let value = values[f.name]
    if (f.type === 'checkbox') value = value ? 1 : 0
    else if (value === '') value = null
    else if (f.type === 'datetime-local') value = value.replace('T', ' ') + (value.length === 16 ? ':00' : '')
    return [f.name, value]
  }))
}
