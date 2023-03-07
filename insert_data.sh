#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo "$($PSQL "TRUNCATE games, teams;")"
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $WINNER != 'winner' || $OPPONENT != 'opponent' ]]
    then
    #Get Team ID
    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name ILIKE '$WINNER';")
    TEAM_IDO=$($PSQL "SELECT team_id FROM teams WHERE name ILIKE '$OPPONENT';")
    #If not found
    if [[ -z $TEAM_ID ]]
      then
      #Insert into table
      INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES ('$WINNER');")
      if [[ -z $TEAM_IDO ]]
      then INSERT_OP_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES ('$OPPONENT');")
      TEAM_IDO=$($PSQL "SELECT team_id FROM teams WHERE name ILIKE '$OPPONENT';")
      fi
    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name ILIKE '$WINNER';")
    else if [[ -z $TEAM_IDO ]]
    then INSERT_OP_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES ('$OPPONENT');")
    TEAM_IDO=$($PSQL "SELECT team_id FROM teams WHERE name ILIKE '$OPPONENT';")
      fi
    fi
  fi

  if [[ $YEAR != 'year' || $ROUND != 'round' || $WINNER_GOALS != 'winner_goals' || $OPPONENT_GOALS != 'opponent_goals' ]]
    then
      INSERT_GAME_RESULTS=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ('$YEAR', '$ROUND', '$TEAM_ID', '$TEAM_IDO', '$WINNER_GOALS', '$OPPONENT_GOALS');")
      GAME_ID=$($PSQL "SELECT game_id FROM games")
  fi
done
