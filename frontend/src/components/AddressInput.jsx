import { useState } from 'react'
import CountrySelect from './CountrySelect.jsx'

// These records store the complete address in a single database column.
export default function AddressInput({ value, onChange, maxLength = 255, ...props }) {
  const [country, setCountry] = useState(() => {
    const last = value.split(',').at(-1).trim()
    const names = new Intl.DisplayNames(['es'], { type: 'region' })
    for (let a = 65; a <= 90; a++) for (let b = 65; b <= 90; b++) {
      const code = String.fromCharCode(a, b)
      if (names.of(code) === last) return last
    }
    return value ? '' : 'Guatemala'
  })
  const suffix = `, ${country}`
  const text = country && value.endsWith(suffix) ? value.slice(0, -suffix.length) : value
  function update(address, nextCountry) {
    onChange({ target: { value: address.trim() ? [address, nextCountry].filter(Boolean).join(', ') : '' } })
  }
  return <>
    <input {...props} value={text} className="form-control" maxLength={maxLength - country.length - 2} onChange={(event) => update(event.target.value, country)} />
    <label htmlFor={`${props.id}-country`} className="form-label mt-2">País</label>
    <CountrySelect id={`${props.id}-country`} value={country} disabled={props.disabled} onChange={(event) => { setCountry(event.target.value); update(text, event.target.value) }} />
  </>
}
