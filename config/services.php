<?php

return [

    /*
    |--------------------------------------------------------------------------
    | Third Party Services
    |--------------------------------------------------------------------------
    |
    | This file is for storing the credentials for third party services such
    | as Mailgun, Postmark, AWS and more. This file provides the de facto
    | location for this type of information, allowing packages to have
    | a conventional file to locate the various service credentials.
    |
    */

    'mailgun' => [
        'domain' => env('MAILGUN_DOMAIN'),
        'secret' => env('MAILGUN_SECRET'),
        'endpoint' => env('MAILGUN_ENDPOINT', 'api.mailgun.net'),
    ],

    'postmark' => [
        'token' => env('POSTMARK_TOKEN'),
    ],

    'ses' => [
        'key' => env('AWS_ACCESS_KEY_ID'),
        'secret' => env('AWS_SECRET_ACCESS_KEY'),
        'region' => env('AWS_DEFAULT_REGION', 'us-east-1'),
    ],
    'firebase' => [
        'api_key' => 'AIzaSyDwgW3DtTpLtz03QoGadpWi2EKiLpDREOA',
        'auth_domain' => 'orixc-f5a94.firebaseapp.com',
        'database_url' => 'https://orixc-f5a94.firebaseio.com',
        'project_id' => 'orixc-f5a94',
        'storage_bucket' => 'orixc-f5a94.appspot.com',
        'messaging_sender_id' => '768182284876',
        'app_id' => '1:768182284876:web:fb513eb543eb9123c7fae9',
        'measurement_id' => 'G-WT0J5KTE1J',
    ],
];
