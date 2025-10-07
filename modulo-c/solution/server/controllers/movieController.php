<?php

class MovieController {
    private Movie $model;

    public function __construct() {
        $this->model = new Movie();
    }

    public function index() {
        try {
            // OBTENER PELICULAS
            $movies = $this->model->getAll();
            
            return_response(
                200,
                true,
                "Películas obtenidas correctamente",
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

    public function show($id) {
        try {
            // VALIDAR ID
            if (empty($id) || !preg_match("/^[0-9]+$/", $id)) {
                return_response(
                    422,
                    false,
                    "Error de validación: El ID debe ser un número",
                );
                return;
            }

            // OBTENER PELICULA
            $movie = $this->model->getById($id);
            
            // VALIDAR EXISTENCIA
            if (empty($movie)) {
                return_response(
                    404,
                    false,
                    "No se econtró la película",
                );
                return;
            }

            return_response(
                200,
                true,
                "Películas obtenidas correctamente",
                $movie
            );
        } catch (Exception $e) {
            return_response(
                500, 
                false,
                "Hubo un error al obtener la película: {$e->getMessage()}"
            );
        }
    }

    public function store() {
        try {
            // OBTENER Y VALIDAR BODY
            $data = get_body();

            foreach(["titulo"] as $key) {
                if (empty($data[$key])) {
                    return_response(
                        422, 
                        false,
                        "El $key es obligatorio"
                    );
                    return;
                }
            }

            // MANEJO DE DATOS VACIOS
            if (!isset($data["anio"])) $data["anio"] = 2025;
            if (!isset($data["generos"])) $data["generos"] = [];
            if (!isset($data["valoracion"])) $data["valoracion"] = 0.0;
            if (!isset($data["duracion"])) $data["duracion"] = 0;

            // CREACION DE PELICULA
            $movie = $this->model->create($data);

            // MANEJO DE ERROR
            if ($movie === null) {
                return_response(
                    500, 
                    false,
                    "Hubo un error al guardar la película"
                );
                return;
            }
        
            return_response(
                201,
                true,
                "Película guardada correctamente",
                $movie
            );
        } catch (Exception $e) {
            return_response(
                500, 
                false,
                "Hubo un error al guardar la película: {$e->getMessage()}"
            );
        }
    }

    public function update($id) {
        try {
            // VALIDAR ID
            if (empty($id) || !preg_match("/^[0-9]+$/", $id)) {
                return_response(
                    422,
                    false,
                    "Error de validación: El ID debe ser un numero",
                );
                return;
            }

            // VALIDAR EXISTENCIA
            $existingMovie = $this->model->getById($id);
            
            if (empty($existingMovie)) {
                return_response(
                    404,
                    false,
                    "No se econtró la película",
                );
                return;
            }

            // OBTENER BODY
            $data = get_body();

            // ACTUALIZAR
            $movie = $this->model->update($id, $data);
        
            return_response(
                200,
                true,
                "Película actualizada correctamente",
                $movie
            );
        } catch (Exception $e) {
            return_response(
                500, 
                false,
                "Hubo un error al actualizar la película: {$e->getMessage()}"
            );
        }
    }

    public function destroy($id) {
        try {
            // VALIDAR ID
            if (empty($id) || !preg_match("/^[0-9]+$/", $id)) {
                return_response(
                    422,
                    false,
                    "Error de validación: El ID debe ser un numero",
                );
                return;
            }

            // VALIDAR EXIXTENCIA
            $existingMovie = $this->model->getById($id);
            
            if (empty($existingMovie)) {
                return_response(
                    404,
                    false,
                    "No se econtró la película",
                );
                return;
            }

            // ACTUALIZAR
            $movie = $this->model->destroy($id);
        
            return_response(
                200,
                true,
                "Película eliminada correctamente"
            );
        } catch (Exception $e) {
            return_response(
                500, 
                false,
                "Hubo un error al eliminar la película: {$e->getMessage()}"
            );
        }
    }
}