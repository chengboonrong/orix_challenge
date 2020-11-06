<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\UserController;
// use App\Http\Controllers\Auth\LoginController;
use Illuminate\Support\Facades\Auth;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

Route::get('/', function () {
    return view('welcome');
});
// Route::get('user',[UserController::class, 'index']);

// Route::get('/users', function () {
//     return view('users','UserController@index');
// });
Auth::routes();
// Route::get('/home', 'HomeController@index')->name('home');

Route::get('/home', [App\Http\Controllers\HomeController::class, 'index'])->name('home');
Route::post('login/{provider}/callback', [App\Http\Controllers\Auth\LoginController::class, 'handleCallback']);
Auth::routes();

Route::get('/index', [App\Http\Controllers\HomeController::class, 'index'])->name('home');
