#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)
if(length(args)==0)
{
  stop("no argument passed")
}

library(CPBias)
library(Biostrings)
#library(dplyr)
library(parallel)

findCPB = function(x, reference_cpb_table)
{
  #print("in findCPB")
  #x = as.character(x)
  print(x)
  cpb = CPScalc(x, reference = reference_cpb_table, draw = FALSE, silent = TRUE)[[1]]
  print(cpb)
  temp_df = CPBtable(x, silent = TRUE)$CPBtable
  k = nrow(temp_df[!is.na(temp_df$cps),])
  #print(x)
  #print(k)
  cpb = cpb/log10(k)
  return(cpb)
}

number_of_cores = detectCores()
clust = makeCluster(number_of_cores)
coding_content = importFasta(fastaLocation = "/home/cidr/Downloads/softwares/CodonShuffle-master/coding_regions.fasta",sepSequences = TRUE)[[1]]
cpb_table = CPBtable(coding_content, silent = TRUE)[[1]]
#cpb_table = cpb_table$CPBtable
#class(cpb_table$CPBtable)

# library(ggplot2)
# codon_bias_scores_df = cpb_table$CPBtable
# codon_bias_scores_df = codon_bias_scores_df %>% dplyr::filter(!is.na(cps))
# ggplot(codon_bias_scores_df, aes(x = cps))+geom_density()

#replicates = readDNAStringSet(filepath = args[1])
replicates = importFasta(fastaLocation = args[1], sepSequences = TRUE)[[1]]
print(replicates)
#v = c(length = length(replicates))


#findCPB(replicates[[1]],cpb_table)

clusterExport(clust,varlist = c("findCPB","cpb_table"))
clusterEvalQ(clust,library(CPBias))
res = parSapply(clust,replicates,findCPB,cpb_table)
res = (res - mean(res))/sd(res)
res = (res - res[1])^2

#findCPB(replicates[[1]],cpb_table)



#res = sapply(as.vector(replicates),findCPB, cpb_table)

# for(i in 1:length(replicates))
# {
#   v[i] = CPScalc(replicates[[i]], reference = cpb_table$CPBtable, draw = FALSE, silent = TRUE)[[1]]
#   #print(length(CPScalc(replicates[[i]], reference = cpb_table$CPBtable, draw = FALSE, silent = TRUE)[[2]]))
#   temp_df = CPBtable(replicates[[i]], silent = TRUE)$CPBtable
#   k = nrow(temp_df[!is.na(temp_df$cps),])
#   #print(k)
#   #print("*****")
#   #print(v[i])
#   v[i] = v[i]/log10(k)
#   #print(v[i])
# }
# v = (v - mean(v))/sd(v)
# v = v - v[1]
# v = v^2
# #hist(v)
# res[3] == v[3]
gc()
