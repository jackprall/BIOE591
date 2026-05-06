# This script was written for BIOE 591 Lab 10 (pop structure)
# By Jack Prall

#####
# This marks the demo section (or the k=2 section)
library(tidyverse)

# read in sample names
fam <- read_table('results/sparrows.int.fam', col_names = F, show_col_types = F)
samples <- fam$X2

# choose a K value (starting with 2 to match the demo)
k <- 2

# read in the q-matrix
q <- read_table("sparrows.int.2.Q", col_names = F, show_col_types = F)

# name the ancestry columns
colnames(q) <- paste0("Cluster", 1:k)

# combine with sample names
q_df <- q %>% mutate(sample = samples) %>% relocate(sample)

# convert to long format for ggplot
q_long <- q_df %>% pivot_longer(
  cols = starts_with("Cluster"),
  names_to = "cluster",
  values_to = "ancestry"
) %>% mutate(sample = factor(sample, levels = samples))

# plot the data
ggplot(q_long, aes(x = sample, y = ancestry, fill = cluster)) +
  geom_col(width = 1, color = "white") +
  theme_bw() +
  labs(x = "Individual", y = "Ancestry Proportion") +
  theme(
    panel.grid = element_blank(),
    axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)
  )

# extract the cross validation results  
cv_df <- tibble(file = "outputs/pop_strucutre-2.out") %>% #file name contains a type, my b
  mutate(text = map_chr(file, read_file),
         cv_line = str_extract(text, "CV error \\(K=\\d+\\):\\s*[-0-9.eE]+"),
         K = str_match(cv_line, "CV error \\(K=(\\d+)\\)")[,2] |> as.integer(),
         CV = str_match(cv_line, ":\\s*([-0-9.eE]+)")[,2] |> as.numeric()
         ) %>% 
  select(file, K, CV) %>% 
  arrange(K)
  
#   k-value CV  
#   2       0.24831

# read in the vcf and new libraries
library(adegenet)
library(vcfR)  
vcf <- read.vcfR(file = "/home/z41f731/bioe-591-genomics/course-materials/data/structure_data/sparrows.vcf", verbose = T)

# get to genind obj
dna <- vcfR2DNAbin(vcf, unphased_as_NA = F, consensus = T, extract.haps = F)
species_genind <- DNAbin2genind(dna)

# deal with the missing data and center genotypes
species_genind_scaled <- scaleGen(species_genind, NA.method = "mean", scale = F)
species_pca <- prcomp(species_genind_scaled, center = F, scale = F)

# plot the pca
screeplot(species_pca)

# sort the pca to better visualize
pc <- data.frame(species_pca$x[,1:3])
pc$sample <- rownames(pc)

# plot the pca
ggplot(data=pc, aes(x=PC1, y=PC2)) +
  geom_text(aes(label = sample))

# do k-means clustering (k=2)
grp <- find.clusters(species_genind, n.pca = 50, n.clust = 2)

# plot this
pc$cluster <- grp$grp
ggplot(pc, aes(x = PC1, y = PC2, color = cluster)) +
  geom_point(size = 2) +
  geom_text(aes(label = sample), vjust = -0.5, size = 3)

# use dapc
dapc2 <- dapc(species_genind, pop = grp$grp, n.pca = 50, n.da = 2)

# take the posterior probabilities out
q1 <- as.data.frame(dapc2$posterior)
q1$sample <- rownames(q1)
q1_long <- q |> pivot_longer(
  cols = -sample,
  names_to = "cluster",
  values_to = "ancestry"
)
 
# plot the dapc results
ggplot(q1_long, aes(x = sample, y = ancestry, fill = cluster)) +
  geom_col(width = 1, color = "white") +
  theme_bw() +
  labs(x = "Individual", y = "Assignment probability") +
  theme(panel.grid = element_blank(),
    axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)
  )

# identify clusters
grp_auto <- find.clusters(species_genind,
                          n.pca = 50,
                          choose.n.clust = F,
                          max.n.clust = 10,
                          stat = "BIC")
grp_auto$Kstat
# K=1      K=2      K=3      K=4      K=5      K=6      K=7      K=8      K=9      K=10 
# 589.0262 588.5963 590.3575 592.5596 594.8737 597.0305 599.5883 602.0799 604.5651 606.7778 

# plot the BIC values by K value
plot(1:length(grp_auto$Kstat),
     grp_auto$Kstat,
     type = "b",
     xlab = "K",
     ylab = "BIC")




#####
# Repeat this for k=3
k <- 3

# read in the q-matrix
q <- read_table("sparrows.int.3.Q", col_names = F, show_col_types = F)

# name the ancestry columns
colnames(q) <- paste0("Cluster", 1:k)

# combine with sample names
q_df <- q %>% mutate(sample = samples) %>% relocate(sample)

# convert to long format for ggplot
q_long <- q_df %>% pivot_longer(
  cols = starts_with("Cluster"),
  names_to = "cluster",
  values_to = "ancestry"
) %>% mutate(sample = factor(sample, levels = samples))

# plot the data
ggplot(q_long, aes(x = sample, y = ancestry, fill = cluster)) +
  geom_col(width = 1, color = "white") +
  theme_bw() +
  labs(x = "Individual", y = "Ancestry Proportion") +
  theme(
    panel.grid = element_blank(),
    axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)
  )

# extract the cross validation results  
cv_df <- tibble(file = "outputs/pop_strucutre-3.out") %>% #file name contains a type, my b
  mutate(text = map_chr(file, read_file),
         cv_line = str_extract(text, "CV error \\(K=\\d+\\):\\s*[-0-9.eE]+"),
         K = str_match(cv_line, "CV error \\(K=(\\d+)\\)")[,2] |> as.integer(),
         CV = str_match(cv_line, ":\\s*([-0-9.eE]+)")[,2] |> as.numeric()
  ) %>% 
  select(file, K, CV) %>% 
  arrange(K)

#   k-value CV  
#   3       0.2582

# do k-means clustering (k=3)
grp <- find.clusters(species_genind, n.pca = 50, n.clust = 3)

# plot this
pc$cluster <- grp$grp
ggplot(pc, aes(x = PC1, y = PC2, color = cluster)) +
  geom_point(size = 2) +
  geom_text(aes(label = sample), vjust = -0.5, size = 3)




#####
# Repeat this for k=4
k <- 4

# read in the q-matrix
q <- read_table("sparrows.int.4.Q", col_names = F, show_col_types = F)

# name the ancestry columns
colnames(q) <- paste0("Cluster", 1:k)

# combine with sample names
q_df <- q %>% mutate(sample = samples) %>% relocate(sample)

# convert to long format for ggplot
q_long <- q_df %>% pivot_longer(
  cols = starts_with("Cluster"),
  names_to = "cluster",
  values_to = "ancestry"
) %>% mutate(sample = factor(sample, levels = samples))

# plot the data
ggplot(q_long, aes(x = sample, y = ancestry, fill = cluster)) +
  geom_col(width = 1, color = "white") +
  theme_bw() +
  labs(x = "Individual", y = "Ancestry Proportion") +
  theme(
    panel.grid = element_blank(),
    axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)
  )

# extract the cross validation results  
cv_df <- tibble(file = "outputs/pop_strucutre-4.out") %>% #file name contains a type, my b
  mutate(text = map_chr(file, read_file),
         cv_line = str_extract(text, "CV error \\(K=\\d+\\):\\s*[-0-9.eE]+"),
         K = str_match(cv_line, "CV error \\(K=(\\d+)\\)")[,2] |> as.integer(),
         CV = str_match(cv_line, ":\\s*([-0-9.eE]+)")[,2] |> as.numeric()
  ) %>% 
  select(file, K, CV) %>% 
  arrange(K)

#   k-value CV  
#   4       0.26584

# do k-means clustering (k=3)
grp <- find.clusters(species_genind, n.pca = 50, n.clust = 4)

# plot this
pc$cluster <- grp$grp
ggplot(pc, aes(x = PC1, y = PC2, color = cluster)) +
  geom_point(size = 2) +
  geom_text(aes(label = sample), vjust = -0.5, size = 3)


#####
# Write up section
# Our analysis matched Smith et al. 2024, suggesting that K=2 is the correct number of populations.
# This can be seen by it having the lowest CV error value, it's the "crook" in DAPC's BIC plot,
# and the PCA plots for k=3 and k=4 show overlap between groups, but not for K=2.
# Additionally, the PCAs match the DAPC, both suggesting K=2 to be the best fitting model.

#   k-value CV_error 
#   2       0.24831
#   3       0.2582
#   4       0.26584
