<?php

namespace Database\Seeders;


use App\Models\Article;
use App\Models\Comment;
use App\Models\Tag;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Date;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use app\Models\User;


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
        $rose = User::create([
                'username' => 'Rose',
                'email' => 'rose@mail.com',
                'password' => Hash::make('pwd'),
                'bio' => "Je voudrais devenir enseignante pour enfants",
                'created_at' => Date::now(),
                'updated_at' => Date::now(),
            ]);
        $musonda = User::create([
                'username' => 'Musonda',
                'email' => 'musonda@mail.com',
                'password' => Hash::make('pwd2'),
                'bio' => "Je songe à devenir infirmière, j’écris mes réflexions",
                'created_at' => Date::now(),
                'updated_at' => Date::now(),
        ]);

        // Create followers
        $rose->following()->attach($musonda->id);
        $musonda->following()->attach($rose->id);

        // Create articles
        $roseArticleId = Article::create([
            'user_id' => $rose->id,
            'title' => 'Article de Rose',
            'slug' => 'slug article rose',
            'description' => 'Contenu article de Rose',
            'body' => 'Article éducatif',
        ]);

        $musondaFirstArticleId = Article::create([
            'user_id' => $musonda->id,
            'title' => 'Premier article de Musonda',
            'slug' => 'slug article de Musonda',
            'description' => 'Contenu du premier article de Musonda',
            'body' => 'Article médical',
        ]);

        $musondaSecondArticleId = Article::create([
            'user_id' => $musonda->id,
            'title' => 'Deuxième article de Musonda',
            'slug' => 'slug article de Musonda',
            'description' => 'Contenu du deuxième article de Musonda',
            'body' => 'Article santé',
        ]);

        // Establishing follow relationship with articles
        $musonda->favoritedArticles()->attach($roseArticleId->id);
        $rose->favoritedArticles()->attach($musondaFirstArticleId->id);
        $rose->favoritedArticles()->attach($musondaSecondArticleId->id);


        // Adding the “education” tag to Rose’s article
        $tagID = Tag::create([
                'name' => 'éducation',
        ]);

        $roseArticleId->tags()->attach($tagID->id);

        // Create comments
        Comment::create([
            'body' => 'J\'adore ta manière de concevoir l\'éducation des enfants',
            'article_id' => $roseArticleId->id,
            'user_id' => $musonda->id,
            'created_at' => Date::now(),
            'updated_at' => Date::now(),
        ]);
    }
}
