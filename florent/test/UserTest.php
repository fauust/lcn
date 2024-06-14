<?php

namespace Tests\Unit;

// use PHPUnit\Framework\TestCase;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;
use App\Models\User;
use App\Models\Article;

class UserTest extends TestCase
{
    /**
     * A basic unit test example.
     *
     * @return void
     */
    // public function test_example()
    // {
    //     $this->assertTrue(true);
    // }
    use RefreshDatabase;

    public function test_getRouteKeyNames()
    {
        $user = new User();

        $this->assertEquals('username', $user->getRouteKeyName());
    }

    public function test_articles()
    {
        $title = 'TITLE';
        $slug = 'SLUG';
        $desc = 'DESCRIPTION';
        $body = 'BODY';

        User::factory()->create([
            'id' => 1,
            'username' => 'Rose',
        ]);

        Article::factory()->create([
            'id' => 1,
            'user_id' => 1,
            'title' => $title,
            'slug' => $slug,
            'description' => $desc,
            'body' => $body
        ]);

        $user = User::where('id', 1)->firstOrFail();

        $item = $user->articles()->get()->firstOrFail();

        $this->assertNotEmpty($item);
        $this->assertEquals($title, $item->title);
        $this->assertEquals($slug, $item->slug);
        $this->assertEquals($desc, $item->description);
        $this->assertEquals($body, $item->body);
    }

    public function test_favouriteArticles()
    {
        $user = User::factory()->create([
            'username' => 'Rose',
        ]);

        $article1 = Article::factory()->create([
            'title' => 'First Article',
            'slug' => 'first-article',
        ]);

        $article2 = Article::factory()->create([
            'title' => 'Second Article',
            'slug' => 'second-article',
        ]);

        $user->favoritedArticles()->attach($article1->id);
        $user->favoritedArticles()->attach($article2->id);

        $favoritedArticles = $user->favoritedArticles;

        $this->assertCount(2, $favoritedArticles);
        $this->assertTrue($favoritedArticles->contains($article1));
        $this->assertTrue($favoritedArticles->contains($article2));
    }

    // public function test_followers()
    // {
    //     $this->assertTrue(true);
    // }

    // public function test_following()
    // {
    //     $this->assertTrue(true);
    // }

    // public function test_doesUserFollowAnotherUser()
    // {
    //     $this->assertTrue(true);
    // }

    // public function test_doesUserFollowArticle()
    // {
    //     $this->assertTrue(true);
    // }
}
