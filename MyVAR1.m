function [B,E,vE,y] = MyVAR1(X,p)
E = 0;
vE = 0;
[siglen, nsigs] = size(X);
D = [];
for s=1:nsigs
    D = [D buffer(X(1:end-1,s),p,p-1,"nodelay")'];
end
D = [ones(size(D,1),1) D];
x = X(p+1:end,:);
B = geninv(D)*x;
y = D*B;
E = x-y;
vE = cov(E);
end


