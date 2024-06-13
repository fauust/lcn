<!DOCTYPE html>
<html>
<head>
    <title>Welcome</title>
</head>
<body>
    <h1>Welcome to our application!</h1>

    @php
        use App\Models\User;
        $user = User::first(); // Get the first user in the database
    @endphp

    @if($user)
        <h2>User Details</h2>
        <p><strong>Name:</strong> {{ $user->name }}</p>
        <p><strong>Email:</strong> {{ $user->email }}</p>
    @else
        <p>No user found.</p>
    @endif
</body>
</html>

