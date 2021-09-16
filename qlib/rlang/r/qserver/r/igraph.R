

library('ggplot2')

library('igraph')

update.packages('igraph')

source('C:/q/r/qserver/qserver.R')

kdb <- open_connection('localhost',19010)

bot <-execute(kdb,'bot')

g <- graph.data.frame(bot, directed=TRUE)

clique.number(g)

cliques(g)


l = largest.independent.vertex.sets(g)

ind <- induced.subgraph(g, largest.independent.vertex.sets(g)[[1]])

plot(ind)

i <-independent.vertex.sets(g, min=NULL, max=NULL)

maximal.independent.vertex.sets(graph)
independence.number(graph)