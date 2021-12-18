

fit_logistic <- function(dat, fmla){
  beta = glm(fmla, dat, family = "binomial")$coefficients
  return(beta)
}

fit_regression <- function(dat, fmla){
  beta = lm(fmla, dat)$coefficients
  return(beta)
}

fit_models <- function(dat,fmla_D, fmla_M,fmla_Y){
  beta_M = fit_regression(dat, fmla_M)
  beta_D = fit_regression(dat, fmla_D)
  #beta_R1 = fit_regression(dat, fmla_R1)
  #beta_R2 = fit_regression(dat, fmla_R2)
  #beta_R3 = fit_regression(dat, fmla_R3)
  beta_Y = fit_logistic(dat, fmla_Y)
  
  return(list(beta_M=beta_D, 
              beta_D=beta_M, 
              beta_Y=beta_Y))
}

