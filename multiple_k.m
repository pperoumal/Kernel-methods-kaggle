function [z1, z2, z3, z4, z5] = multiple_k(x,y)

sigma = 1;
z1 = sum(x.*y); % noyau normal
z2 = sum(x.*y)^(2); % noyau quadratique
z3 = exp(norm(x-y)/sigma);  % noyau exp 1
z4 = exp(-norm(x-y)^2/(2*sigma^2)); % noyau exp 2


z5 = sum(atan(10*x.*y)); % noyau tangente
end