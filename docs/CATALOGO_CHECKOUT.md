# Catálogo y checkout

## Flujo implementado

El inicio y el encabezado consultan `api/catalogo/index.php`: productos activos, categorías activas (incluidos sus padres), imágenes, descripción, stock, calificaciones y número real de reseñas publicadas. La consulta local confirmó 108 productos y 48 categorías.

Los enlaces del encabezado y del pie usan filtros reales:

- `/?categoria=ID#productos`: categoría y descendientes.
- `/?q=texto#productos`: búsqueda por nombre, categoría y descripción.
- `/?vista=novedades#productos`: fecha de incorporación descendente.
- `/?vista=vendidos#productos`: unidades en órdenes Confirmada, Procesando, Enviada o Entregada.
- `/?vista=ofertas#productos`: promociones activas y vigentes sin cupón.

Se aplica la mejor promoción elegible por producto, sin acumular descuentos. Los descuentos de porcentaje se calculan con BCMath y se truncan a dos decimales. El precio final no puede ser negativo. Las promociones con cupón no se muestran como descuentos automáticos. El catálogo y el checkout comparten esta regla.

Los favoritos requieren sesión y utilizan la lista de deseos persistida en MariaDB. Las referencias antiguas a productos de ejemplo ya no se utilizan en el inicio. Los banners siguen siendo material visual; se retiraron importes y porcentajes promocionales inventados, y la suscripción simulada se sustituyó por un acceso a novedades del catálogo.

## Carrito y compra

El carrito conserva solamente identificadores y cantidades en `localStorage`; nombres, imágenes y precios se obtienen del catálogo. Finalizar compra abre `/checkout`. El usuario puede iniciar sesión allí o registrarse desde Mi cuenta y regresar a la compra.

El checkout permite:

1. Revisar productos, ajustar cantidades o eliminarlos y actualizar precios/existencias.
2. Seleccionar direcciones propias guardadas o escribir direcciones de envío y facturación. Las direcciones escritas quedan como copia en la orden, sin agregarse automáticamente a Direcciones.
3. Indicar nombre de facturación y NIT/CF.
4. Elegir Efectivo al recibir o Transferencia bancaria. Ambos crean un pago Pendiente; no existe cobro con tarjeta ni integración bancaria.
5. Confirmar y consultar una página persistente con el número de pedido, factura y detalle.

Envío e impuestos adicionales mantienen el valor actual de cero; el resumen lo muestra antes de confirmar. No se incorporaron tasas, recargos ni reglas fiscales nuevas. La factura es el documento interno del proyecto.

## API y consistencia

`POST api/checkout/index.php` recibe `SolicitudID` (32 caracteres hexadecimales), NombreFactura, NIT, MetodoPago, DireccionEnvio, DireccionPago, DireccionEnvioID/DireccionPagoID opcionales y Detalles con ProductoID, Cantidad y PrecioEsperado.

El servidor obtiene el propietario y correo de la sesión, valida las direcciones guardadas, bloquea productos en orden de ID, verifica stock y recalcula los importes. PrecioEsperado únicamente detecta cambios que deben ser revisados por el cliente: nunca sustituye el precio del servidor. Campos como UsuarioID y Total se rechazan.

Una única transacción guarda Ordenes, DetalleOrdenes, Facturas, DetalleFacturas y Pagos, y descuenta stock. El pedido comienza Pendiente. Una falla revierte todas las escrituras.

No se cambiaron tablas ni se requiere una migración. Para persistir la protección contra duplicados se utiliza:

- `Facturas.NumeroFactura = TA-<SolicitudID>`, con su restricción UNIQUE existente.
- `Facturas.Notas` contiene metadatos JSON de checkout: huella de la solicitud y estado del correo. Estos metadatos deben conservarse.
- Bloqueo del usuario para serializar los intentos, incluso desde sesiones diferentes.

Reenviar el mismo identificador y datos devuelve la orden existente sin descontar stock ni enviar otro correo. Un identificador ya registrado con otros datos devuelve 409. El navegador conserva el intento en `sessionStorage` hasta recibir una confirmación o un rechazo definitivo; una respuesta perdida ofrece recuperar o completar ese mismo intento.

`GET api/checkout/index.php?solicitud=TOKEN` consulta la confirmación del propietario. La interfaz la muestra en `/checkout?pedido=TOKEN`. Un tercero no puede consultar el pedido con el token. Al completarse una compra se retiran del carrito las cantidades compradas.

## Correo: Ethereal activado en esta instalacion

Se siguió `PROYECTO/Guia envio confirmacion pedido.pdf`: PHPMailer mediante SMTP, destinatario de la cuenta, resumen real, validación en PHP y envío posterior al registro. Referencia de la biblioteca: https://github.com/PHPMailer/PHPMailer

PHPMailer está declarado en Composer y su versión está fijada en composer.lock. En otra instalación ejecutar `composer install`.

La configuracion local ahora utiliza Ethereal, con STARTTLS en el puerto 587, a partir del CSV proporcionado por el usuario. La conexion y autenticacion SMTP se verificaron sin enviar mensajes. Ethereal captura las confirmaciones en su bandeja de pruebas y no las entrega al destinatario real.

Los archivos config/SMTPcredentials.csv y config/mail.local.php estan ignorados por Git y protegidos contra descarga HTTP mediante config/.htaccess (verificado: HTTP 403). Debe conservarse esta proteccion al subir el proyecto a Apache; otros servidores requieren una regla equivalente.

En una nueva instalacion, el correo permanece desactivado hasta proporcionar configuracion privada. Para configurarlo:

1. Copiar `config/mail.local.example.php` a `config/mail.local.php`.
2. Completar host, puerto, usuario, contraseña de aplicación, remitente y cifrado.
3. Activar enabled. Para Gmail, el ejemplo usa smtp.gmail.com, puerto 587 y tls.

El archivo privado está ignorado por Git. También se admiten las variables de entorno SMTP_ENABLED, SMTP_HOST, SMTP_PORT, SMTP_USERNAME, SMTP_PASSWORD, SMTP_ENCRYPTION, SMTP_FROM y SMTP_FROM_NAME. PHP no carga archivos .env automáticamente.

El envío sucede después del commit. Un fallo SMTP nunca cancela una orden guardada ni pide al usuario comprar otra vez. El resultado distingue enviado, no_configurado, fallido o pendiente. No se reenvía automáticamente un correo al recuperar una solicitud. Los mensajes incluyen versión HTML con textos escapados y versión de texto; no contienen credenciales. No se enviaron correos externos durante las pruebas.

## Validación

- Lint y compilación del frontend correctos.
- Sintaxis PHP de los archivos nuevos correcta.
- `python tests/test_api.py --checkout-only`: 42 respuestas HTTP y comprobaciones SQL en una base temporal. Valida catálogo, promociones, stock, direcciones ajenas, manipulación de importes, atomicidad, idempotencia, recuperación y SMTP local (incluido fallo de conexión sin perder la compra).
- `node tests/checkout_ui.cjs <ruta-playwright>`: API simulada, filtros, favoritos, carrito persistente, autenticación, direcciones/facturación, forma de pago, respuesta perdida seguida de recarga, ausencia de duplicados y móvil.
- `node tests/user_ui.cjs <ruta-playwright>`: regresión del panel de usuario correcta.
- Capturas de checkout en escritorio y móvil revisadas.
- Consulta de catálogo real de solo lectura: 108 productos y 48 categorías. Ninguna compra de prueba se realizó en todoaqui_db.

La carpeta tests/ continúa ignorada por Git; sus scripts y capturas permanecen locales.
