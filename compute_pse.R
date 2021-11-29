

compute_pse <- function(beta_D,beta_M,beta_Y){
  
  y_a = beta_Y[1]
  y_d = beta_Y[2]
  y_m = beta_Y[3]
#  y_r1 = beta_Y[5]
#  y_r2 = beta_Y[6]
#  y_r3 = beta_Y[7]
  M_a = beta_M[2]
#  M_q = beta_M[3]
#  r2_m = beta_R2[3]
#  r2_l = beta_R2[4]
#  r3_m = beta_R3[3]
#  r3_l = beta_R3[4]
  D_a = beta_D[2]
#  D_q = beta_D[4]
 
  #print(y_a+y_d*D_a+M_a*y_m)
  pse_eff=exp(y_a+y_d*D_a+M_a*y_m)
  #print(pse_eff)
  
  return(as.numeric(pse_eff))
}



