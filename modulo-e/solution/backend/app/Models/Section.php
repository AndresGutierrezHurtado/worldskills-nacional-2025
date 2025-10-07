<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Section extends Model
{
    use HasFactory;

    protected $fillable = [
        'event_id',
        'name',
        'price',
        'capacity',
        'available'
    ];

    protected $casts = [
        'price' => 'decimal:2'
    ];

    public function event(): BelongsTo
    {
        return $this->belongsTo(Event::class);
    }

    public function purchases(): HasMany
    {
        return $this->hasMany(Purchase::class);
    }

    public function getSoldOutAttribute(): bool
    {
        return $this->available <= 0;
    }

    public function getOccupancyPercentageAttribute(): float
    {
        if ($this->capacity === 0) return 0;
        return (($this->capacity - $this->available) / $this->capacity) * 100;
    }
}