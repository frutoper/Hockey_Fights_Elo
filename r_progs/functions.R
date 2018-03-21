
clean_date <- function(dat){
  
  # Convert date - remove commas
  dat$date <- (gsub(",","",dat$date))
  # replace spaces with blackslash
  dat$date <- (gsub(" ","/",dat$date))
  # replace dash with backslash
  dat$date <- gsub("-", "/", dat$date)
  
  # Hockey Fights data has a different date format in 2016
  if(as.numeric(  min( substr(dat$date,8,12)   )) == 16){

    dat$date <- as.Date(dat$date, format="%d/%B/%y")
  }else{

    # Convert to date
    dat$date <- as.Date(dat$date, format="%B/%d/%Y")
  }
  
  dat <- dat[order(dat$date),]
  
  # reset index after re-order
  rownames(dat) <- 1:nrow(dat)
  
  
  return(dat)
  
}






elo_function <- function(dat,fights, k=32){
  for(i in 1:nrow(fights)){
    temp_f <- fights[i,]
    
    # str(temp_f)
    
    temp_dat <- dat[dat$date == temp_f$date,c('date',
                                              gsub(" ", "_", temp_f$away_player_name),
                                              gsub(" ", "_", temp_f$home_player_name))]
    
    # str(temp_f)
    # str(temp_dat)
    
    (Ra <- 10**(temp_dat[,2]/400))
    (Rh <- 10**(temp_dat[,3]/400))
    
    (RaProb <- Ra / (Ra+Rh))
    (RhProb <- Rh / (Ra+Rh))
    
    (d_pct <- temp_f$fight_votes_draw / temp_f$fight_votes)
    
    # Too many fights may result in a draw.
    # the fight is only a draw is more than 50% of the voters think its a draw
    # If less than 50%, then we have a winner
    # add function control - if(d_pct > .5){tie}
    if(d_pct > .5){
      a_dat <- temp_dat[,2] + k*(0.5 - RaProb)
      h_dat <- temp_dat[,3] + k*(0.5 - RhProb)
    }else{
      #Re-scale non-ties
      (a_pct <- temp_f$fight_votes_away_win / (temp_f$fight_votes - temp_f$fight_votes_draw) )
      (h_pct <- temp_f$fight_votes_home_win / (temp_f$fight_votes - temp_f$fight_votes_draw))
      
      a_dat <- temp_dat[,2] + k*(a_pct - RaProb)
      h_dat <- temp_dat[,3] + k*(h_pct - RhProb)
    }
    
    
    dat[dat$date > temp_f$date, gsub(" ", "_", temp_f$away_player_name)] <- a_dat
    dat[dat$date > temp_f$date, gsub(" ", "_", temp_f$home_player_name)] <- h_dat
    
  }
  return(dat)
}


