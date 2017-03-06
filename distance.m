function z = distance(x, c, Xtrain, clusters, moyenne_gram)

S = clusters{c}; % images de la classe c 
nb_im = length(S); % nombre d'images dans la classe c

K = zeros(1,nb_im);
for i = 1:nb_im
   K(i) = k(x, Xtrain(S(i),:)); % on calcule la valeur de k entre x et chaque image de xtrain
end

    z = k(x,x) + moyenne_gram(c) - (2/nb_im)*sum(K); % on compare la valeur du rk en x ajouté à la moyenne du rk sur le cluster c par rapport aux moyennes des rk entre x et les classes 
end