#!/usr/bin/bash

#if [[ $1 == "test" ]]
#then
#  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
#else
#  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
#fi

# Do not change code above this line. Use the PSQL variable above to query your database.
#PGPASSWORD=smvpg psql -U postgres worldcup -h 5433
#PSQL="psql postgresql://postgres:smvpg@localhost:5433/worldcup"
PSQL="psql --username=postgres --dbname=worldcup --port=5433 --password -t --no-align -c"
echo "$($PSQL"TRUNCATE teams,games")"
cat games_test.csv | while IFS=, read -r YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != year ]]
  then
  #find team ids
    #find win team
    
    WIN_ID=$($PSQL"SELECT team_id FROM teams WHERE name='$WINNER'")
    #if not found
    
    if [[ -z $WIN_ID ]]
    then 
      INSERT_WTEAM_RES=$($PSQL"INSERT INTO teams(name) VALUES ('$WINNER')")
      if [[ $INSERT_WTEAM_RES == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $WINNER
      fi
      #get new win_id 
      WIN_ID=$($PSQL"SELECT team_id FROM teams WHERE name='$WINNER'")
    fi
    #find opp team 
    OPP_ID=$($PSQL"SELECT team_id FROM teams WHERE name='$OPPONENT'")
    #if not found 
    if [[ -z $OPP_ID ]] 
    then 
      INSERT_OTEAM_RES=$($PSQL"INSERT INTO teams(name) VALUES ('$OPPONENT')")
      if [[ $INSERT_OTEAM_RES == "INSERT 0 1" ]]
      then 
        echo Inserted into teams, $OPPONENT
      fi
      #get new win_id
      OPP_ID=$($PSQL"SELECT team_id FROM teams WHERE name='$OPPONENT'")    
    fi
    #insert data into games 
    INS_GAME_RES=$($PSQL"INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES ($YEAR,'$ROUND',$WIN_ID,$OPP_ID,$WINNER_GOALS,$OPPONENT_GOALS)")
    if [[ $INS_GAME_RES == "INSERT 0 1" ]]
    then
      echo Inserted into games, $YEAR,$ROUND,$WIN_ID,$OPP_ID,$WINNER_GOALS,$OPPONENT_GOALS
    fi
  fi
done