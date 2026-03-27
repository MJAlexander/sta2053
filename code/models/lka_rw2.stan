
data {
  int<lower=0> N; // number of observations
  int<lower=0> T; //number of years
  int<lower=0> P; 
  vector[N] y; //log ratio
  vector[N] se; // standard error around observations
  vector[T] years; // unique years of study
  vector[P] years_p; 
  real<lower=0> max_se;
  int<lower=0> year_i[N]; // year index of observations
  
}

parameters {
  vector[T] alpha;
  real<lower = 0> sigma_alpha;
}


model {
  
  alpha[1] ~ normal(0,sigma_alpha);
  alpha[2] ~ normal(alpha[1],sigma_alpha);
  alpha[3:T] ~ normal(2*alpha[2:(T-1)] - alpha[1:(T-2)], sigma_alpha);
  y ~ normal(alpha[year_i], se);
  sigma_alpha ~ normal(0,1);
}

generated quantities {
  real y_proj[P];
  real alpha_proj[P];
  
  alpha_proj[1] = normal_rng(2*alpha[T] - alpha[T-1], sigma_alpha);
  alpha_proj[2] = normal_rng(2*alpha_proj[1] - alpha[T], sigma_alpha);
  for(i in 3:P){
    alpha_proj[i] = normal_rng(2*alpha_proj[i-1] - alpha_proj[i-2], sigma_alpha);
  }
  y_proj = normal_rng(alpha_proj, max_se);
}

