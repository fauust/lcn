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

    public function test_doesUserFollowAnotherUser()
    {
        $this->seed();

        $rose = User::where('username', 'Rose')->first();
        $musonda = User::where('username', 'Musonda')->first();

        $this->assertTrue($rose->doesUserFollowAnotherUser($rose->id, $musonda->id));
    }

//    public function test_doesUserFollowArticle()
//    {
//        $this->seed();
//
//        $musonda = User::where('username', 'Musonda')->first();
//        $rose = User::where('username', 'Rose')->first();
//        $articleId = Article::where('user_id',$rose->id)->first();
//        $this->assertTrue($rose->doesUserFollowArticle($musonda->id, $articleId->id));
//    }

//    public function test_idAndName()
//    {
//
//    }
}
