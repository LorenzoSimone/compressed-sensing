BPM = 40;
SEC = 3;
RATE = 1000;
CMP_RATE = 75;
n = SEC*RATE;
m = ceil(n*(100-CMP_RATE)/100);

%Simulating heart beat sensing
[x,y] = simulate_ecg(BPM, RATE, SEC);

%Discrete cosine transform (DCT) to spectral domain
x_dct = 1:1:n;
y_dct = dct(y);

%Random sample m points amongst n
ind = randperm(length(x),m);
ind = sort(ind); 
y_cs = y(ind);
x_cs = x(ind);

A = idct(eye(n));
A = A(ind,:);

[freq_sol,fun_val, err] = solvesimplex(A,y_cs);
y_sol = idct(freq_sol)';

FigH = figure('Position', get(0, 'Screensize'));
subplot(3,2,1);
plot(x,y)
grid on
title('ECG Sample')

subplot(3,2,2);
plot(x_dct+8, y_dct)
grid on
title('DCT')

subplot(3,2,3);
plot(y_sol)
hold on
grid on
title('ECG reconstruction')

subplot(3,2,4);
plot(freq_sol)
grid on
title('DCT reconstruction')

h = subplot(3,2,5);
plot(y);
hold on
plot(y_sol);
grid on
axis([0 n -0.5 2.5])
myAxes=findobj(h,'Type','Axes');
exportgraphics(myAxes,'BPM_'+string(BPM)+'_'+'CR_'+string(CMP_RATE)+'.png');

%Writing the results part
[mse,corr] = metrics(y,y_sol);
headers = {'n','m','err','f_val', 'MSE', 'CORR', 'CR','BPM'};
R = [n,m,err, fun_val, mse, corr,CMP_RATE, BPM];
fprintf('\n');
fprintf('|%20s|', headers{1:end-1});
fprintf('\n');
fprintf('|%20f|',R);

F    = getframe(FigH);
imwrite(F.cdata, 'reconstruction.png', 'png')
