<?php /*
     $ch = curl_init('https://api.restcountries.com/countries/v5?q=canada');
     curl_setopt($ch, CURLOPT_HTTPHEADER, ['Authorization: Bearer rc_live_0d1b07baff444ad6a400cf329db784d7']);
     curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
     $data = json_decode(curl_exec($ch), true);
?>
<script> /*
     fetch(
          'https://api.restcountries.com/countries/v5?q=canada',
          { headers: { 'Authorization': 'Bearer rc_live_0d1b07baff444ad6a400cf329db784d7' } }
     )
     .then(function (response) { return response.json(); })
     .then(function (data) { console.log(data); });
</script>

fetch(
    "http://localhost/tienda_online/api/paises/"
)
     .then((response) => response.json())
     .then((respuesta) => {
          console.log(respuesta.data);
     });

<select name="Pais" value={Pais} onChange={manejarCambio}>
    <option value="">Seleccione un país</option>
    {paises.map((pais) => (
        <option key={pais.Codigo} value={pais.Nombre}>
            {pais.Bandera} {pais.Nombre}
        </option>
    ))}
</select>
*/