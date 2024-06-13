<?php

namespace Tests\Unit;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Artisan;
use Tests\TestCase;

class UserTest extends TestCase
{

    use RefreshDatabase;

    public function test_example()
    {
        $response = $this->get('/');

        $response->assertStatus(200);
    }

    public function test_getRouteKeyName(){

        $user = new User();
        $this->assertTrue($user->getRouteKeyName() === 'username', 'ok');
    }

    public function test_articles(){

        $this->artisan('db:seed');

        $user = User::where('email', 'rose@mail.com')->first();


        $articles = $user->articles;

        $this->assertCount(1, $articles, 'Rose devrait avoir un article');
        $article = $articles->first();
        $this->assertEquals('Mon article', $article->title, "L'artixle de Rose doit avoir pour titre Mon article");
        $this->assertEquals('Mon article est super', $article->body, "Le contenu de l'article de rose est Mon article est super");

    }

   

}
