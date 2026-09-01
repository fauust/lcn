<?php

namespace Database\Seeders;

use App\Models\Article;
use App\Models\Tag;
use App\Models\User;
use Illuminate\Database\Seeder;

class AddArticleTagSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        $article = Article::where('title', 'XVs3zJL')->first();

        if ($article) {
            // Récupérer l'ID de l'article
            $articleId = $article->id;

            // Trouver le tag par son nom
            $tag = Tag::where('name', 'ouk')->first();

            if ($tag) {
                // Récupérer l'ID du tag
                $tagId = $tag->id;

                // Vérifier si l'association article-tag existe déjà
                $exists = $article->tags()->where('tag_id', $tagId)->exists();

                // Si l'association n'existe pas, alors la créer
                if (!$exists) {
                    $article->tags()->attach($tagId);
                    // Ou utiliser Tag::create(['article_id' => $articleId, 'tag_id' => $tagId]);
                }
            } else {
                // Créer le tag s'il n'existe pas
                $newTag = Tag::create(['name' => 'ouk']);
                $article->tags()->attach($newTag->id);
            }
        }
    }
}
