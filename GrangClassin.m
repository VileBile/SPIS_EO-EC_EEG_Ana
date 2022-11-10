
G = zeros(64*64,100,20);
for i=1:10
    G(:,:,i) = importdata("eo"+num2str(i)+"vgs.mat");
    G(:,:,10+i) = importdata("ec"+num2str(i)+"vgs.mat");
end



%sanity check
imagesc(reshape(G(:,1,1),64,64));
%% zeros on diagonal, so it's probably good

G = reshape(G,64*64,100*20);
G = G';
cs = zeros(1,100*20);
cs(1:100*10) = 1; % 1 = EO
cs = cs';
%% sanity check 2
imagesc(reshape(G(1,:),64,64));
%% it's as above, good.
[coeff,score,latent,tsquared,explained,mu] = pca(G);

a = 90;

[~,ncomp] = min(abs(cumsum(explained)-a));

%% from here we run clasification app


%% Save best moddels from all features 
%classin.models = {lSVM,qSVM,NN,EnsSbsDis};
%save("100gsClassin.mat","classin","-v7.3");


asigns = G*coeff;
D = asigns(:,1:4);

as90 = asigns(:,1:ncomp);
eoas = mean(abs(asigns(1:500,:)),1);
ecas = mean(abs(asigns(501:1000,:)),1);

asdiff = abs(eoas-ecas);



