
#Loading data
pred <- read.table("~/GitHub/Neural-net-wave-detector/data/ESW_probabilities.csv", quote="\"", comment.char="")
actu <- read.table("~/GitHub/Neural-net-wave-detector/data/TSWF_high_res_indexes.csv", quote="\"", comment.char="")

library(caret)
library(ROCR)

P1 <- prediction(pred, labels=actu) # ROCR evaluation

ROC1 <- performance(P1,"tpr","fpr")

plot(ROC1, lwd=2, main="ROC curve")
plot(ROC2, add = T, lwd=2, col = "red")
plot(ROC3, add = T, lwd=2, col = "green")
arrows(0,0,1,1,lty=2, code=0)


#color threshold
plot(performance(P1,"tpr","fpr"), main="ROC Curve for modelV2 (100 epochs, Adagrad)", 
     colorize=TRUE, print.cutoffs.at=seq(0,1,by=0.05))
arrows(0,0,1,1,lty=2, code=0)

#optimal yoda index
library(ROCit)
ROCit_obj <- rocit(score=pred[,1],class=actu[,1])
plot1 <- plot(ROCit_obj)
?rocit
summary(ROCit_obj)



library(pROC)
rocobj <- roc(actu, pred)
coords(rocobj, "best")
