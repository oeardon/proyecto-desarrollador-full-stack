const regionNames = new Intl.DisplayNames(['es'], { type: 'region' })
const countries = new Set(['Guatemala'])
for (let a = 65; a <= 90; a++) for (let b = 65; b <= 90; b++) countries.add(regionNames.of(String.fromCharCode(a, b)))

export function addressParts(value = '') {
  const original = String(value ?? '')
  const parts = original.split(',').map((part) => part.trim())
  const country = countries.has(parts.at(-1)) ? parts.pop() : original ? '' : 'Guatemala'
  // Older free-form addresses may not contain city/department: keep their text intact.
  const department = country && parts.length >= 3 ? parts.pop() : ''
  const city = department ? parts.pop() : ''
  return { address: parts.join(', '), city, department, country, original, changed: false }
}

export function formatAddress(value) {
  if (typeof value === 'string') return value
  if (!value) return ''
  if (!value.changed && value.original) return value.original
  const parts = [value.address, value.city, value.department].map((part) => (part ?? '').trim())
  if (!parts.some(Boolean)) return ''
  return [...parts, (value.country ?? '').trim()].filter(Boolean).join(', ')
}
