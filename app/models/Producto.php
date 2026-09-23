<?php 
     function obtenerTodosProductos($conexion) {
          $sql = "SELECT P.ProductoID,
                         P.CategoriaID,
                         P.SKU,
                         P.Nombre,
                         P.Descripcion,
                         P.Precio,
                         P.Cantidad,
                         P.Imagen,
                         P.Estado,
                         P.FechaRegistro,
                         C.Nombre AS Categoria
                  FROM Productos P
                  INNER JOIN Categorias C
                     ON P.CategoriaID = C.CategoriaID
                  ORDER BY P.ProductoID ASC";
          $consulta = $conexion->prepare($sql);
          $consulta->execute();
          return $consulta->fetchAll();
     }

     function obtenerProductoPorId($conexion, $ProductoID) {
          $sql = "SELECT P.ProductoID,
                         P.CategoriaID,
                         P.SKU,
                         P.Nombre,
                         P.Descripcion,
                         P.Precio,
                         P.Cantidad,
                         P.Imagen,
                         P.Estado,
                         P.FechaRegistro,
                         C.Nombre AS Categoria
                  FROM Productos P
                  INNER JOIN Categorias C
                     ON P.CategoriaID = C.CategoriaID
                  WHERE P.ProductoID = :ProductoID";
          $stmt = $conexion->prepare($sql);
          $stmt->execute([":ProductoID" => $ProductoID]);
          return $stmt->fetch();
     }

     function crearProducto($conexion, $datos) {
          $sql = "INSERT INTO Productos(CategoriaID, SKU, Nombre, Descripcion, Precio, Cantidad, Imagen)
                  VALUES (:CategoriaID, :SKU, :Nombre, :Descripcion, :Precio, :Cantidad, :Imagen)";
          $stmt = $conexion->prepare($sql);
          $stmt->execute([":CategoriaID" => $datos["CategoriaID"],
                          ":SKU" => $datos["SKU"] ?? null,
                          ":Nombre" => $datos["Nombre"],
                          ":Descripcion" => $datos["Descripcion"] ?? null,
                          ":Precio" => $datos["Precio"],
                          ":Cantidad" => $datos["Cantidad"] ?? 0,
                          ":Imagen" => $datos["Imagen"] ?? null]);
          return $conexion->lastInsertId();
     }

     function actualizarProducto($conexion, $ProductoID, $datos) {
          $sql = "UPDATE Productos
                  SET CategoriaID = :CategoriaID,
                      SKU = :SKU,
                      Nombre = :Nombre,
                      Descripcion = :Descripcion,
                      Precio = :Precio,
                      Cantidad = :Cantidad,
                      Imagen = :Imagen,
                      Estado = :Estado
                  WHERE ProductoID = :ProductoID";
          $stmt = $conexion->prepare($sql);
          return $stmt->execute([":CategoriaID" => $datos["CategoriaID"],
                                 ":SKU" => $datos["SKU"],
                                 ":Nombre" => $datos["Nombre"],
                                 ":Descripcion" => $datos["Descripcion"],
                                 ":Precio" => $datos["Precio"],
                                 ":Cantidad" => $datos["Cantidad"],
                                 ":Imagen" => $datos["Imagen"],
                                 ":Estado" => $datos["Estado"],
                                 ":ProductoID" => $ProductoID]);
     }

     function eliminarProducto($conexion, $ProductoID) {
          $sql = "DELETE FROM Productos
                  WHERE ProductoID = :ProductoID";
          $stmt = $conexion->prepare($sql);
          $stmt->execute([":ProductoID" => $ProductoID]);
          return $stmt->rowCount() > 0;
     }
     /* obtenerProductosPorCategoria()
        buscarProductos()
        obtenerProductosActivos()
        obtenerProductosConPromocion() */
?>