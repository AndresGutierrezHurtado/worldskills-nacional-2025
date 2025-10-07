<?php

function get_body(): array 
{
    $data = $_POST;

    $data2 = json_decode(file_get_contents("php://input"), true) ?? [];

    return array_merge($data, $data2);
}