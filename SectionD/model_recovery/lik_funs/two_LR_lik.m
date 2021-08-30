%% KN
% Likelihood function for two LR model

function [lik] = two_LR_lik(blocks, choices, rewards, x)

tau = x(1);
alpha_pos = x(2);
alpha_neg = x(3);

% Initialize log likelihood at 0
lik = 0;


% Loop through trials
for trial = 1:length(choices)
    
    % At the start of each block, initialize value estimates
    if trial == 1 || blocks(trial) ~= blocks(trial-1)
        val_ests = [.5 .5];
    end
    
    
    % Determine choice probabilities
    ev = exp(val_ests./tau); %multiply inverse temperature * value estimates and exponentiate
    sev = sum(ev);
    choice_probs = ev/sev; %divide values by sum of all values so the probabilities sum to 1
    
    % Determine the choice the participant actually made on this trial
    trial_choice = choices(trial);
    
    %Determine the probability that the participant made the choice they
    %made
    lik_choice = choice_probs(trial_choice);
    
    %update log likelihood
    lik = lik + log(lik_choice);
    
    % Get the reward the participant received on this trial
    trial_reward = rewards(trial);
    
    %Compute  prediction error
    PE = trial_reward - val_ests(trial_choice);
    
    % Update value estimates for next trial
    if PE > 0
     val_ests(trial_choice) = val_ests(trial_choice) + alpha_pos * PE; 
    else
        val_ests(trial_choice) = val_ests(trial_choice) + alpha_neg * PE;
    end
     
end

% Put priors on parameters
%lik= lik+log(pdf('beta', alpha_pos, 1.1,1.1));
%lik= lik+log(pdf('beta', alpha_neg, 1.1,1.1));
%lik= lik+log(pdf('gam', beta, 4.82, 0.88));

%flip sign of loglikelihood (which is negative, and we want it to be as close to 0 as possible) so we can enter it into fmincon, which searches for minimum, rather than maximum values
lik = -lik;

