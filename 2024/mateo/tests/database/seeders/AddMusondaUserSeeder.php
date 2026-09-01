<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class AddMusondaUserSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {

        $exist = User::where('email', 'musonda@mail.com')->first();

        if(!$exist) {
            User::Create([
                'username' => 'Musonda',
                'email' => 'musonda@mail.com',
                'password' => Hash::make('pwd2'),
                'image' => null,
                'bio' => "Je songe à devenir infirmière, j’écris mes réflexions",
                'created_at' => now(),
                'updated_at' => now()
            ]);
        }
    }
}
