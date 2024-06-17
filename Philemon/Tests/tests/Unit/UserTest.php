<?php

namespace Tests\Unit;

use App\Models\Article;
use App\Models\User;
use Tests\TestCase;

class UserTest extends TestCase
{
    protected function setUp(): void
    {
        parent::setUp();

        // Exécuter les migrations
        $this->artisan('migrate:fresh');
    }

    /**
     * A basic unit test example.
     *
     * @return void
     */
    public function test_example()
    {
        $this->assertTrue(true);
    }

    public function test_getRouteKeNames()
    {

        $user = User::factory()->create();
        $this->assertEquals('username', $user->getRouteKeyName());
    }

    public function test_articles()
    {
        $title = 'THE TITLE';
        $slug = 'THE SLUG';
        $desc = 'THE BIG DESCRIPTION';
        $body = 'THE BIG BODY';

        // Création d'un utilisateur.
        $user = User::factory()->create();

        // Création d'un article lié à cet utilisateur.
        $article = Article::factory()->create([
            'user_id' => $user->id,
            'title' => $title,
            'slug' => $slug,
            'description' => $desc,
            'body' => $body
        ]);

        // Je recupére la function articles de user.
        $userArticles = $user->articles()->first();

        // Vérification que la collection d'articles n'est pas vide.
        $this->assertNotEmpty($userArticles);

        // Vérification des données de l'article.
        $this->assertEquals($title, $userArticles->title);
        $this->assertEquals($slug, $userArticles->slug);
        $this->assertEquals($desc, $userArticles->description);
        $this->assertEquals($body, $userArticles->body);


    }

    public function test_favoritedArticles(){

        $title = 'THE TITLE';
        $slug = 'THE SLUG';
        $desc = 'THE BIG DESCRIPTION';
        $body = 'THE BIG BODY';

        // Création d'utilisateurs.
        $usertest1 = User::factory()->create();
        $usertest2 = User::factory()->create();

        // Création d'un article lié à un utilisateur.
        $articleUser2 = Article::factory()->create([
            'user_id' => $usertest2->id,
            'title' => $title,
            'slug' => $slug,
            'description' => $desc,
            'body' => $body
        ]);

        //
        $usertest1->favoritedArticles()->attach($articleUser2->id);

        // Je recupére la function favoritedArticles de user.
        $userFavoritedArticle = $usertest1->favoritedArticles()->first();

        // Vérification
         $this->assertTrue($usertest1->favoritedArticles->contains($userFavoritedArticle));

    }

    public function test_following()
    {

    }




}
