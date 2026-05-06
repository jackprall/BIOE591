# This script was write for BIOE591 Lab 9
# By Jack Pralll

# library fun
#install.packages("related", repos = "https://R-Forge.R-project.org")
#install.packages("adegenet")
#install.packages("vcfR")
#install.packages("pegas")
#install.packages("ggplot2")
library(related)
library(adegenet)
library(vcfR)
library(pegas)
library(tidyr)
library(reshape2)
library(ggplot2)

# Read in the vcf
vcf <- read.vcfR(file = "data/Addax_MaxMissing10.recode.vcf", verbose = TRUE)

# change to aa genind object
genind_obj <- vcfR2genind(vcf)

# visualize the new object
head(genind_obj@tab)
summary(genind_obj@loc.n.all)

# calculate observed and expected heterozygosity
af_summary <- adegenet::summary(genind_obj)
h_o <- af_summary$Hobs
H_e <- af_summary$Hexp

# visualize these two and create a dataframe for each locus
head(h_o)
head(H_e)
het_df <- data.frame(locus = names(h_o), h_o = h_o, h_e = H_e)
head(het_df)

# calculate Fis values
Fis_per_locus <- 1 - (h_o / H_e)
mean(Fis_per_locus, na.rm = TRUE)
# returned -0.04107379

# calculate a chi^2 test for HWE
loci_obj <- genind2loci(genind_obj)
hwe_results <- pegas::hw.test(loci_obj, B = 100)
hwe_results1 <- as.data.frame(hwe_results)

# filter deviations from HWE by p-value
hwe_results %>% as_tibble() %>% filter(Pr.exact<0.05)

# back to kinship
# get the filtered genotypes
gt_filtered <- extract.gt(vcf, element = "GT")

# this whole block
# sample ids
sample_ids <- colnames(gt_filtered)

gt_to_alleles <- function(gt_vector) {
  # split "0/1" or "0|1" into two integer alleles, returning a 2-column matrix (samples x 2 alleles)
  allele1 <- integer(length(gt_vector))
  allele2 <- integer(length(gt_vector))
  
  for (i in seq_along(gt_vector)) {
    g <- gt_vector[i]
    if (is.na(g) || g %in% c("./.", ".", "./", "/.")) {
      allele1[i] <- 0
      allele2[i] <- 0
    } else {
      parts <- as.integer(strsplit(g, "[/|]")[[1]])
      allele1[i] <- parts[1] + 1L    # shift: 0->1 (ref), 1->2 (alt)
      allele2[i] <- parts[2] + 1L
    }
  }
  cbind(allele1, allele2)
}

allele_list <- vector("list", nrow(gt_filtered))

for (v in seq_len(nrow(gt_filtered))) {
  allele_list[[v]] <- gt_to_alleles(gt_filtered[v, ])
}

# combine: each element is (n_samples x 2); bind column-wise
allele_matrix <- do.call(cbind, allele_list)

# add individual IDs as the first column
coancestry_input <- data.frame(IndID = sample_ids, allele_matrix,
                               stringsAsFactors = FALSE)

# column names: IndID, L1_a, L1_b, L2_a, L2_b, ...
locus_names <- paste0(rep(paste0("L", seq_len(nrow(gt_filtered))),
                          each = 2),
                      rep(c("_a", "_b"), nrow(gt_filtered)))
colnames(coancestry_input) <- c("IndID", locus_names)


## Back to the stuff I typed out. Time to run coancestry
kin_results <- coancestry(
  genotype.data = coancestry_input,
  wang = 1,
  dyadml = 1,
  quellergt = 1
)



### Comparing values
library(stats)
# read in the ngs results
ngs_results <- read.delim("results/Addax10.ngsrelate.out")

# Gather the summary stats 
quantile(abs(ngs_results$KING))
# 0%         25%        50%        75%        100% 
# 0.00005500 0.03611125 0.05907900 0.08829675 0.28092100 
mean(abs(ngs_results$KING))
# 0.06746959

quantile(abs(kin_results$relatedness$wang))
# 0%       25%      50%      75%      100% 
# 0.000100 0.020525 0.046950 0.085100 0.510100 
mean(abs(kin_results$relatedness$wang))
# 0.06834093

### Report
# Here we see comparable means and medians (50th quantile) between the two methods.
# However, the ranges prove to be rather different, with the upper bound twice as large for ngs than for "related".
# The lower bound for ngs is an order of magnitude lower than for "related".
# The means and medians suggest a roughly 1/16th relatedness (great-great grandparent, or cousin's child).

