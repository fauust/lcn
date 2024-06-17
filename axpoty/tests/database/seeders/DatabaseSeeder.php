<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use DB;
use Hash;
use App\Models\User;
use App\Models\Article;
use App\Models\Tag;
use App\Models\Comment;
use App\Models\ArticleTag;
use App\Models\UserArticle;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     *
     * @return void
     */
    public function run()
    {
        // Creating users
        $rose = User::create([
            'username' => 'Rose',
            'email' => 'rose@mail.com',
            'password' => Hash::make('pwd'),
            'bio' => 'Je voudrais devenir enseignante pour enfants',
            'created_at' => now(),
            'updated_at' => now()
        ]);

        $musonda = User::create([
            'username' => 'Musonda',
            'email' => 'musonda@mail.com',
            'password' => Hash::make('pwd2'),
            'bio' => 'Je songe à devenir infirmière, j’écris mes réflexions',
            'created_at' => now(),
            'updated_at' => now()
        ]);

        // Establishing follow relationship
        $rose->following()->attach($musonda->id);
        $musonda->following()->attach($rose->id);

        // Creating articles
        $roseArticle = Article::create([
            'user_id' => $rose->id,
            'title' => 'L\'importance de l\'éducation des enfants',
            'slug' => 'importance-education-enfants',
            'description' => 'Un article sur l\'éducation des enfants',
            'body' => 'Le contenu de l\'article sur l\'éducation des enfants...',
            'created_at' => now(),
            'updated_at' => now()
        ]);

        $musondaArticle1 = Article::create([
            'user_id' => $musonda->id,
            'title' => 'Réflexions sur le métier d\'infirmière',
            'slug' => 'reflexions-metier-infirmiere',
            'description' => 'Un article sur les réflexions de Musonda sur le métier d\'infirmière',
            'body' => 'Le contenu de l\'article sur les réflexions...',
            'created_at' => now(),
            'updated_at' => now()
        ]);

        $musondaArticle2 = Article::create([
            'user_id' => $musonda->id,
            'title' => 'Les défis d\'être infirmière',
            'slug' => 'defis-etre-infirmiere',
            'description' => 'Un article sur les défis d\'être infirmière',
            'body' => 'Le contenu de l\'article sur les défis...',
            'created_at' => now(),
            'updated_at' => now()
        ]);

        // Establishing follow relationship with articles
        $musonda->favoritedArticles()->attach($roseArticle->id);
        $rose->favoritedArticles()->attach($musondaArticle1->id);
        $rose->favoritedArticles()->attach($musondaArticle2->id);

        // Creating tag and attaching it to Rose's article
        $educationTag = Tag::create([
            'name' => 'éducation'
        ]);

        $roseArticle->tags()->attach($educationTag->id);

        // Creating comment
        Comment::create([
            'user_id' => $musonda->id,
            'article_id' => $roseArticle->id,
            'body' => 'J\'adore ta manière de concevoir l\'éducation des enfants',
            'created_at' => now(),
            'updated_at' => now()
        ]);
    }
}
