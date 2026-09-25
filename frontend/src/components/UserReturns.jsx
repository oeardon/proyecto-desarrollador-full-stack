import { money } from '../services/userFormat.js'
import { Link, useNavigate } from 'react-router-dom'
import { useState } from 'react'
import { UserFacts, UserForm, UserTable } from './UserShared.jsx'
import { requestUser } from '../services/userService.js'

function ReturnForm({ order }) {
  const [quantities, setQuantities] = useState({})
  const navigate = useNavigate()
  const available = order.Detalles.filter((line) => line.CantidadDisponibleDevolucion > 0)
  if (order.Estado !== 'Entregada') return <p role="status">Solo puedes solicitar devoluciones de órdenes entregadas.</p>
  if (!available.length) return <p role="status">Todos los productos de esta orden ya tienen una devolución solicitada o procesada.</p>
  return <>
    <h2 className="h4">Devolver productos de la orden #{order.OrdenID}</h2>
    <p>Indica cuántas unidades deseas devolver. Deja en cero los productos que conservarás.</p>
    <UserForm fields={[{ name: 'Motivo', label: 'Motivo de la devolución', type: 'textarea', required: true, maxLength: 255, wide: true }]}
      submitLabel="Solicitar devolución" onCancel={() => navigate('/cuenta/usuario/devoluciones')}
      onSave={async (values) => {
        const details = available.filter((line) => Number(quantities[line.DetalleOrdenID]) > 0).map((line) => ({ DetalleOrdenID: line.DetalleOrdenID, Cantidad: Number(quantities[line.DetalleOrdenID]), Motivo: values.Motivo.trim() }))
        if (!details.length) throw new Error('Selecciona al menos una unidad para devolver.')
        const result = await requestUser('devoluciones', { method: 'POST', data: { OrdenID: order.OrdenID, Motivo: values.Motivo.trim(), Detalles: details } })
        navigate(`/cuenta/usuario/devoluciones/${result.DevolucionID}`, { state: { mensaje: 'Tu solicitud de devolución fue registrada.' } })
      }}>
      <div className="mt-4">{available.map((line) => <div className="row g-2 align-items-center mb-3" key={line.DetalleOrdenID}>
        <div className="col-12 col-sm-8"><label htmlFor={`devolver-${line.DetalleOrdenID}`}>{line.Producto}</label><p className="small text-secondary mb-0">Disponibles para devolver: {line.CantidadDisponibleDevolucion}</p></div>
        <div className="col-6 col-sm-4"><input id={`devolver-${line.DetalleOrdenID}`} aria-label={`Cantidad a devolver de ${line.Producto}`} className="form-control" type="number" min="0" max={line.CantidadDisponibleDevolucion} step="1" value={quantities[line.DetalleOrdenID] ?? 0} onChange={(event) => setQuantities({ ...quantities, [line.DetalleOrdenID]: event.target.value })} /></div>
      </div>)}</div>
    </UserForm>
  </>
}

export default function UserReturns({ data, id, orderId }) {
  if (id === 'nueva') {
    if (orderId) return <ReturnForm order={data} />
    const orders = data.filter((order) => order.Estado === 'Entregada')
    return <><h2 className="h4">Selecciona una orden entregada</h2><UserTable rows={orders} rowKey="OrdenID" empty="No tienes órdenes entregadas para solicitar una devolución." columns={[
      ['OrdenID', 'Orden', (value) => <Link to={`/cuenta/usuario/devoluciones/nueva?orden=${value}`}>Seleccionar orden #{value}</Link>], ['FechaOrden', 'Fecha'], ['Total', 'Total', money],
    ]} /></>
  }
  if (id) return <>
    <Link to="/cuenta/usuario/devoluciones">Volver a mis devoluciones</Link>
    <h2 className="h4 mt-4">Devolución #{data.DevolucionID}</h2>
    <UserFacts record={data} fields={[
      ['FechaSolicitud', 'Fecha de solicitud'], ['Estado', 'Estado'], ['Motivo', 'Motivo'], ['MontoReembolso', 'Importe de la devolución', money],
    ]} />
    <Link to={`/cuenta/usuario/ordenes/${data.OrdenID}`}>Consultar orden #{data.OrdenID}</Link>
    <h3 className="h5 mt-4">Productos incluidos</h3>
    <UserTable rows={data.Detalles} columns={[
      ['Producto', 'Producto'], ['Cantidad', 'Cantidad'], ['Motivo', 'Motivo'], ['MontoReembolso', 'Importe', money],
    ]} />
  </>
  return <>
    <Link className="btn btn-primary mb-3" to="/cuenta/usuario/devoluciones/nueva">Solicitar devolución</Link>
    <p className="text-secondary">Consulta el avance de tus solicitudes. La tienda revisará y actualizará su estado.</p>
    <UserTable rows={data} rowKey="DevolucionID" empty="Todavía no has solicitado devoluciones." columns={[
      ['DevolucionID', 'Devolución', (value) => <Link to={`/cuenta/usuario/devoluciones/${value}`}>Ver devolución #{value}</Link>],
      ['OrdenID', 'Orden', (value) => <Link to={`/cuenta/usuario/ordenes/${value}`}>#{value}</Link>], ['FechaSolicitud', 'Fecha'], ['Estado', 'Estado'], ['MontoReembolso', 'Importe', money],
    ]} />
  </>
}
