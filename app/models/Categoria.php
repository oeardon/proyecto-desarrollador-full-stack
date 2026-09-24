<?php 
     function obtenerCategorias($conexion) {
          $sql = "SELECT *
                  FROM Categorias
                  ORDER BY CategoriaID ASC";
          $consulta = $conexion->prepare($sql);
          $consulta->execute();
          return $consulta->fetchAll();
     }

     function obtenerCategoriaPorId($conexion, $CategoriaID) {
          $sql = "SELECT *
                  FROM Categorias
                  WHERE CategoriaID = :CategoriaID";
          $stmt = $conexion->prepare($sql);
          $stmt->execute([":CategoriaID" => $CategoriaID]);
          return $stmt->fetch();
     }

     function crearCategoria($conexion, $datos) {
          $sql = "INSERT INTO Categorias (Nombre, Descripcion, Estado, CategoriaPadreID)
                  VALUES (:Nombre, :Descripcion, :Estado, :CategoriaPadreID)";
          $stmt = $conexion->prepare($sql);
          $stmt->execute([":Nombre" => $datos["Nombre"],
                          ":Descripcion" => $datos["Descripcion"],
                          ":Estado" => $datos["Estado"],
                          ":CategoriaPadreID" => $datos["CategoriaPadreID"]]);
          return $conexion->lastInsertId();
     }

     function actualizarCategoria($conexion, $CategoriaID, $datos) {
          $sql = "UPDATE Categorias
                  SET Nombre = :Nombre,
                      Descripcion = :Descripcion,
                      Estado = :Estado,
                      CategoriaPadreID = :CategoriaPadreID
                  WHERE CategoriaID = :CategoriaID";
          $stmt = $conexion->prepare($sql);
          return $stmt->execute([":Nombre" => $datos["Nombre"],
                                 ":Descripcion" => $datos["Descripcion"],
                                 ":Estado" => $datos["Estado"],
                                 ":CategoriaPadreID" => $datos["CategoriaPadreID"],
                                 ":CategoriaID" => $CategoriaID]);
     }

     function eliminarCategoria($conexion, $CategoriaID) {
          $sql = "DELETE FROM Categorias
                  WHERE CategoriaID = :CategoriaID";
          $stmt = $conexion->prepare($sql);
          $stmt->execute([":CategoriaID" => $CategoriaID]);
          return $stmt->rowCount() > 0;
     }
     function bloquearCategorias($conexion) {
          $sql = "SELECT *
                  FROM Categorias
                  ORDER BY CategoriaID ASC FOR UPDATE";
          $stmt = $conexion->prepare($sql);
          $stmt->execute();
          return $stmt->fetchAll();
     }
?>