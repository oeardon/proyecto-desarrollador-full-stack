<?php
     function validarTexto($valor, $maximo, $opcional = false) {
          if ($opcional && $valor === null) return true;
          return is_string($valor) && ($opcional || trim($valor) !== "") && mb_strlen($valor, "UTF-8") <= $maximo;
     }

     function validarEntero($valor, $minimo = 1, $maximo = 2147483647) {
          return (is_int($valor) || is_string($valor)) &&
               filter_var($valor, FILTER_VALIDATE_INT) !== false &&
               $valor >= $minimo && $valor <= $maximo;
     }

     function validarMonto($valor) {
          return (is_string($valor) || is_int($valor) || is_float($valor)) && preg_match('/^\d{1,8}(\.\d{1,2})?$/D', (string) $valor) === 1 && $valor <= 99999999.99;
     }

     function validarFecha($valor) {
          if (!is_string($valor)) return false;
          $fecha = date_create_from_format('!Y-m-d H:i:s', $valor);
          return $fecha && $fecha->format('Y-m-d H:i:s') === $valor;
     }

     function validarOpcion($valor, $opciones) {
          return is_string($valor) && in_array($valor, $opciones, true);
     }
?>