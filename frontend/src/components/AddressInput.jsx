import { useEffect, useRef } from 'react'
import CountrySelect from './CountrySelect.jsx'
import { formatAddress } from '../services/addressFormat.js'

export default function AddressInput({ value, onChange, maxLength = 255, id, name, required = false, disabled = false, readOnly = false }) {
  const input = useRef(null)
  const fullAddress = formatAddress(value)
  const error = fullAddress.length > maxLength ? `La dirección completa debe tener como máximo ${maxLength} caracteres.` : ''
  const completeRequired = !readOnly && (required || Boolean(fullAddress)) && (!value.original || value.changed)
  useEffect(() => { input.current.setCustomValidity(error) }, [error])
  function update(field, text) {
    onChange({ target: { value: { ...value, [field]: text, changed: true } } })
  }
  return <>
    <input ref={input} id={id} name={name} type="text" value={value.address} className="form-control" maxLength={maxLength} required={required || completeRequired} disabled={disabled} readOnly={readOnly} autoComplete="address-line1" pattern=".*\S.*" aria-describedby={`${id}-help`} onChange={(event) => update('address', event.target.value)} />
    <div className="row g-2 mt-1">
      <div className="col-12 col-sm-6"><label htmlFor={`${id}-city`} className="form-label">Ciudad{completeRequired ? ' *' : ''}</label><input id={`${id}-city`} type="text" className="form-control" value={value.city} maxLength={75} required={completeRequired} disabled={disabled} readOnly={readOnly} autoComplete="address-level2" pattern=".*\S.*" onChange={(event) => update('city', event.target.value)} /></div>
      <div className="col-12 col-sm-6"><label htmlFor={`${id}-department`} className="form-label">Departamento{completeRequired ? ' *' : ''}</label><input id={`${id}-department`} type="text" className="form-control" value={value.department} maxLength={100} required={completeRequired} disabled={disabled} readOnly={readOnly} autoComplete="address-level1" pattern=".*\S.*" onChange={(event) => update('department', event.target.value)} /></div>
    </div>
    <label htmlFor={`${id}-country`} className="form-label mt-2">País{completeRequired ? ' *' : ''}</label>
    <CountrySelect id={`${id}-country`} value={value.country} required={completeRequired} disabled={disabled || readOnly} autoComplete="country-name" onChange={(event) => update('country', event.target.value)} />
    <div id={`${id}-help`} className={`form-text${error ? ' text-danger' : ''}`}>{error || `Dirección, ciudad, departamento y país: máximo ${maxLength} caracteres en total.`}</div>
  </>
}
