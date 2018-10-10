let mix = require('laravel-mix');

/*
 |--------------------------------------------------------------------------
 | Mix Asset Management
 |--------------------------------------------------------------------------
 |
 | Mix provides a clean, fluent API for defining some Webpack build steps
 | for your Laravel application. By default, we are compiling the Sass
 | file for the application as well as bundling up all the JS files.
 |
 */

const path = require('path');
mix.webpackConfig({

    resolve: {
    
        alias: {
           'theme.config' : path.resolve(__dirname, 'resources/assets/js/')  //path.join(__dirname, 'resources/assets/scss/base/theme.config')  
        }
     }
});


mix.react('resources/assets/js/app.js', 'public/js')
   .sass('resources/assets/sass/app.scss', 'public/css')
    .styles(['resources/assets/css/semantic-ui.css',
        'resources/assets/css/animate.css'],'public/css/all.css');
