%% analysis done useing +microstate toolbox
clear

load sampleEEGdata.mat
locs = EEG.chanlocs;
clear EEG

dat = importdata("SpisD_preprocd.set");
dat = dat.data(:,1:end-1,:);
dat = laplacian_perrinX(dat,[locs.X],[locs.Y],[locs.Z]);
[ch,pnts,tris] = size(dat);
srate = 256;
eo = dat(:,:,1:10);
ec = dat(:,:,11:end);

coh = microstate.cohort;

for i=1:20
    if i > 10 
        eci = microstate.individual(squeeze(ec(:,:,i-10))',"eeg",srate);
        coh.individual = [coh.individual, eci];
    else
        eoi = microstate.individual(squeeze(eo(:,:,i))',"eeg",srate);
        coh.individual = [coh.individual, eoi];
    end
end
 
%[eocoh,optimum_k,k_values,maps_all_k,gev_all_k] = eocoh.cluster_globalkoptimum('kmin',2,'kmax',20); 

% 
% layout = importdata("~/Documents/MATLAB/SpisEOEC/layout.mat");
% 
% 
% eocoh.plot('globalmaps',layout,'cscale',[0.1,0.5]) ; 



[coh,optimum_k,k_values,maps_all_k,gev_all_k] = coh.cluster_globalkoptimum('kmin',2,'kmax',10); 

save("~/Documents/MATLAB/SpisEOEC/microlap.mat","coh");
% save("~/Documents/MATLAB/SpisEOEC/ecmicro.mat","eccoh");
% 
% data = importdata("~/Documents/MATLAB/SpisEOEC/eomicro.mat")

maps = coh.globalmaps;
for i=1:5
    subplot(4,2,i)
    topoplotIndie(maps(:,i),locs)
end
