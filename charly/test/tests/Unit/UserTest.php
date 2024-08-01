<?php

namespace Tests\Unit;

use Illuminate\Support\Facades\Hash;
use Tests\TestCase;
use Illuminate\Foundation\Testing\RefreshDatabase;
use App\Models\User;
use App\Models\Article;

class UserTest extends TestCase
{
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();
        $this->seed(\Database\Seeders\DatabaseSeeder::class);
    }

    public function test_getRouteKeyNames()
    {
        $user = new User();
        $this->assertEquals('username', $user->getRouteKeyName());
    }

    public function test_articles()
    {
        $user = User::where('username', 'Rose')->first();
        $this->assertNotNull($user);
        $articles = $user->articles;
        $this->assertCount(1, $articles);
        $this->assertEquals('Éducation des enfants', $articles->first()->title);
        $this->assertEquals('Une réflexion sur l’éducation des enfants', $articles->first()->description);
        $this->assertEquals('Contenu de l’article de Rose...', $articles->first()->body);
    }

    public function test_favoritedArticles()
    {
        $this->seed(\Database\Seeders\DatabaseSeeder::class);
        $user = User::where('username', 'Rose')->first();
        $this->assertNotNull($user);
        $article = Article::where('title', 'Éducation des enfants')->first();
        $this->assertNotNull($article);
        $user->favoritedArticles()->attach($article->id);
        $favoriteArticles = $user->favoritedArticles;
        $this->assertCount(1, $favoriteArticles);
        $this->assertEquals('Éducation des enfants', $favoriteArticles->first()->title);
    }

    public function test_followers()
    {
        $user = User::where('username', 'Musonda')->first();
        $followers = $user->followers;
        $this->assertNotNull($user);
        $this->assertCount(1, $followers);
        $this->assertEquals('Rose', $followers->first()->username);
    }

    public function test_following()
    {
        $user = User::where('username', 'Rose')->first();
        $following = $user->following;
        $this->assertNotNull($user);
        $this->assertCount(1, $following);
        $this->assertEquals('Musonda', $following->first()->username);
    }

    public function test_doesUserFollowAnotherUser()
    {
        $rose = User::where('username', 'Rose')->first();
        $musonda = User::where('username', 'Musonda')->first();
        $this->assertTrue($rose->following->contains($musonda));
    }

    public function test_doesUserFollowArticle()
    {
        $rose = User::where('username', 'Rose')->first();
        $article = Article::where('title', 'Éducation des enfants')->first();
        $rose->favoritedArticles()->attach($article);
        $this->assertTrue($rose->favoritedArticles->contains($article));
    }

    public function test_setPasswordAttribute()
    {
        $user = User::factory()->make();
        $password = 'testpassword';
        $user->setPasswordAttribute($password);
        $this->assertNotEquals($password, $user->password);
        $this->assertTrue(Hash::check($password, $user->password));
    }

    public function test_getJWTIdentifier()
    {
        $user = User::factory()->create();
        $jwtIdentifier = $user->getJWTIdentifier();
        $this->assertEquals($user->getKey(), $jwtIdentifier);
    }

    public function test_getJWTCustomClaims()
    {
        $user = User::factory()->create();
        $claims = $user->getJWTCustomClaims();
        $this->assertArrayHasKey('username', $claims);
        $this->assertEquals($user->username, $claims['username']);
        $this->assertArrayHasKey('id', $claims);
        $this->assertEquals($user->id, $claims['id']);
    }

    public function test_doesUserIsAdmin()
    {
        $user = User::factory()->create();
        $this->assertFalse($user->doesUserIsAdmin($user->id));
        $user->role = 'admin';
        $user->save();
        $this->assertTrue($user->doesUserIsAdmin($user->id));
    }

}
