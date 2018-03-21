
# read in final values from 2014-15
final_1415 <- read.csv("Hockey/Hockey_Fights/data/final_elo_2014-15.csv")
mean(final_1415$final_elo)

# Look at Elo Histogram
hist(final_1415$final_elo)
# 1/3 mean reversion
final_1415$diff <- final_1415$final_elo - 1200
hist(final_1415$diff)
final_1415$adj <- final_1415$diff/3
hist(final_1415$adj)
final_1415$elo_adj <- final_1415$final_elo - final_1415$adj
hist(final_1415$elo_adj)

# read in data from 2015 to 2016
hf_1516 <- read.csv("Hockey/Hockey_Fights/data/hf_data_nhl_2015-16.csv")

hf <- hf_1516

# Convert date - remove commas
hf$date <- (gsub(",","",hf$date))
# replace spaces with blackslash
hf$date <- (gsub(" ","/",hf$date))

# Convert to date
hf$date <- as.Date(hf$date, format="%B/%d/%Y")

hf <- hf[order(hf$date),]

head(hf)

# reset index after re-order
rownames(hf) <- 1:nrow(hf)

# Find date max and min
max_date <- max(hf$date)
min_date <- min(hf$date)

# Create a list of all dates from begining to end
all_dates <- seq(min_date,max_date, by=1)

# Remove space from all players names
hf$away_player_name <- gsub(" ", "_", hf$away_player_name)
hf$home_player_name <- gsub(" ", "_", hf$home_player_name)

# create a list of all players - including players from pervious seasons
away_n <- as.character(unique(hf$away_player_name))
home_n <- as.character(unique(hf$home_player_name))
elo_n <- as.character(final_1415$names)
player_list <- unique(c(away_n, home_n,elo_n))

# Create a panel dataset of all date and player combinations
elox <- final_1415[,c('names','elo_adj')]

old_names <- final_1415$names

new_names <- setdiff(player_list, old_names)

new_1200 <- data.frame(names = new_names,
                       elo_adj = rep(1200,length(new_names)))

all_names <- rbind(elox, new_1200)

library('reshape2')

wide_elo <- spread(all_names, key = names, value = elo_adj)
str(wide_elo)

days <- max_date - min_date

df <- data.frame(a=1:2, b=letters[1:2]) 
df[rep(seq_len(nrow(df)), each=2),]

box_elo <- wide_elo[rep(seq_len(nrow(wide_elo)),each=days),]
date_frame <- data.frame(date = seq(min_date,max_date, by=1))

elo_1516 <- merge(date_frame, box_elo)
head(elo_1516)
str(elo_1516)

elo <- elo_1516


for(i in 1:nrow(hf)){
  temp_f <- hf[i,]

  temp_elo <- elo[elo$date == temp_f$date,c('date',
                                            gsub(" ", "_", temp_f$away_player_name),
                                            gsub(" ", "_", temp_f$home_player_name))]
  
  (Ra <- 10**(temp_elo[,2]/400))
  (Rh <- 10**(temp_elo[,3]/400))
  
  (RaProb <- Ra / (Ra+Rh))
  (RhProb <- Rh / (Ra+Rh))
  
  (d_pct <- temp_f$fight_votes_draw / temp_f$fight_votes)
  
  # Too many fights may result in a draw.
  # the fight is only a draw is more than 50% of the voters think its a draw
  # If less than 50%, then we have a winner
  # add function control - if(d_pct > .5){tie}
  if(d_pct > .5){
    a_elo <- temp_elo[,2] + 32*(0.5 - RaProb)
    h_elo <- temp_elo[,3] + 32*(0.5 - RhProb)
  }else{
    #Re-scale non-ties
    (a_pct <- temp_f$fight_votes_away_win / (temp_f$fight_votes - temp_f$fight_votes_draw) )
    (h_pct <- temp_f$fight_votes_home_win / (temp_f$fight_votes - temp_f$fight_votes_draw))
    
    a_elo <- temp_elo[,2] + 32*(a_pct - RaProb)
    h_elo <- temp_elo[,3] + 32*(h_pct - RhProb)
  }
  
  
  elo[elo$date > temp_f$date, gsub(" ", "_", temp_f$away_player_name)] <- a_elo
  elo[elo$date > temp_f$date, gsub(" ", "_", temp_f$home_player_name)] <- h_elo
  
}

final_elo <- elo[nrow(elo),2:ncol(elo)]

final_elo_long <- gather(final_elo, colnames(final_elo))
colnames(final_elo_long) <- c('names','final_elo')

final_elo_long <- final_elo_long[order(-final_elo_long$final_elo),]

hist(final_elo_long$final_elo)
summary(final_elo_long$final_elo)

write.csv(final_elo_long,"Hockey/Hockey_Fights/data/final_elo_2015-16.csv",row.names = F)

write.csv(elo,"Hockey/Hockey_Fights/data/elo_2015-16.csv",row.names = F)


