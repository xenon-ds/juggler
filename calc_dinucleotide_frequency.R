#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)
if(length(args)==0)
{
  stop("no argument passed")
}
library(Biostrings)
library(dplyr)
replicates = readRNAStringSet(filepath = args[1])
#names(replicates)
dn_df = as.data.frame(dinucleotideFrequency(replicates))
#rownames(dn_df) = names((replicates))
dn_df = dn_df %>% dplyr::mutate(total_dinucleotides = rowSums(.))
dn_df = dn_df[,1:16]/dn_df[,17]
dn_df = dn_df /0.0625

temp_df = do.call(rbind,apply(dn_df,1,function(x) x - first_row))
first_row = as.vector(dn_df[1,])
temp_df = sweep(as.matrix(dn_df), 1, first_row,"-")
print(head(temp_df))
temp_df = apply(temp_df,c(1,2), function(x) x^2)
temp_df = 
print(head(temp_df))
dn_df - dn_df[1,]
print(getwd())
write.csv(dn_df, file = "./final_dinucleotide_frequecy_from_r.csv", row.names = FALSE)
#print(dn_df)
