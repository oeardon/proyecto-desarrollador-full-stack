const API_ORDENES = '/api/ordenes/'

async function leerRespuesta(respuesta) {
  let resultado
  try {
    resultado = await respuesta.json()
  } catch {
    const error = new Error('El servidor no devolvió una respuesta JSON válida')
    error.status = respuesta.status
    throw error
  }

  if (!respuesta.ok || !resultado?.success) {
    const error = new Error(resultado?.message || 'No se pudo completar la compra')
    error.status = respuesta.status
    throw error
  }

  return resultado
}

export async function crearOrden({ direccionEnvio, direccionPago, cart }) {
  const detalles = cart.map((item) => ({
    ProductoID: item.id,
    Cantidad: item.quantity,
  }))

  let respuesta
  try {
    respuesta = await fetch(API_ORDENES, {
      method: 'POST',
      credentials: 'include',
      headers: {
        Accept: 'application/json',
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        DireccionEnvio: direccionEnvio.trim(),
        DireccionPago: direccionPago.trim(),
        Detalles: detalles,
      }),
    })
  } catch {
    const error = new Error('No se pudo conectar con el servidor')
    error.status = 0
    throw error
  }

  return leerRespuesta(respuesta)
}
