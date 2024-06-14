<?php

namespace Tests\Unit;

use App\Models\Article;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Hash;
use Tests\TestCase;

class ArticleTest extends TestCase
{
    use RefreshDatabase;
    /**
     * A basic unit test example.
     *
     * @return void
     */
    public function test_articles()
    {
        // GIVEN : Create user and create article
        $rose=User::factory()->create([
            'username'=> 'Rose',
            'email'=> 'rose@gmail.com',
            'password' => Hash::make('pwd'),
        ]);


        $article = Article::factory()->create([
            'title' => 'title',
            'description' => 'description',
            'body' => 'body',
            'user_id' => $rose->id,
        ]);

        // WHEN
        $articles=$rose->articles;

        //THEN
        $this->assertCount(1,$articles,'Rose n\'a pas écrit d\'article');
        $article=$articles->first();
        $this->assertEquals('title', $article->title);
        $this->assertEquals('description', $article->description);
        $this->assertEquals('body', $article->body);

    }


}
