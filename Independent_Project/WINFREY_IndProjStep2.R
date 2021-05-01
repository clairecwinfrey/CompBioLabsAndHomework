# Script for Independent Project, Part 2
# Claire Winfrey
# April 29, 2021

#########################################################
# 1) SET UP
#########################################################
rm(list = ls())

#setwd("~/Desktop/UTK_Research/Dryad_files")

library(phyloseq) # Phyloseq package makes it easier to manipulate the data files, 
# because it allows the combination of the metadata file, the taxonomy file,
# the ASV table, and the phylogenetic tree into a single, manipulative collection of
# objects.
library(ape)
library(indicspecies)
library(vegan)

# Read in and check files:
#########################
# ASV table:
ASV_table_all <- read.csv(file="ASV_table_names.csv", sep=",", row.names=1) #read in ASV table
ASV_table_all <- as.matrix(ASV_table_all)
head(ASV_table_all)
dim(ASV_table_all)
colnames(ASV_table_all)

# Metadata:
metadata_all <- read.csv("metadata_total_pub.csv", row.names=1)
head(metadata_all)
rownames(metadata_all)
dim(metadata_all)

# Taxonomy:
taxonomy_all <- read.csv("taxonomy_only.csv", sep=",", row.names=1)
taxonomy_all <- as.matrix(taxonomy_all)
head(taxonomy_all)

# Tree:
require("ape")
phylo_tree <- read.tree(file="tree.nwk")
class(phylo_tree) #class is phylo, so this will be fine to add to phyloseq as is

#########################################################
# 2. CLEAN DATA AND MAKE PHYLOSEQ OBJECTS
#########################################################
# Because I realized that I sent you slightly old files, I actually
# had quite a bit of cleaning to do which let me practice many of 
# the techniques we learned in class! In this section, most of the code
# except for the part following the psotu2veg function (line 158) is new!

# The original code that I used in my preprint is here:
# https://github.com/clairecwinfrey/PhanBioMS_scripts/blob/master/QIIME2_scripts/q2_to_PS2.R
# https://github.com/clairecwinfrey/PhanBioMS_scripts/blob/master/R_scripts/analysis/PS_Rarefying_DIssim.R

# Make sure that the sample names are the same order for the ASV and the
# metadata files. This is necessary to make the phyloseq object below work.
colnames(ASV_table_all) == rownames(metadata_all) #they are not all the same
false_index <- which((colnames(ASV_table_all) == rownames(metadata_all))==F)
colnames(ASV_table_all)[false_index]
rownames(metadata_all)[false_index]
# After looking at this, I suspect that the names really are the same, but 
# that they are just out of order.
sort(colnames(ASV_table_all)) == sort(rownames(metadata_all)) #This shows that it
# is not just a matter of order, but at least one value is different and is throwing
# off the order of the first 47 samples

# Which sample names are not shared?
ASVcols <- colnames(ASV_table_all) #extract column names from ASV table
meta_rows <- rownames(metadata_all) #extract rownames from metadata 
index1 <- which((ASVcols %in% meta_rows) ==F) #shows that the values in slot 25 and 41 of ASVcols 
# differ from those values in meta_rows
index2 <- which((meta_rows %in% ASVcols) ==F) #and these values correspond to slots 37 and 53 in metarows
ASVcols[index1] #"BUTX.S.3.2"  "BATX.PV.290"
meta_rows[index2] #"B2R.S.3.2"   "BATX.PD.290"

# Checking which values are not shared another way, because I am still getting comfortable with %in%!
require("base") #I think that there is also a setdiff() function in dplyr.
setdiff(ASVcols, meta_rows) #returns values that are in ASV cols, but not in meta_rows
#"BUTX.S.3.2"  "BATX.PV.290"
setdiff(meta_rows, ASVcols) #returns values that are in meta_rows, but not in ASVcols
#"B2R.S.3.2"   "BATX.PD.290"

# Fixing column names:
# In the ASV columns, BATX.PV.290 should be BATX.PD.290 (as it is in meta_rows)
index3 <- which(ASVcols == "BATX.PV.290") #pull out slot where the incorrect name is
colnames(ASV_table_all)[index3] <- "BATX.PD.290"
colnames(ASV_table_all)[index3] #"BATX.PD.290" as expected

# In the meta_rows, B2R.S.3.2 should be BUTX.S.3.2 (as it is in ASVcols)
index4 <- which(meta_rows == "B2R.S.3.2") #pull out slot where the incorrect name is
rownames(metadata_all)[index4] <- "BUTX.S.3.2"
rownames(metadata_all)[index4] #"BUTX.S.3.2"

# Finally, make sure that the rows and column names are now the same:
colnames(ASV_table_all) == rownames(metadata_all) #no
sort(colnames(ASV_table_all)) == sort(rownames(metadata_all)) # all are true,
# The two lines above mean that the sample names are the same, they are just 
# out of order. This doesn't represent a problem for making a phyloseq object

# Make the objects above phyloseq objects:
# Note that the tree was already impoorted as a phyloseq-compatible object
ASV_physeq_all <- otu_table(ASV_table_all, taxa_are_rows=TRUE)
class(ASV_physeq_all) #is a phyloseq object
taxonomy_all <- tax_table(taxonomy_all)
class(taxonomy_all)
metadata_physeq_all <- sample_data(metadata_all)
class(metadata_physeq_all)

# Check to make sure that all are the taxon ID 
taxa_names(ASV_physeq_all)
taxa_names(taxonomy_all)
taxa_names(phylo_tree)

# Merge into one phyloseq object:
physeq_all <- phyloseq(ASV_physeq_all, taxonomy_all, metadata_physeq_all, phylo_tree)
dim(otu_table(physeq_all)) #288 samples
physeq_all #looks as expected

# Now, create a subset phyloseq object for just the samples needed for the analyses,
# i.e. only gut samples, not soil samples or control samples.

# First, I learned regular expressions so that I don't have to hand type out all of the 
# sample names to keep! All of the gut microbiome samples, and only these samples,
# contain either "PV" or "PD" in their names, which stand for Phanaeus vindex and
# P. difformis.
guts_names <- meta_rows[grep(".*PV|PD.*",meta_rows)]
guts_names

# Now, use this above to make a subset phyloseq object:
guts_ps <- prune_samples(guts_names, physeq_all)
sample_data(guts_ps) #looks as expected!

# Drop samples with less than 3507 reads (a number for rarefying that
# I came up with using rarefaction curves upstream):
otu_table(guts_ps) #pulls out the OTU/ASV table from the phyloseq object
thresh <- 3507 #threshold

rare_index <- which(colSums(otu_table(guts_ps)) >= thresh)
sampsToKeep <- colnames(otu_table(guts_ps))[rare_index]
length(sampsToKeep) #199 samples, matches what I originally did
sampsToKeep

# Use prune_samples function in phyloseq to only keep samples that have
# number of reads above the threshold of 3,507
guts_psTrimmed <- prune_samples(sampsToKeep, guts_ps)
guts_psTrimmed

# Get rid of ASVs that are not present in any gut samples (i.e. those that are
# only in soils and controls which we filtered out of dataset):
# Since I currently have 23,641 taxa, doing this should speed up calculations.
# Extra taxa in tree should be dropped automatically.

# First, get ASV table out of phyloseq:
# A very handy little function from:
# https://jacobrprice.github.io/2017/08/26/phyloseq-to-vegan-and-back.html
psotu2veg <- function(physeq) {
  OTU <- otu_table(physeq)
  if (taxa_are_rows(OTU)) {
    OTU <- t(OTU) #invert columns and rows
  }
  return(as(OTU, "matrix"))
}

ASVnotPS <- psotu2veg(guts_psTrimmed)
str(ASVnotPS) #now sample names are rows and ASVs are columns
ASVnotPSnoZeros <- ASVnotPS[, colSums(ASVnotPS !=0) > 0]
str(ASVnotPSnoZeros) #looks as expected with 199 rows and 1358 columns

# Another way of doing this to check:
ASVnotPSnoZeros2 <- ASVnotPS[,which(!apply(ASVnotPS, 2, FUN = function(x) {all(x == 0)}))]
str(ASVnotPSnoZeros2)
all(ASVnotPSnoZeros == ASVnotPSnoZeros2) #these are the same.

# Finally, re-create phyloseq objects using the ASV table that only has taxa 
# present in the beetle guts:
ASVnotPSnoZeros.tp <- t(ASVnotPSnoZeros) #make taxa=rows again
ASV_guts <- otu_table(ASVnotPSnoZeros.tp, taxa_are_rows=TRUE) #make a phyloseq object
str(ASV_guts)
taxa_names(ASV_guts) #good, ASV names are represented as the taxon ID
guts_ps_cleaned <- phyloseq(ASV_guts, taxonomy_all, metadata_physeq_all, phylo_tree)
guts_ps_cleaned #looks good. taxonomy object, metadata, and tree have been filtered
# automatically according to the samples in ASV guts


#########################################################
# 3. INDICATOR SPECIES ANALYSIS
#########################################################
# The purpose of this section is to run indicator analyses
# to find ASVs that are associated with different groupings
# of individual beetles. These groups include: P. vindex in allopatry,
# P. vindex in sympatry, P. difformis in allopatry, and P. difformis in
# sympatry. In addition, this section will run indicator analyses to
# find gut ASVs that are correlated with beetles collected in areas
# with high amounts of cattle (3), medium amounts of cattle (2), 
# low amounts of cattle (1), and combinations of 
# these cattle abundance groupings.

# The new code here is the function that I made, indSpecTable,
# which I explain more below.

# My original code used in the pre-print is here: 
# https://github.com/clairecwinfrey/PhanBioMS_scripts/blob/master/R_scripts/analysis/indicator_sp_analysis.R

# Remove remove phyloseq attributes from the cleaned ASV table, 
# so that we can more easily manipulate it.
gutASVsCleaned <- psotu2veg(guts_ps_cleaned)
str(gutASVsCleaned) # beetles are rows and ASVs are columns! 
head(gutASVsCleaned)
rownames(gutASVsCleaned)

# Remove phyloseq attributes from taxonomy file that was trimmed down automatically by phyloseq function:
gutTaxCleaned <- as.data.frame(phyloseq::tax_table(guts_ps_cleaned), stringsAsFactors = F)
head(gutTaxCleaned)
str(gutTaxCleaned)

# New function: indSpecTable 
####################################################
# indSpecTable take the output of the indicator species analysis,
# the taxonomy table for the samples, and the ASV table for the 
# samples. It returns a dataframe that has:
# has the ASV TaxonID,
# the taxonomic name of the ASV, the biserial correlation coefficient
# ("stat"), the p-value for the indicator ASV, and the
# group of samples that the ASV is an indicator for, and the relative
# abundance of each indicator ASV in each group of samples!

indSpecTable <- function(myMultipatt, taxTable, ASVtable, signLevel=0.05) { 
  #arguments are: 
  # 1) myMultipatt: an object produced by multipatt function;
  # 2) taxTable: a taxonomy table that has the taxonIDs as row names and #
  # 7 columns for taxonomic levels (Kingdom, Phylum, Class...Species);
  # 3) signLevel: significance level for p-value cut-off
  # 4)JUST ADDED FOR REL ABUNDANCE: ASVtable: ASV table where samples/sites
  # are rows and TaxonIDs are columns (this will be inverted in script)
  require(indicspecies)
  groups <- unique(myMultipatt$cluster) #gets groups from myMultipatt
  # The lines below pull out only the indicator ASVs that have a
  # p-value less than or equal to the significance level specified in the 
  # function call. Indicator ASVs are represented by TaxonID
  ASVstoKeep <- rownames(myMultipatt$sign)[which(myMultipatt$sign$p.value <= signLevel)]
  ### replace ASVdfs with ASVsToKeep
  ASVtable_t <- t(ASVtable) #make rows TaxonID 
  ASVtableIndex <- which(rownames(ASVtable_t) %in% ASVstoKeep)
  ASV_sigs <- ASVtable_t[ASVtableIndex,] #new ASV table only has significant ASVs
  # Below makes it so that individual samples are labeled according to clustering group
  colnames(ASV_sigs) <- myMultipatt$cluster
  # Combine by clustering groups
  combByCluster <- t(rowsum(t(ASV_sigs), group=colnames(ASV_sigs), na.rm =T)) 
  # Below, pre-allocate a dataframe that we'll fill in with the relative abundances
  # of each ASV in each group
  relAbundDf <- data.frame(matrix(nrow=nrow(combByCluster), ncol=(length(groups)))) 
  # The for loop below makes column names for relAbundDf based on names of groups used for clustering
  relAbundCol <- rep(NA,length(groups)) #pre-allocate vector to hold relative abundance columns
  for (i in 1:length(groups)){ #make column names for the relative abundance of each group in analysis
    relAbundCol[i] <- paste("relAbund in", colnames(combByCluster)[i])
  }
  colnames(relAbundDf) <- relAbundCol
  totalCounts <- colSums(combByCluster) #get total ASV counts in each clustering group
  # For loop calculates the relative abundance of each significant ASV in each grouping:
  for(j in 1:nrow(combByCluster)){  #loop over all the significant ASVs
    relAbundDf[j,] <- (combByCluster[j,]/totalCounts)*100
  }
  rownames(relAbundDf) <- rownames(combByCluster) #make row names TaxonID
  # Merge taxonomy table and relAbundDF by rows that they share
  mergedDf_1 <- merge(taxTable, relAbundDf, by=0)
  rownames(mergedDf_1) <- mergedDf_1[,1] #make the column "row.names" the actual rownames again
  mergedDf_1[,1] <- NULL #remove "row.names" column
  # Get the last 3 rows of myMultipatt$sign
  accessSign <- myMultipatt$sign[,c((ncol(myMultipatt$sign)),(ncol(myMultipatt$sign) -1),(ncol(myMultipatt$sign) -2))]
  # Merge mergedDf_1 with accessSign to add index, stat, and p-value
  mergedDf_2 <- merge(mergedDf_1,accessSign, by=0)
  results <- mergedDf_2[with(mergedDf_2, order(index)),]
  rownames(results) <- results[,1] #make row names taxon ID
  results[,1] <- NULL #remove "row.names" column
  #The following lines before the return change the index name to reflect the group
  # that the indicator analysis is for.
  alphabet <- sort(unique(myMultipatt$cluster), decreasing = FALSE)
  results$index[1:length(alphabet)] <- alphabet
  index1 <- which(results$index==1)
  results$index[index1] <- alphabet[1]
  index2 <- which(results$index==2)
  results$index[index2] <- alphabet[2]
  index3 <- which(results$index==3)
  results$index[index3] <- alphabet[3]
  index4 <- which(results$index==4)
  results$index[index4] <- alphabet[4]
  return(results)
}


# Allopatry and Sympatry Indicator Species Analyses
####################################################

# First, make a vector that lists each beetle by species.
# Pull out the Range overlap and species data from the phyloseq metadata file:
SpeciesRange <- sample_data(guts_ps_cleaned)$Range.Overlap.Spec
str(SpeciesRange)
unique(SpeciesRange) #no typos, have the four categories expected.

# Perform indicator species analysis:
set.seed(9)
IndicByRange <- multipatt(x=gutASVsCleaned, cluster=SpeciesRange, func="r.g", control=how(nperm = 999), duleg = TRUE) 
#changed to 999 reps to make things faster for Comp bio assignment (paper uses version with 99999 reps)
summary(IndicByRange) #shows all of the taxon IDs for ASVs associated with each group, as well as
# the  r.g. value (under stat, this is the correlation index that takes into account the
# variation within and among groups), and the p-value from a permutation test.

# Finally, apply function to the multipatt object created above:
ByRangeISTable <- indSpecTable(myMultipatt=IndicByRange, taxTable= gutTaxCleaned, ASVtable = gutASVsCleaned, signLevel=0.05)
# Below is a more concise nice way to see what the function does: the Family and Genus of ASV,
# the relative abundance of the ASVeach group, and the group that the ASV is an indicator species for
ByRangeISTable[,c(5:6,8:11,14)] 


# Cattle Abundance Indicator Species Analyses
####################################################
CattleAbund <- sample_data(guts_ps_cleaned)$CattlePresenceRank
str(CattleAbund)
unique(CattleAbund) #no typos, have the four categories expected.
is.ordered(CattleAbund) #not an ordinal variable, so fine for the analysis
# Change 1,2, and 3 to low, medium, and high, respectively, so that results are
# easier to interpret
CattleAbund[which(CattleAbund==3)] <- "high"
CattleAbund[which(CattleAbund==2)] <- "medium"
CattleAbund[which(CattleAbund==1)] <- "low"
unique(CattleAbund) #as expected

set.seed(93) #again, nperm below changed from 99999 to 999 to speed up analysis
IndicByCatt <- multipatt(x=gutASVsCleaned, cluster=CattleAbund, func="r.g", control=how(nperm = 999), duleg = TRUE) 
summary(IndicByCatt) 

# Finally, apply function to the multipatt object created above:
ByCattISTable <- indSpecTable(myMultipatt=IndicByCatt, taxTable= gutTaxCleaned, ASVtable = gutASVsCleaned, signLevel=0.05)
# Below is a more concise nice way to see what the function does: the Family and Genus of ASV,
# the relative abundance of the ASVeach group, and the group that the ASV is an indicator species for
ByCattISTable[,c(5:6,8:10,13)] 

#########################################################
# 3. VISUALIZATION
#########################################################

# 1. Split up data by group: 
require(phyloseq)
guts_ps_cleaned #phyloseq object
colnames(sample_data(guts_ps_cleaned)) #"Range.Overlap.Spec" is one of the columns
# Merge samples by "Range.Overlap.Spec"
ByRangeOverlap <- merge_samples(guts_ps_cleaned, group = "Range.Overlap.Spec")
ASVTableTp <- t(otu_table(ByRangeOverlap)) #make TAxonIDs rows and groups columns
unique(ASVTableTp)
colnames(ASVTableTp)

# 2. Get the number of ASVs in each group:
TotalASVsperGroup <- apply(ASVTableTp,2,function(x) sum(x > 0))

# 3. What proportion of total ASVs per group are indicator ASVs?
# Make vector of number of ASVs per group.
# Using summary on the multipatt objecft shows that there are 24 for Allo_difformis,
# 16 for Allo_vindex, 8 for Symp_difformis, and 19 for Symp_vind
summary(IndicByRange) 
IndicPerGroup <- c(24,16,8,19)
# Get proportion of total ASVs that are indicator species
IndicSpecProp <- IndicPerGroup/TotalASVsperGroup 

# 4. Make a data frame that we can use for plot:
plotDat <- data.frame(rbind(IndicPerGroup,TotalASVsperGroup))
colors <- c("purple", "orange")

barplot(as.matrix(plotDat), main="Indicator ASVs versus Total ASVs for Range Overlap Groups", ylab = "ASV counts", 
        ylim=c(0, 800), cex.lab = 1.2, cex.main = 1.3, beside=TRUE, col=colors)
ytick<-seq(0, 800, by=50)
axis(side=2, at=ytick, labels = FALSE)
legend("topright", 
       legend = c("Indicator ASVs", "Total ASVs"), 
       fill = colors, bty = "n")

