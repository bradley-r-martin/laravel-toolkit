<?php

namespace App\Services;

use Maknz\Slack\Client;

class Slack{

  public function __construct(){
    $settings = [
      'username' => 'Blumers Lawyers',
      'channel' => '#support',
      'link_names' => true
    ];
    
    $this->client = new Client('https://hooks.slack.com/services/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', $settings);
  
  }


  public function message(){
    $this->client->send('Support Test API');
  }


}