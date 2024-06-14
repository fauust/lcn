<?php


use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class ApiTest extends TestCase
{
    public function testArticleEndpoint()
    {
        // URL de l'API à tester
        $url = 'http://127.0.0.1:8000/api/articles/xvs3zjl';

        // Effectuer une requête GET
        $response = $this->getHttpResponse($url);

        // Vérifier le statut de la réponse
        $this->assertSame(200, $response->getStatusCode());

        // Vérifier le contenu JSON
        $expectedJson = '{"article":{"slug":"xvs3zjl","title":"XVs3zJL","description":"L5Ro54Luo0","body":"UX8tNbKA8O","tagList":["ouk"],"createdAt":"2024-06-13T09:43:02.000000Z","updatedAt":"2024-06-13T09:43:02.000000Z","favoritesCount":0,"favorited":false,"author":{"username":"Rose","bio":"Je voudrais devenir enseignante pour enfants","image":null,"following":false}}}';
        $actualJson = $response->getBody()->getContents();

        $this->assertJsonStringEqualsJsonString($expectedJson, $actualJson);
    }

    private function getHttpResponse($url)
    {
        $client = new \GuzzleHttp\Client();
        return $client->request('GET', $url);
    }
}
