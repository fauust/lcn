<?php

namespace Database\Seeders;

use App\Models\Article;
use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Str;

class AddMusondaArticleSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        $this->call(AddMusondaUserSeeder::class);

        $musonda= User::where('username', 'Musonda')->first();

        $exist = Article::where('title', "azae")->first();
        $title = "azae";

        if(!$exist) {
            Article::Create([
                'user_id' => $musonda->id,
                'title' => $title,
                'slug' => Str::slug($title),
                'description' => Str::random(10),
                'body' => Str::random(10),
                'created_at' => now(),
                'updated_at' => now()
            ]);
        }

        $exist = Article::where('title', "bqa")->first();
        $title = "bqa";

        if(!$exist) {
            Article::Create([
                'user_id' => $musonda->id,
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
