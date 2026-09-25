import { money } from '../services/userFormat.js'
import { Link } from 'react-router-dom'
import { UserFacts, UserTable } from './UserShared.jsx'

const totals = [['Subtotal', 'Subtotal', money], ['DescuentoTotal', 'Descuento', money], ['ImpuestoTotal', 'Impuestos', money], ['Total', 'Total', money]]
export default function UserOrders({ data, id }) {
  if (!id) return <UserTable rows={data} rowKey="OrdenID" empty="Todavía no tienes órdenes."
    columns={[
      ['OrdenID', 'Orden', (value) => <Link to={`/cuenta/usuario/ordenes/${value}`}>Ver orden #{value}</Link>],
      ['FechaOrden', 'Fecha'], ['Estado', 'Estado'], ['Total', 'Total', money],
    ]} />
  return <>
    <Link to="/cuenta/usuario/ordenes">Volver a mis órdenes</Link>
    <h2 className="h4 mt-4">Orden #{data.OrdenID}</h2>
    <UserFacts record={data} fields={[
      ['FechaOrden', 'Fecha'], ['Estado', 'Estado'], ['DireccionEnvio', 'Dirección de envío'], ['DireccionPago', 'Dirección de facturación'],
      ...totals.slice(0, 3), ['CostoEnvio', 'Envío', money], totals[3],
    ]} />
    <h3 className="h5 mt-4">Productos de la orden</h3>
    <UserTable rows={data.Detalles} rowKey="DetalleOrdenID" columns={[
      ['Producto', 'Producto'], ['Cantidad', 'Cantidad'], ['PrecioUnitario', 'Precio unitario', money], ['Subtotal', 'Subtotal', money],
    ]} />
    <h3 className="h5 mt-4">Pagos y formas de pago</h3>
    <UserTable rows={data.Pagos} rowKey="PagoID" empty="Esta orden todavía no tiene pagos registrados." columns={[
      ['MetodoPago', 'Forma de pago'], ['FechaPago', 'Fecha'], ['Monto', 'Monto', money], ['Estado', 'Estado'], ['ReferenciaPago', 'Referencia'],
    ]} />
    <h3 className="h5 mt-4">Facturas</h3>
    {!data.Facturas.length && <p className="text-secondary">Esta orden todavía no tiene factura.</p>}
    {data.Facturas.map((invoice) => <article className="card mb-3" key={invoice.FacturaID}><div className="card-body">
      <h4 className="h6">Factura {invoice.NumeroFactura}</h4>
      <UserFacts record={invoice} fields={[
        ['FechaEmision', 'Fecha de emisión'], ['Estado', 'Estado'], ['Nombre', 'Nombre'], ['NIT', 'NIT'], ['Direccion', 'Dirección'], ...totals,
      ]} />
      <UserTable rows={invoice.Detalles} columns={[
        ['Descripcion', 'Descripción'], ['Cantidad', 'Cantidad'], ['PrecioUnitario', 'Precio unitario', money], ['Descuento', 'Descuento', money], ['Impuesto', 'Impuesto', money], ['Subtotal', 'Subtotal', money],
      ]} />
    </div></article>)}
    {data.Estado === 'Entregada' && <Link className="btn btn-primary mt-3" to={`/cuenta/usuario/devoluciones/nueva?orden=${data.OrdenID}`}>Solicitar devolución</Link>}
  </>
}
