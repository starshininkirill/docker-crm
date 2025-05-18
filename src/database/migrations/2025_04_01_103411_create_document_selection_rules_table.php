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
        Schema::create('document_selection_rules', function (Blueprint $table) {
            $table->id();
            $table->foreignId('document_template_id')
                ->constrained('document_templates')
                ->onDelete('cascade');
            $table->string('type');
            $table->integer('priority')->default(1);
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('document_selection_rules');
    }
};
