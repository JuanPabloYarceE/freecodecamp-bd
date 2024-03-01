#! /bin/bash
PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\n~~~~~ MY SALON ~~~~~\n"
echo Welcome to My Salon, how can I help you?



MAIN_MENU(){
  if [[ $1 ]]
  then 
    echo -e "\n$1"
  fi
  AVAILABLE_SERVICES=$($PSQL "select * from services")
  echo "$AVAILABLE_SERVICES" | while read SERVICE_ID BAR NAME
  do
    echo "$SERVICE_ID) $NAME"
  done
  read SERVICE_ID_SELECTED
  SERVICE_CUSTOMER=$($PSQL "select * from services where service_id='$SERVICE_ID_SELECTED'")
  SERVICE_NAME=$($PSQL "select name from services where service_id='$SERVICE_ID_SELECTED'")

  if [[ -z $SERVICE_CUSTOMER ]] 
  then
    MAIN_MENU "I could not find that service. What would you like today?"
  else 
    echo -e "What's your phone number?\n"
    read CUSTOMER_PHONE
    CUSTOMER_INFO=$($PSQL "SELECT * FROM customers WHERE phone='$CUSTOMER_PHONE'")
    #if customer doesn't exist
    if [[ -z $CUSTOMER_INFO ]]
    then
      echo -e "\nI don't have a record for that phone number, what's your name?"
      read CUSTOMER_NAME
      INSERT_CUSTOMER_INFO=$($PSQL "insert into customers(phone,name) values ('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
    fi
    echo -e "\nWhat time would you like your$SERVICE_NAME, $CUSTOMER_NAME?"
    read SERVICE_TIME
    CUSTOMER_ID=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE'")
    INSERT_APPOINTMENT_INFO=$($PSQL "insert into appointments(customer_id,service_id,time) values ($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME')")
    echo "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
    
  fi
}

MAIN_MENU