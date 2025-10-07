<?php

class GenreController {
    private Movie $model;

    public function __construct() {
        $this->model = new Movie();
    }

    public function show($genre) {
        try {
            // TRAER PELICULAS POR GENERO
            $movies = $this->model->getByGenre($genre);
            
            return_response(
                200,
                true,
                "Películas del genero $genre obtenidas correctamente",
                $movies,
                true
            );
        } catch (Exception $e) {
            return_response(
                500, 
                false,
                "Hubo un error al obtener las películas: {$e->getMessage()}"
            );
        }
    }
}