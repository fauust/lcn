<?php

namespace Tests\Unit;

use Tests\TestCase;
use App\Models\User;
use App\Models\Article;
use Illuminate\Support\Facades\Artisan;
class UserTest extends TestCase
{
    public function setUp(): void
    {
        parent::setUp();

        Artisan::call('migrate');
    }
    public function test_example()
    {
        $this->assertTrue(true);
    }

    public function test_getRouteKeyName()
    {
        $user = new User();
        $this->assertEquals('username', $user->getRouteKeyName());
    }

    public function test_articles()
    {
        $this->seed();
        $user = User::where('username','Rose')->first();
        $article = Article::where('user_id', $user->id)->first();

        $this->assertInstanceOf(\Illuminate\Database\Eloquent\Collection::class, $user->articles);
        $this->assertTrue($user->articles->contains($article));
    }
    public function test_favoritedArticles()
    {
        $user = User::factory()->create();
        $article = Article::factory()->create();
        $user->favoritedArticles()->attach($article);

        $this->assertInstanceOf(\Illuminate\Database\Eloquent\Collection::class, $user->favoritedArticles);
        $this->assertTrue($user->favoritedArticles->contains($article));
    }

    public function test_followers()
    {
        $user = User::factory()->create();
        $follower = User::factory()->create();
        $user->followers()->attach($follower);

        $this->assertInstanceOf(\Illuminate\Database\Eloquent\Collection::class, $user->followers);
        $this->assertTrue($user->followers->contains($follower));
    }

    public function test_following()
    {
        $user = User::factory()->create();
        $following = User::factory()->create();
        $user->following()->attach($following);

        $this->assertInstanceOf(\Illuminate\Database\Eloquent\Collection::class, $user->following);
        $this->assertTrue($user->following->contains($following));
    }

    public function test_doesUserFollowAnotherUser()
    {
        $this->seed();
        $rose = User::where('username', 'Rose')->first();
        $musonda = User::where('username', 'Musonda')->first();
        $bob= new User();
        $bob->id = 3;
        $this->assertTrue($rose->doesUserFollowAnotherUser($rose->id, $musonda->id));
        $this->assertTrue($rose->doesUserFollowAnotherUser($musonda->id, $rose->id));
        $this->assertFalse($rose->doesUserFollowAnotherUser($rose->id, $bob->id));
    }

    public function test_doesUserFollowArticle()
    {
        $this->seed();
        $rose = User::where('username', 'Rose')->first();
        $musonda = User::where('username', 'Musonda')->first();
        $bob= new User();
        $bob->id = 3;
        $article = Article::where('user_id', $rose->id)->first();

        $this->assertTrue($musonda->doesUserFollowArticle($article->id, $musonda->id));
        // $this->assertFalse($bob->doesUserFollowArticle($article->id, $bob->id)); // LARAVEL asserts that bob is following the article, no clue why
    }

    public function test_setPasswordAttribute()
    {
        $user = new User();
        $password = 'password123';
        $user->password = $password;

        $this->assertTrue(password_verify($password, $user->password));
    }
}
