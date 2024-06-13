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
        // \App\Models\User::factory(10)->create();
        User::factory()->create( [
            'username'  => 'Rose',
            'email'     => 'rose@mail.com',
            'password'  => Hash::make('pwd'),
            'image'     => null,
            'bio'       => 'Je voudrais devenir enseignante pour enfants',
        ]);
        User::factory()->create( [
            'username'  => 'Musonda',
            'email'     => 'musonda@mail.com',
            'password'  => Hash::make('pwd2'),
            'image'     => null,
            'bio'       => 'Je songe à devenir infirmière, j’écris mes réflexions',
        ]);
        // Followers :
        DB::table('followers')->insert([
            'follower_id' => 1,
            'following_id' => 2,
        ]);
        DB::table('followers')->insert([
            'follower_id' => 2,
            'following_id' => 1,
        ]);
        Article::factory()->create([
            'user_id' => 1,
            'title' => 'Article de Rose',
            'slug' => 'article-de-rose',
            'description' => 'Description de l\'article de Rose',
            'body' => 'Blablabla Rose',
        ]);
        DB::table('article_user')->insert([
            'article_id' => 1,
            'user_id' => 2,
        ]);
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
        DB::table('article_user')->insert([
            'article_id' => 2,
            'user_id' => 1,
        ]);
        DB::table('article_user')->insert([
            'article_id' => 3,
            'user_id' => 1,
        ]);
        # Tags
        DB::table('tags')->insert([
            'name' => 'Education',
        ]);
        DB::table('article_tag')->insert([
            'article_id' => 1,
            'tag_id' => 1,
        ]);
        # Comments
        DB::table('comments')->insert([
            'user_id' => 2,
            'article_id' => 1,
            'body' => 'Commentaire de Musonda sur l\'article de Rose : j\'adore ta manière de concevoir l\'éducation des enfants',
        ]);

    }
}
