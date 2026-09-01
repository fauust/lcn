<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class AddRoseUserSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        $user = User::where('email', 'rose@mail.com')->first();

        if(!$user) {
            $user = User::Create([
                'username' => 'Rose',
                'email' => 'rose@mail.com',
                'password' => Hash::make('pwd'),
                'image' => null,
                'bio' => "Je voudrais devenir enseignante pour enfants",
                'created_at' => now(),
                'updated_at' => now()
            ]);
        }
    }
}
