## How and why do the gut microbiomes of sister species of _Phanaeus_ dung beetles differ across their ranges?
### Claire Winfrey
### Introduction
#### Context and Overall goals  
For my independent project in Computational Biology, my overarching goals were to employ some of the skills that we have learned to make existing analyses more reproducible and transparent. My hope is that doing so will not only make my paper more likely to be accepted for publication in a peer-reviewed journal, but that it will also lead to more robust and reproducible results. 

#### Background
Biogeography has a rich history, evidenced by Charles Darwin's famous insights comparing the species he observed across South America. However, most biogeographical work has focused on macroorganisms. Studies of the biogeography of the microbiome, the unicellular organisms found in and on plants and animals, are limited despite the key role the microbiome may play in species ranges. Specifically, research shows that the microbiome serves diverse functions that may affect organismal fitness and species ranges, such as aiding in digestion, metabolism, and immune system function (e.g. Russell & Moran, 2013), determining the thermal limits of species (e.g. Kukuchi et al., 2016), and even preventing hybridization (Brucker & Bordenstein, 2013). Given the critical role of the microbiome, organisms may be locally adapted through the community of microbes living in and on them. Despite biology's foundation in biogeography and the tight relationship between hosts and their resident microbes, little is known about how the microbiome changes across the geographic range of host species and the factors affecting these changes. My work is aimed at filling these knowledge gaps.

Thus, the motivating questions of my study were: Does the microbiome of animals vary across their ranges, and if so, what abiotic and biotic factors are contributing to these patterns? 

### Methods
#### Goals of the original study and brief description of methodology
The dataset comes from a paper titled "Drivers of interpopulation variation in the gut microbiomes of sister species of *Phanaeus* dung beetles", which is available as a pre-print [here](https://www.biorxiv.org/content/10.1101/2021.02.19.431932v1). To gather these data, I sampled two sister species of dung beetles which have maternally-transmitted gut microbiomes (Estes et al., 2013), *Phanaeus vindex* and *Phanaeus difformis*, from populations across their ranges where they co-occur (are sympatric) and where they are not found together (are allopatric). I then dissected out the whole guts of each beetle, extracted the DNA in each gut, amplified the DNA using universal bacterial/archaeal primers, and then sequenced the amplicon libraries on an Illumina MiSeq. 

I processed raw sequence data with the platform QIIME2 (Bolyen et al. 2019), utilizing various bioinformatic tools available in QIIME2 as detailed in the pre-print. Then, I imported my processed sequence data in R for rarefaction, statistical analysis, and data visualization. For the manuscript analyses, I considered how range overlap (sympatry or allopatry), distances among populations, and a variety of abiotic factors explained the variation in the gut microbial communities that I observed, mainly using a statistical modeling technique called distance-based redundancy analyses. I also conducted indicator species analyses, which allowed me to find which ASVs tended to be found in various groupings of my data (i.e. each beetle species in various types of habitat).

There are four data objects which together constitute the "data". 
1.  **Amplicon sequence variant (ASV) table**. An ASV is roughly analogous to a bacterial or archaeal species, and the ASV table provides the numbers of each bacterial/archaeal "species" that were found in each individual beetle gut.
	* file name: ASV_table_names.csv 
	* format: .csv file
	* size: 14.5 MB 
2. **Taxonomy table**. This file links each identifier represented in the ASV table to that bacterial or archaeal taxon's taxonomic classification. Different taxonomic levels, ranging from kingdom to species, are included as known for that ASV. 
	* file name: taxonomy_only.csv
	* format: .csv file
	* size: 4.4 MB
3. **Metadata file** The metadata provides useful informational about each individual beetle, e.g. its mass, the population that it came from, whether is was *P. vindex* or *P. difformis*, etc. 
	* file name: metadata_total_pub.csv
	* format: .csv file
	* size: 36 KB
4. **Phylogenetic tree** This file provides the phylogenetic relationships between all ASVs in the dataset. 
	* file name: tree.nwk
	* format:  Newick Tree format (.nwk extension)
	* size: 16.8 GB

Each of these files was mostly pre-cleaned in QIIME2. However, I realized when I started to code my project that there were in fact were 2 small labeling errors in the ASV table file and the metadata file. On the bright side, I got to take advantage of some of the tools we learned in class to fix these mistakes and this serves as a double check before I publish!

#### My methods for this project
I completed this project in three major parts, as shown in the [script](https://github.com/clairecwinfrey/CompBioLabsAndHomework/blob/master/Independent_Project/WINFREY_IndProjStep2.R):

1. **Cleaning and organize the data**
Each of these files was mostly pre-cleaned in QIIME2. However, I realized when I started to code my project that there were in fact were 2 small labeling errors in the ASV table file and the metadata file. On the bright side, I got to take advantage of some of the tools we learned in class to fix these mistakes and this serves as a double check before I publish!
* To clean the data, I made use of the following tools:
	* the package phyloseq (McMurdie and Holmes, 2013)
	* logical and numerical indexing, using the function `which()`
	* regular expressions, with `grep()`
	* various helpful functions like accessor functions and `str()`, `dim()`, `head()`, etc.
2. **Indicator species analyses and new function** As in my original manuscript, I performed indicator species analyses, using a package called "indicspecies" and a function called `multipatt()`(Cáceres & Legendre, 2009). This analysis takes the ASV table (as described above) and estimates group-equalized, point-biserial correlation coefficients between each ASV and different groupings of individual beetles, ultimately providing ASVs that are indicative of a certain category of beetle. In my original analyses, I looked at ASVs that were associated with beetles found in habitats with varying amounts of cattle, as well as ASVs that were associated with *P. vindex* and *P. difformis* in sympatry or in allopatry. While the function worked as expected, it only provided the ASV identifiers for ASVs associated with each grouping. These identifiers do not give the taxonomic information, which is the biologically-relevant information. In addition, `multipatt()` does not provide any idea of how abundant the identified indicator species are in the dataset.
* As a new approach, I created a new function, `indSpecTable()` that takes the ASV table, the taxonomy table, a user-set alpha level, and the object created by `multipatt()` as the input. Through a series of for loops, logical and numerical indexing, and merges of mulitple dataframes, `indSpecTable()` returns a data frame that has, for each ASV:
	* the original TaxonID
	* the taxonomic information
	* the relative abundance of the ASV in each group considered in the indicator species analysis
	* the group-equalized, point-biserial correlation coefficient
	* the p-value
	* the group for which the ASV was identified as an indicator species.
* `indSpecTable()` is flexible, and can accept any number of groups and ASVs (within the limits of R's memory) that the user desires! This was definitely the hardest thing that I have ever coded, but after many, many hours fiddling with it, I'm very happy with how it turned out! 
3. **Visualization**
Finally, I created a barplot using some of the handy functions in `phyloseq` and R's base functions to create a barchart showing some of the results of my function. My original goal was to make a stacked barchart using `ggplot2`, where the x-axis would have the names of each group used in the indicator species analysis and `indSpecTable`, the height of the bar would reflect the number of indicator ASVs found, and each bar would be color coded to show the different phyla represented in the ASVs. Alas, although I spent several hours trying this was too challenging to do with the time that I had left after creating the function.

### Results & Conclusions
While my main questions about how and why the gut microbiome of *Phanaeus* dung beetles were addressed in the analyses that I used in my pre-print, the additions described above will make my code more reproducible. Furthermore, the function that I create could be useful for future researchers conducting indicator species analyses, such as folks in my lab. From this exercise, I also became far more comfortable with writing complicated, multi-part functions, and I learned how to "reverse engineer" the results that I want into code much more effectively.

The plot below provides an idea of the proportion of the total ASVs in a given group that are represented by indicator species. Here, I provide the plot for the indicator versus total ASV counts for the data separated into *P. difformis* from allopatric populations, *P. vindex* from allopatric populations, *P. difformis* from sympatric populations, and *P. vindex* from sympatric populations. The plot shows that sympatric *P. difformis* beetles had the highest ASV richness, but also, interestingly, the fewest identified indicator species and the smallest proportion of indicator species. Sympatric groupings of *P. vindex* and *P. difformis* had the most overall ASVs. Overall, the indicator species were a small proportion of each groups' overall ASV richness. This reinforces that there is a high degree of overlap in the gut microbiomes of each group, but also provides some candidate taxa that future researchers could investigate if trying to pinpoint specific ASVs that may allow these beetles to be better adapted to local conditions.
![results plot](https://github.com/clairecwinfrey/CompBioLabsAndHomework/blob/master/Independent_Project/IndicatorVsTotalASVs_plot.png)


### References
Bolyen, E., Rideout, J. R., Dillon, M. R., Bokulich, N. A., Abnet, C. C., Al-Ghalith, G. A., ... & Caporaso, J. G. (2019). Reproducible, interactive, scalable and extensible microbiome data science using QIIME 2. _Nature biotechnology_, _37_(8), 852-857. [https://doi.org/10.1038/s41587-019-0209-9](https://doi.org/10.1038/s41587-019-0209-9)

Brucker, R. M., & Bordenstein, S. R. (2013). The hologenomic basis of speciation: gut bacteria cause hybrid lethality in the genus Nasonia. _Science_, _341_(6146), 667-669. https://doi.org/10.1126/science.1240659

Cáceres, M. D., & Legendre, P. (2009). Associations between species and groups of sites: indices and statistical inference. _Ecology_, _90_(12), 3566-3574. [https://doi.org/10.1890/08-1823.1](https://doi.org/10.1890/08-1823.1)

Engel, P., & Moran, N. A. (2013). The gut microbiota of insects–diversity in structure and function. _FEMS microbiology reviews_, _37_(5), 699-735.
[https://doi.org/10.1111/1574-6976.12025](https://doi.org/10.1111/1574-6976.12025)

Estes, A. M., Hearn, D. J., Snell-Rood, E. C., Feindler, M., Feeser, K., Abebe, T., ... & Moczek, A. P. (2013). Brood ball-mediated transmission of microbiome members in the dung beetle, Onthophagus taurus (Coleoptera: Scarabaeidae). _PLoS One_, _8_(11), e79061. https://10.1371/journal.pone.0079061

Kikuchi, Y., Tada, A., Musolin, D. L., Hari, N., Hosokawa, T., Fujisaki, K., & Fukatsu, T. (2016). Collapse of insect gut symbiosis under simulated climate change. _MBio_, _7_(5). [https://doi.org/10.1128/mBio.01578-16]

McMurdie and Holmes (2013) phyloseq:  [An R Package for Reproducible Interactive Analysis and Graphics of Microbiome Census Data](http://dx.plos.org/10.1371/journal.pone.0061217). PLoS ONE. 8(4):e61217

Winfrey, C.C. & Sheldon, K.S. (2021). Drivers of interpopulation variation in the gut microbiomes of sister species of *Phanaeus* dung beetles. *bioRxiv*. https://doi.org/10.1101/2021.02.19.431932

Winfrey, C.C. & Sheldon, K.S. (2021) Data from: Drivers of interpopulation variation in the gut microbiomes of sister species of *Phanaeus* dung beetles. NCBI GenBank, BioProject ID: [PRJNA706782](https://www.ncbi.nlm.nih.gov/bioproject/?term=PRJNA706782)
