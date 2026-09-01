<?php

namespace Tests\Unit;

use Illuminate\Support\Facades\Artisan;
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
    public function it_checks_if_user_is_created_correctly()
    {
        Artisan::call('db:seed');

        $user = User::where('email', 'rose@mail.com')->first();

        $this->assertNotNull($user, "User with email rose@mail.com should exist in the database.");

        $this->assertEquals('Rose', $user->username);
        $this->assertEquals('rose@mail.com', $user->email);

        $this->assertEquals('Je voudrais devenir enseignante pour enfants', $user->bio);
    }

    /** @test */
    public function test_articles()
    {
        // GIVEN
        $this->artisan('db:seed');
        $rose = User::where('email', 'rose@mail.com')->first();

        // WHEN
        $articles = $rose->articles;

        // THEN
        $this->assertCount(1, $articles, "Rose devrait avoir un article");
        $article = $articles->first();
        $this->assertEquals('Article de Rose', $article->title, "L'article de Rose devrait avoir pour titre 'Article de Rose'");
        $this->assertEquals('Contenu de l\'article de Rose', $article->body, "L'article de Rose devrait avoir pour contenu 'Contenu de l'article de Rose'");
    }

//    /** @test */
//    public function test_favouriteArticles()
//    {
//        // GIVEN
//        //$user-> favouriteArticle()==
//        $this->artisan('db:seed');
//        $musonda = User::where('email', 'musonda@mail.com')->first();
//        $rose = User::where('email', 'rose@mail.com')->first();
//        $articleRose = Article::factory()->create([
//            'user_id' => $rose->id,
//            'title' => 'Article de Rose',
//            'body' => 'Contenu de l\'article de Rose',
//        ]);
//
//        // WHEN
//        $articles = $musonda->favoritedArticles()->attach($articleRose->id);
//
//        // THEN
//        $this->assertEquals( $rose->articles, $articles);
//    //        $this->assertEquals('Article de Rose', $article->title, "L'article de Rose devrait avoir pour titre 'Article de Rose'");
////        $this->assertEquals('Contenu de l\'article de Rose', $article->body, "L'article de Rose devrait avoir pour contenu 'Contenu de l'article de Rose'");


//    }


}
