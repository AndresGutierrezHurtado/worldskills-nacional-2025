<?php

namespace Database\Seeders;

use App\Models\Section;
use Illuminate\Database\Seeder;

class SectionSeeder extends Seeder
{
    public function run(): void
    {
        $sections = [
            [
                'event_id' => '1',
                'name' => 'general',
                'price' => 50.00,
                'capacity' => 1000,
                'avaible' => 245
                            ],
            [
                'event_id' => '1',
                'name' => 'preferencial',
                'price' => 80.00,
                'capacity' => 500,
                'avaible' => 150
            ],
            [
                'event_id' => '1',
                'name' => 'vip',
                'price' => 120.00,
                'capacity' => 200,
                'avaible' => 75
            ],
            [
                'event_id' => '2',
                'name' => 'general',
                'price' => 60.00,
                'capacity' => 1200,
                'avaible' => 400
                            ],
            [
                'event_id' => '2',
                'name' => 'preferencial',
                'price' => 90.00,
                'capacity' => 600,
                'avaible' => 200
            ],
            [
                'event_id' => '2',
                'name' => 'vip',
                'price' => 150.00,
                'capacity' => 300,
                'available' => 75
            ],
                [
                'event_id' => '3',
                'name' => 'general',
                'price' => 70.00,
                'capacity' => 1500,
                'available' => 600
                            ],
            [
                'event_id' => '3',
                'name' => 'preferencial',
                'price' => 100.00,
                'capacity' => 700,
                'available' => 250
            ],
            [
                'event_id' => '1',
                'name' => 'vip',
                'price' => 180.00,
                'capacity' => 400,
                'available' => 100
            ],
            
        ];

        foreach ($sections as $section) {
            Section::create($section);
        }
    }
}