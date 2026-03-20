
data {
  int<lower=0> N; // number of observations
  int<lower=0> T; //number of years
  int<lower=0> P; 
  int<lower=0> mid_year; // mid-year of study
  vector[N] y; //log ratio
  vector[N] se; // standard error around observations
  vector[T] years; // unique years of study
  vector[P] years_p; 
  real<lower=0> max_se;
  int<lower=0> year_i[N]; // year index of observations
  
}

parameters {
  real alpha;
  real beta;

}

transformed parameters{
  vector[T] mu;
  
  for(t in 1:T){
    mu[t] = alpha + beta*(years[t] - mid_year);
  }
}

model {
  
  y ~ normal(mu[year_i], se);
  
  alpha ~ normal(0, 1);
  beta ~ normal(0,1);
}

generated quantities {
  real y_proj[P];
  real mu_proj[P];
  for(i in 1:P){
    mu_proj[i] = alpha + beta*(years_p[i] - mid_year);
  }
  y_proj = normal_rng(mu_proj, max_se);
}

