<?php

namespace Tests\Unit;

use App\Models\Article;
use App\Models\User;
use Tests\TestCase;

class FollowingTest extends TestCase
{
    protected function setUp(): void
    {
        parent::setUp();

        // Exécuter les migrations
        $this->artisan('migrate');
    }

    // Vos méthodes de test...

    /**
     * A basic unit test example.
     *
     * @return void
     */
    public function test_example()
    {
        $this->assertTrue(true);
    }

    public function test_followers()
    {
        $user = User::factory()->create();
        $follower = User::factory()->create();
        $user->followers()->attach($follower);

        $this->assertTrue($user->followers->contains($follower));
    }

    public function test_following()
    {
        $user = User::factory()->create();
        $follower = User::factory()->create();
        $user->followers()->attach($follower);

        $this->assertTrue($follower->following->contains($user));
    }

    public function test_doesUserFollowAnotherUser()
    {
        $this->seed();

        $rose = User::where('username', 'Rose')->first();
        $musonda = User::where('username', 'Musonda')->first();

        $this->assertTrue($rose->doesUserFollowAnotherUser($rose->id, $musonda->id));
    }

    public function test_favouriteArticles()
    {
        $this->seed();

        $musonda = User::where('username', 'Musonda')->first();
        $rose = User::where('username', 'Rose')->first();
        $article = Article::where('user_id',$rose->id)->first();
        $musonda->favoritedArticles()->attach($article->id);
        $this->assertTrue($musonda->favoritedArticles->contains($article));
    }

    public function test_doesUserFollowArticle()
    {
        $this->seed();

        $musonda = User::where('username', 'Musonda')->first();
        $rose = User::where('username', 'Rose')->first();
        $article = Article::where('user_id', $rose->id)->first();
        $musonda->favoritedArticles()->attach($article->id);
        $this->assertTrue($musonda->doesUserFollowArticle($musonda->id, $article->id));
    }


//    public function test_idAndName()
//    {
//
//    }
}
