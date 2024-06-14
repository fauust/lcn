<?php

namespace Database\Seeders;

use App\Models\Article;
use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Str;

class AddRoseArticleSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        // Appel du seeder pour créer l'utilisateur Rose si nécessaire
        $this->call(AddRoseUserSeeder::class);

        // Récupération de l'utilisateur Rose
        $rose = User::where('username', 'Rose')->first();

        // Vérification si l'article existe déjà
        $exist = Article::where('slug', 'xvs3zjl')->first();

        // Si l'article n'existe pas, le créer
        if (!$exist) {
            Article::create([
                'user_id' => $rose->id,
                'title' => 'XVs3zJL',
                'slug' => 'xvs3zjl',
                'description' => 'L5Ro54Luo0',
                'body' => 'UX8tNbKA8O',
                'created_at' => '2024-06-13 09:43:02',
                'updated_at' => '2024-06-13 09:43:02',
            ]);
        }
    }
}
