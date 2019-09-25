function J = computeCostMulti(X, y, theta)
%COMPUTECOSTMULTI Compute cost for linear regression with multiple variables
%   J = COMPUTECOSTMULTI(X, y, theta) computes the cost of using theta as the
%   parameter for linear regression to fit the data points in X and y

    % Initialize some useful values
    m = length(y); % number of training examples
    n = size(X,2); % number of features (not including x0)
    sum = 0;

    % You need to return the following variables correctly 
    J = 0;

    for i=1:m
        
        currentX = X(i,:)'; % column vector
        h = theta'*currentX;
        diff = h-y(i);
        sum = sum + diff^2;
        
    end

    J=sum/(2*m);

end
