<?php

namespace Tests\Unit;

use App\Models\Article;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Hash;
use Tests\TestCase;

class UserTest extends TestCase
{
    use RefreshDatabase;

    /**
     * Test to get route key name for User model.
     *
     * @return void
     */
    public function test_getRouteKeyNames()
    {
        $user = new User();
        $this->assertEquals('username', $user->getRouteKeyName());
    }

    public function test_articles()
    {
        // GIVEN a context : Create user and create article
        $rose = User::factory()->create([
            'username' => 'Rose',
            'email' => 'rose@gmail.com',
            'password' => Hash::make('pwd'),
        ]);

        $article = Article::factory()->create([
            'title' => 'title',
            'description' => 'description',
            'body' => 'body',
            'user_id' => $rose->id,
        ]);

        // WHEN some condition
        $articles = $rose->articles;

        //THEN expect some output
        $this->assertCount(1, $articles, 'Rose n\'a pas écrit d\'article');
        $article = $articles->first();
        $this->assertEquals('title', $article->title);
        $this->assertEquals('description', $article->description);
        $this->assertEquals('body', $article->body);

    }

    public function test_favoriteArticles()
    {
        // GIVEN a context : Create users and create article
        $rose = User::factory()->create([
            'username' => 'Rose',
            'email' => 'rose@mail.com',
            'password' => Hash::make('pwd'),
        ]);
        $musonda = User::factory()->create([
            'username' => 'Musonda',
            'email' => 'musonda@mail.com',
            'password' => Hash::make('pwd2'),
        ]);

        $musondaArticle = Article::factory()->create([
            'title' => 'Réflexions sur la santé',
            'slug' => 'reflexions-sur-la-sante',
            'description' => 'description de l\'article santé',
            'body' => 'Article sur les réflexions de Musonda concernant la santé.',
            'user_id' => $musonda->id,
        ]);

        // WHEN Rose favorites an article by Musonda
        $rose->favoritedArticles()->attach($musondaArticle->id);

        // THEN expect some output
        $favoriteArticles = $rose->favoritedArticles;
        $this->assertCount(1, $favoriteArticles, 'Rose n\'a pas d\'article favoris');
        $favoritedArticle = $favoriteArticles->first();
        $this->assertEquals('Réflexions sur la santé', $favoritedArticle->title);
        $this->assertEquals('description de l\'article santé', $favoritedArticle->description);
        $this->assertEquals('Article sur les réflexions de Musonda concernant la santé.', $favoritedArticle->body);
    }

    /**
     * Test to check if followers are returned correctly.
     *
     * @return void
     */

    public function test_followers()
    {
        // GIVEN a context: Create users
        $rose = User::factory()->create([
            'username' => 'Rose',
            'email' => 'rose@mail.com',
            'password' => Hash::make('pwd'),
        ]);

        $musonda = User::factory()->create([
            'username' => 'Musonda',
            'email' => 'musonda@mail.com',
            'password' => Hash::make('pwd2'),
        ]);

        // WHEN: Insert a follower record into the followers table
        \DB::table('followers')->insert([
            'follower_id' => $musonda->id,
            'following_id' => $rose->id,
        ]);

        // THEN expect some output
        $followers = $rose->followers;
        $this->assertCount(1, $followers, 'Rose n\'a pas de follower');
        $follower = $followers->first();
        $this->assertEquals('Musonda', $follower->username);
        $this->assertEquals('musonda@mail.com', $follower->email);
    }


    public function test_following()
    {
        // GIVEN a context: Create users
        $rose = User::factory()->create([
            'username' => 'Rose',
            'email' => 'rose@mail.com',
            'password' => Hash::make('pwd'),
        ]);

        $musonda = User::factory()->create([
            'username' => 'Musonda',
            'email' => 'musonda@mail.com',
            'password' => Hash::make('pwd2'),
        ]);

        // WHEN: Insert a follower record into the followers table
        \DB::table('followers')->insert([
            'following_id' => $rose->id,
            'follower_id' => $musonda->id,
        ]);

        // THEN expect some output
        $following = $musonda->following;
        $this->assertCount(1, $following, 'Musonda ne suit pas Rose');
        $toFollow = $following->first();
        $this->assertEquals('Rose', $toFollow->username);
        $this->assertEquals('rose@mail.com', $toFollow->email);
    }

    public function test_doesUserFollowAnotherUser()
    {
        // GIVEN a context
        $rose = User::factory()->create([
            'username' => 'Rose',
            'email' => 'rose@mail.com',
            'password' => Hash::make('pwd'),
        ]);

        $musonda = User::factory()->create([
            'username' => 'Musonda',
            'email' => 'musonda@mail.com',
            'password' => Hash::make('pwd2'),
        ]);

        \DB::table('followers')->insert([
            'follower_id' => $rose->id,
            'following_id' => $musonda->id,
        ]);

        // WHEN some condition
        $result = $rose->doesUserFollowAnotherUser($rose->id, $musonda->id);
        $result2 = $rose->doesUserFollowAnotherUser($rose->id, $musonda->id + 1);

        // THEN expect some output
        $this->assertTrue($result, 'Rose follows Musonda');
        $this->assertFalse($result2, 'Rose does not follow someone else');
    }

}
