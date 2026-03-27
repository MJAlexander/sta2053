data {
  int<lower=0> N;
  int<lower=0> S;
  int<lower=0> K;
  matrix[N,S] y;
  matrix[N,K] B;
}
parameters {
  vector<lower=0>[S] sigma;
  vector<lower=0>[S] sigma_y;
  real<lower=0> tau;
  real mu_sig;
  matrix[K,S] alpha;
}

transformed parameters{
  matrix[N,S] lambda;
  
  for(s in 1:S){
    lambda[,s] = B*alpha[,s];
  }
  
}

model {
  
  sigma ~ lognormal(mu_sig,tau);
  tau ~ normal(0,1);
  sigma_y ~ normal(0,1);
  mu_sig ~ normal(0,1);
  
  
  for(s in 1:S){
    alpha[1,s] ~ normal(0, sigma[s]);
    alpha[2,s] ~ normal(alpha[1,s], sigma[s]);
    alpha[3:K,s] ~ normal(2*alpha[2:(K - 1),s] - alpha[1:(K - 2),s], sigma[s]);
    y[,s] ~ normal(B*alpha[,s], sigma_y[s]);
  }
}