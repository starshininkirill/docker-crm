<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('work_statuses', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->string('type')->unique();
            $table->float('hours')->nullable()->default(null);
            $table->boolean('need_confirmation')->default(false);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('work_statuses');
    }
};
