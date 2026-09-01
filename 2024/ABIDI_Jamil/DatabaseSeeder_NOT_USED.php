<?php
//
namespace Database\Seeders;
//
//use Carbon\Carbon;
//use Illuminate\Database\Seeder;
//
//class DatabaseSeeder extends Seeder
//{
//    /**
//     * Seed the application's database.
//     *
//     * @return void
//     */
//    public function run()
//    {
//        DB::table('users')-> insert([
//            'name'=> 'Rose',
//            'email'=> 'rose@mail',
//            'password' => null,
//            'bio' => 'je songe à devenir une infirmière, j écris mes réflexions',
//            'created_at'=> Carbon::now(),
//            'updated_at'=> Carbon::now(),
//        ]);
//    }
//}
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Carbon\Carbon;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     *
     * @return void
     */
    public function run()
    {
        // Créer les utilisatrices
        $roseId = DB::table('users')->insertGetId([
            'username' => 'Rose',
            'email' => 'rose@mail.com',
            'password' => Hash::make('pwd'),
            'image' => null,
            'bio' => 'Je voudrais devenir enseignante pour enfants',
            'created_at' => Carbon::now(),
            'updated_at' => Carbon::now(),
        ]);

        $musondaId = DB::table('users')->insertGetId([
            'username' => 'Musonda',
            'email' => 'musonda@mail.com',
            'password' => Hash::make('pwd2'),
            'image' => null,
            'bio' => 'Je songe à devenir infirmière, j’écris mes réflexions',
            'created_at' => Carbon::now(),
            'updated_at' => Carbon::now(),
        ]);

        // Faire en sorte que Musonda suive Rose et vice versa
        DB::table('followers')->insert([
            ['follower_id' => $musondaId, 'following_id' => $roseId],
            ['follower_id' => $roseId, 'following_id' => $musondaId],
        ]);

        // Créer un article écrit par Rose que Musonda suit
        $articleId = DB::table('articles')->insertGetId([
            'user_id' => $roseId,
            'title' => 'Mon premier article',
            'slug' => 'mon-premier-article',
            'description' => 'Ceci est mon premier article.',
            'body' => 'Ceci est le contenu de mon premier article.',
            'created_at' => Carbon::now(),
            'updated_at' => Carbon::now(),
        ]);

        DB::table('article_user')->insert([
            'user_id' => $musondaId,
            'article_id' => $articleId,
        ]);
    }
}
