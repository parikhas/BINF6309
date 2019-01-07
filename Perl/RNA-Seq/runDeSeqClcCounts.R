library("DESeq2")
#Load saved RData.
load("clcCountsBlast2GoAnnotations.RData")

ddsAll <- DESeqDataSetFromMatrix(countData = rawCounts,
                                 colData = colData,
                                 design = ~ Vibrio + Menthol)

ddsAll$Menthol <- relevel(ddsAll$Menthol, ref="NoMenthol")
ddsAll$Vibrio <- relevel(ddsAll$Vibrio, ref="NoVibrio")

nrow(counts(ddsAll))

ddsAll <- ddsAll[ rowSums(counts(ddsAll)) > 10, ]
nrow(counts(ddsAll))

ddsAll <- DESeq(ddsAll)

resultsNames(ddsAll)

resVibrio <- results(ddsAll, alpha=0.05, name="Vibrio_Vibrio_vs_NoVibrio")
resMenthol <- results(ddsAll, alpha=0.05, name="Menthol_Menthol_vs_NoMenthol")
dfVibrio <- as.data.frame(resVibrio)
dfMenthol <- as.data.frame(resMenthol)

head(dfVibrio)
head(dfMenthol)

dfVibrio <- subset(subset(dfVibrio, select=c(log2FoldChange, padj)))
head(dfVibrio)

dfMenthol <- subset(subset(dfMenthol, select=c(log2FoldChange, padj)))
head(dfMenthol)

dfBoth <- merge(dfMenthol, dfVibrio, by=0, suffixes = c(".Menthol",".Vibrio"))
rownames(dfBoth) <- dfBoth$Row.names
head(dfBoth)

dfBoth <- subset(dfBoth, select = -c(Row.names) )
head(dfBoth)

dfBothAnnot <- merge(dfBoth, geneDesc,by=0,all.x=TRUE )
rownames(dfBothAnnot) <- dfBothAnnot$Row.names
dfBothAnnot <- subset(dfBothAnnot, select = -c(Row.names) )
head(dfBothAnnot, n=10)

save(ddsAll, dfBothAnnot, resVibrio, resMenthol, file="summarizedDeResults.RData")

rm(list=ls())






