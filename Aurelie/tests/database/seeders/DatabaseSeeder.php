<?php

namespace Database\Seeders;


use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Date;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     *
     * @return void
     */
    public function run()
    {
        // \App\Models\User::factory(10)->create();
        // Create users
        $roseId =DB::table('users')->insertGetId([
                'username' => 'Rose',
                'email' => 'rose@mail.com',
                'password' => Hash::make('pwd'),
                'bio' => "Je voudrais devenir enseignante pour enfants",
                'created_at' => Date::now(),
                'updated_at' => Date::now(),
            ]);
        $musondaId = DB::table('users')->insertGetId([
                'username' => 'Musonda',
                'email' => 'musonda@mail.com',
                'password' => Hash::make('pwd2'),
                'bio' => "Je songe à devenir infirmière, j’écris mes réflexions",
                'created_at' => Date::now(),
                'updated_at' => Date::now(),
        ]);

        // Create followers
        DB::table('followers')->insert([
            ['follower_id' => $roseId,
                'following_id' => $musondaId],

            ['follower_id' => $musondaId,
                'following_id' => $roseId],
        ]);

        // Create articles
        $roseArticleId = DB::table('articles')->insert([
            'title' => 'Article de Rose',
            'slug' => 'slug article rose',
            'description' => 'Contenu de l\'article de Rose',
            'body' => 'Article éducatif',
            'user_id' => $roseId,
        ]);

        $musondaFirstArticleId = DB::table('articles')->insert([
            'title' => 'Premier article de Musonda',
            'slug' => 'slug article de Musonda',
            'description' => 'Contenu du premier article de Musonda',
            'body' => 'Article médical',
            'user_id' => $musondaId,
        ]);

        $musondaSecondArticleId = DB::table('articles')->insert([
            'title' => 'Deuxième article de Musonda',
            'slug' => 'slug article de Musonda',
            'description' => 'Contenu du deuxième article de Musonda',
            'body' => 'Article santé',
            'user_id' => $musondaId,
        ]);

        // Adding the “education” tag to Rose’s article
        $tagID = DB::table('tags')->insertGetId([
                'name' => 'éducation',
        ]);

        DB::table('article_tag')->insert([
            'article_id' => $roseArticleId,
            'tag_id' => $tagID,
        ]);

        // Create comments
        DB::table('comments')->insert([
            'body' => 'J\'adore ta manière de concevoir l\'éducation des enfants',
            'article_id' => $roseArticleId,
            'user_id' => $musondaId,
            'created_at' => Date::now(),
            'updated_at' => Date::now(),
        ]);
    }
}
