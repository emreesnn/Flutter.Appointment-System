<?php
namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;

class AppointmentController extends Controller
{
    public function index()
    {
        $response = Http::get(env('STRAPI_BASE_URL') . '/appointments');

        $rawData = $response->json('data');

        $flattened = collect($rawData)->map(function ($item) {
            return [
                'id' => $item['id'],
                'documentId' => $item['documentId'] ?? '',
                'title' => $item['title'] ?? '',
                'description' => $item['description'] ?? '',
                'date' => $item['date'] ?? '',
                'appointment_status' => $item['appointment_status'] ?? '',
            ];
        });

        return response()->json([
            'data' => $flattened->values(),
        ]);
    }

    public function store(Request $request)
    {
        $raw = $request->getContent();
        $json = json_decode($raw, true);

        $data = [
            'data' => [
                'title' => $json['data']['title'] ?? null,
                'description' => $json['data']['description'] ?? null,
                'date' => $json['data']['date'] ?? null,
                'appointment_status' => $json['data']['appointment_status'] ?? null,
            ]
        ];

        \Log::info('Strapiye gönderilen:', $data);

        $response = Http::withHeaders([
            'Content-Type' => 'application/json',
        ])->post(env('STRAPI_BASE_URL') . '/appointments', $data);

        if (!$response->successful()) {
            \Log::error('Strapi Hatası:', [
                'status' => $response->status(),
                'body' => $response->body()
            ]);
            return response()->json(['error' => $response->body()], $response->status());
        }

        return $response->json();
    }

    public function update(Request $request, $id)
    {
        $raw = $request->getContent();
        $json = json_decode($raw, true);

        $data = [
            'data' => [
                'title' => $json['data']['title'] ?? null,
                'description' => $json['data']['description'] ?? null,
                'date' => $json['data']['date'] ?? null,
                'appointment_status' => $json['data']['appointment_status'] ?? null,
            ]
        ];

        \Log::info("PUT isteği (id=$id):", $data);

        $response = Http::withHeaders([
            'Content-Type' => 'application/json',
        ])->put(env('STRAPI_BASE_URL') . "/appointments/{$id}", $data);

        if (!$response->successful()) {
            \Log::error('Strapi Güncelleme Hatası:', [
                'status' => $response->status(),
                'body' => $response->body()
            ]);
            return response()->json(['error' => $response->body()], $response->status());
        }

        return $response->json();
    }


    public function show($id)
    {
        $response = Http::get(env('STRAPI_BASE_URL') . "/appointments/{$id}");

        $data = $response->json('data');

        if (!$data || !isset($data['id'])) {
            return response()->json(['error' => 'Appointment not found'], 404);
        }

        return [
            'id' => $data['id'],
            'documentId' => $data['documentId'],
            'title' => $data['title'] ?? null,
            'description' => $data['description'] ?? null,
            'date' => $data['date'] ?? null,
            'appointment_status' => $data['appointment_status'] ?? null,
        ];
    }



    public function destroy($id)
    {
        $response = Http::delete(env('STRAPI_BASE_URL') . "/appointments/{$id}");
        return $response->json();
    }
}
