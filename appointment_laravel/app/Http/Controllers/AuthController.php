<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

class AuthController extends Controller
{
    public function register(Request $request)
    {
        try {
            $payload = [
                'username' => $request->input('username'),
                'email' => $request->input('email'),
                'password' => $request->input('password'),
            ];

            Log::info('⇢ Register JSON:', $payload);

            $response = Http::withHeaders([
                'Content-Type' => 'application/json',
                'Accept' => 'application/json',
            ])->asJson()->post(env('STRAPI_BASE_URL') . '/auth/local/register', $payload);

            Log::info('⇠ Strapi Yanıtı:', [
                'status' => $response->status(),
                'body' => $response->body(),
            ]);

            return response()->json($response->json(), $response->status());

        } catch (\Exception $e) {
            Log::error('Register Error:', [
                'message' => $e->getMessage(),
                'trace' => $e->getTraceAsString(),
            ]);

            return response()->json(['error' => 'Sunucu hatası'], 500);
        }
    }

    public function login(Request $request)
    {
        $payload = [
            'identifier' => $request->input('email'),
            'password' => $request->input('password'),
        ];

        $response = Http::asJson()->withHeaders([
            'Accept' => 'application/json',
            'Content-Type' => 'application/json'
        ])->post(env('STRAPI_BASE_URL') . '/auth/local', $payload);

        return response()->json($response->json(), $response->status());
    }

}
