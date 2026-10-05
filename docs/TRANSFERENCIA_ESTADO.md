# Estado vigente — TodoAquí

Actualizado el 26 de septiembre de 2026 con las aclaraciones del propietario y la inspección de archivos. Esta versión sustituye la interpretación anterior de una diferencia de copia de causa desconocida.

## Decisiones confirmadas por el usuario

- Se eliminó el vínculo Git porque otro colaborador subió cambios de configuración React que causaban conflictos.
- Se revirtieron intencionalmente las adaptaciones de hosting para entregar una copia completa funcionando localmente.
- La copia vigente local está en `C:\xampp\htdocs\tienda_online`.
- El usuario comprobó conexión a MongoDB Atlas y creación de una orden con envío capturado por Ethereal.
- `build` contiene los archivos que se subieron al hosting. No sustituye la aplicación local.
- El sitio publicado ya dispone de certificado SSL validado, según confirmación del usuario.

## Estado observado en archivos

No hay repositorio Git reconocible. Las reseñas usan `ResenasMongo.php`; no se necesita recuperar el selector MariaDB que se había creado para hosting. Checkout conserva `crypto.randomUUID()` y el backend utiliza nombres SQL PascalCase de la instalación local. Estas diferencias respecto al hosting no son por sí mismas trabajo pendiente.

Composer requiere mongodb/mongodb `^2.4` y PHPMailer `^7.1`. Las dependencias y requisitos se detallan en [Instalación](INSTALACION_LOCAL.md). El correo se configura con entorno y `mail.local.php`; no imprimir secretos. La documentación actual cubre funcionalidades/directorios, excepto `INFORME` y `build`.

## Hosting e historia

El dominio informado es `proyecto6-dfs-intecap2026.x10.mx`. Antes existieron adaptaciones específicas de tablas SQL, reseñas MariaDB y compatibilidad del frontend. No trasladarlas de nuevo al entregable por inferencia.

El problema anterior `SMTP_TLS` pertenecía al correo del hosting. La validación HTTPS informada no confirma el estado del SMTP, que utiliza una conexión independiente. No hay confirmación posterior de resolución SMTP en hosting. No deshabilitar validación TLS por suposición.

Esta revisión no inspecciona ni modifica `build`, ni comprueba conexiones externas. Véase [URLs](URLS_ENTREGA.md).

## Pendientes reales de documentación/evidencia

- No está `frontend/public/creditos-imagenes.html`, aunque existe el enlace en el pie. Las fuentes están parcialmente conservadas en el mapa de imágenes; no inventar una galería como si ya existiera.
- No están el PDF EER ni `database/modelo_nosql.json` citados antiguamente. Hay modelo SQL y explicación/diagramas en [Base de datos](BASE_DATOS.md) y [NoSQL](MODELO_NOSQL.md).
- El script `test:structure` apunta a una prueba ausente. Las limitaciones de pruebas se registran en [CASOS_PRUEBA.md](CASOS_PRUEBA.md).
- Las evidencias de validación de requisitos con clientes y capturas finales deben aportarse realmente.

## Continuación

Usar esta copia para trabajo local. No recrear Git, aplicar ajustes de hosting, importar bases ni enviar correos como consecuencia de leer esta transferencia. Trabajar en español, no delegar sin solicitud y respetar datos y fotografías. Las guías no certifican que toda suite histórica pase en esta copia.

El ejecutor aislado ha fallado con `helper_unknown_error`; se realizaron lecturas/escrituras documentales mediante comandos autorizados fuera del aislamiento. Rutas habituales: PHP `C:\xampp\php\php.exe` y MySQL `C:\xampp\mysql\bin\mysql.exe`.

[Volver al índice documental](README.md).
