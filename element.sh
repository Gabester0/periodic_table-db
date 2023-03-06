#! /bin/bash


PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

get_and_print_element () {
  ELEMENT_DATA="$($PSQL "SELECT elements.atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements FULL JOIN properties ON elements.atomic_number = properties.atomic_number FULL JOIN types ON properties.type_id = types.type_id WHERE elements.$1 = '$2';")"
  if [[ -z $ELEMENT_DATA ]]
    then
      echo "I could not find that element in the database."
  else
    echo $ELEMENT_DATA | while IFS='|' read ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS TYPE
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
    done
  fi
}

# Get type of argument
if [ -z $1 ]
  then
    echo "Please provide an element as an argument."
  else
    # If argument is numeric look up by atomic number
    if [[ $1 =~ ^[0-9]+$ ]]
      then
        get_and_print_element "atomic_number" $1
    # If argument is alphabetical, 3 characters or shorter and is not element named Tin, lookup by symbol (there are symbols that are three characters long)
    elif [[ ${#1} < 4 ]] && [[ $1 != 'Tin' ]]
      then
        get_and_print_element "symbol" $1
    # Look up by name
    else
        get_and_print_element "name" $1
    fi
fi
