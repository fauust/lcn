<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;

class DatabaseSeeder extends Seeder
{
    public function run()
    {
        // Création des utilisateurs
        DB::table('users')->updateOrInsert(
            ['username' => 'Rose', 'email' => 'rose@mail.com'],
            [
                'password' => Hash::make('pwd'),
                'bio' => 'Je voudrais devenir enseignante pour enfants',
                'created_at' => now(),
                'updated_at' => now(),
            ]
        );

        DB::table('users')->updateOrInsert(
            ['username' => 'Musonda', 'email' => 'musonda@mail.com'],
            [
                'password' => Hash::make('pwd2'),
                'bio' => 'Je songe à devenir infirmière, j’écris mes réflexions',
                'created_at' => now(),
                'updated_at' => now(),
            ]
        );

        $roseId = DB::table('users')->where('username', 'Rose')->value('id');
        $musondaId = DB::table('users')->where('username', 'Musonda')->value('id');

        DB::table('followers')->insert([
            ['follower_id' => $roseId, 'following_id' => $musondaId],
            ['follower_id' => $musondaId, 'following_id' => $roseId],
        ]);

        $roseArticleId = DB::table('articles')->insertGetId([
            'title' => 'Éducation des enfants',
            'slug' => Str::slug('Éducation des enfants'),
            'description' => 'Une réflexion sur l’éducation des enfants',
            'body' => 'Contenu de l’article de Rose...',
            'user_id' => $roseId,
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        $musondaArticle1Id = DB::table('articles')->insertGetId([
            'title' => 'Devenir infirmière',
            'slug' => Str::slug('Devenir infirmière'),
            'description' => 'Mes pensées sur le métier d’infirmière',
            'body' => 'Contenu de l’article de Musonda...',
            'user_id' => $musondaId,
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        $musondaArticle2Id = DB::table('articles')->insertGetId([
            'title' => 'Réflexions d’une future infirmière',
            'slug' => Str::slug('Réflexions d’une future infirmière'),
            'description' => 'Autres réflexions sur le métier d’infirmière',
            'body' => 'Deuxième contenu de l’article de Musonda...',
            'user_id' => $musondaId,
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        $tagId = DB::table('tags')->where('name', 'éducation')->value('id');
        if (!$tagId) {
            $tagId = DB::table('tags')->insertGetId(['name' => 'éducation']);
        }

        DB::table('article_tag')->insert([
            'article_id' => $roseArticleId,
            'tag_id' => $tagId,
        ]);

        DB::table('comments')->insert([
            'body' => 'J’adore ta manière de concevoir l’éducation des enfants',
            'user_id' => $musondaId,
            'article_id' => $roseArticleId,
            'created_at' => now(),
            'updated_at' => now(),
        ]);
    }
}
