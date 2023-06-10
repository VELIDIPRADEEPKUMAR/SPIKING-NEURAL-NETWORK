F = 30:120;

S1 =interp1([30,130],[1,120],F);
S2 = interp1([0,60],[0,120],(F-60).*((F-60)>0));
S3 = interp1([0,40],[0,120],(60-F).*((60-F)>0));

B = S1*800 - S2*3000 + S3*1200;
T = S1*700 + S2*500 - S3*800; 
N = S1*3200 - S2*3200 - S3*3200;

% Neuron 1
Vb = -50;
Vo = -60;
V_th = 20;
tau = 2;
C = 1;
I = B/200;
dt = 1/1000;
k = 1;
S1 = 0;

for j = 1:length(I)
    for i = 1:500
       if(Vb(k)>V_th)
            Vb(k+1) = Vo;
            S1(k+1) = 1;
       else
            Vb(k+1) = Vb(k) - ((Vb(k) - Vo)*dt)/tau + I(j)*dt;
            S1(k+1) = 0;
       end
       k = k + 1;
    end
end




% Neuron 2
Vt = -50;
Vo = -60;
V_th = 20;
tau = 2;
C = 1;
I = T/200;
dt = 1/1000;
k = 1;
S2 = 0;

for j = 1:length(I)
    for i = 1:500
       if(Vt(k)>V_th)
            Vt(k+1) = Vo;
            S2(k+1) = 1;
       else
            Vt(k+1) = Vt(k) - ((Vt(k) - Vo)*dt)/tau + I(j)*dt;
            S2(k+1) = 0;
       end
       k = k + 1;
    end
end

% Neuron 3
Vn = -50;
Vo = -60;
V_th = 20;
tau = 2;
C = 1;
I = N/200;
dt = 1/1000;
k = 1;
S3 = 0;

for j = 1:length(I)
    for i = 1:500
       if(Vn(k)>V_th)
            Vn(k+1) = Vo;
            S3(k+1) = 1;
       else
            Vn(k+1) = Vn(k) - ((Vn(k) - Vo)*dt)/tau + I(j)*dt;
            S3(k+1) = 0;
       end
       k = k + 1;
    end
end

T = linspace(30,120,length(Vn));

figure;
subplot(3,1,1);
plot(T,S1);
title("Neuron Spikes Tuned for Bradycardia");
xlabel("Freq(F)");
ylabel("Spikes");

subplot(3,1,2);
plot(T,S3);
title("Neuron Spikes Tuned for Normal case");
xlabel("Freq(F)");
ylabel("Spikes");

subplot(3,1,3);
plot(T,S2);
title("Neuron Spikes Tuned for Tachycardia");
xlabel("Freq(F)");
ylabel("Spikes");

%% R and QRS bases Detection 

F = 70;%% 30:120;
QRS = 120;%60:180;
a = 40;

%[F,QRS] = meshgrid(F_X,QRS_Y);

S1 =interp1([30,130],[1,120],F);
S2 = interp1([0,60],[0,120],(F-60).*((F-60)>0));
S3 = interp1([0,40],[0,120],(60-F).*((60-F)>0));

S4 = interp1([0,60],[0,120],(QRS-120).*((QRS-120)>0));
S5 = interp1([0,60],[0,120],(120-QRS).*((120-QRS)>0)); 

W_B = S1*3000 - S2*12000 + S3*3600 + S4*3000 - S5*5000;
N_B = S1*3000 - S2*12000 + S3*3600 - S4*5000 + S5*3000;

W_T = S1*2100 + S2*1500 - S3*8000 + S4*3000 - S5*5000; 
N_T = S1*2100 + S2*1500 - S3*8000 - S4*5000 + S5*3000; 

N = S1*14000 - S2*10800 - S3*10800 - S4*0 - S5*0;


% Neuron 1
Vb = -50;
Vo = -60;
V_th = 20;
tau = 2;
C = 1;
I = W_B/a;
dt = 1/1000;
k = 1;
S1 = 0;


for j = 1:length(I)
    for l = 1:500
       if(Vb(k)>V_th)
            Vb(k+1) = Vo;
            S1(k+1) = 1;
       else
            Vb(k+1) = Vb(k) - ((Vb(k) - Vo)*dt)/tau + I(j)*dt;
            S1(k+1) = 0;
       end
       k = k + 1;
    end
end





% Neuron 2
Vnb = -50;
Vo = -60;
V_th = 20;
tau = 2;
C = 1;
I = N_B/a;
dt = 1/1000;
k = 1;
S2 = 0;

for j = 1:length(I)
    for i = 1:500
       if(Vnb(k)>V_th)
            Vnb(k+1) = Vo;
            S2(k+1) = 1;
       else
            Vnb(k+1) = Vnb(k) - ((Vnb(k) - Vo)*dt)/tau + I(j)*dt;
            S2(k+1) = 0;
       end
       k = k + 1;
    end
end

% Neuron 3
Vwt = -50;
Vo = -60;
V_th = 20;
tau = 2;
C = 1;
I = W_T/a;
dt = 1/1000;
k = 1;
S3 = 0;

for j = 1:length(I)
    for i = 1:500
       if(Vwt(k)>V_th)
            Vwt(k+1) = Vo;
            S3(k+1) = 1;
       else
            Vwt(k+1) = Vwt(k) - ((Vwt(k) - Vo)*dt)/tau + I(j)*dt;
            S3(k+1) = 0;
       end
       k = k + 1;
    end
end

% Neuron 4
Vnt = -50;
Vo = -60;
V_th = 20;
tau = 2;
C = 1;
I = N_T/a;
dt = 1/1000;
k = 1;
S4 = 0;

for j = 1:length(I)
    for i = 1:500
       if(Vnt(k)>V_th)
            Vnt(k+1) = Vo;
            S4(k+1) = 1;
       else
            Vnt(k+1) = Vnt(k) - ((Vnt(k) - Vo)*dt)/tau + I(j)*dt;
            S4(k+1) = 0;
       end
       k = k + 1;
    end
end

% Neuron 5
Vn = -50;
Vo = -60;
V_th = 20;
tau = 2;
C = 1;
I = N/a;
dt = 1/1000;
k = 1;
S5 = 0;

for j = 1:length(I)
    for i = 1:500
       if(Vn(k)>V_th)
            Vn(k+1) = Vo;
            S5(k+1) = 1;
       else
            Vn(k+1) = Vn(k) - ((Vn(k) - Vo)*dt)/tau + I(j)*dt;
            S5(k+1) = 0;
       end
       k = k + 1;
    end
end


T = linspace(30,120,length(Vn));

figure;
subplot(5,1,1);
plot(S1);
title("Wide Bradycardia");


subplot(5,1,2);
plot(S2);
title("Narrow Bradycardia");


subplot(5,1,3);
plot(S3);
title("Wide Tachycardia");


subplot(5,1,4);
plot(S4);
title("Narrow Tachycardia");


subplot(5,1,5);
plot(S5);
title("Normal");

