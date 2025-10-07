<?php

use App\Http\Controllers\EventController;
use App\Http\Controllers\PurchaseController;
use App\Http\Controllers\SectionController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

// Health check endpoint
Route::get('/health', function () {
    return response()->json([
        'status' => 'OK',
        'message' => 'ConcertTickets API is running',
        'timestamp' => now()->toISOString()
    ]);
});

// Events routes
Route::get('/events', [EventController::class, 'index']);
Route::get('/events/{id}', [EventController::class, 'show']);
Route::get('/events/genre/{genre}', [EventController::class, 'getByGenre']);
//Route::get('/events/upcoming', [EventController::class, 'getUpcomingEvents']);

// Sections routes
Route::get('/events/{eventId}/sections', [SectionController::class, 'getEventSections']);
Route::get('/sections/{sectionId}/availability', [SectionController::class, 'getSectionAvailability']);

// Purchases routes
Route::post('/purchases', [PurchaseController::class, 'store']);
Route::get('/purchases/{id}', [PurchaseController::class, 'show']);
Route::get('/purchases/customer/{email}', [PurchaseController::class, 'getCustomerPurchases']);
Route::get('/purchases/confirmation/{code}', [PurchaseController::class, 'getPurchaseByConfirmationCode']);
//Route::get('/purchases/stats', [PurchaseController::class, 'getPurchaseStats']);

// Fallback route
Route::fallback(function () {
    return response()->json([
        'success' => false,
        'error' => 'Endpoint no encontrado'
    ], 404);
});