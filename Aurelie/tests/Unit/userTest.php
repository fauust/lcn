<?php

namespace Tests\Unit;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class UserTest extends TestCase
{
    use RefreshDatabase;

    public function test_getRouteKeyNames()
    {
        $user = new User();
        $this->assertEquals('username', $user->getRouteKeyName());
    }
}
