library(ddplyr)
library(dplyr)
library(ggplot2)
library(scales)
require(plyr)
library(reshape2)
# your solution here
setwd('~/mygit/msd2015/homework/homework_1/problem_3/movielens')
ratings<-read.table('ratings.csv',sep=',',header=FALSE)
#name columns
colnames(ratings)<-c('UserId','MovieId','Ratings','TimeStamp')
###############################
#MOVIES
###############################
#summarise by MovieId
movies<-ddply(ratings,.(MovieId),summarize,MovieCount=length(MovieId))
#sort
movie.k<-movies[order(-movies$MovieCount),]
#add k = ranking for movies by popularity
k<-list(1:length(movie.k$MovieId))
movie.k['k']<-k


#stolen from movielens example in class
movie.k['cdf']<-cumsum(movie.k$MovieCount)/sum(movie.k$MovieCount)
ggplot(data=movie.k, aes(x=k, y=cdf)) +
  geom_line() +
  scale_x_continuous(labels=comma) +
  scale_y_continuous(labels=percent) +
  xlab('Movie Rank') + ylab('CDF')
ggsave(file="movie_popularity_cdf.pdf", width=4, height=4)

##################################
#USERS
#################################
#find number of reviews by user
users<-ddply(ratings,.(UserId),summarize,UserCount=length(UserId))
#find users < 10 reviews
users<-users[order(users$UserCount)]
head(users[order(users$UserCount),])
#no need to eliminate because every user has at least 20 reviews

#stolen from example in class
ggplot(data=users, aes(x=UserCount)) +
  geom_histogram() +
  scale_x_continuous(labels=comma) +
  scale_y_continuous(labels=comma) +
  xlab('Number of Ratings by User') + ylab('Count') +
  scale_x_log10()
ggsave(file="user_activity_dist.pdf", width=4, height=4)

###############################################
#AGGREGATE
##############################################
#join UserCount and MovieCount back to ratings
ratings.k<-inner_join(ratings,movie.k)
ratings.final<-inner_join(ratings.k,users)
#ordering by UserId, then K
ratings.final<-ratings.final[order(ratings.final$UserId,ratings.final$k),]
#find the cumulative sum for every user (each movie =1/total no of reviews)
ratings.final$csum<-ave(1/ratings.final$UserCount,ratings.final$UserId,FUN=cumsum)

#this part is kinda hacky:
#finds all values=100%
perc100<-function(x){
  if (x>=1) {
  var<-1}
  else {
    var<-0}
  return(var)
}

#finds all values > 90%
perc90<-function(x){
  if (x>=.9) {
    var<-1}
  else {
    var<-0}
  return(var)
}

#corrects for those values >.9 in order to add up right
correct90<-function(x){
  if (x==-1){
    var<-0
  } else {
    var<-x
  } 
  return(var)
}
#####################################################
#100% satisfaction curve
#####################################################
#add a 1 for every value where user has reached 100% satisfaction
ratings.final$perc100<-mapply(perc100,ratings.final$csum)
#sum thoses 1's by movie rating
ratingcum<-ddply(ratings.final,.(k),summarize,perc100=sum(perc100))
#add those sums to get a cumulative distribution of satisfaction
ratingcum$final100<-cumsum(ratingcum$perc100)/sum(ratingcum$perc100)

#####################################################
#90% satisfaction curve
#####################################################
#unlike with 100%, we cannot simply find the one value corresponding to 1
#first, find any value greater than 90% and label with a 1
ratings.final$perc90<-mapply(perc90,ratings.final$csum)
#find the difference between the value and its lagged value + 0
#for example, 89%->10%: 0-0=0, 91%->89%: 1-0=1, 93%->91%: 1-1=0, 5%->100%: 0-1=-1
#therefore, all the 1s will cancel out except for the value that just exceeds 90%  
ratings.final$perc90cut<-append(c(0),diff(ratings.final$perc90))
# the only remaining values will be -1 when it switches users
# so I wrote a function to set this to 0
ratings.final$perc90cut<-mapply(correct90,ratings.final$perc90cut)

#add those sums to get a cumulative distribution of satisfaction
ratingcum90<-ddply(ratings.final,.(k),summarize,perc90=sum(perc90cut))
ratingcum90$final90<-cumsum(ratingcum90$perc90)/sum(ratingcum90$perc90)
#add to 100% satisfaction dataset
ratingcum$final90<-ratingcum90$final90

#plot result
ggplot()+
  geom_line(data=ratingcum,aes(x=k,y=final100, color="final100"))+
  geom_line(data=ratingcum,aes(x=k,y=final90, color="final90"))+
  xlab('Inventory')+ylab('Percentage of Users')
ggsave(file="inventory_dist.pdf", width=6, height=4)
