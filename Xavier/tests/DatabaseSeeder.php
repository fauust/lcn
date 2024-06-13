<?php

namespace Database\Seeders;

use App\Models\Article;
use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     *
     * @return void
     */
    public function run(): void
    {
        // Create 2 users
        User::factory()->create( [ // id = 1
            'username'  => 'Rose',
            'email'     => 'rose@mail.com',
            'password'  => Hash::make('pwd'),
            'image'     => null,
            'bio'       => 'Je voudrais devenir enseignante pour enfants',
        ]);
        User::factory()->create( [ // id = 2
            'username'  => 'Musonda',
            'email'     => 'musonda@mail.com',
            'password'  => Hash::make('pwd2'),
            'image'     => null,
            'bio'       => 'Je songe à devenir infirmière, j’écris mes réflexions',
        ]);
        // Insert into Followers table : use id of users created above :
        DB::table('followers')->insert([
            'follower_id' => 1,
            'following_id' => 2,
        ]);
        DB::table('followers')->insert([
            'follower_id' => 2,
            'following_id' => 1,
        ]);
        // Create one article for Rose
        Article::factory()->create([
            'user_id' => 1,
            'title' => 'Article de Rose',
            'slug' => 'article-de-rose',
            'description' => 'Description de l\'article de Rose',
            'body' => 'Blablabla Rose',
        ]);
        // associate the article to the user
        DB::table('article_user')->insert([
            'article_id' => 1,
            'user_id' => 2,
        ]);
        // Create two articles for Musonda
        Article::factory()->create([
            'user_id' => 2,
            'title' => 'Article de Musonda 1',
            'slug' => 'article-de-musonda-1',
            'description' => 'Description de l\'article de Musonda 1',
            'body' => 'Blablabla Musonda 1',
        ]);
        Article::factory()->create([
            'user_id' => 2,
            'title' => 'Article de Musonda 2',
            'slug' => 'article-de-musonda-2',
            'description' => 'Description de l\'article de Musonda 2',
            'body' => 'Blablabla Musonda 2',
        ]);
        // associate the articles to the user
        DB::table('article_user')->insert([
            'article_id' => 2,
            'user_id' => 1,
        ]);
        DB::table('article_user')->insert([
            'article_id' => 3,
            'user_id' => 1,
        ]);
        // Create tag
        DB::table('tags')->insert([
            'name' => 'Education',
        ]);
        // Associate tag to article
        DB::table('article_tag')->insert([
            'article_id' => 1,
            'tag_id' => 1,
        ]);
        // Insert Comment to article
        DB::table('comments')->insert([
            'user_id' => 2,
            'article_id' => 1,
            'body' => 'Commentaire de Musonda sur l\'article de Rose : j\'adore ta manière de concevoir l\'éducation des enfants',
        ]);

    }
}
