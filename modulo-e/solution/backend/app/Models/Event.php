<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Event extends Model
{
    use HasFactory;

    protected $fillable = [
        'name',
        'date',
        'venue',
        'image_url',
        'description',
        'genre',
        'min_price'
    ];

    protected $casts = [
        'date' => 'datetime',
        'min_price' => 'decimal:2'
    ];

    public function sections(): HasMany
    {
        return $this->hasMany(Section::class);
    }

    public function purchases(): HasMany
    {
        return $this->hasMany(Purchase::class);
    }

    public function getAvailableSectionsAttribute()
    {
        return $this->sections()->where('available', '>', 0)->get();
    }
}