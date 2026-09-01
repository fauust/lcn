<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     *
     * @return void
     */
    public function run()
    {
        $this->call([
            AddRoseUserSeeder::class,
            AddMusondaUserSeeder::class,
            AddFollowersSeeder::class,
            AddRoseArticleSeeder::class,
            AddMusondaArticleSeeder::class,
            AddTagSeeder::class,
            AddArticleTagSeeder::class,
            AddCommentSeeder::class
        ]);
    }
}
