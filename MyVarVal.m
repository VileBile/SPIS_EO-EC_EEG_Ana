
xs = [-1 2];
for i = 1:99
xs = [xs [xs(end)-xs(end-1)]];
end
xs = xs + 5
% ys = [5]
% for i = 1:100
% ys = [ys [ys(end)-0.1*xs(i)]]
% end
% ys = ys + rand(size(ys));

ord = 2;

[A,E] = armorf(xs,1,length(xs),ord);
[A1,~,E1]= MyVAR1(xs',ord);

