library('rvest')

# initialize an empty dataset
hf <- data.frame(date = rep(0, 2366),
                 time = rep(0, 2366),
                 away_team = rep(0, 2366),
                 away_ply = rep(0, 2366),
                 home_team = rep(0, 2366),
                 home_ply = rep(0, 2366),
                 win_name = rep(0, 2366),
                 win_score = rep(0, 2366),
                 place_name = rep(0, 2366),
                 place_score = rep(0, 2366),
                 show_name = rep(0, 2366),
                 show_score = rep(0, 2366)
                 )
head(hf)


fight <- read_html("http://www.hockeyfights.com/fights/137718")
fight

137718

hf$date[i] <- fight %>%
  html_node(".fauxhead+ tr td:nth-child(1)") %>%
  html_text()


id_vector <- c(137715:140081)
id_vector[4]
for(i in 1:4){

  Sys.sleep((runif(1)+3)*30)
  
  print(i)
 
  ignore <- read_html(paste0("http://www.hockeyfights.com/"))
  
  Sys.sleep((runif(1)+3)*2)
    
  fight <- read_html(paste0("http://www.hockeyfights.com/fights/",id_vector[i]))
  
  
  hf$date[i] <- fight %>%
    html_node(".fauxhead+ tr td:nth-child(1)") %>%
    html_text()
  
  hf$time[i] <- fight %>%
    html_node(".fauxhead~ tr+ tr td:nth-child(1)") %>%
    html_text()
  
  hf$away_team[i] <- fight %>%
    html_node(".fauxhead+ tr td:nth-child(2)") %>%
    html_text()
  
  hf$away_ply[i] <- fight %>%
    html_node(".fauxhead+ tr .columnbreaker+ .columnbreaker") %>%
    html_text()
  
  
  hf$home_team[i] <- fight %>%
    html_node(".fauxhead~ tr+ tr .columnbreaker:nth-child(2)") %>%
    html_text()
  
  hf$home_ply[i] <- fight %>%
    html_node(".fauxhead~ tr+ tr .columnbreaker+ .columnbreaker") %>%
    html_text()
  
  hf$win_name[i] <- fight %>%
    html_node(".contentblock~ .contentblock+ .contentblock tr:nth-child(1) td:nth-child(1)") %>%
    html_text()
  
  hf$win_score[i] <- fight %>%
    html_node("tr:nth-child(1) .columnbreaker+ .columnbreaker") %>%
    html_text()
  
  hf$place_name[i] <- fight %>%
    html_node(".blueheader+ .contentnormal tr:nth-child(2) td:nth-child(1)") %>%
    html_text()
  
  hf$place_score[i] <- fight %>%
    html_node(".blueheader+ .contentnormal tr:nth-child(2) .columnbreaker+ .columnbreaker") %>%
    html_text()
  
  
  hf$show_name[i] <- fight %>%
    html_node(".blueheader+ .contentnormal tr:nth-child(3) td:nth-child(1)") %>%
    html_text()
  
  hf$show_score[i] <- fight %>%
    html_node(".blueheader+ .contentnormal tr~ tr+ tr .columnbreaker+ .columnbreaker") %>%
    html_text()

  print(hf[i,])
}

head(hf,10)

tail(hf)
hf[,1:5]

write.csv(hf, "Hockey/Hockey_Fights/data/raw_201728_incomplete.csv",row.names = F)
