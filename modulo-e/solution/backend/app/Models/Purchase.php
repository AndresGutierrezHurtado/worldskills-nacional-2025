<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Purchase extends Model
{
    use HasFactory;

    protected $fillable = [
        'event_id',
        'section_id',
        'quantity',
        'customer_name',
        'customer_email',
        'total',
        'confirmation_code'
    ];

    protected $casts = [
        'total' => 'decimal:2'
    ];

    public function event(): BelongsTo
    {
        return $this->belongsTo(Event::class);
    }

    public function section(): BelongsTo
    {
        return $this->belongsTo(Section::class);
    }

    public function getFormattedDateAttribute(): string
    {
        return $this->created_at->format('d/m/Y H:i');
    }

    public function getTicketDetailsAttribute(): array
    {
        return [
            'event_name' => $this->event->name,
            'event_date' => $this->event->date->format('d/m/Y H:i'),
            'event_venue' => $this->event->venue,
            'section_name' => $this->section->name,
            'unit_price' => $this->section->price,
            'quantity' => $this->quantity,
            'total' => $this->total,
            'confirmation_code' => $this->confirmation_code
        ];
    }
}