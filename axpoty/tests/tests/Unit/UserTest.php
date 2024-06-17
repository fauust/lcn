<?php

namespace Tests\Unit;

#use PHPUnit\Framework\TestCase;

use Tests\TestCase;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Artisan;

class UserTest extends TestCase
{
    /**
     * A basic unit test example.
     *
     * @return void
     */
    use RefreshDatabase;


    public function test_getRouteKeyNames()
    {
        $user = new \App\Models\User();
        $this->assertEquals('username', $user->getRouteKeyName());
    }

    public function test_articles()
    {
        Artisan::call('db:seed');
        $user = \App\Models\User::where('username', 'Rose')->first();
        # Assert user not null
        $this->assertNotNull($user);
        # Assert user has articles
        $this->assertInstanceOf(\Illuminate\Database\Eloquent\Relations\HasMany::class, $user->articles());
        $this->assertEquals("L'importance de l'éducation des enfants", $user->articles()->first()->title);
        $this->assertEquals("Un article sur l'éducation des enfants", $user->articles()->first()->description);
        $this->assertEquals("Le contenu de l'article sur l'éducation des enfants...", $user->articles()->first()->body);
        $this->assertEquals("importance-education-enfants", $user->articles()->first()->slug);
        $this->assertEquals("éducation", $user->articles()->first()->tags()->first()->name);
    }

    public function test_favoritedArticles()
    {
        Artisan::call('db:seed');
        $user = \App\Models\User::where('username', 'Musonda')->first();
        $this->assertInstanceOf(\Illuminate\Database\Eloquent\Relations\BelongsToMany::class, $user->favoritedArticles());
        $this->assertNotNull($user->favoritedArticles);
        $this->assertEquals("L'importance de l'éducation des enfants", $user->favoritedArticles->first()->title);
        $this->assertEquals("Un article sur l'éducation des enfants", $user->favoritedArticles->first()->description);
        $this->assertEquals("Le contenu de l'article sur l'éducation des enfants...", $user->favoritedArticles->first()->body);
        $this->assertEquals("importance-education-enfants", $user->favoritedArticles->first()->slug);
        $this->assertEquals("éducation", $user->favoritedArticles->first()->tags()->first()->name);
    }


    public function test_followers()
    {
        Artisan::call('db:seed');
        $rose = \App\Models\User::where('username', 'Rose')->first();
        $this->assertNotNull($rose);
        $this->assertEquals('Musonda', $rose->followers->first()->username);
    }

    public function test_following()
    {
        Artisan::call('db:seed');
        $rose = \App\Models\User::where('username', 'Rose')->first();
        $this->assertNotNull($rose);
        $this->assertEquals('Musonda', $rose->following->first()->username);
    }

    public function test_doesUserFollowAnotherUser()
    {
        Artisan::call('db:seed');
        $rose = \App\Models\User::where('username', 'Rose')->first();
        $this->assertNotNull($rose);
        $this->assertTrue($rose->doesUserFollowAnotherUser($rose->id,  $rose->following()->first()->id));
        $this->assertFalse($rose->doesUserFollowAnotherUser($rose->id,  $rose->id));
    }

    public function test_doesUserFollowArticle()
    {
        Artisan::call('db:seed');
        $rose = \App\Models\User::where('username', 'Rose')->first();
        $this->assertNotNull($rose);
        $this->assertTrue($rose->doesUserFollowArticle($rose->id, $rose->favoritedArticles->first()->id));
        $this->assertFalse($rose->doesUserFollowArticle($rose->id, $rose->articles->first()->id));
    }
}
