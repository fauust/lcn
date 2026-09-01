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
        // Create users
        $roseId = DB::table('users')->insertGetId([
            'username' => 'Rose',
            'email' => 'rose@mail.com',
            'password' => Hash::make('pwd'),
            'bio' => 'Je voudrais devenir enseignante pour enfants',
            'created_at' => Date::now(),
            'updated_at' => Date::now()
        ]);
         $musondaId = DB::table('users')->insertGetId([
            'username' => 'Musonda',
            'email' => 'musonda@mail.com',
            'password' => Hash::make('pwd2'),
            'bio' => 'Je songe à devenir infirmière, j’écris mes réflexions',
             'created_at' => Date::now(),
             'updated_at' => Date::now()
        ]);
         // Create followers
        DB::table('followers') ->insert([
            ['follower_id' => $roseId,
            'following_id' => $musondaId],

            ['follower_id' => $musondaId,
                'following_id' => $roseId]
        ]);

        // Create Articles
        $roseArticleId = DB::table('articles')->insert([
            'title' => 'Éducation des enfants',
            'slug' => 'education-des-enfants',
            'description' => 'description de l\'article éducatif',
            'body' => 'Article géniale sur le Montessori.',
            'user_id' => $roseId,
        ]);

        $musondaArticle1Id = DB::table('articles')->insertGetId([
            'title' => 'Réflexions sur la santé',
            'slug' => 'reflexions-sur-la-santé',
            'description' => 'description de l\'article santé',
            'body' => 'Article sur les réflexions de Musonda concernant la santé.',
            'user_id' => $musondaId
        ]);

        $musondaArticle2Id = DB::table('articles')->insertGetId([
            'title' => 'Devenir infirmière, une vovation',
            'slug' => 'reflexions-sur-la-vocation',
            'description' => 'description de l\'article vocation',
            'body' => 'Article sur le parcours de Musonda pour devenir infirmière.',
            'user_id' => $musondaId,
        ]);

        // Création des tags et de leur association aux articles
        $tagId = DB::table('tags')->insertGetId([
            'name' => 'éducation',

        ]);

        DB::table('article_tag')->insert([
            'article_id' => $roseArticleId,
            'tag_id' => $tagId,
        ]);

        // Création des commentaires
        DB::table('comments')->insert([
            'body' => 'J\'adore ta manière de concevoir l\'éducation des enfants.',
            'article_id' => $roseArticleId,
            'user_id' => $musondaId,
            'created_at' => Date::now(),
            'updated_at' => Date::now()
        ]);
    }
}
