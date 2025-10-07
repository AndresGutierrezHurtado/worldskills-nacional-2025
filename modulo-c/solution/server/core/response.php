<?php

function return_response($code, bool $success, string $message, array $data = null, bool $total = false)
{
    $response =[
        "success" => $success,
        "message" => $message,
    ];

    if ($total && $data !== null) {
        $response["total"] = count($data);
    }

    if ($data !== null) {
        $response["data"] = $data;
    }

    http_response_code($code);
    echo json_encode($response);
    flush();
    return;
}