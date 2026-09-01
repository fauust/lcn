<?php

namespace Database\Seeders;

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
    public function run()
    {
        #create user
        $roseId = DB::table('users')->insertGetId([
          'username' => 'Rose',
          'email' => 'rose@mail.com',
          'password' => Hash::make('pwd'),
          'image' => null,
          'bio' => 'Je voudrais devenir enseignante pour enfants'
        ]); // \App\Models\User::factory(10)->create()
        $musondaId = DB::table('users')->insertGetId([
          'username' => 'Musonda,',
          'email' => 'musonda@mail.com',
          'password' => Hash::make('pwd2'),
          'image' => null,
          'bio' => 'Je songe à devenir infirmière, j’écris mes réflexions'
        ]);

        #create follower
        DB::table('followers')->insert([
            'follower_id' => $roseId,
            'following_id' => $musondaId
        ]);
        DB::table('followers')->insert([
            'follower_id' => $musondaId,
            'following_id' => $roseId
        ]);

        #create articles
        $roseArticleId = DB::table('articles')->insert([
            'user_id' => $roseId,
            'title' => 'Comment éduquer un enfant',
            'slug' => 'art01',
            'description' => 'ruhjogfr',
            'body' => 'urghfuizyhfuze hzreohfzfeizi !!!'
        ]);
        DB::table('articles')->insert([
            'user_id' => $musondaId,
            'title' => 'Lire de loin',
            'slug' => 'art02',
            'description' => 'hfueiuirezotfia',
            'body' => 'zfeiziuyhr uizeyhrfzekhfdqs noiyyhoheqo !!!'
        ]);
        DB::table('articles')->insert([
            'user_id' => $musondaId,
            'title' => 'Lire de près',
            'slug' => 'art03',
            'description' => 'rghuighfr',
            'body' => 'jehzfhf jdsgj, fhjuoizrhjefozihrfzekhfdqs udhefuizhs !!!'
        ]);

        #create tag
        $tagId = DB::table('tags')->insert([
            'name' => 'éducation'
        ]);

        DB::table('article_tag')->insert([
            'article_id' => $roseArticleId,
            'tag_id' => $tagId,
        ]);

        // Création des commentaires
        DB::table('comments')->insert([
            'body' => 'J\'adore ta manière de concevoir l\'éducation des enfants.',
            'article_id' => $roseArticleId,
            'user_id' => $musondaId,
        ]);
    }
}
