<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\User;
use App\Models\Article;
use App\Models\Tag;
use App\Models\Comment;
use Illuminate\Support\Facades\Hash;

class DatabaseSeeder extends Seeder
{
    public function run()
    {
        // Create users
        $rose = User::factory()->create([
            'username' => 'Rose',
            'email' => 'rose@mail.com',
            'password' => Hash::make('pwd'),
            'bio' => 'Je voudrais devenir enseignante pour enfants',
        ]);

        $musonda = User::factory()->create([
            'username' => 'Musonda',
            'email' => 'musonda@mail.com',
            'password' => Hash::make('pwd2'),
            'bio' => 'Je songe à devenir infirmière, j’écris mes réflexions',
        ]);

        // Create followings
        $rose->following()->attach($musonda->id);
        $musonda->following()->attach($rose->id);

        // Create articles of Rose
        $articleRose = Article::factory()->create([
            'user_id' => $rose->id,
            'title' => 'Article de Rose',
            'body' => 'Contenu de l\'article de Rose',
        ]);

        // Create articles of Musonda with explicit titles
        $articleMusonda1 = Article::factory()->create([
            'user_id' => $musonda->id,
            'title' => 'Premier article de Musonda',
            'body' => 'Contenu du premier article de Musonda',
        ]);

        $articleMusonda2 = Article::factory()->create([
            'user_id' => $musonda->id,
            'title' => 'Deuxième article de Musonda',
            'body' => 'Contenu du deuxième article de Musonda',
        ]);

        // Musonda follow Rose's article
        $musonda->favoritedArticles()->attach($articleRose->id);

        // Rose follow Musonda's articles
        $rose->favoritedArticles()->attach($articleMusonda1->id);
        $rose->favoritedArticles()->attach($articleMusonda2->id);

        // Create tags "éducation" for Rose's article
        $tagEducation = Tag::factory()->create([
            'name' => 'éducation',
        ]);

        $articleRose->tags()->attach($tagEducation->id);

        // Create comments
        Comment::factory()->create([
            'article_id' => $articleRose->id,
            'user_id' => $musonda->id,
            'body' => 'J\'adore ta manière de concevoir l\'éducation des enfants',
        ]);
    }
}
