function visualizeLearningRate(alphas)
%VISUALIZELEARNINGRATE plots the cost function convergence plot for as many
%times as there are alphas

    fprintf('Loading data ...\n');

    %% Load Data
    data = load('housingData.txt');
    X = data(:, 1:2);
    y = data(:, 3);
    m = length(y);

    % Scale features and set them to zero mean
    fprintf('Normalizing Features ...\n');

    [X mu sigma] = featureNormalize(X);

    % Add intercept term to X
    X = [ones(m, 1) X];


    %% ================ Part 2: Gradient Descent ================

    fprintf('Running gradient descent ...\n');

    % Choose some alpha value
    num_iters = 100;

    numAlphas = length(alphas);

    % Init Theta and Run Gradient Descent for the number of alpha values
    % available

    figure;
    hold on
    grid on
    title('Value of Cost Function J vs. Number of Iterations')
    xlabel('Number of iterations');
    ylabel('Cost J');    
    
    for i=1:numAlphas
        
        theta = zeros(3, 1);
        
        [~, J_history] = gradientDescentMulti(X, y, theta, alphas(i), num_iters);

        
        
        % Plot the convergence graph
        plot(1:numel(J_history), J_history, '-b', 'LineWidth', 2,'Color',rand(1,3));

    end

    legend(string(alphas))
end