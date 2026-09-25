import react from '@vitejs/plugin-react'
import { defineConfig } from 'vite'

async function detectarServidorApi() {
  const servidores = ['http://localhost', 'http://localhost:8080']
  const errores = []

  for (const servidor of servidores) {
    try {
      const respuesta = await fetch(`${servidor}/tienda_online/api/categorias/index.php`, {
        signal: AbortSignal.timeout(3000),
        redirect: 'error',
      })
      if (!respuesta.ok) throw new Error(`HTTP ${respuesta.status}`)
      const contenido = await respuesta.json()
      if (contenido?.success !== true || !Array.isArray(contenido.data)) {
        throw new Error('La respuesta no corresponde al listado de categorías')
      }
      console.info(`[Vite] API: ${servidor}`)
      return servidor
    } catch (error) {
      errores.push(`${servidor}: ${error.message}`)
    }
  }

  throw new Error(`No se pudo conectar con la API. Comprueba Apache y MariaDB.\n${errores.join('\n')}`)
}

export default defineConfig(async ({ command, isPreview }) => {
  // La compilación y la vista previa no necesitan consultar la API.
  const target = command === 'serve' && !isPreview
    ? await detectarServidorApi()
    : 'http://localhost'

  return {
    plugins: [react()],
    server: {
      host: 'localhost',
      port: 5173,
      proxy: {
        '/tienda_online/public/uploads/resenas': { target, changeOrigin: true },
        '/tienda_online/api': {
          target,
          changeOrigin: true,
        },
      },
    },
  }
})
