
rm(list=ls(all=TRUE))
cat("\f") 

library(nloptr)

set.seed(0)

#setwd("~/ADULT_sexism")

#adult_dat <- read.csv("adult_processed.csv", sep = ",")
no_intervention <- read.csv('no_intervention.csv', sep = ',')
intervention <- read.csv('intervantion.csv', sep = ',')


k = 8500
r = floor(0.75*k)

idx_1 = sample(1:nrow(no_intervention), k)
train = no_intervention[idx_1, ]

idx_2 = sample(1:k, r)
dat = train[idx_2, ]
cv_dat = train[-idx_2, ]
test_dat = no_intervention[-idx_1, ]

source("fit_models.R")
source("compute_pse.R")
source("constrained_mle.R")
source("evaluate_performance.R")

l_u = 1.05
l_l = 0.95
tau_u = min(l_u, 1/l_l)
tau_l = max(l_l, 1/l_u)

# M vs A and C
#x_M = dat[, c(2, 8:10)] # use A and all C's
#y_M = "married"
#fmla_M = as.formula(paste(paste(y_M, "~ "), paste(colnames(x_M), collapse="+")))

# L vs A, M, and C
#x_L = dat[, c(2, 3, 8:10)] # use A, M, and all C's
#y_L = "higher_edu"
#fmla_L = as.formula(paste(paste(y_L, "~ "), paste(colnames(x_L), collapse="+")))


# D vs A and Q
x_D = dat[, c(1, 4)] # use A and all Q's
y_D = "D"
fmla_D = as.formula(paste(paste(y_D, "~ "), paste(colnames(x_D), collapse="+")))

# M1 vs Q, A, and D
x_M = dat[, c(1:2, 4)] # use A, Q, and all D's
y_M = "M"
fmla_M = as.formula(paste(paste(y_M, "~ "), paste(colnames(x_M), collapse="+")))


# M2 vs Q, A, and D
#x_M2 = dat[, c(1:2, 4)] # use A, Q, and all D's
#y_M2 = "higher_edu"
#fmla_M2 = as.formula(paste(paste(y_M2, "~ "), paste(colnames(x_M2), collapse="+")))


# M1 vs Q, A, and A
#x_M3 = dat[, c(1:2, 4)] # use A, Q, and all D's
#y_M3 = "higher_edu"
#fmla_M3 = as.formula(paste(paste(y_M3, "~ "), paste(colnames(x_M3), collapse="+")))


# R1 vs A, M, L, and C
#x_R1 = dat[, c(2:4, 8:10)] # use A, M, L, and all C's
#y_R1 = "managerial_occ"
#fmla_R1 = as.formula(paste(paste(y_R1, "~ "), paste(colnames(x_R1), collapse="+")))

# R2 vs A, M, L, and C
#x_R2 = dat[, c(2:4, 8:10)] # use A, M, L, and all C's
#y_R2 = "high_hours"
#fmla_R2 = as.formula(paste(paste(y_R2, "~ "), paste(colnames(x_R2), collapse="+")))

# R3 vs A, M, L, and C
#x_R3 = dat[, c(2:4, 8:10)] # use A, M, L, and all C's
#y_R3 = "gov_jobs"
#fmla_R3 = as.formula(paste(paste(y_R3, "~ "), paste(colnames(x_R3), collapse="+")))

# Y vs A, M, D, Q
x_Y = dat[, 1:4] # A, M, L, R1, R2, R3, and all C's
y_Y = "Y"
fmla_Y = as.formula(paste(paste(y_Y, "~ "), paste(colnames(x_Y), collapse="+")))


# fitting +++++++++++++++++++++++
# unconstrained GLM and LM

#beta_lm = fit_models(dat,fmla_D,fmla_M,fmla_R1,fmla_R2,fmla_R3,fmla_Y)
beta_lm = fit_models(dat,fmla_D,fmla_M,fmla_Y)

# constrianed optimization
beta_opt = constrained_mle(dat,fmla_D,fmla_M,fmla_Y,func=compute_pse,tau_u,tau_l)


# compute pse +++++++++++++++++++++++
(pse_lm = compute_pse(beta_lm$beta_D, beta_lm$beta_M,beta_lm$beta_Y))

(pse_opt = compute_pse(beta_opt$beta_D, beta_opt$beta_M, beta_opt$beta_Y))


# cross-validate (delta) +++++++++++++++++++++++
delta_vec = seq(0, 1, by=0.1)
delta_lm = find_delta(cv_dat, beta_lm$beta_Y, delta_vec)
delta_opt = find_delta(cv_dat, beta_opt$beta_Y, delta_vec)
delta_lm = 0.5
delta_opt = 0.5

ndraws = 100

# Evaluations +++++++++++++++++++++++
x = data.frame("intercept" = 1, test_dat[, 1:4])
x_rm = x[, 2:4]
y = test_dat[, 5]

# regular fit
perf_lm = contingency_table(x, y, beta_lm$beta_Y, delta_lm, ndraws, type="no-constrain")
compute_accuracy(perf_lm)

# constrianed fit
perf_opt = contingency_table(x, y, beta_opt, delta_opt, ndraws, type="constrained")
compute_accuracy(perf_opt)



