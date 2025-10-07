<?php

namespace Database\Seeders;

use App\Models\Purchase;
use Illuminate\Database\Seeder;

class PurchaseSeeder extends Seeder
{
    public function run(): void
    {
        $purchases = [
            [   'event_id' => 1,
                'section_id'=> 3,
                'quantity' => 2,
                'customer_name' =>'María González',
                'customer_email'=> 'maria.gonzalez@email.com',                
                'total' => 240.000,
                'confirmation_code' =>'TICKET-ROCK125'
                            
            ],
            [
               'event_id' => 1,
                'section_id'=>  2, 
                'quantity' =>4,
                'customer_name' =>'Carlos López',
                'customer_email'=>  'carlos.lopez@email.com',       
                'total' => 320.00, 
                'confirmation_code' =>'TICKET-ROCK459'
            ],
            [
                'event_id' => 2,
                'section_id'=> 1, 
                'quantity' =>3,
                'customer_name' => 'Ana Martínez',
                'customer_email'=>  'ana.martinez@email.com', 
                'total' => 180.00, 
                'confirmation_code' =>'TICKET-POP739'  
            ],            
          
        ];

        foreach ($purchases as $purchase) {
            Purchase::create($purchase);
        }
    }
}