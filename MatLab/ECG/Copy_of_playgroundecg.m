BPM = 60;
SEC = 5;
RATE = 1000;
CMP_RATE = 95;
n = SEC*RATE;
m = ceil(n*(100-CMP_RATE)/100);

%Simulating heart beat sensing
[x,y] = simulate_ecg(BPM, RATE, SEC);

%Discrete cosine transform (DCT) to spectral domain
x_dct = 1:1:n+1;
y_dct = dct(y);

%Random sample m points amongst n
ind = randperm(length(x),m);
ind = sort(ind); 
y_cs = y(ind);
x_cs = x(ind);

A = idct(eye(n));
A = A(ind,:);

subplot(1,2,1);
plot(x,y);
hold on
plot(x_cs,y_cs,'x','MarkerSize',4);
grid on
title('ECG Sample')

subplot(1,2,2);
plot(x_dct+8, y_dct);
grid on
title('DCT')

