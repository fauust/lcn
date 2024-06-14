<?php

namespace Tests\Unit;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Artisan;
use Tests\TestCase;

class UserTest extends TestCase
{
    use RefreshDatabase;

    public function test_getRouteKeyNames()
    {
        // Given: Un nouvel utilisateur est créé
        $user = new User();

        // When: La méthode getRouteKeyName est appelée
        $routeKeyName = $user->getRouteKeyName();

        // Then: retourne un 'username'
        $this->assertEquals('username', $routeKeyName);
    }


    public function test_articles()
    {
        // Given: La base de données est peuplée et un utilisateur spécifique est récupéré
        Artisan::call('db:seed');
        $user = \App\Models\User::where('username', 'Rose')->first();

        // Assert: L'utilisateur n'est pas nul
        $this->assertNotNull($user);

        // When: On récupère les articles de l'utilisateur
        $articles = $user->articles();

        // Then: L'utilisateur doit avoir des articles
        $this->assertInstanceOf(\Illuminate\Database\Eloquent\Relations\HasMany::class, $articles);
        $firstArticle = $articles->first();

        // Le premier article a les propriétés attendues
        $this->assertEquals("Article de Rose", $firstArticle->title);
        $this->assertEquals("Contenu article de Rose", $firstArticle->description);
        $this->assertEquals("Article éducatif", $firstArticle->body);
        $this->assertEquals("slug article rose", $firstArticle->slug);
        $this->assertEquals("éducation", $firstArticle->tags()->first()->name);
    }

    public function test_favoriteArticles()
    {
        // Given: La base de données est peuplée et un utilisateur spécifique est récupéré
        Artisan::call('db:seed');
        $user = \App\Models\User::where('username', 'Musonda')->first();

        // Assert: L'utilisateur n'est pas nul et la relation des articles favoris est correcte
        $this->assertNotNull($user);
        $this->assertInstanceOf(\Illuminate\Database\Eloquent\Relations\BelongsToMany::class, $user->favoritedArticles());

        // When: On récupère les articles favoris de l'utilisateur
        $favoritedArticles = $user->favoritedArticles;

        // Assert: L'utilisateur doit avoir des articles favoris
        $this->assertNotNull($favoritedArticles);
        $firstFavoritedArticle = $favoritedArticles->first();

        // Then: Le premier article favori a les propriétés attendues
        $this->assertEquals("Article de Rose", $firstFavoritedArticle->title);
        $this->assertEquals("Contenu article de Rose", $firstFavoritedArticle->description);
        $this->assertEquals("Article éducatif", $firstFavoritedArticle->body);
        $this->assertEquals("slug article rose", $firstFavoritedArticle->slug);
        $this->assertEquals("éducation", $firstFavoritedArticle->tags()->first()->name);
    }

    public function test_followers()
    {
        // Given: La base de données est peuplée et un utilisateur spécifique est récupéré
        Artisan::call('db:seed');
        $rose = \App\Models\User::where('username', 'Rose')->first();

        // Assert: L'utilisateur 'Rose' n'est pas nul
        $this->assertNotNull($rose);

        // When: On récupère les followers de l'utilisateur
        $followers = $rose->followers;

        // Then: Le premier follower doit avoir le nom d'utilisateur 'Musonda'
        $this->assertNotNull($followers);
        $this->assertGreaterThan(0, $followers->count());
        $this->assertEquals('Musonda', $followers->first()->username);
    }

    public function test_following()
    {
        // Given: La base de données est peuplée et un utilisateur spécifique est récupéré
        Artisan::call('db:seed');
        $rose = \App\Models\User::where('username', 'Rose')->first();

        // Assert: L'utilisateur 'Rose' n'est pas nul
        $this->assertNotNull($rose);

        // When: On récupère les utilisateurs que 'Rose' suit
        $following = $rose->following;

        // Assert: Les utilisateurs suivis par 'Rose' ne doivent pas être nuls
        $this->assertNotNull($following);
        $this->assertGreaterThan(0, $following->count());

        // Then: Le premier utilisateur suivi doit avoir le nom d'utilisateur 'Musonda'
        $this->assertEquals('Musonda', $following->first()->username);
    }

    public function test_doesUserFollowAnotherUser()
    {
        // Given: La base de données est peuplée et un utilisateur spécifique est récupéré
        Artisan::call('db:seed');
        $rose = \App\Models\User::where('username', 'Rose')->first();

        // Assert: L'utilisateur 'Rose' n'est pas nul
        $this->assertNotNull($rose);

        // When: On récupère l'utilisateur que 'Rose' suit
        $firstFollowing = $rose->following()->first();

        // Assert: L'utilisateur suivi par 'Rose' n'est pas nul
        $this->assertNotNull($firstFollowing);

        // Then: Vérifier que 'Rose' suit cet utilisateur
        $this->assertTrue($rose->doesUserFollowAnotherUser($rose->id, $firstFollowing->id));

        // Then: Vérifier que 'Rose' ne se suit pas lui-même
        $this->assertFalse($rose->doesUserFollowAnotherUser($rose->id, $rose->id));
    }

    public function test_doesUserFollowArticle()
    {
        // Given: La base de données est peuplée et un utilisateur spécifique est récupéré
        Artisan::call('db:seed');
        $rose = \App\Models\User::where('username', 'Rose')->first();

        // Assert: L'utilisateur 'Rose' n'est pas nul
        $this->assertNotNull($rose);

        // When: On récupère le premier article favori de 'Rose'
        $firstFavoritedArticle = $rose->favoritedArticles->first();

        // Assert: Le premier article favori de 'Rose' n'est pas nul
        $this->assertNotNull($firstFavoritedArticle);

        // Then: Vérifier que 'Rose' suit cet article
        $this->assertTrue($rose->doesUserFollowArticle($rose->id, $firstFavoritedArticle->id));

        // When: On récupère le premier article écrit par 'Rose'
        $firstArticle = $rose->articles->first();

        // Assert: Le premier article écrit par 'Rose' n'est pas nul
        $this->assertNotNull($firstArticle);

        // Then: Vérifier que 'Rose' ne suit pas cet article (car c'est son propre article)
        $this->assertFalse($rose->doesUserFollowArticle($rose->id, $firstArticle->id));
    }
}
