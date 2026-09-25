import { useState } from 'react'
import { loadCountries } from '../services/countryService.js'

export default function CountrySelect({ value = 'Guatemala', ...props }) {
  const [countries, setCountries] = useState([])
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState(false)
  async function load() {
    if (loading || countries.length) return
    setLoading(true); setError(false)
    try { setCountries(await loadCountries()) } catch { setError(true) }
    finally { setLoading(false) }
  }
  const options = [...new Set([value, 'Guatemala', ...countries].filter(Boolean))].sort((a, b) => a.localeCompare(b, 'es'))
  return <>
    <select {...props} value={value} className="form-select" onFocus={load} onPointerDown={load} onKeyDown={load} aria-busy={loading}>
      {!value && <option value="">Selecciona un país</option>}
      {options.map((country) => <option key={country} value={country}>{country}</option>)}
    </select>
    {loading && <small role="status">Cargando países…</small>}
    {error && <div role="alert" className="form-text text-danger">No se pudieron cargar los países. <button type="button" className="btn btn-link btn-sm" onClick={load}>Reintentar</button></div>}
  </>
}
