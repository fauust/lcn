<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;

class AddFollowersSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        $this->call(AddRoseUserSeeder::class);
        $this->call(AddMusondaUserSeeder::class);

        $rose = User::where('username', 'Rose')->first();
        $musonda = User::where('username', 'Musonda')->first();

        $musonda->following()->syncWithoutDetaching([$rose->id]);
        $rose->following()->syncWithoutDetaching([$musonda->id]);
    }
}
