import { useEffect, useState } from 'react'
import { Link, useLocation } from 'react-router-dom'
import { adminSchemas, fieldLabel, formPayload, initialValues, transitions } from '../data/adminSchemas.js'
import { recordQuery, requestAdmin } from '../services/adminService.js'

const entries = (record) => Object.entries(record).filter(([key, value]) => !/contrasena|password|hash/i.test(key) && !/^\d+$/.test(key) && !Array.isArray(value) && (value === null || typeof value !== 'object'))
const display = (value) => value === null || value === undefined || value === '' ? '—' : String(value)

function Field({ field, value, onChange, disabled = false, prefix = 'registro', editing = false }) {
  const id = `${prefix}-${field.name}`
  const props = { id, name: field.name, disabled, required: field.required && !(editing && field.type === 'password'), value: value ?? '', onChange: (event) => onChange(event.target.value) }
  return <div className={field.type === 'textarea' ? 'col-12' : 'col-12 col-md-6'}>
    {field.type === 'checkbox' ? <div className="form-check mt-4"><input id={id} type="checkbox" className="form-check-input" disabled={disabled} checked={Boolean(value)} onChange={(event) => onChange(event.target.checked)} /><label className="form-check-label" htmlFor={id}>{fieldLabel(field.name)}</label></div> : <>
      <label className="form-label" htmlFor={id}>{fieldLabel(field.name)}{props.required ? ' *' : ''}</label>
      {field.type === 'select' ? <select {...props} className="form-select"><option value="">Selecciona una opción</option>{field.options.map((option) => <option key={option} value={option}>{option}</option>)}</select>
        : field.type === 'textarea' ? <textarea {...props} maxLength={field.maxLength} rows={3} className="form-control" />
          : <input {...props} type={field.type} min={field.min} max={field.max} step={field.type === 'datetime-local' ? 1 : field.step} minLength={field.minLength} maxLength={field.maxLength} autoComplete={field.type === 'password' ? 'new-password' : 'off'} className="form-control" />}
      {editing && field.type === 'password' && <div className="form-text">Deja este campo vacío para conservar la contraseña.</div>}
    </>}
  </div>
}
function RecordDetails({ record, prefix = 'consulta' }) {
  return <div className="row g-3 mb-4">{entries(record).map(([name, value]) => <div key={name} className="col-12 col-md-6"><label htmlFor={`${prefix}-${name}`} className="form-label">{fieldLabel(name)}</label><input id={`${prefix}-${name}`} className="form-control" readOnly value={display(value)} /></div>)}</div>
}
function SearchRecord({ resource, onFind }) {
  const keys = adminSchemas[resource].keys
  const [values, setValues] = useState(Object.fromEntries(keys.map((key) => [key, ''])))
  return <form className="mb-4" onSubmit={(event) => { event.preventDefault(); onFind(values) }}><p>Indica {keys.length > 1 ? 'los dos identificadores que componen el registro' : 'el ID del registro'}.</p><div className="row g-3">{keys.map((key) => <Field key={key} field={{ name: key, type: 'number', min: 1, step: 1, required: true }} value={values[key]} prefix="buscar" onChange={(value) => setValues({ ...values, [key]: value })} />)}</div><button className="btn btn-dark mt-3" type="submit">Buscar registro</button></form>
}
function RecordsTable({ resource, records }) {
  const [rows, setRows] = useState(records)
  const [busy, setBusy] = useState(false)
  const [message, setMessage] = useState('')
  const [error, setError] = useState('')
  const columns = [...new Set(rows.flatMap((row) => entries(row).map(([name]) => name)))]
  async function remove(row) {
    if (!window.confirm(`¿Eliminar el registro ${recordQuery(resource, row)}? Esta acción no se puede deshacer.`)) return
    setBusy(true); setError(''); setMessage('')
    try {
      const result = await requestAdmin(resource, { method: 'DELETE', record: row })
      setRows((current) => current.filter((item) => recordQuery(resource, item) !== recordQuery(resource, row))); setMessage(result.message)
    } catch (failure) { setError(failure.message) } finally { setBusy(false) }
  }
  return <>
    <div className="d-flex flex-wrap gap-3 align-items-center mb-3"><Link className="btn btn-primary" to={`/cuenta/admin/${resource}/agregar`}>Agregar</Link><span className="text-secondary">{rows.length} registro(s)</span></div>
    {error && <div role="alert" className="alert alert-danger">{error}</div>}{message && <div role="status" className="alert alert-success">{message}</div>}{busy && <p role="status">Eliminando registro…</p>}
    {!rows.length ? <p role="status">No hay registros para mostrar.</p> : <div className="table-responsive admin-table" tabIndex={0} aria-label="Tabla de registros"><table className="table table-striped table-hover align-middle"><caption>{resource}: registros encontrados</caption><thead><tr>{columns.map((name) => <th scope="col" key={name}>{fieldLabel(name)}</th>)}<th scope="col">Acciones</th></tr></thead><tbody>{rows.map((row) => <tr key={recordQuery(resource, row)}>{columns.map((name) => <td key={name}>{display(row[name])}</td>)}<td><div className="d-flex gap-2"><Link className={`btn btn-sm btn-outline-primary${busy ? ' disabled' : ''}`} aria-label={`Editar ${recordQuery(resource, row)}`} to={`/cuenta/admin/${resource}/editar?${recordQuery(resource, row)}`}>Editar</Link><button type="button" className="btn btn-sm btn-outline-danger" disabled={busy} aria-label={`Eliminar ${recordQuery(resource, row)}`} onClick={() => remove(row)}>Eliminar</button></div></td></tr>)}</tbody></table></div>}
  </>
}
function RecordForm({ resource, operation, record }) {
  const schema = adminSchemas[resource]
  const editing = operation === 'editar'
  const deleting = operation === 'eliminar'
  const allowedStates = editing ? transitions[resource]?.[record.Estado] : undefined
  const fields = (editing ? schema.editFields ?? schema.fields : schema.fields).map((field) => field.name === 'Estado' && allowedStates ? { ...field, options: allowedStates } : field)
  const [values, setValues] = useState(() => ({ ...initialValues(fields, record), ...(allowedStates ? { Estado: '' } : {}) }))
  const [lines, setLines] = useState(() => schema.lines ? [initialValues(schema.lines)] : [])
  const [busy, setBusy] = useState(false)
  const [error, setError] = useState('')
  const [message, setMessage] = useState('')
  const [finished, setFinished] = useState(false)
  async function submit(event) {
    event.preventDefault()
    if (busy) return
    if (deleting && !window.confirm(`¿Confirmas que deseas eliminar el registro ${recordQuery(resource, record)}? Esta acción no se puede deshacer.`)) return
    setBusy(true); setError(''); setMessage('')
    try {
      const data = deleting ? undefined : formPayload(fields, values, editing)
      if (!editing && !deleting && schema.lines) data.Detalles = lines.map((line) => formPayload(schema.lines, line))
      const result = await requestAdmin(resource, { method: deleting ? 'DELETE' : editing ? 'PUT' : 'POST', record: editing || deleting ? record : undefined, data })
      setMessage(result.message || 'Operación completada correctamente.'); setFinished(true)
    } catch (failure) { setError(failure.message) } finally { setBusy(false) }
  }
  return <>
    {schema.hint && <p className="alert alert-info">{schema.hint}</p>}{error && <p role="alert" className="alert alert-danger">{error}</p>}{message && <div role="status" className="alert alert-success">{message}</div>}
    {finished ? <Link to={`/cuenta/admin/${resource}/mostrar`} className="btn btn-primary">Mostrar todos los registros</Link> : <form onSubmit={submit}>
      {deleting ? <><p>Revisa los datos. Se solicitará confirmación antes de eliminarlos.</p><RecordDetails record={record} /></> : <>
        {editing && <details className="mb-4"><summary className="mb-3">Ver datos actuales del registro</summary><RecordDetails record={record} /></details>}
        <p className="small text-secondary">Los campos con * son obligatorios.</p>
        <fieldset disabled={busy}><div className="row g-3">{fields.map((field) => <Field key={field.name} field={field} value={values[field.name]} editing={editing} disabled={editing && schema.immutable?.includes(field.name)} onChange={(value) => setValues((current) => ({ ...current, [field.name]: value }))} />)}</div>
        {!editing && schema.lines && <fieldset className="mt-4"><legend className="h5">Detalles del documento</legend>{lines.map((line, index) => <div className="border rounded p-3 mb-3" key={index}><h3 className="h6">Línea {index + 1}</h3><div className="row g-3">{schema.lines.map((field) => <Field key={field.name} field={field} prefix={`linea-${index}`} value={line[field.name]} onChange={(value) => setLines((current) => current.map((item, i) => i === index ? { ...item, [field.name]: value } : item))} />)}</div><button className="btn btn-outline-danger btn-sm mt-3" type="button" disabled={lines.length === 1} onClick={() => setLines((current) => current.filter((_, i) => i !== index))}>Quitar línea {index + 1}</button></div>)}<button type="button" className="btn btn-outline-dark" disabled={lines.length >= 100} onClick={() => setLines((current) => [...current, initialValues(schema.lines)])}>Agregar línea</button></fieldset>}
        </fieldset>
      </>}
      {record.Detalles?.length > 0 && <details className="mt-4"><summary>Detalles vinculados ({record.Detalles.length})</summary>{record.Detalles.map((line, index) => <div className="border rounded p-3 mt-3" key={index}><RecordDetails record={line} prefix={`detalle-${index}`} /></div>)}</details>}
      {allowedStates?.length === 0 ? <p className="alert alert-info mt-3">El estado actual no admite más cambios.</p> : <button type="submit" disabled={busy} className={`btn ${deleting ? 'btn-danger' : 'btn-primary'} mt-4`}>{busy ? 'Procesando…' : deleting ? 'Eliminar registro' : editing ? 'Guardar cambios' : 'Agregar registro'}</button>}
    </form>}
  </>
}
function LoadRecords({ resource, operation, query }) {
  const [state, setState] = useState({ loading: true, data: null, error: '' })
  const [attempt, setAttempt] = useState(0)
  useEffect(() => {
    const controller = new AbortController()
    requestAdmin(resource, { record: query ? Object.fromEntries(new URLSearchParams(query)) : undefined, signal: controller.signal })
      .then((result) => { if (!controller.signal.aborted) setState({ loading: false, data: result.data, error: '' }) })
      .catch((error) => { if (!controller.signal.aborted) setState({ loading: false, data: null, error: error.message }) })
    return () => controller.abort()
  }, [resource, query, attempt])
  if (state.loading) return <p role="status">Cargando registros…</p>
  if (state.error) return <div role="alert" className="alert alert-danger"><p>{state.error}</p><button className="btn btn-outline-dark" onClick={() => { setState({ loading: true, data: null, error: '' }); setAttempt((n) => n + 1) }}>Reintentar</button></div>
  if (operation === 'mostrar' || operation === 'buscar') return <RecordsTable resource={resource} records={Array.isArray(state.data) ? state.data : [state.data]} />
  return <RecordForm resource={resource} operation={operation} record={state.data} />
}
export default function AdminCrud({ resource, operation }) {
  const { search } = useLocation()
  const schema = adminSchemas[resource]
  const params = new URLSearchParams(search)
  const direct = operation === 'editar' && schema.keys.every((key) => /^[1-9]\d*$/.test(params.get(key) ?? '')) ? recordQuery(resource, Object.fromEntries(params)) : ''
  const [query, setQuery] = useState(direct)
  const [revision, setRevision] = useState(0)
  return <div className="mt-4">
    {operation !== 'mostrar' && operation !== 'agregar' && !direct && <SearchRecord resource={resource} onFind={(values) => { setQuery(recordQuery(resource, values)); setRevision((n) => n + 1) }} />}
    {operation === 'agregar' ? <RecordForm resource={resource} operation={operation} record={{}} /> : (operation === 'mostrar' || query) && <LoadRecords key={`${query}-${revision}`} resource={resource} operation={operation} query={query} />}
    <div className="d-flex gap-3 flex-wrap mt-4"><Link to={`/cuenta/admin/${resource}`}>Volver al panel de la tabla</Link>{operation !== 'mostrar' && <Link to={`/cuenta/admin/${resource}/mostrar`}>Mostrar todos los registros</Link>}</div>
  </div>
}
