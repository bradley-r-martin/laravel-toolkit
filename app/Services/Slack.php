<?php

namespace App\Services;

use Maknz\Slack\Client;

class Slack{

  public function __construct(){
    $settings = [
      'username' => config('app.name'),
      'channel' => '#'.env('SLACK_CHANNEL',config('app.name')),
      'link_names' => true,
      'icon' => ':red_circle:'
    ];
    
    $this->client = new Client(env('SLACK_WEBHOOK_URL',''), $settings);
  
  }


  public function message($message){
    $this->client->send($message);
  }


}