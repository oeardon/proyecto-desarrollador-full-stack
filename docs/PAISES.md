# Países en formularios

Revisión documental: 26/09/2026, sobre la copia local. Las validaciones anteriores se conservan como antecedentes; no se repitieron durante esta actualización.

Los campos País de direcciones de usuario y administración usan CountrySelect. También se incluye en direcciones manuales de envío y facturación del checkout y en direcciones de proveedores, órdenes y facturas del administrador. En estos últimos registros el país se conserva dentro del texto de dirección, sin cambiar el esquema de la base de datos. Las direcciones existentes no se sobrescriben al abrir el formulario.

Las direcciones nuevas parten de Guatemala. Al enfocar o pulsar el selector se carga la lista completa y se ordena con la configuración regional española. Se conservan valores antiguos aunque no estén en el catálogo. Si falla la carga, se mantiene el valor actual y se ofrece Reintentar.

El endpoint api/paises/index.php consulta REST Countries v5 en páginas de 100 con offset sucesivos. Solicita names.translations.spa.common para incluir también territorios sin código ISO. La llave permanece en config/api_keys.php y nunca se entrega al navegador.

La lista completa se almacena durante 24 horas en el directorio temporal de PHP; un bloqueo evita descargas simultáneas. El proceso PHP necesita permiso de escritura en ese directorio. El navegador comparte una única petición entre selectores durante la sesión de la aplicación. No se cachean respuestas parciales ni fallidas.

Referencia de paginación: https://restcountries.com/docs/countries

Verificación histórica (no repetida en esta revisión): consulta real de 254 registros, todos con traducción española; sintaxis PHP, compilación Vite, ESLint y prueba de navegador con checkout simulado. La prueba comprueba carga diferida, Guatemala inicial, orden alfabético, España y Abjasia, y selección de México conservada en la dirección de facturación.

## Actualización de caché y fallos

La escritura se verifica y se publica mediante un archivo temporal y renombrado. Si falla, se conserva la caché anterior y se responde 503. Una lista vencida no se sirve.

El bloqueo es no bloqueante: las solicitudes concurrentes reciben 503 con Retry-After: 60 mientras otra actualiza la lista. Si falla el proveedor o el guardado, se espera 60 segundos antes de otra descarga. Antes de consultar se persiste una protección de 180 segundos por si el proceso termina inesperadamente. Una caché vigente se devuelve aunque exista ese plazo. El bloqueo se libera siempre y los temporales fallidos se eliminan.

## Dirección, ciudad y departamento

Las direcciones manuales del checkout y los campos de dirección de proveedores, altas de órdenes y altas de facturas utilizan cuatro controles: Dirección, Ciudad, Departamento y País. Al enviar se concatenan, en ese orden, separados por coma y espacio. Se recortan los espacios al principio y al final de cada parte y se valida el máximo de 255 caracteres del texto completo. Se mantienen las columnas y contratos actuales de la API.

Las direcciones guardadas del checkout se muestran desglosadas y de solo lectura; para introducir otra se elige Escribir otra dirección. La opción de usar la misma dirección para facturación se mantiene. Los registros antiguos conservan su texto original si no se modifica la dirección. Al editar una dirección con país reconocido y al menos tres partes previas, las últimas dos se muestran como Ciudad y Departamento; las anteriores permanecen juntas como Dirección. Si el texto antiguo no permite ese desglose, se conserva en Dirección y se completan los campos al modificarlo.

Las reglas de edición no cambian: las órdenes permiten cambiar su estado y las facturas permiten anularse. El CRUD de Direcciones mantiene sus columnas separadas. Validación histórica, no repetida en esta revisión: lint, compilación y pruebas de navegador con API simulada para checkout, altas de órdenes/facturas, edición de proveedores, conservación de texto antiguo, validación y pantalla móvil.

## Integración local

`countryService.js` solicita `/tienda_online/api/paises/`; Apache resuelve index.php mediante DirectoryIndex. Esta copia no utiliza el ajuste de URL explícita que se había hecho para hosting. `api/paises/restcountries.php` es una muestra auxiliar, no el endpoint del selector. cURL, clave privada y caché escribible son requisitos; véase [Instalación](INSTALACION_LOCAL.md).

[Volver al índice documental](README.md).
