
library(tidyverse)


hf <- read.csv("Hockey/Hockey_Fights/data/hf_data_nhl_2014-15.csv")


############################################################################################################################
# Clean data and setup datasets
###########################################################################################################################
# Convert date - remove commas
hf$date <- (gsub(",","",hf$date))
# replace spaces with blackslash
hf$date <- (gsub(" ","/",hf$date))

# Convert to date
hf$date <- as.Date(hf$date, format="%B/%d/%Y")

# reorder oldest to newest
hf <- hf[order(hf$date),]

# re-index for easier reference
rownames(hf) <- 1:nrow(hf)

# Find date max and min
max_date <- max(hf$date)
min_date <- min(hf$date)

# Create a list of all dates from begining to end
all_dates <- seq(min_date,max_date, by=1)

# Remove space from all players names
hf$away_player_name <- gsub(" ", "_", hf$away_player_name)
hf$home_player_name <- gsub(" ", "_", hf$home_player_name)

# create a list of all players
away_n <- as.character(unique(hf$away_player_name))
home_n <- as.character(unique(hf$home_player_name))
player_list <- unique(c(away_n, home_n))

# Create a panel dataset of all date and player combinations
df <- data.frame(player_list)


# make a dataset with date and fighers names
# pre load dataset with starting elo of 1200 for every fighter
elo <- data.frame(matrix(ncol = length(player_list)+1, nrow = length(all_dates), 1200))
colnames(elo) <- c('date', player_list)

# add real dates to dates column
elo$date <- all_dates
str(elo)
head(elo)
############################################################################################################################
# DONE - clean data and setup datasets
###########################################################################################################################




############################################################################################################################
# Loop Through rights to create elo
###########################################################################################################################

for(i in 1:dim(elo)[1]){
  #i <- 1
  
  t_fight <- hf[i,]
  t_fight
  
  str(t_fight)
  
  elo1 <- elo[elo$date == t_fight$date,c('date',
                                        gsub(" ", "_", t_fight$away_player_name),
                                        gsub(" ", "_", t_fight$home_player_name))]
  
  
  (Ra <- 10**(elo1[,2]/400))
  (Rh <- 10**(elo1[,3]/400))
  
  (RaProb <- Ra / (Ra+Rh))
  (RhProb <- Rh / (Ra+Rh))
  
  (d_pct <- t_fight$fight_votes_draw / t_fight$fight_votes)
  
  # Too many fights may result in a draw.
  # the fight is only a draw is more than 50% of the voters think its a draw
  # If less than 50%, then we have a winner
  # add function control - if(d_pct > .5){tie}
  if(d_pct > .5){
    a_elo <- elo1[,2] + 32*(0.5 - RaProb)
    h_elo <- elo1[,3] + 32*(0.5 - RhProb)
  }else{
    #Re-scale non-ties
    (a_pct <- t_fight$fight_votes_away_win / (t_fight$fight_votes - t_fight$fight_votes_draw) )
    (h_pct <- t_fight$fight_votes_home_win / (t_fight$fight_votes - t_fight$fight_votes_draw))
    
    a_elo <- elo1[,2] + 32*(a_pct - RaProb)
    h_elo <- elo1[,3] + 32*(h_pct - RhProb)
  }
  
  # reset all future elo rating to the most recent change
  elo[elo$date > t_fight$date, gsub(" ", "_", t_fight$away_player_name)] <- a_elo
  elo[elo$date > t_fight$date, gsub(" ", "_", t_fight$home_player_name)] <- h_elo
}

tail(elo)
# save season elo rating
write.csv(elo, )



