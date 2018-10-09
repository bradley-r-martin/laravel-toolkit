
# START UI PACK







# DECLARE INITIAL FUNCTION STATUS AS 4
declare -a FUNCTION_STATUSES

for f in ${functions[@]}; do 
  # SET DEFAULT
  FUNCTION_STATUSES=( "4" "${FUNCTION_STATUSES[@]}")
done
KEYS=(${!functions[@]})
SUCCESS="\033[1;32m[ SUCCESS ]\033[0m"
SKIPPED="\033[1;33m[ SKIPPED ]\033[0m"
FAILURE="\033[1;31m[ FAILURE ]\033[0m"
WAITING="\033[1;30m[ WAITING ]\033[0m"
RUNNING1="\033[1;30m[ \033[1;35m*\033[0m - - - ]\033[0m"
RUNNING2="\033[1;30m[ \033[1;35m*\033[0m \033[1;35m*\033[0m - - ]\033[0m"
RUNNING3="\033[1;30m[ \033[1;35m*\033[0m \033[1;35m*\033[0m \033[1;35m*\033[0m - ]\033[0m"
RUNNING4="\033[1;30m[ \033[1;35m*\033[0m \033[1;35m*\033[0m \033[1;35m*\033[0m \033[1;35m*\033[0m ]\033[0m"
RUNNING="\033[1;30m[ \033[1;35m- - - -\033[0m ]\033[0m"
CURRENT_FUNCTION_STATUS=0
CURRENT_FUNCTION_INFO=""
CURRENT_FUNCTION=0



function UI_HEADER(){
  echo "+-----------------------------------------------------------------+"
  echo "|                                                                 |"
  echo "|                               \033[1;36mSETUP\033[0m                             |"
  echo "|                                                                 |"
  echo "+-----------------------------------------------------------------+"
}

function ui(){
  clear
  UI_HEADER
  echo "+-------------+--------------+------------------------------------+"
  echo "|  CONDITION  | TASK         |  RESPONSE                          |"
  echo "|-------------+--------------+------------------------------------|"
  R=$((0))

  for Z in ${functions[@]}; do 

    Z_FUNCNAME="${Z:0:12}"
    Z_FUNCNAME_L="${#Z_FUNCNAME}"
    Z_FUNCNAME_S=$(( 12 - Z_FUNCNAME_L ))
    Z_FUNCNAME_K=""
    Z_FUNCNAME_K=$(printf "%*s%s" $Z_FUNCNAME_S '' "$Z_FUNCNAME_K")


    if [[ "${CURRENT_FUNCTION}" = "${Z}" ]]; then
      Z_RESPONSE="${CURRENT_FUNCTION_INFO:0:34}"
    else
      Z_RESPONSE=""
    fi
    Z_RESPONSE_L="${#Z_RESPONSE}"
    Z_RESPONSE_S=$(( 34 - Z_RESPONSE_L ))
    Z_RESPONSE_K=""
    Z_RESPONSE_K=$(printf "%*s%s" $Z_RESPONSE_S '' "$Z_RESPONSE_K")

    ZFUNC_NAME="| \033[1;34m${Z_FUNCNAME}\033[0m ${Z_FUNCNAME_K}|"
    
    if [[ "${CURRENT_FUNCTION}" = "${Z}" ]] && [[ ${CURRENT_FUNCTION_STATUS} -eq 1 ]]; then 
      echo "| ${RUNNING1} ${ZFUNC_NAME} ${Z_RESPONSE} ${Z_RESPONSE_K}|"
    elif [[ "${CURRENT_FUNCTION}" = "${Z}" ]] && [[ ${CURRENT_FUNCTION_STATUS} -eq 2 ]]; then
      echo "| ${RUNNING2} ${ZFUNC_NAME} ${Z_RESPONSE} ${Z_RESPONSE_K}|"
    elif [[ "${CURRENT_FUNCTION}" = "${Z}" ]] && [[ ${CURRENT_FUNCTION_STATUS} -eq 3 ]]; then
      echo "| ${RUNNING3} ${ZFUNC_NAME} ${Z_RESPONSE} ${Z_RESPONSE_K}|"
    elif [[ "${CURRENT_FUNCTION}" = "${Z}" ]] && [[ ${CURRENT_FUNCTION_STATUS} -eq 4 ]]; then
      echo "| ${RUNNING4} ${ZFUNC_NAME} ${Z_RESPONSE} ${Z_RESPONSE_K}|"
    
    elif [[ "${CURRENT_FUNCTION}" = "${Z}" ]]; then
      echo "| ${RUNNING} ${ZFUNC_NAME} ${Z_RESPONSE} ${Z_RESPONSE_K}|"
    else
        if [[ ${FUNCTION_STATUSES[$R]} -eq 1 ]]; then 
          echo "| ${SUCCESS} ${ZFUNC_NAME} ${Z_RESPONSE} ${Z_RESPONSE_K}|"
        fi
        if [[ ${FUNCTION_STATUSES[$R]} -eq 2 ]]; then 
          echo "| ${SKIPPED} ${ZFUNC_NAME} ${Z_RESPONSE} ${Z_RESPONSE_K}|"
        fi
        if [[ ${FUNCTION_STATUSES[$R]} -eq 3 ]]; then 
          echo "| ${FAILURE} ${ZFUNC_NAME} ${Z_RESPONSE} ${Z_RESPONSE_K}|"
        fi
          if [[ ${FUNCTION_STATUSES[$R]} -eq 4 ]]; then 
          echo "| ${WAITING} ${ZFUNC_NAME} ${Z_RESPONSE} ${Z_RESPONSE_K}|"
        fi
    fi


    R=$((R+1))
  done
  echo "|-------------+--------------+------------------------------------|"
  echo ""
}


function UPDATE_UI(){
  ui
}



function B_STATUS(){
  CURRENT_FUNCTION_STATUS=$1
  UPDATE_UI
}
function B_INFO(){
  CURRENT_FUNCTION_INFO=$1
  UPDATE_UI
}


function run(){
  # Function runs your declared install map 
  I=$((0))
  for f in ${functions[@]}; do 
      CURRENT_FUNCTION_STATUS=0
      CURRENT_FUNCTION_INFO=""
      CURRENT_FUNCTION=${f}
      ui
      $f
      ERROR_CODE=$?
      FUNCTION_STATUSES[I]=${ERROR_CODE}
      I=$((I+1))

      CURRENT_FUNCTION_STATUS=0
      CURRENT_FUNCTION=0
      ui
  done 
}






  if [  -f .env ]; then
      clear
      UI_HEADER
      echo "|                                                                 |"
      echo "|     Setup has already run, Would you like to rollback and       |"
      echo "|     uninstall this package? (Y/N):                              |"
      echo "|                                                                 |"
      echo "+-----------------------------------------------------------------+"
      read -p "" -n 1 -r
      if [[  $REPLY =~ ^[Yy]$ ]]; then
          rm .env >/dev/null 2>/dev/null
          rm composer.lock >/dev/null 2>/dev/null
          rm package-lock.json >/dev/null 2>/dev/null
          rm -r node_modules >/dev/null 2>/dev/null
          rm -r vendor >/dev/null 2>/dev/null
          exit
      else
          exit
      fi
  fi

  ui
  run
  ui