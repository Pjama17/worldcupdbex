#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  
  #echo "$WINNER"
  # how do i make sure the top row is not included from the csv files
  # how do i reset the ID numbers
  TEAM_EXISTS=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")
  # need to add missing teams from opponents as well
  TEAM_ALSO_EXISTS=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")

if [[ -z $TEAM_EXISTS ]]
then
    # add new row insert team etc.
   INSERT_TEAM_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
fi
if [[ -z $TEAM_ALSO_EXISTS ]]
then 
  # check if same as $TEAM_EXISTS and skip if it is
  # I don't know if i need to do that - try without it - AND IT WORKED! ALL UNIQUE TEAMS INSERTED
  INSERT_ALSO_TEAM_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
fi
  # i need to insert each game into games table using the winner id and opponent id linked from the teams table
  # maybe if i add the info from games this will happen automatically?
  # it won't happen automatically - how do i extract this omg it is awfully and too difficult
  # first try and access the id info yourself
  # SELECT * FROM teams WHERE name='Belgium' returns team_id 3
  # To get winner_id reference
  # SELECT team_id FROM teams WHERE name='$WINNER'
  # to get opponent_id reference
  # SELECT team_id FROM teams WHERE name='$OPPONENT'
  # and some how add this to insert data - by creating new VARIABLES
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

  INSERT_GAMES_DATA=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES('$YEAR', '$ROUND', '$WINNER_ID', '$OPPONENT_ID', '$WINNER_GOALS', '$OPPONENT_GOALS')")
done < <(tail -n +2 games.csv)


