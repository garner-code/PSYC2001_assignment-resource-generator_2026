#dataGen
## Data generation for PSYC2001 assigment 2025
## written by K. Garner, 2025
dataGen <- function(zID) {
  #the data is randomised based on the student ID as a seed
  set.seed(zID)
  
  n_grps <- 2
  subN <- 100
  N_mult <- 3 # will run the data generation process and
  # then concatenate this number of times, to get 
  # a datafile of 1000 subjects
  ##### make the continuous regressors
  v1_mu <- 0.5
  v1_sd <- 0.5
  g1_v1 <- rnorm(subN/2, v1_mu, v1_sd) # a basis for group 1
  # scale v1 to be between 0 and 1
  library(scales)
  g1_v1 <- scales::rescale(g1_v1, to=c(0.2,0.9))
  # now make a second group for v1
  g2_mu <- 0.85
  g2_v1 <- rnorm(subN/n_grps, g2_mu, v1_sd)
  g2_v1 <- scales::rescale(g2_v1, to=c(0.25,0.95))
  
  # allocate to group
  group <- rep(c(1,2), times=subN/n_grps)
  v1 <- rep(0, length(group))
  v1[group==1] <- g1_v1
  v1[group==2] <- g2_v1

  # now make a second variable that has a negative correlation
  # with the first
  v2 <- (v1 - 0.05) + rnorm(subN, mean=0, sd=v1_sd*2)
  v2 <- scales::rescale(v2, to=c(0.1,0.9))
  
  total_v1_noise <- rnorm(subN*N_mult, 0, 0.01) # get a tiny bit of noise
  total_v2_noise <- rnorm(subN*N_mult, 0, 0.01)
  v1 <- rep(v1, times=N_mult) + total_v1_noise
  v2 <- rep(v2, times=N_mult) + total_v2_noise
  
  dat <- data.frame(subID = 1:(subN*N_mult),
                    group = group,
                    v1 = round(v1, digits=3),
                    v2 = round(v2, digits=3))
  return(dat)
  #End function
}
