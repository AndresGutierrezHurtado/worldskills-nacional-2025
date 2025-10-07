<?php

namespace Database\Seeders;

use App\Models\Event;
use Illuminate\Database\Seeder;

class EventSeeder extends Seeder
{
    public function run(): void
    {
        $events = [
            [
                'name' => 'Festival de Rock Internacional',
                'date' => '2024-03-15 20:00:00',
                'venue' => 'Estadio Nacional',
                'image_url' => 'https://images.unsplash.com/photo-1571330735066-03aaa9429d89',
                'description' => 'El mejor festival de rock con bandas internacionales y nacionales',
                'genre' => 'rock',
                'min_price' => 50.00
            ],
            [
                'name' => 'Super Pop Live 2024',
                'date' => '2024-04-20 18:00:00',
                'venue' => 'Arena Ciudad',
                'image_url' => 'https://images.unsplash.com/photo-1506157786151-b8491531f063',
                'description' => 'Los artistas pop más importantes del momento en un solo evento',
                'genre' => 'pop',
                'min_price' => 60.00
            ],
            // ... más eventos
        ];

        foreach ($events as $event) {
            Event::create($event);
        }
    }
}