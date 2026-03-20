
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
  real alpha[T];
  real<lower = 0> sigma_alpha;
}


model {
  
  alpha[1] ~ normal(0,1);
  alpha[2:T] ~ normal(alpha[1:(T-1)], sigma_alpha);
  y ~ normal(alpha[year_i], se);
  sigma_alpha ~ normal(0,1);
}

generated quantities {
  real y_proj[P];
  real alpha_proj[P];
  
  alpha_proj[1] = normal_rng(alpha[T], sigma_alpha);
  for(i in 2:P){
    alpha_proj[i] = normal_rng(alpha_proj[i-1], sigma_alpha);
  }
  y_proj = normal_rng(alpha_proj, max_se);
}

