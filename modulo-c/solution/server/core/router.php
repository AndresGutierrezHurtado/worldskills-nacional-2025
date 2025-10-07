<?php

class Router {
    public function __construct(
        private array $routes = []
    ) {}

    public function add($method, $path, $callback)
    {
        // ALMACENAR RUTAS
        $this->routes[] = [
            "method" => strtoupper($method),
            "path" => $path,
            "callback" => $callback
        ];
    }

    public function dispatch($reqMethod, $reqPath) 
    {
        $reqPath = str_replace("/api-peliculas", "", $reqPath);
    
        // ENCONTRAR RUTAS
        foreach($this->routes as $route) {
            $tmpMethod = isset($_POST["_method"]) ? $_POST["_method"] : "";

            if ($route["method"] !== strtoupper($reqMethod) && $route["method"] !== strtoupper($tmpMethod)) continue;
            
            $pattern = preg_replace("/\{([^}]+)\}/", "([^/]+)", $route["path"]);
            $pattern = "#^$pattern/?$#";
            
            if (preg_match($pattern, $reqPath, $matches)) {
                array_shift($matches);

                return call_user_func_array($route["callback"], $matches);
            }
        }

        // ERROR SI NO SE ENCUENTRA RUTA
        return_response(
            404, 
            false, 
            "No se encontró esa ruta"
        );
    }
}