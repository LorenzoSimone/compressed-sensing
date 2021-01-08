clc 
close all
clear
A = input ('enter amplitude:');
F = input ('enter frequency:');
t = 0:0.001:3;
y1 = A*sin(2*pi*F*t);
subplot(3,2,1)
plot(t,y1)
title('sine plot')
xlabel('time')
ylabel('amplitude')
grid ON

y2 = A*cos(2*pi*F*t)
subplot(3,2,2)
plot(t,y2)
title('cosine plot')
xlabel('time')
ylabel('amplitude')
grid ON

y3 = signal_square(t);
subplot(3,2,3)
plot(t,y3)
title('square plot')
xlabel('time')
ylabel('amplitude')
grid ON

y4 = signal_triangle(t);
subplot(3,2,4)
plot(t,y4)
title('triangular plot')
xlabel('time')
ylabel('amplitude')
grid ON

y5 = signal_sawtooth(t);
subplot(3,2,5)
plot(t,y5)
title('sawtooth plot')
xlabel('time')
ylabel('amplitude')
grid ON