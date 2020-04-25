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
#observed frequency/expected frequency 
dn_df = dn_df /0.0625

first_row = as.vector(dn_df[1,])
temp_df = do.call(rbind,apply(dn_df,1,function(x) x - first_row))
#temp_df = sweep(as.matrix(dn_df), 1, first_row,"-")
print(head(temp_df))
temp_df = apply(temp_df,c(1,2), function(x) x^2)
temp_df = data.frame(temp_df) %>% dplyr::mutate(sum_of_squares = rowSums(.))

z = (temp_df$sum_of_squares - mean(temp_df$sum_of_squares))/sd(temp_df$sum_of_squares)
z = (z-z[1])^2
z = as.data.frame(z)
names(z) = "dinucleotide_frequency_z_squared_score"
z$id = names(replicates)

#print(head(temp_df))
#dn_df - dn_df[1,]
#print(getwd())
write.csv(dn_df, file = "./final_dinucleotide_frequency_from_r.csv", row.names = FALSE)
print("dinucleotide wise frequenct file generated")
print("./final_dinucleotide_frequency_from_r.csv")
write.csv(z, file = "./dinucleotide_frequency_z_squared.csv", row.names = FALSE)
print("dinucleotide frequency z squared sumf file generated ")
print("./dinucleotide_frequency_z_squared.csv")
#print(dn_df)
