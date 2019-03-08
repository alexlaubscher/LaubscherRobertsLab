% Initial populations
y1 = 250;
y2 = 500;

% Set the area
area = 5;

% Initializing time
time = 0;
maxTime = 3;

% Storing the populations for the plot
pop1 = [y1];
pop2 = [y2];
timelog = [0];

% Run the while loop until the time length has run its course
while (time < maxTime)
    % Updating propensities
    p1 = 15 * y1;
    p2 = 0.05 / area * y1 * y2;
    p4 = 10 * y2;
    
    % Sum over all propensities
    total = p1 + p2 + p4;
    
    % Calculate time step
    tau = 1 / total * log(rand);
    
    % Sample another rand and compare to cdf
    sample = (total)*rand;

    if sample < p1
        y1 = y1 + 1;
    elseif sample < p1 + p2
        y1 = y1 - 1;
        y2 = y2 + 1;
    else
        y2 = y2 - 1;
    end
    
    % Subtract because the distribution is negative
    time = time - tau;
    
    pop1 = [pop1 y1];
    pop2 = [pop2 y2];
    timelog = [timelog time];
end

figure(); 
plot(timelog, pop1);
hold on;
plot(timelog, pop2);
hold off;
