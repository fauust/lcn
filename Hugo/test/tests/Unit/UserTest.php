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

}
