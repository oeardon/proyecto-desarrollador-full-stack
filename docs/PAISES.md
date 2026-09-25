# Países en formularios

Los campos País de direcciones de usuario y administración usan CountrySelect. También se incluye en direcciones manuales de envío y facturación del checkout y en direcciones de proveedores, órdenes y facturas del administrador. En estos últimos registros el país se conserva dentro del texto de dirección, sin cambiar el esquema de la base de datos. Las direcciones existentes no se sobrescriben al abrir el formulario.

Las direcciones nuevas parten de Guatemala. Al enfocar o pulsar el selector se carga la lista completa y se ordena con la configuración regional española. Se conservan valores antiguos aunque no estén en el catálogo. Si falla la carga, se mantiene el valor actual y se ofrece Reintentar.

El endpoint api/paises/index.php consulta REST Countries v5 en páginas de 100 con offset sucesivos. Solicita names.translations.spa.common para incluir también territorios sin código ISO. La llave permanece en config/api_keys.php y nunca se entrega al navegador.

La lista completa se almacena durante 24 horas en el directorio temporal de PHP; un bloqueo evita descargas simultáneas. El proceso PHP necesita permiso de escritura en ese directorio. El navegador comparte una única petición entre selectores durante la sesión de la aplicación. No se cachean respuestas parciales ni fallidas.

Referencia de paginación: https://restcountries.com/docs/countries

Verificación: consulta real de 254 registros, todos con traducción española; sintaxis PHP, compilación Vite, ESLint y prueba de navegador con checkout simulado. La prueba comprueba carga diferida, Guatemala inicial, orden alfabético, España y Abjasia, y selección de México conservada en la dirección de facturación.
