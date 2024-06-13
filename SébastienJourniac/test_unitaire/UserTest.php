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
    public function test_getRouteKeyName()
    {
        $user = new User();
        $this->assertEquals('username', $user->getRouteKeyName());
    }
}
