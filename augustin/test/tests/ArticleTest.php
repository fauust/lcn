<?php

namespace Tests\Feature;

use App\Models\Article;
use App\Models\Tag;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class ArticleTest extends TestCase
{
    use RefreshDatabase;

    public function testShowArticle()
    {
        $article = Article::factory()->create();

        $response = $this->get('api/articles/' . $article->slug);
        $response->assertExactJson([
                'article' => [
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
                ]
            ]);
    }
    public function testListArticles()
    {
        $article = Article::factory()->create();
        $article2 = Article::factory()->create();
        $article3 = Article::factory()->create();
        $response= $this->get('api/articles');
        $response->assertExactJson([
            'articles' => [
                [
                    'slug' => $article->slug,
                    'title' => $article->title,
                    'description' => $article->description,
                    'body' => $article->body,
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
                ],
                [
                    'slug' => $article2->slug,
                    'title' => $article2->title,
                    'description' => $article2->description,
                    'body' => $article2->body,
                    'tagList' => [],
                    'createdAt' => $article2->created_at,
                    'updatedAt' => $article2->updated_at,
                    'favorited' => false,
                    'favoritesCount' => 0,
                    'author' => [
                        'username' => $article2->user->username,
                        'bio' => $article2->user->bio,
                        'image' => $article2->user->image,
                        'following' => false
                    ]
                ],
                [
                    'slug' => $article3->slug,
                    'title' => $article3->title,
                    'description' => $article3->description,
                    'body' => $article3->body,
                    'tagList' => [],
                    'createdAt' => $article3->created_at,
                    'updatedAt' => $article3->updated_at,
                    'favorited' => false,
                    'favoritesCount' => 0,
                    'author' => [
                        'username' => $article3->user->username,
                        'bio' => $article3->user->bio,
                        'image' => $article3->user->image,
                        'following' => false
                    ]
                ]
            ],
            'articlesCount' => 3
        ]);
    }
    public function testListArticlesWithTags()
    {
        $article = Article::factory()->create();

        $article2 = Article::factory()->create();

        $tag1 = Tag::factory()->create();
        $tag2 = Tag::factory()->create();

        $article->tags()->attach($tag1->id);
        $article->tags()->attach($tag2->id);

        $article2->tags()->attach($tag1->id);



        $response = $this->get('api/articles?tag='. $tag1->name);

        $response -> assertExactJson([
            'articles' => [
                [
                    'slug' => $article->slug,
                    'tagList' => [$tag1->name, $tag2->name],
                    'title' => $article->title,
                    'description' => $article->description,
                    'body' => $article->body,
                    'createdAt' => $article->created_at,
                    'updatedAt' => $article->updated_at,
                    'favorited' => false,
                    'favoritesCount' => 0,
                    'author' => [
                        'username' => User::where('id', $article->user_id)->first()->username,
                        'bio' =>  User::where('id', $article->user_id)->first()->bio,
                        'image' => User::where('id', $article->user_id)->first()->image,
                        'following' => false
                    ]
                ],
                [
                    'slug' => $article2->slug,
                    'title' => $article2->title,
                    'description' => $article2->description,
                    'body' => $article2->body,
                    'tagList' => [$tag1->name],
                    'createdAt' => $article2->created_at,
                    'updatedAt' => $article2->updated_at,
                    'favorited' => false,
                    'favoritesCount' => 0,
                    'author' => [
                        'username' => User::where('id', $article2->user_id)->first()->username,
                        'bio' =>  User::where('id', $article2->user_id)->first()->bio,
                        'image' => User::where('id', $article2->user_id)->first()->image,
                        'following' => false
                    ]
                ]
            ],
            'articlesCount' => 2
        ]);

        $response= $this->get('api/articles?tag='. $tag2->name);
        $response -> assertExactJson([
            'articles' => [
                [
                    'slug' => $article->slug,
                    'title' => $article->title,
                    'description' => $article->description,
                    'body' => $article->body,
                    'tagList' => [$tag1->name, $tag2->name],
                    'createdAt' => $article->created_at,
                    'updatedAt' => $article->updated_at,
                    'favorited' => false,
                    'favoritesCount' => 0,
                    'author' => [
                        'username' => User::where('id', $article->user_id)->first()->username,
                        'bio' =>  User::where('id', $article->user_id)->first()->bio,
                        'image' => User::where('id', $article->user_id)->first()->image,
                        'following' => false
                    ]
                ]
            ],
            'articlesCount' => 1
        ]);

        $response = $this->get('api/articles?author='.User::where('id', $article->user_id)->first()->username);
        $response -> assertExactJson([
            'articles' => [
                [
                    'slug' => $article->slug,
                    'title' => $article->title,
                    'description' => $article->description,
                    'body' => $article->body,
                    'tagList' => [$tag1->name, $tag2->name],
                    'createdAt' => $article->created_at,
                    'updatedAt' => $article->updated_at,
                    'favorited' => false,
                    'favoritesCount' => 0,
                    'author' => [
                        'username' => User::where('id', $article->user_id)->first()->username,
                        'bio' =>  User::where('id', $article->user_id)->first()->bio,
                        'image' => User::where('id', $article->user_id)->first()->image,
                        'following' => false
                    ]
                ]
            ],
            'articlesCount' => 1
        ]);
    }
}
