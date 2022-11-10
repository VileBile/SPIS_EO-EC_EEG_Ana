%analysis done useing +microstate toolbox


clear
dat = importdata("SpisD_preprocd.set");
d = dat.data;
micros = importdata("micro.mat");

%clear
% 
load sampleEEGdata.mat
locs = EEG.chanlocs;
clear EEG
% 
% dat = importdata("SpisD_preprocd.set");
% dat = dat.data(:,1:end-1,:);
% d = laplacian_perrinX(dat,[locs.X],[locs.Y],[locs.Z]);
% 

% micros = importdata("microlap.mat");

maps = micros.globalmaps;
a = figure(1)
nmaps = size(maps,2);
side = ceil(sqrt(nmaps));
for i=1:nmaps
    subplot(side,side,i)
    topoplotIndie(maps(:,i),locs)

end

[x,y,z] = size(d);
asigns = zeros(y,z,nmaps);
for i=1:nmaps
    for t=1:y
        for s=1:z
            temp = abs(corrcoef(maps(:,i),d(:,t,s)));
            asigns(t,s,i) = temp(2,1);
        end
    end
end

[~,asidx] = max(asigns,[],3);

eoas = reshape(asidx(:,1:10),[],1);
ecas = reshape(asidx(:,11:20),[],1);

mapdurs = zeros(nmaps,20);
mapoccurs = zeros(nmaps,20);
for mi = 1:20
    i = 1;
    while i < y
        mapoccurs(asidx(i,mi),mi) = mapoccurs(asidx(i,mi),mi) + 1;
        mdur = 1;
        while asidx(i,mi) == asidx(i+1,mi)
            mdur = mdur + 1;
            i = i +1;
            if i == y
                break
            end
        end
        mapdurs(asidx(i,mi),mi) = mapdurs(asidx(i,mi),mi) + mdur; 
        i = i + 1;
    end
    disp(mi)
end

maplens = zeros(nmaps,20);
for t = 1:20
    for mi = 1:nmaps
        maplens(mi,t) = mapdurs(mi,t)/mapoccurs(mi,t);
    end
end

mprobs = zeros(nmaps,nmaps,20); %% (i,j) P(t=j|t-1 = i)
for t=1:20
    for mi=1:nmaps
       pos = asidx(:,t)==mi;
       nxpos = logical([0 pos(1:end-1)']);
       for mi1=1:nmaps
           nx = asidx(nxpos,t);
           mprobs(mi,mi1,t) = length(asidx(nx==mi1,t))/length(nx); 
       end
    end
end

a1 = mean(mprobs(:,:,1:10),3);
a2 = mean(mprobs(:,:,11:20),3);

x = mprobs(:,:,1:10);
x1 = mprobs(:,:,11:end);
x = reshape(x,[],10);
x1 = reshape(x1,[],10);
ts = [x x1];
t = zeros(1,20);
t(1:10) = 1;

figure(2)
mapidx = zeros(nmaps,y,20);
for i =1:nmaps
    for j =1:z
        temp = asidx(:,j);
        mapidx(i,:,j) = temp == i;;
    end
end



