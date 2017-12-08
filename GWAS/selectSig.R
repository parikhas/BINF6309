file<-read.table("epilepsy.txt.assoc.adjusted", header=TRUE)
#head(file)
MyData=file[file$BONF<=0.05,]
write.csv(MyData, file="selectSig.csv")

