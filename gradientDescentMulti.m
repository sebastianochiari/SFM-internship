function [theta, J_history] = gradientDescentMulti(X, y, theta, alpha, num_iters)
%GRADIENTDESCENTMULTI Performs gradient descent to learn theta
%   theta = GRADIENTDESCENTMULTI(x, y, theta, alpha, num_iters) updates theta by
%   taking num_iters gradient steps with learning rate alpha

    % Initialize some useful values
    m = length(y); % number of training examples
    J_history = zeros(num_iters, 1);
    n = length(theta); % number of thetas
    tempTheta = zeros(n,1);

    for iter = 1:num_iters

        for j=1:n

            sum = 0;

            for i=1:m

                currentX = X(i,:)'; 
                h = theta'*currentX;
                diff = h-y(i);
                sum = sum + diff*X(i,j);

            end

            tempTheta(j)=theta(j)-alpha/m*sum;

        end
        theta = tempTheta;

        % ============================================================

        % Save the cost J in every iteration    
        J_history(iter) = computeCostMulti(X, y, theta);

    end

end
