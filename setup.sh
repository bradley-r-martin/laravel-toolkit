#!/bin/bash -u
declare -a functions=( PHP MYSQL LARAVEL COMPOSER ENVIRONMENT DATABASE DEVELOPMENT )

PHP() {
  # Check PHP
  MIN_VERSION="7.0.0"
  MAX_VERSION="10.0.0"
  PHP_VERSION=`php -r 'echo PHP_VERSION;'`
  function version_compare() {
      COMPARE_OP=$1;
      TEST_VERSION=$2;
      RESULT=$(php -r 'echo version_compare(PHP_VERSION, "'${TEST_VERSION}'", "'${COMPARE_OP}'") ? "TRUE" : "";')
      test -n "${RESULT}";
  }
  if ( version_compare "<" "${MIN_VERSION}" || version_compare ">" "${MAX_VERSION}" ); then
        B_INFO "PHP: ${PHP_VERSION} must be between ${MIN_VERSION} - ${MAX_VERSION}";
      return 3
  else
    B_INFO "PHP: ${PHP_VERSION} MYSQL: 5.6.5"
    sleep 5
    return 1
  fi
}
MYSQL(){
   return 1
}
LARAVEL(){
  return 1
}
COMPOSER(){ 
  B_STATUS 1
  B_INFO "Downloading dependancies..."
  composer install >/dev/null 2>/dev/null
  return 1
}
ENVIRONMENT(){
  # Make a copy of the config file
  B_STATUS 1
  B_INFO "Coping .env.example => .env"
  cp .env.example .env >/dev/null 2>/dev/null
  B_STATUS 2
  B_INFO "Generating application key..."
  php artisan key:generate >/dev/null 2>/dev/null
  B_STATUS 3
  B_INFO "Setup your database:"
  read -s -p "Edit details in .env, Y to continue (Y/N):" -n 1 -r
  if [[  $REPLY =~ ^[Yy]$ ]]; then
    DB_DATABASE=$(grep DB_DATABASE .env | xargs)
    IFS='=' read -ra DB_DATABASE <<< "$DB_DATABASE"
    DB_DATABASE=${DB_DATABASE[1]}
    B_INFO "MYSQL database: $DB_DATABASE"
    return 1
  else
    return 3
  fi
}
DATABASE() { 
  read -p "Would you like to run database migrations and seeding (Y/N): " -n 1 -r
  echo    # (optional) move to a new line
  if [[  $REPLY =~ ^[Yy]$ ]]; then
      B_STATUS 2
      B_INFO "migrating..."
      php artisan migrate:refresh --seed >/dev/null 2>/dev/null
  else
    return 2
  fi
}
DEVELOPMENT(){
  B_STATUS 1
  B_INFO "Download dependancies ?"
  read -s -p "Would you like to install development dependencies(Y/N):" -n 1 -r
    if [[  $REPLY =~ ^[Yy]$ ]]; then
      B_STATUS 2
      B_INFO "running npm install..."
      npm install >/dev/null 2>/dev/null
      B_STATUS 3
      B_INFO "builing application..."
      npm run development >/dev/null 2>/dev/null
      return 1
    else
      return 2
    fi
}

# Run installer
source ./app/Console/installer.sh


