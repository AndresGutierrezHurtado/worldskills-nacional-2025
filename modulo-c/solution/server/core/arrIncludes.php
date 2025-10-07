<?php

function arrayIncludes($array, $search) {
    foreach ($array as $item) {
        if ($item === $search) return true;
    }
    return false;
}