<?php

namespace Database\Seeders;

use App\Models\Article;
use App\Models\Comment;
use App\Models\User;
use Illuminate\Database\Seeder;

class AddCommentSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        $user = User::where('email', 'musonda@mail.com')->first();
        $article = Article::where('title', 'XVs3zJL')->first();

        Comment::create([
            'user_id' => $user->id,
            'article_id' => $article->id,
            'body' => "Elle adore sa manière de concevoir l’éducation des enfants.",
        ]);


    }
}
