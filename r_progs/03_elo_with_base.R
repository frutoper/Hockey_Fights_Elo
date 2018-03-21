# Author: Mark Fruin
# Data Source: HockeyFights.com
# Purpose: Given previous elo rating, update elo rating with another season of data
# Elo Sources: 
# https://metinmediamath.wordpress.com/2013/11/27/how-to-calculate-the-elo-rating-including-example/
# https://gist.github.com/i000313/90b1f3c556b1b1ad8278
# http://gobase.org/studying/articles/elo/
# https://en.wikipedia.org/wiki/Elo_rating_system
# https://fivethirtyeight.com/features/how-our-2017-nfl-predictions-work/

library('reshape2')


new <- '2016-17'
old <- '2015-16'

# read in final values from 2014-15
old_final_elo <- read.csv(paste0("Hockey/Hockey_Fights/data/final_elo_", old, ".csv"))
mean(old_final_elo$final_elo)

# Look at Elo Histogram
hist(old_final_elo$final_elo)
# 1/3 mean reversion
old_final_elo$diff <- old_final_elo$final_elo - 1200

old_final_elo$adj <- old_final_elo$diff/3

old_final_elo$elo_adj <- old_final_elo$final_elo - old_final_elo$adj
hist(old_final_elo$elo_adj)

# read in data from 2015 to 2016
hf <- read.csv(paste0("Hockey/Hockey_Fights/data/hf_data_nhl_", new,".csv"))

# Custom Function in functions.R
# over-rides dataset, only run once
hf <- clean_date(hf)

# Find date max and min
max_date <- max(hf$date)
min_date <- min(hf$date)

# Create a list of all dates from begining to end
all_dates <- seq(min_date,max_date, by=1)

# Remove space from all players names
hf$away_player_name <- gsub(" ", "_", trimws(hf$away_player_name, which = c("both")))
hf$home_player_name <- gsub(" ", "_", trimws(hf$home_player_name, which = c("both")))

# create a list of all players - including players from pervious seasons
away_n <- as.character(unique(hf$away_player_name))
home_n <- as.character(unique(hf$home_player_name))
elo_n <- as.character(old_final_elo$names)
player_list <- unique(c(away_n, home_n,elo_n))

# Create a panel dataset of all date and player combinations
elox <- old_final_elo[,c('names','elo_adj')]

# find players without a previous elo rating
new_names <- setdiff(player_list, old_final_elo$names)

new_1200 <- data.frame(names = new_names,
                       elo_adj = rep(1200,length(new_names)))

all_names <- rbind(elox, new_1200)

# convert from long to wide
wide_elo <- spread(all_names, key = names, value = elo_adj)

# find the number of days in the season
days_in_season <- max_date - min_date

# convert from wide to box - make a row for every day of the season
box_elo <- wide_elo[rep(seq_len(nrow(wide_elo)),each= days_in_season+1),]
date_frame <- data.frame(date = seq(min_date,max_date, by=1))

dim(box_elo)
dim(date_frame)
elo <- cbind(date_frame, box_elo)

# dim(elo)
# head(elo)
# str(elo)



# See functions.R for function details
elo <- elo_function(elo,hf)



final_elo <- elo[nrow(elo),2:ncol(elo)]

final_elo_long <- gather(final_elo, colnames(final_elo))
colnames(final_elo_long) <- c('names','final_elo')

final_elo_long <- final_elo_long[order(-final_elo_long$final_elo),]

hist(final_elo_long$final_elo)
summary(final_elo_long$final_elo)

write.csv(final_elo_long,paste0("Hockey/Hockey_Fights/data/final_elo_",new, ".csv"),row.names = F)

write.csv(elo,paste0("Hockey/Hockey_Fights/data/elo_",new,".csv"),row.names = F)



