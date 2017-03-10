
clear all

close all
%% Pré-traitement

Ntrain = 3571; % Nombre d'images dans l'échantillon d'entrainement
Ntest=5000-Ntrain;

Xtrain = csvread('Xtr.csv');
Xtrain=Xtrain(:,1:(end-1)); % on récupère les images

Xtest = Xtrain((Ntrain+1):end, :); % Ensemble de test
Xtrain = Xtrain(1:Ntrain, :); % ensemble d'entainement

Ytrain = csvread('Ytr.csv', 1, 0); % Ensemble des labels
Y = Ytrain(:,2); % On sélectionne la colonne contenant les labels
Y = Y+1; % on ajoute 1

Ytest = Y((Ntrain+1):end); % ensemble des labels test
Ytrain = Y(1:Ntrain); % ensemble des labels train
nb_classes = max(Y) - min(Y) + 1; % nombre de classes


%% Calcul de la moyenne des polynomial values sur les différentes classes

clusters = cell(nb_classes,1); % Tableaux des différentes classes
for i = 1:nb_classes % on rassemble les différentes images dans leur classe
    clusters{i} = find(Ytrain == i);
end

NB_CLASSES = cellfun(@length, clusters);

gram1 = cell(nb_classes); % initialisation de la matrice de gram
gram2 = cell(nb_classes); % initialisation de la matrice de gram
gram3 = cell(nb_classes); % initialisation de la matrice de gram
gram4 = cell(nb_classes); % initialisation de la matrice de gram
gram5 = cell(nb_classes); % initialisation de la matrice de gram


for c = 1:nb_classes
    
    n = NB_CLASSES(c); % nombre d'image dans la classe c
    S = clusters{c}; % les indices des images appartenant à la classe c
    %     tic % comptage du temps d'execution
    GRAMc1 = zeros(n,n); % on calcule la matrice de gram dans la classe c
    GRAMc2 = zeros(n,n); % on calcule la matrice de gram dans la classe c
    GRAMc3 = zeros(n,n); % on calcule la matrice de gram dans la classe c
    GRAMc4 = zeros(n,n); % on calcule la matrice de gram dans la classe c
    GRAMc5 = zeros(n,n); % on calcule la matrice de gram dans la classe c
    for i = 1:n
        for j =1:n
            
            [GRAMc1(i,j), GRAMc2(i,j), GRAMc3(i,j), GRAMc4(i,j), GRAMc5(i,j)] = multiple_k(Xtrain(S(i),:), Xtrain(S(j),:));
            
        end
    end
    gram1{c} = GRAMc1; % gram contient les matrices de gram de toutes les classes
    gram2{c} = GRAMc2; % gram contient les matrices de gram de toutes les classes
    gram3{c} = GRAMc3; % gram contient les matrices de gram de toutes les classes
    gram4{c} = GRAMc4; % gram contient les matrices de gram de toutes les classes
    gram5{c} = GRAMc5; % gram contient les matrices de gram de toutes les classes
    
    %     toc % comptage du temps d'execution
end

moyenne_gram1 = zeros(1,nb_classes);
moyenne_gram2 = zeros(1,nb_classes);
moyenne_gram3 = zeros(1,nb_classes);
moyenne_gram4 = zeros(1,nb_classes);
moyenne_gram5 = zeros(1,nb_classes);

for c = 1:nb_classes
    n = NB_CLASSES(c);
    moyenne_gram1(c) = sum(sum(gram1{c}))/(2*n^2);
    moyenne_gram2(c) = sum(sum(gram2{c}))/(2*n^2);
    moyenne_gram3(c) = sum(sum(gram3{c}))/(2*n^2);
    moyenne_gram4(c) = sum(sum(gram4{c}))/(2*n^2);
    moyenne_gram5(c) = sum(sum(gram5{c}))/(2*n^2);
end

%%  Verification sur Xtest

classifications = zeros(1,Ntest); % tableau des classes
% tic % comptage
for i = 1:Ntest
    distances1 = zeros(1, nb_classes);  % distance
    distances2 = zeros(1, nb_classes);  % distance
    distances3 = zeros(1, nb_classes);  % distance
    distances4 = zeros(1, nb_classes);  % distance
    distances5 = zeros(1, nb_classes);  % distance
    distances=zeros(1, nb_classes);
    x = Xtest(i,:);
    for c = 1:nb_classes % on compare cette image aux différentes moyennes de gram de chaque cluster
        Z = multiple_distance(x,c, Xtrain, clusters, moyenne_gram1, moyenne_gram2, moyenne_gram3, moyenne_gram4, moyenne_gram5);
        
        distances1(c)=Z(1);
        distances2(c)=Z(2);
        distances3(c)=Z(3);
        distances4(c)=Z(4);
        distances5(c)=Z(5);
        
       % Ne marche pas  distance(c)=(distances1(c)+distances2(c)+distances3(c)+distances4(c)+distances5(c))/5;
        
    end
  [~, idx1] = min(distances1);  % vote du kernel 1
        [~, idx2] = min(distances2);  % vote du kernel 2
        [~, idx3] = min(distances3);  % vote du kernel 3
        [~, idx4] = min(distances4);  % vote du kernel 4
        [~, idx5] = min(distances5);  % vote du kernel 5
        classes=[1 2 3 4 5 6 7 8 9 10];
        votes=find(classes==idx1)+find(classes==idx2)+find(classes==idx3)+find(classes==idx4)+find(classes==idx5);
        [A, I]= max(votes); 
        % on privilégie le noyau 4 : exponentiel quadratique , si égalité
        % des votes : 
        if length(I)==1; % si le max est concentré en une classe
        classifications(i) = I; % la classe est attribuée
        else  % si le max est concentré sur plusieurs classes, on prend la prédiction du noyau exp
                    classifications(i) = max(votes); % la classe est attribuée
classifications(i) = idx4; % la classe est attribuée 

         
        end
    
end



% toc % comptage
sum(Ytest(1:Ntest)==classifications')/Ntest % on compte le nombre de réussites







