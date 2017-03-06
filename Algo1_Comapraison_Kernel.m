%% Pré-traitement

Ntrain = 4900; % Nombre d'images dans l'échantillon d'entrainement 
Ntest=5000-Ntrain;

Xtrain = csvread('Xtr.csv'); 
Xtrain=Xtrain(:,1:(end-1)); % on récupère les images 
size(Xtrain)

Xtest = Xtrain((Ntrain+1):end, :); % Ensemble de test
Xtrain = Xtrain(1:Ntrain, :); % ensemble d'entainement 

Ytrain = csvread('Ytr.csv', 1, 0); % Ensemble des labels
Y = Ytrain(:,2); % On sélectionne la colonne contenant les labels
Y = Y+1; % on ajoute 1 

Ytest = Y((Ntrain+1):end); % ensemble des labels test
Ytrain = Y(1:Ntrain); % ensemble des labels train 
nb_classes = max(Y) - min(Y) + 1; % nombre de classes 


% on affiche une image au hasard 
clf
i = 4900;
picture1 = Xtrain(i,:);
picture2 = cat(3, reshape(picture1(1:1024), 32,32), reshape(picture1(1025:2048), 32,32), reshape(picture1(2049:end), 32,32));
%u = min(min(min(U)));
image(picture2);



%% Calcul de la moyenne des polynomial values sur les différentes classes

clusters = cell(nb_classes,1); % Tableaux des différentes classes 
for i = 1:nb_classes % on rassemble les différentes images dans leur classe
   clusters{i} = find(Ytrain == i); 
end

NB_CLASSES = cellfun(@length, clusters);  

gram = cell(nb_classes); % initialisation de la matrice de gram 
for c = 1:nb_classes
 
    n = NB_CLASSES(c); % nombre d'image dans la classe c 
    S = clusters{c}; % les indices des images appartenant à la classe c 
%     tic % comptage du temps d'execution 
    GRAMc = zeros(n,n); % on calcule la matrice de gram dans la classe c 
    for i = 1:n
        for j =1:n
            GRAMc(i,j) = k(Xtrain(S(i),:), Xtrain(S(j),:));
        end
    end
    gram{c} = GRAMc; % gram contient les matrices de gram de toutes les classes
%     toc % comptage du temps d'execution
end

moyenne_gram = zeros(1,nb_classes);
for c = 1:nb_classes
   n = NB_CLASSES(c);
   moyenne_gram(c) = sum(sum(gram{c}))/(2*n^2);
end

%%  Verification sur Xtest 

classifications = zeros(1,Ntest); % tableau des classes
% tic % comptage 
for i = 1:Ntest 
distances = zeros(1, nb_classes);  % distance 
x = Xtest(i,:);
for c = 1:nb_classes % on compare cette image aux différentes moyennes de gram de chaque cluster
    distances(c) = distance(x,c, Xtrain, clusters, moyenne_gram);
end

[~, idx] = min(distances);  % on prend l'indice du minimum 
classifications(i) = idx; % la classe est attribuée 

end
% toc % comptage
sum(Ytest(1:N)==classifications')/Ntest % on compte le nombre de réussites 







