
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


elo <- read.csv("Hockey/Hockey_Fights/data/elo_2014-15.csv")

str(elo)
dim(elo)
table(elo$date)

elo$date_date <- as.Date(elo$date)

str(elo$date_date)

p <- plot_ly(elo, x = 'date_date', y = 'Erik_Condra', type = 'scatter', mode = 'lines')

p

plot(elo$date_date,elo$Erik_Condra,elo$Bryan_Bickell)

p <- plot_ly(elo, x = ~date_date, y=~Sean_Couturier, name='Sean_Couturier' ,type='scatter',mode='lines') %>%
  add_trace(y = ~Erik_Condra, name = 'Erik_Condra',mode = 'lines') 

p

elo$Sean_Couturier <- ifelse(elo$Sean_Couturier == 1200,
                          NA, elo$Sean_Couturier)

colnames(elo)
2:277

for(i in 2:277){
  dum_non_1200 <- ifelse(elo[i] == 1200,0,1)
  
  index <- min(which(dum_non_1200 == TRUE),280)
  
  elo[1:(index -2),i] <- NA 

}



ay <- list(
  tickfont = list(color = "red"),
  overlaying = "y",
  side = "right"
)
p <- plot_ly(elo,x=~date_date,name="date_date") %>%
  add_trace(y=Sean_Couturier,name="Sean_Couturier",mode='lines') 
p

%>%
  layout(yaxis2=ay)

summary(elo$Sean_Couturier)


p <- plot_ly(elo, x = ~date_date, y=~Sean_Couturier, name='Sean_Couturier' ,type='scatter',mode='lines') %>%
  add_trace(y = ~Erik_Condra, name = 'Erik_Condra',mode = 'lines') 

p

p <- plot_ly(elo, x = ~date_date, y=~elo[,2], name=colnames(elo)[2] ,type='scatter',mode='lines') %>%
  add_trace(y = ~Erik_Condra, name = 'Erik_Condra',mode = 'lines') 

p


z <- apply(elo,2,sd,na.rm=TRUE)

hist(z)
summary(z)

high_sd_list <- ifelse(z < 10 | is.na(z),F,T)

summary(high_sd_list)

6,10, 15
for(k in 1:length(high_sd_list)){
  if(high_sd_list[k] == T){
    print(k)
  }
}

p <- plot_ly(elo, x = ~date_date, y=elo[,6],
             name=colnames(elo)[6] ,
             type='scatter',
             mode='lines')
p

for(i in 2:length(high_sd_list)){
  if(high_sd_list[i] == T){
    p<-add_trace(p=p, y=elo[,i], name= colnames(elo)[i],mode = 'lines') 
  }
}

p

