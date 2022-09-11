#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

MAIN_FUNCTION() {
  if [[ ! $1 =~ ^[0-9]+$ ]]
  then
    ELEMENT_MAIN_INFO=$($PSQL "select * from elements where symbol='$1' or name='$1'")
  else
    ELEMENT_MAIN_INFO=$($PSQL "select * from elements where atomic_number=$1")
  fi

  if [[ -z $ELEMENT_MAIN_INFO ]]
  then
    echo "I could not find that element in the database."
  else
    GET_SECONDARY_INFO
  fi
}

GET_SECONDARY_INFO() {
  echo $ELEMENT_MAIN_INFO | while read ATOMIC_NUMBER BAR SYMBOL BAR NAME
  do
    SECONDARY_INFO=$($PSQL "select * from properties inner join types using(type_id) where atomic_number=$ATOMIC_NUMBER")
    echo $SECONDARY_INFO | while read TYPE_ID BAR ATOMIC_NUMBER BAR ATOMIC_MASS BAR MELTING_POINT BAR BOILING_POINT BAR TYPE
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
  done
}

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  MAIN_FUNCTION $1
fi