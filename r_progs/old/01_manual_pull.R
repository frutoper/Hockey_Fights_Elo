fight <- readLines('http://www.hockeyfights.com/fights/137755')


fight %>%
  html_node(".blueheader+ .contentnormal tr:nth-child(3) td:nth-child(1)") %>%
  html_text()


grep('itemprop="name"',fight)



grep('class="columnbreaker"><a href="/players/'),fight)


mypattern = '<td class="row-text">([^<]*)</td>'
> datalines = grep(mypattern,thepage[536:length(thepage)],value=TRUE)


mypattern = '<td class="columnbreaker"><a href="/players/([^<]*)">([^<]*)</a></td>'
datalines = grep(mypattern,fight[200:length(fight)],value=TRUE)

grep(datalines[1], '">')

?gsub

result = gsub(mypattern,'\\1',matches)


library(stringr)
datalines
str_match(datalines[1], "> (.*) <")
dl <- datalines[1]
dl2 <- datalines[2]
gregexpr(pattern ='\">',dl2)

dl2
dim(datalines)


z <- 'markfruin'

substr(dl2,53,400)

