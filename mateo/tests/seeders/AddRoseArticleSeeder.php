<?php

namespace Database\Seeders;

use App\Models\Article;
use App\Models\User;
use GuzzleHttp\Promise\Create;
use Illuminate\Database\Seeder;
use Illuminate\Support\Str;

class AddRoseArticleSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        $this->call(AddRoseUserSeeder::class);

        $rose = User::where('username', 'Rose')->first();

        $exist = Article::where('title', "XVs3zJL")->first();

        $title = "XVs3zJL";

        if(!$exist) {
            Article::Create([
                'user_id' => $rose->id,
                'title' => $title,
                'slug' => Str::slug($title),
                'description' => Str::random(10),
                'body' => Str::random(10),
                'created_at' => now(),
                'updated_at' => now()
            ]);
        }
    }
}
