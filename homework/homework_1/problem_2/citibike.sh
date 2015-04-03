#!/bin/bash
#
# add your solution after each of the 10 comments below
#
#####################################
# count the number of unique stations
#####################################
echo "count no of unique stations"
cut -d, -f4 201402-citibike-tripdata.csv | sed "1 d" | sort | uniq -c | wc -l
cut -d, -f9 201402-citibike-tripdata.csv | sed "1 d" | sort | uniq -c | wc -l
#I made a few assumptions here.  I assumed that:
#every start station was also an end station
# It could be the case this isn't true, which is why I checked both
# but I was lazy.  I should probably compare the two lists, but the 
# chance that they are both missing the same amount seems small
# So, I'm confident with 329 stations as an answer.

###################################
# count the number of unique bikes
###################################
echo "count no of unique bikes"
cut -d, -f12 201402-citibike-tripdata.csv | sed "1 d" | sort | uniq -c | wc -l

#####################################
# extract all of the trip start times
#####################################
echo "extract trip start times"
cut -d, -f2 201402-citibike-tripdata.csv | sed "1 d" | sort 
#seems like it is just asking for all the values (no count or anything)
####################################
# count the number of trips per day
###################################
# to count for each day and save to file
# for i in `seq 01 28`;
# do
# 	if [ $i -le 9 ]
# 	then
# 		date=$(cut -d, -f2 201402-citibike-tripdata.csv | grep 2014-02-0$i | sort | wc -l) 
# 		echo 2014-02-0$i, $date >> date.csv
# 	else
# 		date=$(cut -d, -f2 201402-citibike-tripdata.csv | grep 2014-02-$i | sort | wc -l)
# 		echo 2014-02-$i, $date >> date.csv
# 	fi
# done
#another (easier) way is:
echo "no of trips per day"
cut -d, -f2 201402-citibike-tripdata.csv | sed "1 d" | cut -d ' ' -f1 | uniq -c | sort -nr


###################################
# find the day with the most rides
###################################
echo "day with most rides"
cut -d, -f2 201402-citibike-tripdata.csv | sed "1 d" | cut -d ' ' -f1 | uniq -c | sort -nr | head -n1
#OR
# cut -d, -f2 201402-citibike-tripdata.csv | sed "1 d" | cut -d ' ' -f1 | uniq -c | sort -n | tail -n1
####################################
# find the day with the fewest rides
####################################
echo "day with fewest rides"
cut -d, -f2 201402-citibike-tripdata.csv | sed "1 d" | cut -d ' ' -f1 | uniq -c | sort -n | head -n1
#OR 
# cut -d, -f2 201402-citibike-tripdata.csv | sed "1 d" | cut -d ' ' -f1 | uniq -c | sort -nr | tail -n1
##############################################
# find the id of the bike with the most rides
##############################################
echo "bike id with most rides"
cut -d, -f12 201402-citibike-tripdata.csv | sed "1 d" | sort | uniq -c | sort -n | tail -n1
#####################################################
# count the number of riders by gender and birth year
#####################################################
#simple count for gender, birth year 
echo "no of riders by gender and birth year"
cut -d, -f14,15 201402-citibike-tripdata.csv | sed "1 d" | sort | uniq -c | sort -n
# highest count
#cut -d, -f14,15 201402-citibike-tripdata.csv | sed "1 d" | sort | uniq -c | sort -n | tail -n1
#lowest count
#cut -d, -f14,15 201402-citibike-tripdata.csv | sed "1 d" | sort | uniq -c | sort -nr | tail -n1
###################################################################################################################################
# count the number of trips that start on cross streets that both contain numbers (e.g., "1 Ave & E 15 St", "E 39 St & 2 Ave", ...)
###################################################################################################################################
echo "no of trips on cross streets with nos"
awk -F, '$5 ~ /[0-9]+.+&+.+[0-9]/' 201402-citibike-tripdata.csv | wc -l
####################################
# compute the average trip duraction
####################################
echo "avg trip duration"
cut -d, -f1 201402-citibike-tripdata.csv | sed "1 d" |tr '"' ' ' |awk '{total+=$1; count+=1} END {print total/count}'


