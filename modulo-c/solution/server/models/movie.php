<?php

class Movie {
    private $movies;

    public function __construct() {
        $this->movies = FileMovies::getFileInfo();
    }

    // FUNCION PARA OBTENER TODAS LAS PELICULAS DEL ARCHIVO
    public function getAll(): array
    {
        return $this->movies;
    }

    // FUNCION PARA OBTENER UNA PELICULA POR ID DEL ARCHIVO
    public function getById(?int $id): ?array
    {
        if (!$id) return null;

        foreach ($this->movies as $movie) {
            if ($movie["id"] == $id) return $movie;
        }

        return null;
    }

    // FUNCION PARA OBTENER LAS PELICULAS QUE PERTENECEN A UN GENERO
    public function getByGenre($genre): ?array
    {
        if (!$genre) return null;

        $final = [];

        foreach ($this->movies as $movie) {
            if (!arrayIncludes($movie["generos"], $genre)) continue;
            $final[] = $movie;
        }

        usort($final, function ($el, $el2) {
            return $el["valoracion"] < $el2["valoracion"];
        });

        return $final;
    }

    // FUNCION PARA CREAR LA PELICULA CON LOS DATOS RECIBIDOS
    public function create($data): ?array
    {
        // CALCULAR ID
        $id = 1;
        if (count($this->movies) > 0) {
            $lastMovie = $this->movies[count($this->movies) - 1];
            $id = $lastMovie["id"] + 1;
        }

        // AGREGAR AL LISTADO
        $this->movies[] = [
            "id" => $id,
            ...$data,
            "created_at" => time(),
            "updated_at" => time(),
        ];

        // GUARDAR
        FileMovies::setFileInfo($this->movies);

        return $this->getById($id);
    }

    // FUNCION PARA ACTUALIZAR PARCIALMENTE UNA PELICULA
    public function update(?int $id, array $data) 
    {
        if (!$id) return null;

        if (isset($data["created_at"])) unset($data["created_at"]);
        
        foreach ($this->movies as &$movie) {
            if ($movie["id"] !== $id) continue;
            
            foreach($data as $key => $value) {
                if ($key === "id") continue;

                $movie[$key] = $value;
            }

            $movie["updated_at"] = time();
        }

        FileMovies::setFileInfo($this->movies);

        return $this->getById($id);
    }

    // FUNCION PARA ELIMINAR UNA PELICULA POR SU ID
    public function destroy(?int $id)
    {
        if (!$id) return null;

        $newData = array_values(array_filter($this->movies, function ($el) use ($id) {
            return $el['id'] !== $id; 
        }));

        // AGREGAR AL LISTADO
        $this->movies = $newData;

        // GUARDAR
        FileMovies::setFileInfo($this->movies);

        return true;
    }
}