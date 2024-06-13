<?php

namespace Tests\Unit;

use Tests\TestCase;
use App\Models\User;
use App\Models\Article;
use App\Models\Tag;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Hash;

class UserTest extends TestCase
{
    use RefreshDatabase;

    /** @test */
    public function test_getRouteKeyName()
    {
        // GIVEN
        $user = new User();

        // WHEN
        $routeKeyName = $user->getRouteKeyName();

        // THEN
        $this->assertEquals('username', $routeKeyName, "getRouteKeyName() devrait retourner 'username'");
    }

    /** @test */
    public function test_articles()
    {
        // GIVEN
        $rose = User::factory()->create([
            'username' => 'Rose',
            'email' => 'rose@mail.com',
            'password' => Hash::make('pwd'),
            'bio' => 'Je voudrais devenir enseignante pour enfants',
        ]);

        $articleRose = Article::factory()->create([
            'user_id' => $rose->id,
            'title' => 'Article de Rose',
            'body' => 'Contenu de l\'article de Rose',
        ]);

        // WHEN
        $articles = $rose->articles;

        // THEN
        $this->assertCount(1, $articles, "Rose devrait avoir un article");
        $article = $articles->first();
        $this->assertEquals('Article de Rose', $article->title, "L'article de Rose devrait avoir pour titre 'Article de Rose'");
        $this->assertEquals('Contenu de l\'article de Rose', $article->body, "L'article de Rose devrait avoir pour contenu 'Contenu de l'article de Rose'");
    }

    /** @test */
    public function test_favoritedArticles()
    {
        // GIVEN
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

        $article1 = Article::factory()->create([
            'user_id' => $musonda->id,
            'title' => 'Premier article de Musonda',
            'body' => 'Contenu du premier article de Musonda',
        ]);

        $article2 = Article::factory()->create([
            'user_id' => $musonda->id,
            'title' => 'Deuxième article de Musonda',
            'body' => 'Contenu du deuxième article de Musonda',
        ]);

        $rose->favoritedArticles()->attach($article1->id);
        $rose->favoritedArticles()->attach($article2->id);

        // WHEN
        $favoritedArticles = $rose->favoritedArticles;

        // THEN
        $this->assertIsIterable($favoritedArticles, "L'attribut favoritedArticles devrait être itérable");
        $this->assertCount(2, $favoritedArticles, "Rose devrait avoir deux articles favoris");
        $this->assertEquals('Premier article de Musonda', $favoritedArticles->get(0)->title, "Le titre du premier article favori devrait être 'Premier article de Musonda'");
        $this->assertEquals('Deuxième article de Musonda', $favoritedArticles->get(1)->title, "Le titre du deuxième article favori devrait être 'Deuxième article de Musonda'");
    }

    /** @test */
    public function test_followers()
    {
        // GIVEN
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

        $rose->followers()->attach($musonda->id);

        // WHEN
        $followers = $rose->followers;

        // THEN
        $this->assertCount(1, $followers, "Rose devrait avoir un follower");
        $this->assertEquals('Musonda', $followers->first()->username, "Le follower de Rose devrait s'appeler 'Musonda'");
    }

    /** @test */
    public function test_following()
    {
        // GIVEN
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

        $musonda->following()->attach($rose->id);

        // WHEN
        $following = $musonda->following;

        // THEN
        $this->assertCount(1, $following, "Musonda devrait suivre un utilisateur");
        $this->assertEquals('Rose', $following->first()->username, "Musonda devrait suivre Rose");
    }

    /** @test */
    public function test_doesUserFollowAnotherUser()
    {
        // GIVEN
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

        $rose->following()->attach($musonda->id);

        // WHEN
        $isFollowing = $rose->following->contains($musonda);

        // THEN
        $this->assertTrue($isFollowing, "Rose devrait suivre Musonda");
    }



}
