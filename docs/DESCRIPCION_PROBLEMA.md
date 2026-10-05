# Problema y alcance de TodoAquí

## Contexto

Una tienda necesita reunir catálogo, inventario, clientes, pedidos y seguimiento. Gestionarlos por separado dificulta consultar existencias y mantener información consistente entre compras, documentos y atención posterior.

## Objetivo

Desarrollar un proyecto académico FullStack con interfaz responsiva, API con permisos y almacenamiento persistente para demostrar el recorrido desde la búsqueda de productos hasta la compra simulada y su gestión posterior.

## Solución implementada

React presenta catálogo, búsqueda, filtros, promociones, vista rápida, carrito y favoritos. Los usuarios se registran, inician sesión, gestionan perfil/direcciones, consultan órdenes y solicitan devoluciones. Checkout registra orden, factura interna y pago pendiente, descuenta inventario y puede enviar una confirmación capturada por Ethereal.

PHP valida permisos y reglas. MariaDB conserva datos transaccionales y MongoDB Atlas las reseñas de productos, con moderación e imágenes opcionales. El administrador gestiona 17 recursos y sus relaciones/detalles. Un servicio de países apoya los formularios de dirección.

## Límites

No hay cobros/reembolsos bancarios ni facturación fiscal. Crear una compra académica sí escribe datos y modifica existencias. Las propuestas de analítica NoSQL no están implementadas. La recuperación de contraseña por correo no forma parte del flujo actual.

La versión local es el entregable vigente. Los ajustes de hosting fueron revertidos intencionalmente; `build` conserva la copia publicada y queda fuera de este alcance. Véanse [estado](TRANSFERENCIA_ESTADO.md) y [backlog](PRODUCT_BACKLOG.md).

[Volver al índice documental](README.md).
