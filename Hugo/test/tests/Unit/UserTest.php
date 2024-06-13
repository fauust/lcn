<?php

namespace Tests\Unit;

use Tests\TestCase;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Artisan;

class UserTest extends TestCase
{
    use RefreshDatabase;

    /** @test */
    public function it_checks_if_user_is_created_correctly()
    {
        Artisan::call('db:seed');

        $user = User::where('email', 'rose@mail.com')->first();

        $this->assertNotNull($user, "User with email rose@mail.com should exist in the database.");

        $this->assertEquals('Rose', $user->username);
        $this->assertEquals('rose@mail.com', $user->email);
        $this->assertTrue(\Hash::check('pwd', $user->password));
        $this->assertEquals('Je voudrais devenir enseignante pour enfants', $user->bio);
    }
}
