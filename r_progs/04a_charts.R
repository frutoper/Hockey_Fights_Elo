
install.packages("plotly")
library(plotly)
# https://stackoverflow.com/questions/34580095/using-r-and-plot-ly-how-do-i-script-saving-my-output-as-a-webpage
#

?plotlyOutput

x <- c(1:100)
random_y <- rnorm(100, mean = 0)
data <- data.frame(x, random_y)

p <- plot_ly(data, x = ~x, y = ~random_y, type = 'scatter', mode = 'lines')
p
# Create a shareable link to your chart
# Set up API credentials: https://plot.ly/r/getting-started
chart_link = plotly_POST(p, filename="line/basic")
chart_link

p

plotlyOutput(p,inline='div')


eloold <- read.csv("Hockey/Hockey_Fights/data/elo_2014-15.csv")

colnames(eloold)
colnames(elo)
identical(elo[1:2,2],eloold[1:2,2])


identical(colnames(elo),colnames(eloold))

rbind(colnames(elo),colnames(eloold))

str(elo)
dim(elo)
table(elo$date)

elo$date_date <- as.Date(elo$date)

str(elo$date_date)

colnames(elo)
2:277

for(i in 2:277){
  dum_non_1200 <- ifelse(elo[i] == 1200,0,1)
  
  index <- min(which(dum_non_1200 == TRUE),188)
  
  elo[1:(index -2),i] <- NA 
  
}




z <- apply(elo,2,sd,na.rm=TRUE)

hist(z)
summary(z)

high_sd_list <- ifelse(z < 12 | is.na(z),F,T)

summary(high_sd_list)

p <- plot_ly(elo, x = ~date_date, y=elo[,6],
             name=colnames(elo)[6] ,
             type='scatter',
             mode='lines')
p

for(i in 7:length(high_sd_list)){
  if(high_sd_list[i] == T){
    p<-add_trace(p=p, y=elo[,i], name= colnames(elo)[i],mode = 'lines') 
  }
}

p


eloX <- elo[,high_sd_list]

eloX$date <- elo$date_date

write.csv(eloX, 'Hockey/Hockey_Fights/data/sample_2014-15.csv')
