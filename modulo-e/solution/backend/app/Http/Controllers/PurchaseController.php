<?php

namespace App\Http\Controllers;

use App\Models\Event;
use App\Models\Purchase;
use App\Models\Section;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Str;
use Illuminate\Support\Facades\DB;

class PurchaseController extends Controller
{
    public function store(Request $request): JsonResponse
    {
        DB::beginTransaction();

        try {
            $validated = $request->validate([
                'event_id' => 'required|exists:events,id',
                'section_id' => 'required|exists:sections,id',
                'quantity' => 'required|integer|min:1|max:10',
                'customer_name' => 'required|string|max:255',
                'customer_email' => 'required|email|max:255'
            ]);

            // Verificar que la sección pertenece al evento
            $section = Section::where('id', $validated['section_id'])
                ->where('event_id', $validated['event_id'])
                ->first();

            if (!$section) {
                return response()->json([
                    'success' => false,
                    'error' => 'La sección no pertenece a este evento'
                ], 400);
            }

            // Verificar disponibilidad
            if ($section->available < $validated['quantity']) {
                return response()->json([
                    'success' => false,
                    'error' => 'No hay suficientes boletos disponibles. Disponibles: ' . $section->available
                ], 400);
            }

            // Calcular total
            $total = $section->price * $validated['quantity'];

            // Generar código de confirmación único
            do {
                $confirmationCode = 'TICKET-' . Str::upper(Str::random(8));
            } while (Purchase::where('confirmation_code', $confirmationCode)->exists());

            // Crear la compra
            $purchase = Purchase::create([
                'event_id' => $validated['event_id'],
                'section_id' => $validated['section_id'],
                'quantity' => $validated['quantity'],
                'customer_name' => $validated['customer_name'],
                'customer_email' => $validated['customer_email'],
                'total' => $total,
                'confirmation_code' => $confirmationCode
            ]);

            // Actualizar disponibilidad
            $section->available -= $validated['quantity'];
            $section->save();

            DB::commit();

            return response()->json([
                'success' => true,
                'message' => 'Compra realizada exitosamente',
                'data' => [
                    'purchase_id' => $purchase->id,
                    'confirmation_code' => $purchase->confirmation_code,
                    'total' => $purchase->total,
                    'customer_name' => $purchase->customer_name,
                    'customer_email' => $purchase->customer_email,
                    'quantity' => $purchase->quantity,
                    'purchase_date' => $purchase->created_at
                ]
            ], 201);

        } catch (\Illuminate\Validation\ValidationException $e) {
            DB::rollBack();
            return response()->json([
                'success' => false,
                'error' => 'Datos de entrada inválidos',
                'errors' => $e->errors()
            ], 422);

        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'success' => false,
                'error' => 'Error al procesar la compra: ' . $e->getMessage()
            ], 500);
        }
    }

    public function show($id): JsonResponse
    {
        try {
            $purchase = Purchase::with(['event', 'section'])->find($id);

            if (!$purchase) {
                return response()->json([
                    'success' => false,
                    'error' => 'Compra no encontrada'
                ], 404);
            }

            return response()->json([
                'success' => true,
                'data' => $purchase
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'error' => 'Error al cargar la compra: ' . $e->getMessage()
            ], 500);
        }
    }

    public function getCustomerPurchases($email): JsonResponse
    {
        try {
            $purchases = Purchase::with(['event', 'section'])
                ->where('customer_email', $email)
                ->orderBy('created_at', 'desc')
                ->get();

            if ($purchases->isEmpty()) {
                return response()->json([
                    'success' => true,
                    'data' => [],
                    'message' => 'No se encontraron compras para este email'
                ]);
            }

            $formattedPurchases = $purchases->map(function ($purchase) {
                return [
                    'id' => $purchase->id,
                    'confirmation_code' => $purchase->confirmation_code,
                    'quantity' => $purchase->quantity,
                    'total' => $purchase->total,
                    'purchase_date' => $purchase->formatted_date,
                    'customer_name' => $purchase->customer_name,
                    'customer_email' => $purchase->customer_email,
                    'event' => [
                        'id' => $purchase->event->id,
                        'name' => $purchase->event->name,
                        'date' => $purchase->event->date->format('Y-m-d H:i:s'),
                        'venue' => $purchase->event->venue,
                        'image_url' => $purchase->event->image_url
                    ],
                    'section' => [
                        'id' => $purchase->section->id,
                        'name' => $purchase->section->name,
                        'price' => $purchase->section->price
                    ],
                    'ticket_details' => $purchase->ticket_details
                ];
            });

            return response()->json([
                'success' => true,
                'data' => $formattedPurchases,
                'count' => $purchases->count(),
                'total_spent' => $purchases->sum('total')
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'error' => 'Error al cargar las compras del cliente: ' . $e->getMessage()
            ], 500);
        }
    }

    public function getPurchaseByConfirmationCode($code): JsonResponse
    {
        try {
            $purchase = Purchase::with(['event', 'section'])
                ->where('confirmation_code', $code)
                ->first();

            if (!$purchase) {
                return response()->json([
                    'success' => false,
                    'error' => 'Compra no encontrada'
                ], 404);
            }

            return response()->json([
                'success' => true,
                'data' => [
                    'purchase' => $purchase,
                    'ticket_details' => $purchase->ticket_details
                ]
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'error' => 'Error al buscar la compra: ' . $e->getMessage()
            ], 500);
        }
    }

    public function getPurchaseStats(): JsonResponse
    {
        try {
            $stats = [
                'total_purchases' => Purchase::count(),
                'total_revenue' => Purchase::sum('total'),
                'average_ticket_price' => Purchase::avg('total'),
                'purchases_today' => Purchase::whereDate('created_at', today())->count(),
                'top_events' => Purchase::with('event')
                    ->select('event_id', DB::raw('COUNT(*) as purchase_count'))
                    ->groupBy('event_id')
                    ->orderBy('purchase_count', 'desc')
                    ->limit(5)
                    ->get()
            ];

            return response()->json([
                'success' => true,
                'data' => $stats
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'error' => 'Error al cargar estadísticas: ' . $e->getMessage()
            ], 500);
        }
    }
}