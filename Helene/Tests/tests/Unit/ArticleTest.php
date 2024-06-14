<?php

namespace Tests\Unit;

use App\Models\Article;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Hash;
use Tests\TestCase;

class ArticleTest extends TestCase
{
    use RefreshDatabase;
    /**
     * A basic unit test example.
     *
     * @return void
     */
    public function test_articles()
    {
        // GIVEN a context : Create user and create article
        $rose=User::factory()->create([
            'username'=> 'Rose',
            'email'=> 'rose@gmail.com',
            'password' => Hash::make('pwd'),
        ]);


        $article = Article::factory()->create([
            'title' => 'title',
            'description' => 'description',
            'body' => 'body',
            'user_id' => $rose->id,
        ]);


        // WHEN some condition
        $articles=$rose->articles;

        //THEN expect some output
        $this->assertCount(1,$articles,'Rose n\'a pas écrit d\'article');
        $article=$articles->first();
        $this->assertEquals('title', $article->title);
        $this->assertEquals('description', $article->description);
        $this->assertEquals('body', $article->body);

    }

    public function test_favoriteArticles()
    {
        // GIVEN a context : Create users and create article
        $rose = User::factory()->create([
            'username' => 'Rose',
            'email' => 'rose@mail.com',
            'password' => Hash::make('pwd'),
        ]);
        $musonda = User::factory()->create([
            'username' => 'Musonda',
            'email' => 'musonda@mail.com',
            'password' => Hash::make('pwd2'),
        ]);

        $musondaArticle = Article::factory()->create([
            'title' => 'Réflexions sur la santé',
            'slug' => 'reflexions-sur-la-sante',
            'description' => 'description de l\'article santé',
            'body' => 'Article sur les réflexions de Musonda concernant la santé.',
            'user_id' => $musonda->id,
        ]);

        // WHEN Rose favorites an article by Musonda
        $rose->favoritedArticles()->attach($musondaArticle->id);

        // THEN expect some output
        $favoriteArticles = $rose->favoritedArticles;
        $this->assertCount(1, $favoriteArticles, 'Rose n\'a pas d\'article favoris');
        $favoritedArticle = $favoriteArticles->first();
        $this->assertEquals('Réflexions sur la santé', $favoritedArticle->title);
        $this->assertEquals('description de l\'article santé', $favoritedArticle->description);
        $this->assertEquals('Article sur les réflexions de Musonda concernant la santé.', $favoritedArticle->body);
    }

}
