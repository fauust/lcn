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
        $user = User::factory()->create([
            'username' => 'toto'
        ]);

        $articles = Article::factory()->count(1)->create([
            'user_id' => $user->id
        ]);

        $response = $this->get('api/articles/?author=' . $user->username);

        $expectedArticles = $articles->map(function($article) {
            return [
                'slug' => $article->slug,
                    'title' => $article->title,
                    'body' => $article->body,
                    'description' => $article->description,
                    'tagList' => [],
                    'createdAt' => $article->created_at,
                    'updatedAt' => $article->updated_at,
                    'favorited' => false,
                    'favoritesCount' => 0,
                    'author' => [
                        'username' => $article->user->username,
                        'bio' => $article->user->bio,
                        'image' => $article->user->image,
                        'following' => false
                    ]
                    ];
        })->toArray();

        $response->assertExactJson([
            'articles' => $expectedArticles, 'articlesCount' => count($articles)
        ]);
    }

    // public function test_favouriteArticles()
    // {
    //     $this->assertTrue(true);
    // }

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
