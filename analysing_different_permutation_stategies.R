library(dplyr)
ls_n3_df = read.csv("/home/cidr/Downloads/softwares/CodonShuffle-master/NC_045512.2_26245_26472_Severe_acute_respiratory_syndrome_coronavirus_2_isolate_Wuhan_Hu_1__complete_genome_n3_least_square.txt", stringsAsFactors = FALSE, sep = "\t")

ls_n3_df = ls_n3_df %>% dplyr::mutate(permutation_type = "n3")

ls_dn231_df = read.csv("/home/cidr/Downloads/softwares/CodonShuffle-master/NC_045512.2_26245_26472_Severe_acute_respiratory_syndrome_coronavirus_2_isolate_Wuhan_Hu_1__complete_genome_dn231_least_square.txt", sep = "\t",stringsAsFactors = FALSE)

ls_dn231_df = ls_dn231_df %>% dplyr::mutate(permutation_type = "dn231")

ls_dn23_df = read.csv("/home/cidr/Downloads/softwares/CodonShuffle-master/NC_045512.2_26245_26472_Severe_acute_respiratory_syndrome_coronavirus_2_isolate_Wuhan_Hu_1__complete_genome_dn23_least_square.txt", sep = "\t", stringsAsFactors = FALSE)

ls_dn23_df = ls_dn23_df %>% dplyr::mutate(permutation_type = "dn23")

ls_dn31_df = read.csv("/home/cidr/Downloads/softwares/CodonShuffle-master/NC_045512.2_26245_26472_Severe_acute_respiratory_syndrome_coronavirus_2_isolate_Wuhan_Hu_1__complete_genome_dn31_least_square.txt", sep = "\t", stringsAsFactors = FALSE)

ls_dn31_df = ls_dn31_df %>% dplyr::mutate(permutation_type = "dn31")
combined_ls_df = rbind(ls_n3_df[,c("distance","permutation_type")],ls_dn23_df[,c("distance", "permutation_type")], ls_dn231_df[,c("distance", "permutation_type")], ls_dn31_df[,c("distance","permutation_type")])

ggplot(combined_ls_df, aes(x = distance, color = permutation_type))+geom_density()

combined_ls_df %>% dplyr::filter(distance<1.5)

