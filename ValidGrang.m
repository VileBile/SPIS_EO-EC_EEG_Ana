%% To validate Granger calculations


% 1st a tiny example
x = rand(1,100);
y = [0]
for i=2:100
    y = [y 0.9*x(i-1)];
end

g = zeros(2,2);
[~,~,Evx,~] = MyVAR1(x',2);
[~,~,Evy,~] = MyVAR1(y',2);
[~,~,Ev,~] = MyVAR1([x;y]',2);
g(1,2) = -log(Ev(2,2)/Evy);
g(2,1) = -log(Ev(1,1)/Evx);
% It works!


%% Importing the data
data = importdata("SpisD_1-40_ICAd_AvgRef.set");
dat = data.data(:,1:end-1,:); %%throw away one point so that pnts = 38400 ;
[nbchan,pnts,subs] = size(dat);

%% This is to remove redundant its.
c = combvec(1:nbchan,1:nbchan);
filtr = reshape(logical(triu(ones(nbchan))-eye(nbchan)),1,[]);
c = c(:,filtr);
its = size(c,2);

% %Validating the filter
% a = zeros(size(nbchan));
% for i=1:its
%     a(c(1,i),c(2,i)) = 1;
%     a(c(2,i),c(1,i)) = 1;
% 
% end
% imagesc(a)

% Params
segs = 100; %% approx a 200ms segment %% gives segs with 48 pnts
ord = 20; %%approx a 30ms window
% Main loop 
for s=1:subs
    d = dat(:,:,s);
    d = reshape(d,nbchan,pnts/segs,segs);
    gs = zeros(64,64,segs);
    for seg=1:segs
        Evs = zeros(1,nbchan);
        for chan=1:nbchan
            [~,~,Evo,~] = MyVAR1(d(chan,:,seg)',ordr);
            Evs(chan) = Evo;
        end

        for i=1:its
              [~,~,Ev,~] = MyVAR1(d(c(:,i),:,seg)',ordr);
              gs(c(1,i),c(2,i),seg) = max(0,-log(Ev(2,2)/Evs(c(2,i))));   %(i,j) i 'causes' j with gs(i,j) / How much does adding i improve prediction of j.
              gs(c(2,i),c(1,i),seg) = max(0,-log(Ev(1,1)/Evs(c(1,i))));
        end
        disp((s/subs)*(seg/segs))

    end
    if s>10
        save("./gs/g_"+"ec"+(num2str(s-10))+".mat","gs")
    else
        save("./gs/g_"+"eo"+(num2str(s))+".mat","gs")
    end
end

for i=1:size(gs,3)
    imwrite(squeeze(gs(:,:,i)),"./ims/im"+num2str(i)+".png")
end
        
