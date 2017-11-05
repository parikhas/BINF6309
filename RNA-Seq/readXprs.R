#set a variable with the path containing eXpress files
xprsPath<-"xprs_gg"
#set a variable with eXpress results filename
xprsFile<-"results.xprs"
#Create a vector of eXpress results files
files<-list.files(path = xprsPath, pattern = xprsFile, full.names = T, recursive = TRUE)
#Check the vector contents
files
#read the first file
firstFile<-read.delim(files[1],sep = "\t")
#Display the top of the first table
head(firstFile)
#Initialize a variable with null to store the merged table
merged<-NULL
#Iterate over the vector of eXpress results files
for (file in files){
  #Read results.xprs for the samples as tab-delimited
  nextSample<-read.delim(file,sep = "\t")
  #Select the two columns we need
  nextSample<-nextSample[,c("target_id","uniq_counts")]
  #Rename the uniq_counts to column so it identifies the sample
  colnames(nextSample)<-c("transcript", file)
  #If this is the first results file (merged is null) copy to merged
  if (is.null(merged)){
    merged<-nextSample
    #Else merge the next sample
  }else{
    merged<-merge(merged, nextSample)
  }
}
head(merged)
#Get the column names
uglyColumns=colnames(merged)
#Replace the path with an empty string
lessUglyColumns=gsub(paste0(xprsPath,'/'),"",uglyColumns)
lessUglyColumns

#Replace /results.xprs with an empty string
prettyColumns=gsub(paste0('/', xprsFile),"",lessUglyColumns)
prettyColumns
colnames(merged)<-prettyColumns
write.csv(merged, file = "mergedCountTable.csv", row.names = FALSE)
