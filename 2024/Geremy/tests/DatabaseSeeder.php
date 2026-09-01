<?php

namespace Database\Seeders;

use App\Models\Article;
use App\Models\Comment;
use App\Models\Tag;
use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     *
     * @return void
     */
    public function run()
    {
        $rose = User::create([
            'username' => 'Rose',
            'email' => 'rose@mail.com',
            'password' => bcrypt('pwd'),
            'image' => null,
            'bio' => 'Je voudrais devenir enseignante pour les enfants',
            'updated_at' => now(),
            'created_at' => now()
        ]);

        $musonda = User::create([
            'username' => 'Musonda',
            'email' => 'musonda@mail.com',
            'password' => bcrypt('pwd2'),
            'image' => null,
            'bio' => 'Je songe à devenir infirmière, j\'écris mes réflexions',
            'updated_at' => now(),
            'created_at' => now()
        ]);

        $tag = Tag::create([
            'name' => 'éducation'
        ]);

        $rose->following()->attach($musonda->id);
        $musonda->following()->attach($rose->id);


        $articleOne = Article::create([
            'user_id' => $rose->id,
            'title' => "Mon article",
            'slug' => "mon-article",
            'description' => "ceci est une description",
            'body' => "Mon article est super"
        ]);
        $articleTwo = Article::create([
            'user_id' => $musonda->id,
            'title' => "Mon article 2",
            'slug' => "mon-article-2",
            'description' => "ceci est une description",
            'body' => "Mon article est super"
        ]);
        $articleThree = Article::create([
            'user_id' => $musonda->id,
            'title' => "Mon article 3",
            'slug' => "mon-article-3",
            'description' => "ceci est une description",
            'body' => "Mon article est super"
        ]);

        $musonda->favoritedArticles()->attach($articleOne->id);
        $rose->favoritedArticles()->attach($articleTwo->id);
        $rose->favoritedArticles()->attach($articleThree->id);


        $articleOne->tags()->attach($tag->id);
        Comment::create([
           'article_id' => $articleOne->id,
           'user_id' => $musonda->id,
           'body' => 'J\'adore ta manière de concevoir l\'éducation des enfants'
        ]);


    }
}
