<?php

class FileMovies {
    public static function getFileInfo(): array {
        if(!file_exists(__DIR__ . "/../movies.json")) {
            self::setFileInfo([]);
        }

        $content = file_get_contents(__DIR__ . "/../movies.json");
        $response = json_decode($content, true);

        if (!isset($response["movies"])) {
            self::setFileInfo([]);
        }
    
        return $response["movies"] ?? [];
    }

    public static function setFileInfo(array $data): bool {
        $file = [
            "movies" => $data
        ];

        $string = file_put_contents(__DIR__ . "/../movies.json", json_encode($file, JSON_PRETTY_PRINT));

        return true;
    }
}