import CountrySelect from './CountrySelect.jsx'
import { useId, useRef, useState } from 'react'

export function UserFacts({ record, fields }) {
  return <dl className="row mb-0 user-facts">{fields.map(([name, label, format]) => <div className="col-12 col-md-6 mb-3" key={name}>
    <dt className="small text-secondary">{label}</dt><dd className="mb-0">{format ? format(record[name]) : String(record[name] ?? '—')}</dd>
  </div>)}</dl>
}

export function UserTable({ rows, columns, rowKey, empty = 'No hay registros para mostrar.' }) {
  if (!rows.length) return <p role="status" className="text-secondary">{empty}</p>
  return <div className="table-responsive" tabIndex={0} aria-label="Tabla de registros"><table className="table align-middle">
    <thead><tr>{columns.map(([name, label]) => <th scope="col" key={name}>{label}</th>)}</tr></thead>
    <tbody>{rows.map((row, index) => <tr key={row[rowKey] ?? index}>{columns.map(([name, , format]) => <td key={name}>{format ? format(row[name], row) : String(row[name] ?? '—')}</td>)}</tr>)}</tbody>
  </table></div>
}

export function UserForm({ fields, initial = {}, onSave, onCancel, submitLabel = 'Guardar cambios', children }) {
  const [values, setValues] = useState(initial)
  const [busy, setBusy] = useState(false)
  const [error, setError] = useState('')
  const pending = useRef(false)
  const prefix = useId()
  async function submit(event) {
    event.preventDefault()
    if (pending.current) return
    pending.current = true
    setBusy(true)
    setError('')
    try { await onSave(values) } catch (failure) { setError(failure.message) }
    finally { pending.current = false; setBusy(false) }
  }
  return <form onSubmit={submit}>
    {error && <div role="alert" className="alert alert-danger">{error}</div>}
    <fieldset disabled={busy}>
      <div className="row g-3">{fields.map((field) => {
        const id = `${prefix}-${field.name}`
        const props = { id, name: field.name, value: values[field.name] ?? '', required: field.required, maxLength: field.maxLength, minLength: field.minLength, autoComplete: field.autoComplete,
          onChange: (event) => setValues({ ...values, [field.name]: field.type === 'checkbox' ? event.target.checked : event.target.value }) }
        return <div className={field.wide ? 'col-12' : 'col-12 col-md-6'} key={field.name}>
          {field.type === 'checkbox' ? <div className="form-check mt-3"><input {...props} type="checkbox" className="form-check-input" checked={Boolean(values[field.name])} /><label htmlFor={id} className="form-check-label">{field.label}</label></div> : <>
            <label htmlFor={id} className="form-label">{field.label}</label>
            {field.name === 'Pais' ? <CountrySelect {...props} /> : field.options ? <select {...props} className="form-select">{field.options.map((option) => <option key={option}>{option}</option>)}</select>
              : field.type === 'textarea' ? <textarea {...props} className="form-control" rows={3} />
                : <input {...props} className="form-control" type={field.type || 'text'} />}
          </>}
          {field.help && <p className="form-text">{field.help}</p>}
        </div>
      })}</div>
      {children}
      <div className="d-flex flex-wrap gap-2 mt-4"><button className="btn btn-primary" type="submit">{busy ? 'Guardando…' : submitLabel}</button>
        {onCancel && <button className="btn btn-outline-secondary" type="button" onClick={onCancel}>Cancelar</button>}
      </div>
    </fieldset>
  </form>
}

export function ProductImage({ src, name }) {
  const [failed, setFailed] = useState(false)
  if (!src || failed) return <div className="user-product-image text-secondary d-flex align-items-center justify-content-center">Sin imagen</div>
  return <img className="user-product-image" src={src} alt={name} loading="lazy" onError={() => setFailed(true)} />
}
