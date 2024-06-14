<?php

namespace Tests\Unit;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Hash;
use Tests\TestCase;

class UserTest extends TestCase
{
    use RefreshDatabase;

    /**
     * Test to get route key name for User model.
     *
     * @return void
     */
    public function test_getRouteKeyNames()
    {
        $user = new User();
        $this->assertEquals('username', $user->getRouteKeyName());
    }

    /**
     * Test to check if followers are returned correctly.
     *
     * @return void
     */
    public function test_followers()
    {
        // GIVEN a context: Create users
        $rose = User::factory()->create([
            'username' => 'Rose',
            'email' => 'rose@mail.com',
            'password' => Hash::make('pwd'),
        ]);

        $musonda = User::factory()->create([
            'username' => 'Musonda',
            'email' => 'musonda@mail.com',
            'password' => Hash::make('pwd2'),
        ]);

        // WHEN: Insert a follower record into the followers table
        \DB::table('followers')->insert([
            'follower_id' => $musonda->id,
            'following_id' => $rose->id,
        ]);

        // THEN expect some output
        $followers = $rose->followers;
        $this->assertCount(1, $followers, 'Rose n\'a pas de follower');
        $follower = $followers->first();
        $this->assertEquals('Musonda', $follower->username);
        $this->assertEquals('musonda@mail.com', $follower->email);
    }


    public function test_following()
    {
        // GIVEN a context: Create users
        $rose = User::factory()->create([
            'username' => 'Rose',
            'email' => 'rose@mail.com',
            'password' => Hash::make('pwd'),
        ]);

        $musonda = User::factory()->create([
            'username' => 'Musonda',
            'email' => 'musonda@mail.com',
            'password' => Hash::make('pwd2'),
        ]);

        // WHEN: Insert a follower record into the followers table
        \DB::table('followers')->insert([
            'following_id' => $rose->id,
            'follower_id' => $musonda->id,
        ]);

        // THEN expect some output
        $following = $musonda->following;
        $this->assertCount(1, $following, 'Musonda ne suit pas Rose');
        $toFollow = $following->first();
        $this->assertEquals('Rose', $toFollow->username);
        $this->assertEquals('rose@mail.com', $toFollow->email);
    }
}
