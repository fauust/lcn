<?php

namespace Tests\Unit;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class UserTest extends TestCase
{
    /**
     * A basic unit test example.
     *
     * @return void
     */

    use RefreshDatabase;

    public function test_example()
    {
        $this->assertTrue(true);
    }

    public function test_getRouteKeyNames()
    {
        $this->seed();

        $name = 'Rose';
        $user = User::where('username', $name)->first();
        $this->assertSame($name, $user->username);
    }
}
