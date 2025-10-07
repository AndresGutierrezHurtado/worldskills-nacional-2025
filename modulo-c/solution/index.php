<?php

header("Content-Type: application/json");
header("Access-Control-Allow-Origin: * ");

require_once(__DIR__ . "/server/core/autoload.php");

$router = new Router();

// RUTAS PARA PELICULAS
$router->add("GET", "/api/movies", [new MovieController(), "index"]);
$router->add("GET", "/api/movies/genre/{genero}", [new GenreController(), "show"]);
$router->add("GET", "/api/movies/{id}", [new MovieController(), "show"]);

// RUTAS CRUD PARA PELICULAS
$router->add("POST", "/api/movies", [new MovieController(), "store"]);
$router->add("PUT", "/api/movies/{id}", [new MovieController(), "update"]);
$router->add("DELETE", "/api/movies/{id}", [new MovieController(), "destroy"]);

// EJECUTAR ENRUTADOR
$router->dispatch(
    $_SERVER["REQUEST_METHOD"],
    $_SERVER["REDIRECT_URL"] ?? "/"
);

