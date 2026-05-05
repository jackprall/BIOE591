# This script was written for Lab 13 of BIOE 591
# By Jack Prall

# get the packages
library(ape)
library(readr)

# read in the tree
tree <- read.tree("lemurs.snps.min4.phy.contree")

# read in the metadata
meta <- read_tsv("lemur_metadata.txt")

# map species to each sample
map <- setNames(meta$species, meta$ID_long)

# overwrite the tip labels
tree$tip.label <- unname(map[tree$tip.label])
plot(tree)

# root using an outgroup
tree_rooted <- root(tree, outgroup = "murinus", resolve.root = TRUE)

plot(tree_rooted)

# add node labels
bs <- as.numeric(tree$node.label)
nodelabels(ifelse(bs >= 70, bs, ""), cex = 0.7, frame = "n")

# export the plot
png("lemur_tree.png", width = 1000, height = 800)
plot(tree_rooted)
nodelabels(tree$node.label, cex = 0.7, frame = "n")
dev.off()

# # Write up sentences
# Interestingly enough, this analysis only supports have of the conclusions from Poelstra et al, 2021.
# We have strong node support for a clade of msp3 and macarthurii as two separate species, as found by Poelstra.
# However, our analysis refutes the lumping of mittermeieri and lehilahytsara.
# While those two are supported as sister taxa, our analysis shows no overlap between the two species.
# Additionally, strong node support suggests that we are seeing two different populations.
# More research is required to know if this is due to vicariance or true speciation.