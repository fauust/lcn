<?php

namespace Tests\Unit;

use Tests\TestCase;
use App\Models\User;
use App\Models\Article;
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
    public function test_doesUserFollowArticle()
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

        $article = Article::factory()->create([
            'user_id' => $musonda->id,
            'title' => 'Premier article de Musonda',
            'body' => 'Contenu du premier article de Musonda',
        ]);

        $rose->favoritedArticles()->attach($article->id);

        // WHEN
        $doesFollow = $rose->favoritedArticles->contains($article);

        // THEN
        $this->assertNotNull($article, "Premier article de Musonda devrait exister");
        $this->assertIsIterable($rose->favoritedArticles, "Les articles favoris de Rose devraient être itérables");
        $this->assertTrue($doesFollow, "Rose devrait suivre le premier article de Musonda");
    }


    /** @test */
    public function test_setPasswordAttribute()
    {
        // GIVEN
        $rose = User::factory()->create([
            'username' => 'Rose',
            'email' => 'rose@mail.com',
            'password' => 'pwd',
            'bio' => 'Je voudrais devenir enseignante pour enfants',
        ]);

        // WHEN
        // Pas d'action nécessaire, car la factory utilise automatiquement la méthode setPasswordAttribute

        // THEN
        $this->assertTrue(Hash::check('pwd', $rose->password), "Le mot de passe de Rose devrait être hashé");
    }

    /** @test */
    public function test_getJWTIdentifier()
    {
        // GIVEN
        $user = User::factory()->create();

        // WHEN
        $jwtIdentifier = $user->getJWTIdentifier();

        // THEN
        $this->assertNotNull($jwtIdentifier, "getJWTIdentifier() devrait retourner une valeur non nulle");
        $this->assertEquals($user->getKey(), $jwtIdentifier, "getJWTIdentifier() devrait retourner la clé de l'utilisateur");
    }

    /** @test */
    public function test_getJWTCustomClaims()
    {
        // GIVEN
        $user = User::factory()->create();

        // WHEN
        $jwtCustomClaims = $user->getJWTCustomClaims();

        // THEN
        $this->assertIsArray($jwtCustomClaims, "getJWTCustomClaims() devrait retourner un tableau");
        $this->assertEquals($user->id, $jwtCustomClaims['id'], "getJWTCustomClaims() devrait contenir l'id de l'utilisateur");
        $this->assertEquals($user->username, $jwtCustomClaims['username'], "getJWTCustomClaims() devrait contenir l'username de l'utilisateur");
    }

    /** @test */
    public function test_isAdmin()
    {
        // GIVEN
        $adminUser = User::factory()->create(['role' => 'admin']);
        $nonAdminUser = User::factory()->create(['role' => 'user']);

        // WHEN
        $isAdmin = $adminUser->isAdmin();
        $isNotAdmin = $nonAdminUser->isAdmin();

        // THEN
        $this->assertTrue($isAdmin, "isAdmin() devrait retourner true pour les utilisateurs admin");
        $this->assertFalse($isNotAdmin, "isAdmin() devrait retourner false pour les utilisateurs non-admin");
    }
}
