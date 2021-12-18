

# -------------------------------------- 
# Optimize a constrained logistic model
# --------------------------------------
constrained_mle <- function(dat,fmla_D,fmla_M,fmla_Y,func,tau_u,tau_l){
  
  # Define the negative log likelihood function
  eval_f <- function(beta, dat, Y, D, M, Xy, Xd, Xm, func, tau_u, tau_l){
    
    
    beta_D = beta[1:ncol(Xd)]
    beta_M = beta[(ncol(Xd) + 1):(ncol(Xm) + ncol(Xd))]
    #beta_R1 = beta[(ncol(Xm) + ncol(Xl) + 1):(ncol(Xm) + ncol(Xl) + ncol(Xr1))]
    #beta_R2 = beta[(ncol(Xm)+ncol(Xl)+ncol(Xr1)+1):(ncol(Xm)+ncol(Xl)+ncol(Xr1)+ncol(Xr2))]
    #beta_R3 = beta[(ncol(Xm)+ncol(Xl)+ncol(Xr1)+ncol(Xr2)+1):(ncol(Xm)+ncol(Xl)+ncol(Xr1)+ncol(Xr2)+ncol(Xr3))]
    beta_Y = beta[(ncol(Xm)+ncol(Xd)+1):length(beta)]
    
    names(beta_D) = colnames(Xd)
    names(beta_M) = colnames(Xm)
    #names(beta_R1) = colnames(Xr1)
    #names(beta_R2) = colnames(Xr2)
    #names(beta_R3) = colnames(Xr3)
    names(beta_Y) = colnames(Xy)
    
    D = as.matrix(D)
    M = as.matrix(M)
    #R1 = as.matrix(R1)
    #R2 = as.matrix(R2)
    #R3 = as.matrix(R3)
    Y = as.matrix(Y)
    
    f =  t(D-Xd%*%beta_D)%*%(D-Xd%*%beta_D)+t(M-Xm%*%beta_M)%*%(M-Xm%*%beta_M)+sum(Y*log(1+exp(-Xy%*%beta_Y))+(1-Y)*log(1+exp(Xy%*%beta_Y))) 
    return(f/nrow(dat))
  }
  
  # Define the inequlity constraint 
  eval_g_ineq <- function(beta, dat, Y, D, M, Xy, Xd, Xm, func, tau_u, tau_l){
    #print(beta)
    #print(ncol(Xd))
    #print(ncol(Xm))
    beta_D = beta[1:ncol(Xd)]
    beta_M = beta[(ncol(Xd) + 1):(ncol(Xd) + ncol(Xm))]
    #beta_R1 = beta[(ncol(Xm) + ncol(Xl) + 1):(ncol(Xm) + ncol(Xl) + ncol(Xr1))]
    #beta_R2 = beta[(ncol(Xm)+ncol(Xl)+ncol(Xr1)+1):(ncol(Xm)+ncol(Xl)+ncol(Xr1)+ncol(Xr2))]
    #beta_R3 = beta[(ncol(Xm)+ncol(Xl)+ncol(Xr1)+ncol(Xr2)+1):(ncol(Xm)+ncol(Xl)+ncol(Xr1)+ncol(Xr2)+ncol(Xr3))]
    beta_Y = beta[(ncol(Xm)+ncol(Xd)+1):length(beta)]
    
    #print(beta_Y)
    names(beta_D) = colnames(Xd)
    names(beta_M) = colnames(Xm)
    #names(beta_R1) = colnames(Xr1)
    #names(beta_R2) = colnames(Xr2)
    #names(beta_R3) = colnames(Xr3)
    names(beta_Y) = colnames(Xy)
    
    pse = func(beta_D,beta_M,beta_Y)
    eval_g =  c(pse - tau_u, tau_l - pse)
    return(eval_g)
  }
  
  # Prepare the data
  Xd = as.matrix(model.matrix(fmla_D, data=model.frame(dat)))
  #Xl = as.matrix(model.matrix(fmla_L, data=model.frame(dat)))
  Xm = as.matrix(model.matrix(fmla_M, data=model.frame(dat)))
  #Xr1 = as.matrix(model.matrix(fmla_R1, data=model.frame(dat)))
  #Xr2 = as.matrix(model.matrix(fmla_R2, data=model.frame(dat)))
  #Xr3 = as.matrix(model.matrix(fmla_R3, data=model.frame(dat)))
  Xy = as.matrix(model.matrix(fmla_Y, data=model.frame(dat)))
  M = model.frame(fmla_M,dat)[, 1]
  D = model.frame(fmla_D,dat)[, 1]
  #R1 = model.frame(fmla_R1,dat)[, 1]
  #R2 = model.frame(fmla_R2,dat)[, 1]
  #R3 = model.frame(fmla_R3,dat)[, 1]
  Y = model.frame(fmla_Y,dat)[, 1]
  
  # Initialize parameters
  beta_M_0 = rep(0, ncol(Xm))
  beta_D_0 = rep(0, ncol(Xd))
  #beta_R1_0 = rep(0, ncol(Xr1))
  #beta_R2_0 = rep(0, ncol(Xr2))
  #beta_R3_0 = rep(0, ncol(Xr3))
  beta_Y_0 = rep(0, ncol(Xy))
  # names(beta_Y_start) = colnames(Xy)
  
  beta_start = c(beta_D_0, beta_M_0,beta_Y_0)
  
  # Solve the constrained optimization problem
  mle = nloptr(x0=beta_start, 
               eval_f=eval_f, 
               eval_g_ineq=eval_g_ineq,
               opts = list("algorithm"="NLOPT_LN_COBYLA","xtol_rel"=1.0e-8, "maxeval"=5000),
               dat=dat, Y=Y, M=M, D=D, 
               Xy=Xy, Xm = Xm, Xd=Xd, 
               func=func, tau_u=tau_u, tau_l=tau_l)
  
  # Returnt parameters
  beta = mle$solution
  beta_D = beta[1:ncol(Xd)]
  beta_M = beta[(ncol(Xd) + 1):(ncol(Xd) + ncol(Xm))]

  #beta_R1 = beta[(ncol(Xm) + ncol(Xl) + 1):(ncol(Xm) + ncol(Xl) + ncol(Xr1))]
#  beta_R2 = beta[(ncol(Xm)+ncol(Xl)+ncol(Xr1)+1):(ncol(Xm)+ncol(Xl)+ncol(Xr1)+ncol(Xr2))]
#  beta_R3 = beta[(ncol(Xm)+ncol(Xl)+ncol(Xr1)+ncol(Xr2)+1):(ncol(Xm)+ncol(Xl)+ncol(Xr1)+ncol(Xr2)+ncol(Xr3))]
  beta_Y = beta[(ncol(Xm)+ncol(Xd)+1):length(beta_start)]
  
  names(beta_M) = colnames(Xm)
  names(beta_D) = colnames(Xd)
#  names(beta_R1) = colnames(Xr1)
#  names(beta_R2) = colnames(Xr2)
#  names(beta_R3) = colnames(Xr3)
  names(beta_Y) = colnames(Xy)
  
  return(list(beta_D=beta_D, 
              beta_M=beta_M, 
        #      beta_R1=beta_R1, 
        #      beta_R2=beta_R2, 
        #      beta_R3=beta_R3,
              beta_Y=beta_Y))
}


