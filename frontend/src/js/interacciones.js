export function iniciarInteraccionesGlobales() {
  const header = document.querySelector('[data-site-header]')
  const backToTop = document.querySelector('[data-back-to-top]')

  const onScroll = () => {
    header?.classList.toggle('is-scrolled', window.scrollY > 18)
    backToTop?.classList.toggle('is-visible', window.scrollY > 500)
  }

  window.addEventListener('scroll', onScroll, { passive: true })
  onScroll()

  const revealItems = [...document.querySelectorAll('.reveal-item')]
  let observer
  if ('IntersectionObserver' in window) {
    observer = new IntersectionObserver((entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          entry.target.classList.add('is-visible')
          observer.unobserve(entry.target)
        }
      })
    }, { threshold: 0.12, rootMargin: '0px 0px -35px 0px' })
    revealItems.forEach((item) => observer.observe(item))
  } else {
    revealItems.forEach((item) => item.classList.add('is-visible'))
  }

  const dropdownToggles = [...document.querySelectorAll('.dropdown-shop__toggle')]
  const onDropdown = (event) => {
    if (window.innerWidth > 900) return
    const parent = event.currentTarget.closest('.dropdown-shop')
    parent?.classList.toggle('is-mobile-open')
  }
  dropdownToggles.forEach((toggle) => toggle.addEventListener('click', onDropdown))

  const onEscape = (event) => {
    if (event.key === 'Escape') window.dispatchEvent(new CustomEvent('todoaqui:escape'))
  }
  document.addEventListener('keydown', onEscape)

  return () => {
    window.removeEventListener('scroll', onScroll)
    document.removeEventListener('keydown', onEscape)
    dropdownToggles.forEach((toggle) => toggle.removeEventListener('click', onDropdown))
    observer?.disconnect()
  }
}
