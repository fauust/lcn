<?php

namespace Tests\Unit;

use App\Models\User;
use PHPUnit\Framework\TestCase;

class UserTest extends TestCase
{
    /**
     * A basic unit test example.
     *
     * @return void
     */
    public function test_getRouteKeyNames()
    {
        $user = new User();
        $this->assertEquals('username', $user->getRouteKeyName());
    }
}
