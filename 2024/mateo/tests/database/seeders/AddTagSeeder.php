<?php

namespace Database\Seeders;

use App\Models\Tag;
use App\Models\User;
use Illuminate\Database\Seeder;

class AddTagSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        $tag = Tag::where('name', 'ouk')->first();
        $name = "ouk";

        if(!$tag) {
            Tag::Create([
                'name' => $name
            ]);
        }
    }
}
