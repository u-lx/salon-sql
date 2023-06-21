#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"


#appointment menu
MAIN_MENU() {
  echo -e "\n What would you like done today?\n"
  echo -e "\n1) Haircut\n2) Massage\n3) Manicure\n"
  read SERVICE_ID_SELECTED
  if [[ ! $SERVICE_ID_SELECTED =~ ^[1-3]$ ]]
  then
    MAIN_MENU "That is not a valid selection"
  else
    echo -e "\nWhat is your phone number: "
    read CUSTOMER_PHONE
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

    #if no phone number
    if [[ -z $CUSTOMER_ID ]]
    then
      echo -e "\nWhat is your name: "
      read CUSTOMER_NAME
      INSERT_CUSTOMER=$($PSQL "INSERT INTO customers(phone, name) VALUES ('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
      CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
    else
      CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE customer_id=$CUSTOMER_ID")
    fi
    echo -e "\nEnter your desired appointment time (24hr format - 00:00 - 23:59): "
    read SERVICE_TIME
    if [[ ! $SERVICE_TIME =~ ^[0-9][0-9]:[0-9][0-9]$ ]]
    then
      echo -e "\nInvalid time format"
    else
    INSERT_APPT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
    SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
    echo -e "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
    fi

  fi
}

MAIN_MENU
