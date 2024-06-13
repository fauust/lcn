<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\User;
use App\Models\Article;
use App\Models\Tag;
use App\Models\Comment;
class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     *
     * @return void
     */
    public function run()
    {

        $rose = User::firstOrCreate( // create rose if she doesn't exist
            ['email' => 'rose@mail.com'],
            [
                'username' => 'Rose',
                'password' => bcrypt('pwd'),
                'bio' => 'Je voudrais devenir enseignante pour enfants',
                'created_at' => now(),
                'updated_at' => now()
            ]
        );

        $musonda =User::firstOrCreate( // create musonda if she doesn't exist
            ['email' => 'musonda@mail.com'],
            [
                'username' => 'Musonda',
                'password' => bcrypt('pwd2'),
                'bio' => 'Je songe à devenir infirmière, j’écris mes réflexions',
                'created_at' => now(),
                'updated_at' => now()
            ]
        );

        $musonda->followers()->syncWithoutDetaching([$rose->id]); // musonda follows rose
        $rose->followers()->syncWithoutDetaching([$musonda->id]); // rose follows musonda

        $articleRose = Article::firstOrCreate([ // create an article for rose
            'title' => 'Article Title',
            'body' => 'Article Content',
            'description' => 'Article Description',
            'user_id' => $rose->id,
            'created_at' => now(),
            'updated_at' => now()
        ]);

        $musonda->favoritedArticles()->attach($articleRose->id);// musonda favorites rose's article

        $articleMusonda1 = Article::firstOrCreate([ // create an article for musonda
            'title' => 'Article Title',
            'body' => 'Article Content',
            'description' => 'Article Description',
            'user_id' => $musonda->id,
            'created_at' => now(),
            'updated_at' => now()
        ]);

        $articleMusonda2 = Article::firstOrCreate([// create another article for musonda
            'title' => 'Article 2 Title',
            'body' => 'Article Content',
            'description' => 'Article Description',
            'user_id' => $musonda->id,
            'created_at' => now(),
            'updated_at' => now()
        ]);

        $rose->favoritedArticles()->attach($articleMusonda1);// rose added musonda's article to her fevorites
        $rose->favoritedArticles()->attach($articleMusonda2);// rose added musonda's article to her fevorites

        $tag = Tag::firstOrCreate([ // create a tag
            'name' => 'éducation',
        ]);

        $articleRose->tags()->attach($tag->id);// add the tag to rose's article

        Comment::firstOrCreate([ // create a comment for rose's article
            'body' => 'J\'adore ta manière de concevoir l’éducation des enfants',
            'user_id' => $musonda->id,
            'article_id' => $articleRose->id,
            'created_at' => now(),
            'updated_at' => now()
        ]);
    }
}
