### Explanation of WINFREY_Lab8.R
#### Overview and Purpose of Script:  
[WINFREY_Lab8.R](https://github.com/clairecwinfrey/CompBioLabsAndHomework/blob/master/Lab08/WINFREY_Lab8.R) contains code for two functions that calculate the population sizes of a given species over a given number of generations.  The instructions for the assignment are found [here](https://github.com/flaxmans/CompBio_on_git/blob/main/Labs/Lab08/Lab08_documentation_and_metadata.md).

Specifically, the functions employ the discrete-time logistic growth equation (shown below), where `n` is population size, `t` is the time (e.g. generation or year), `r` is the intrinsic growth rate of the population, and `K` is the carrying capacity of the population.
  * `n[t] <- n[t-1] + ( r * n[t-1] * (K - n[t-1])/K )` 

#### Function definitions
Both functions require 4 arguments:
1. `r`, the intrinsic growth rate of population
2. `K`, the population carrying capacity
3. `gens`, the total number of generations (including the initial pop size)
4. `init_pop`, the initial size of the population

* The first of the two functions, `log_growth()`, simply takes the arguments above and returns a vector of the population size (i.e. species abundance) of length `gens`.
* The second function, `log_growth_plot()` returns a matrix of two columns, where the first column is the generation number (of length `gens`, and the second column is the abundance at that generation. The function also plots this matrix.
  * Here is the plot generated in the example for `log_growth_plot()`, from the script:
 ![example plot](https://github.com/clairecwinfrey/CompBioLabsAndHomework/blob/master/Lab08/Results_3_example_plot.png)
