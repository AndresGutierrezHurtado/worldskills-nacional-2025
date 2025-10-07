# LISTADO DE PETICIONES

Se realizo utilizando el servidor apache de xampp, con la ruta base de  



Se utilizó POO como paradigma de programación con un patrón arquitectónico de modelo vista controlador, donde se validan campos, se tiene manejo de errores y tiene una clara separacion de responsabilidades

`/models` esta las entidades encargada de la persistencia

`/controllers` esta se encarga de la logica

`/core` estan configuracion, punto de carga y utilidades

`/server/backup.json` es el punto de inicio para la información

`/server/movies.json` es el almacenamiento de la información

**Los cambios realizados en `movies.json` se veran en el source control `Ctrl+Shift+G`**

**Si el archivo `movies.json` está vacio o eliminado, se regenera otra vez su estructura**

---

## EJECUTAR

1. tener corriendo el xampp con apache

2. Ejecutar los endpoints en postman, cada endpoint está en una TAB

---

## OBTENER TODAS

`GET` http://localhost/api-peliculas/api/movies

## OBTENER POR ID

* __El ID debe ser numerico__

`GET` http://localhost/api-peliculas/api/movies/{id}

## OBTENER POR GENERO

* __ordenados por valoracion__
* __la busqueda es exacta__

`GET` http://localhost/api-peliculas/api/movies/genre/{genero}

## CREAR

* __El Titulo es obligatorio__

`POST` http://localhost/api-peliculas/api/movies

```
{
    "titulo": "NUEVA PELICULA3A 2222",
    "director": "Andrés Gutiérrez Hurtado"
}
```
## ACTUALIZAR POR ID

* __No se puede actualizar ID__
* __No se puede actualizar timestamps__
* __La actualizacion es parcial__

`PUT` http://localhost/api-peliculas/api/movies/33

```
{
    "titulo": "editado 3"
}
```

## ELIMINAR POR ID

`DELETE` http://localhost/api-peliculas/api/movies/3