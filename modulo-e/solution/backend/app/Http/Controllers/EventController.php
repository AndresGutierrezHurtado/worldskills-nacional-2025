<?php

namespace App\Http\Controllers;

use App\Models\Event;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class EventController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        try {
            $query = Event::with(['sections' => function($query) {
                $query->where('available', '>', 0);
            }]);

            // Filtrar por género
            if ($request->has('genre') && $request->genre !== 'all') {
                $validGenres = ['rock', 'pop', 'electronic', 'jazz', 'reggaeton', 'hiphop'];
                if (in_array($request->genre, $validGenres)) {
                    $query->where('genre', $request->genre);
                }
            }

            // Buscar por nombre o lugar
            if ($request->has('search') && !empty($request->search)) {
                $searchTerm = $request->search;
                $query->where(function($q) use ($searchTerm) {
                    $q->where('name', 'like', "%$searchTerm%")
                      ->orWhere('venue', 'like', "%$searchTerm%")
                      ->orWhere('description', 'like', "%$searchTerm%");
                });
            }

            // Ordenar por fecha
            $query->orderBy('date', 'asc');

            $events = $query->get();

            return response()->json([
                'success' => true,
                'data' => $events,
                'count' => $events->count()
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'error' => 'Error al cargar los eventos: ' . $e->getMessage()
            ], 500);
        }
    }

    public function show($id): JsonResponse
    {
        try {
            $event = Event::with(['sections' => function($query) {
                $query->where('available', '>', 0);
            }])->find($id);

            if (!$event) {
                return response()->json([
                    'success' => false,
                    'error' => 'Evento no encontrado'
                ], 404);
            }

            return response()->json([
                'success' => true,
                'data' => $event
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'error' => 'Error al cargar el evento: ' . $e->getMessage()
            ], 500);
        }
    }

    public function getByGenre($genre): JsonResponse
    {
        try {
            $validGenres = ['rock', 'pop', 'electronic', 'jazz', 'reggaeton', 'hiphop'];
            
            if (!in_array($genre, $validGenres)) {
                return response()->json([
                    'success' => false,
                    'error' => 'Género no válido'
                ], 400);
            }

            $events = Event::with(['sections' => function($query) {
                $query->where('available', '>', 0);
            }])->where('genre', $genre)
               ->orderBy('date', 'asc')
               ->get();

            return response()->json([
                'success' => true,
                'data' => $events,
                'count' => $events->count()
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'error' => 'Error al cargar eventos por género: ' . $e->getMessage()
            ], 500);
        }
    }

    public function getUpcomingEvents(): JsonResponse
    {
        try {
            $events = Event::with(['sections' => function($query) {
                $query->where('available', '>', 0);
            }])->where('date', '>', now())
               ->orderBy('date', 'asc')
               ->limit(10)
               ->get();

            return response()->json([
                'success' => true,
                'data' => $events
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'error' => 'Error al cargar próximos eventos: ' . $e->getMessage()
            ], 500);
        }
    }
}