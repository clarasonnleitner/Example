
##### Pakete
# install.packages("car")
# install.packages("plm")
# install.packages("dplyr") 
#
library(car)
library(plm)
library(dplyr)


###Aufgabe 2 


##Teilaufgabe b 

#KQ Sch?tzer 
KQ <-  (lm(Y ~ NRW + JUL + NRW*JUL, data = Schulen)) 

summary(KQ) 


#Gruppenmittelwerte: 

NRw_Juli <- subset(Schulen,NRW==1 & JUL==1)
(mean_NRW_Juli <- mean(NRw_Juli$Y)) 

NRW_Juni <- subset(Schulen, NRW==1 & JUL==0)
(Mean_NRW_Juni <- mean (NRW_Juni$Y))

Bayern_Juli <- subset(Schulen, NRW==0 & JUL==1)
(mean_Bay_Jul <- mean(Bayern_Juli$Y) )

Bayern_Jun <- subset (Schulen, NRW==0 & JUL==0) 
(mean_Bay_Jun <- mean (Bayern_Jun$Y)) 


#Differenzen-Differenzen-Schätzer per Hand 

mean_Bay_Jun-mean_Bay_Jul-(Mean_NRW_Juni-mean_NRW_Juli) 

#oder

mean_NRW_Juli-(mean_Bay_Jul-mean_Bay_Jun)-(Mean_NRW_Juni-mean_Bay_Jun)-mean_Bay_Jun 


#Differenzen-Differenzen-Schätzer mit Funktion 

diff<- lm(Y ~ NRW + JUL + NRW*JUL, data = Schulen)
summary (diff) 


##Teilaufgabe d 


#Möglicher Test, ist der F-Test, alles Null setzten

summary (ols <- lm(Y ~ NRW + JUL + NRW*JUL, data = Schulen))

linearHypothesis(ols, c( "JUL =0")) 



###Aufgabe 3
## Teilaufgabe a) 
#Pooled OLS 
pooled_ols <- (lm(lfare~concen+ldist+ldistsq+y98+y99+y00,data=airfare)) 

summary(pooled_ols)

##Teilaufgabe b  
#random effect 

re <- ( plm (lfare~concen+ldist+ldistsq+y98+y99+y00,data=airfare, model="random", 
                     index=c ("id", "year")))

summary(re) 

##Teilaufgabe c 

fe <- ( plm (lfare~concen+ldist+ldistsq+y98+y99+y00,data=airfare, model="within", 
             index=c ("id", "year"))) 
summary (fe)



##Teilaufgabe d 


mean_concen <- airfare %>% select(id, concen) %>% group_by(id)%>% summarise(mean(concen))
colnames(mean_concen) <- c("id", "concenbar")

airfare_mean_concen <- 
  merge(airfare, mean_concen, by = c("id"), all.x = T, all.y = T)


airfare_mean_concen <- as.data.frame(airfare_mean_concen)

re <-
  (
    plm(
      lfare ~ concenbar + concen + ldist + ldistsq + y98 + y99 + y00,
      data = airfare_mean_concen,
      model = "random",
      index = c ("id", "year")
    )
  )  
summary(re)


