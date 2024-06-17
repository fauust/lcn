<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\DB;

use Carbon\Carbon;

use App\Models\User;
use App\Models\Article;
use App\Models\Tag;
use App\Models\Comment;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     *
     * @return void
     */
    public function run()
    {
        // \App\Models\User::factory(10)->create();

        DB::table('users')->insert([
            'username' => 'Rose',
            'email' => 'rose@mail.com',
            'password' => Hash::make('pwd'),
            'image' => null,
            'bio' => 'Je voudrais devenir enseignante pour enfants',
            'created_at' => Carbon::now(),
            'updated_at' => Carbon::now()
        ]);

        DB::table('users')->insert([
            'username' => 'Musonda',
            'email' => 'musonda@mail.com',
            'password' => Hash::make('pwd2'),
            'image' => null,
            'bio' => 'Je songe à devenir infirmière, j\'écris mes réflexions',
            'created_at' => Carbon::now(),
            'updated_at' => Carbon::now()
        ]);

        DB::table('followers')->insert([
            'follower_id' => 1,
            'following_id' => 2
        ]);

        DB::table('followers')->insert([
            'follower_id' => 2,
            'following_id' => 1
        ]);

        Article::factory()->create([
            'user_id' => 1
        ]);

        DB::table('article_user')->insert([
            'article_id' => 1,
            'user_id' => 2
        ]);

        Article::factory()->create([
            'user_id' => 2
        ]);

        Article::factory()->create([
            'user_id' => 2
        ]);

        DB::table('article_user')->insert([
            'article_id' => 2,
            'user_id' => 1
        ]);

        DB::table('article_user')->insert([
            'article_id' => 3,
            'user_id' => 1
        ]);

        Tag::factory()->create([
            'name' => 'éducation'
        ]);

        DB::table('article_tag')->insert([
            'article_id' => 1,
            'tag_id' => 1
        ]);

        Comment::factory()->create([
            'user_id' => 2,
            'article_id' => 1,
            'body' => 'J\'adore sa manière de concevoir l’éducation des enfants'
        ]);
    }
}
