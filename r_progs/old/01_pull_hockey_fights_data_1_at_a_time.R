library('rvest')

# initialize an empty dataset
hf <- data.frame(date = rep(0,1),
                 time = rep(0,1),
                 away_team = rep(0,1),
                 away_ply = rep(0,1),
                 home_team = rep(0,1),
                 home_ply = rep(0,1),
                 win_name = rep(0,1),
                 win_score = rep(0,1),
                 place_name = rep(0,1),
                 place_score = rep(0,1),
                 show_name = rep(0,1),
                 show_score = rep(0,1),
                 url = rep(0,1)
                 )
head(hf)
 
# fight <- read_html("http://www.hockeyfights.com/fights/137718")
# fight

fight_id <- 137736

read_in_fight <- function(fight_id){
  url <- paste0("http://www.hockeyfights.com/fights/",fight_id)
  fight <- read_html(url)
  
  hf$date <- fight %>%
    html_node(".fauxhead+ tr td:nth-child(1)") %>%
    html_text()
  
  hf$time <- fight %>%
    html_node(".fauxhead~ tr+ tr td:nth-child(1)") %>%
    html_text()
  
  hf$away_team <- fight %>%
    html_node(".fauxhead+ tr td:nth-child(2)") %>%
    html_text()
  
  hf$away_ply <- fight %>%
    html_node(".fauxhead+ tr .columnbreaker+ .columnbreaker") %>%
    html_text()
  
  
  hf$home_team <- fight %>%
    html_node(".fauxhead~ tr+ tr .columnbreaker:nth-child(2)") %>%
    html_text()
  
  hf$home_ply <- fight %>%
    html_node(".fauxhead~ tr+ tr .columnbreaker+ .columnbreaker") %>%
    html_text()
  
  hf$win_name <- fight %>%
    html_node(".contentblock~ .contentblock+ .contentblock tr:nth-child(1) td:nth-child(1)") %>%
    html_text()
  
  hf$win_score <- fight %>%
    html_node("tr:nth-child(1) .columnbreaker+ .columnbreaker") %>%
    html_text()
  
  hf$place_name <- fight %>%
    html_node(".blueheader+ .contentnormal tr:nth-child(2) td:nth-child(1)") %>%
    html_text()
  
  hf$place_score <- fight %>%
    html_node(".blueheader+ .contentnormal tr:nth-child(2) .columnbreaker+ .columnbreaker") %>%
    html_text()
  
  
  hf$show_name <- fight %>%
    html_node(".blueheader+ .contentnormal tr:nth-child(3) td:nth-child(1)") %>%
    html_text()
  
  hf$show_score <- fight %>%
    html_node(".blueheader+ .contentnormal tr~ tr+ tr .columnbreaker+ .columnbreaker") %>%
    html_text()
  
  hf$url <- url
  
  print(hf)
  
  # final <- hf
  final <- rbind(final,hf)
  
  print(tail(final))
  
  print(dim(final))
  
  write.csv(final, "Hockey/Hockey_Fights/data/raw_201728_nhl_incomplete.csv",row.names = F)
}

url <- paste0("http://www.hockeyfights.com/fights/",137755)
fight <- read_html(url)

read_in_fight(137755)

