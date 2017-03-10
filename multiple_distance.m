function  Z = multiple_distance(x, c, Xtrain, clusters, moyenne_gram1, moyenne_gram2, moyenne_gram3, moyenne_gram4, moyenne_gram5)

S = clusters{c}; % images de la classe c 
nb_im = length(S); % nombre d'images dans la classe c



K1 = zeros(1,nb_im);
K2 = zeros(1,nb_im);
K3 = zeros(1,nb_im);
K4 = zeros(1,nb_im);
K5 = zeros(1,nb_im);
for i = 1:nb_im
   [K1(i),K2(i),K3(i),K4(i),K5(i)] = multiple_k(x, Xtrain(S(i),:)); % on calcule la valeur de k entre x et chaque image de xtrain
end
[r1, r2, r3, r4, r5] = multiple_k(x,x);

    Z= [r1, r2, r3, r4, r5] + [moyenne_gram1(c), moyenne_gram2(c), moyenne_gram3(c), moyenne_gram4(c), moyenne_gram5(c)] +  (-1).* (2/nb_im).*[sum(K1), sum(K2), sum(K3), sum(K4), sum(K5)]; % on compare la valeur du rk en x ajouté à la moyenne du rk sur le cluster c par rapport aux moyennes des rk entre x et les classes 
end