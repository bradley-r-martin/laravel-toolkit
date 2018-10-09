<?php

namespace App\Console\Commands;

use Storage;
use ZanySoft\Zip\Zip;

use Illuminate\Console\Command;
use Illuminate\Http\Request;

use Illuminate\Support\Facades\DB;

class restore extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'restore';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Populate slots in database';

    /**
     * Create a new command instance.
     *
     * @return void
     */
    public function __construct()
    {
        parent::__construct();
    }

    /**
     * Execute the console command.
     *
     * @return mixed
     */
    public function handle()
    {
        //

        $disk = Storage::disk('local');
        $files = array_reverse($disk->files('/'.config('backup.backup.name')));

        $backups = [];
        foreach($files as $file){
            $file=str_replace(
                [
                    config('backup.backup.name').'/'.config('backup.backup.destination.filename_prefix'),
                    '.zip'
                ]
            ,'',$file);
            $backups[] = $file;
        }
        if(count($backups)>0){

            $backup = $this->choice('Which backup would you like to restore from?', $backups);

            if ($this->confirm('Are you sure you want to restore from: ('.$backup.') ')) {
                $file = 'storage/app/'.config('backup.backup.name').'/'.config('backup.backup.destination.filename_prefix').$backup.'.zip';
                $this->info($file);
                $zip = Zip::open($file);
                $zip->extract('storage/temp');

                $this->info('Extracting: '.$backup);
            }else{
                $this->info('Restore cancelled');
            }
        }else{
            $this->info('You have no backups to restore from.');
        }
     
    
      //  $path = 'restore.sql';
       // DB::unprepared(file_get_contents($path));

    }
}
