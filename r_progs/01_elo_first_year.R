# Author: Mark Fruin
# Data Source: HockeyFights.com
# Elo Sources: 
# https://metinmediamath.wordpress.com/2013/11/27/how-to-calculate-the-elo-rating-including-example/
# https://gist.github.com/i000313/90b1f3c556b1b1ad8278
# http://gobase.org/studying/articles/elo/
# https://en.wikipedia.org/wiki/Elo_rating_system
# https://fivethirtyeight.com/features/how-our-2017-nfl-predictions-work/




hf <- read.csv("Hockey/Hockey_Fights/data/hf_data_nhl_2014-15.csv")

hf <- clean_date(hf)


# Find date max and min
max_date <- max(hf$date)
min_date <- min(hf$date)

# Create a list of all dates from begining to end
all_dates <- seq(min_date,max_date, by=1)

# Remove special characters from all players names
hf$away_player_name <- gsub(" ", "_", hf$away_player_name)
hf$home_player_name <- gsub(" ", "_", hf$home_player_name)
hf$away_player_name <- gsub("-", ".", hf$away_player_name)
hf$home_player_name <- gsub("-", ".", hf$home_player_name)
hf$away_player_name <- gsub("'", ".", hf$away_player_name)
hf$home_player_name <- gsub("'", ".", hf$home_player_name)

# create a list of all players
away_n <- as.character(unique(hf$away_player_name))
home_n <- as.character(unique(hf$home_player_name))
player_list <- unique(c(away_n, home_n))

# Create a panel dataset of all date and player combinations
elo <- data.frame(matrix(ncol = length(player_list)+1, nrow = length(all_dates), 1200))
colnames(elo) <- c('date', player_list)
head(elo)

elo$date <- all_dates
str(elo)

head(elo[,1])





# See functions.R for function details
elo <- elo_function(elo,hf)




final_elo <- elo[nrow(elo),2:ncol(elo)]

final_elo_long <- gather(final_elo, colnames(final_elo))
colnames(final_elo_long) <- c('names','final_elo')

final_elo_long <- final_elo_long[order(-final_elo_long$final_elo),]

write.csv(final_elo_long,"Hockey/Hockey_Fights/data/final_elo_2014-15.csv",row.names = F)

write.csv(elo,"Hockey/Hockey_Fights/data/elo_2014-15.csv",row.names = F)
