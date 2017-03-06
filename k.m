function z = k(x,y)
sigma = 1;
    %z = sum(x.*y);
    z = exp(-norm(x-y)^2/(2*sigma^2)); % noyau exponentiel 
    %z = exp(norm(x-y)/sigma);
    %z = sum(x.*y)^(2);
    %z = sum(atan(10*x.*y));
end