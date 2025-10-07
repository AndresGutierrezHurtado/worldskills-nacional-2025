<?php

// CONFIGURACION
require_once(__DIR__ . "/arrIncludes.php");
require_once(__DIR__ . "/response.php");
require_once(__DIR__ . "/fileMovies.php");
require_once(__DIR__ . "/router.php");
require_once(__DIR__ . "/getBody.php");

// MODELOS (CONSULTA A ARCHIVOS)
require_once(__DIR__ . "/../models/movie.php");

// CONTROLADORES (LOGICA)
require_once(__DIR__ . "/../controllers/movieController.php");
require_once(__DIR__ . "/../controllers/genreController.php");
