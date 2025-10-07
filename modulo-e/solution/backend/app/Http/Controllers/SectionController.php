<?php

namespace App\Http\Controllers;

use App\Models\Event;
use App\Models\Section;
use Illuminate\Http\JsonResponse;

class SectionController extends Controller
{
    public function getEventSections($eventId): JsonResponse
    {
        try {
            $event = Event::find($eventId);

            if (!$event) {
                return response()->json([
                    'success' => false,
                    'error' => 'Evento no encontrado'
                ], 404);
            }

            $sections = Section::where('event_id', $eventId)
                ->where('available', '>', 0)
                ->orderBy('price', 'asc')
                ->get();

            return response()->json([
                'success' => true,
                'data' => $sections,
                'event' => [
                    'id' => $event->id,
                    'name' => $event->name,
                    'date' => $event->date
                ]
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'error' => 'Error al cargar las secciones: ' . $e->getMessage()
            ], 500);
        }
    }

    public function getSectionAvailability($sectionId): JsonResponse
    {
        try {
            $section = Section::find($sectionId);

            if (!$section) {
                return response()->json([
                    'success' => false,
                    'error' => 'Sección no encontrada'
                ], 404);
            }

            return response()->json([
                'success' => true,
                'data' => [
                    'id' => $section->id,
                    'name' => $section->name,
                    'available' => $section->available,
                    'capacity' => $section->capacity,
                    'sold_out' => $section->sold_out,
                    'occupancy_percentage' => $section->occupancy_percentage
                ]
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'error' => 'Error al verificar disponibilidad: ' . $e->getMessage()
            ], 500);
        }
    }
}