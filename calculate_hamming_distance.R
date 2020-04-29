#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)
if(length(args)==0)
{
  stop("no argument passed")
}

library(Biostrings)
#library(dplyr)
library(parallel)

v_rep = readDNAStringSet(filepath = args[1])
v_rep = as.character(v_rep)
original_string = v_rep[1]
calculate_hamming_distance = function(x)
{
  return(as.integer(stringDist(c(original_string, x), method = "hamming", ignoreCase = FALSE)))
}

number_of_cores = detectCores()
clust = makeCluster(number_of_cores)
clusterExport(clust,varlist = c("original_string", "calculate_hamming_distance"))
clusterEvalQ(clust,library(Biostrings))

res = parSapply(clust,v_rep,calculate_hamming_distance)
res = (res - mean(res))/sd(res)
res = as.data.frame(res)
names(res) = c("hamming_distance")
write.csv(res,args[2])
gc()
