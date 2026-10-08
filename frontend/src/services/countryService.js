let pending
const names = new Intl.DisplayNames(['es'], { type: 'region' })
export function loadCountries() {
  if (!pending) pending = fetch('/proyecto-desarrollador-full-stack/api/paises/', { signal: AbortSignal.timeout(60000) })
    .then(async (response) => {
      const result = await response.json()
      if (!response.ok || !result.success || !Array.isArray(result.data) || !result.data.length) throw new Error('No se pudieron cargar los países.')
      return [...new Set(result.data.map((country) => country.names?.translations?.spa?.common || names.of(country.codes.alpha_2)))].sort((a, b) => a.localeCompare(b, 'es'))
    }).catch((error) => { pending = undefined; throw error })
  return pending
}
