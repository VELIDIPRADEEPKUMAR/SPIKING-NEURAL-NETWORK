F = 30:120;
L = 12000;

S1 = interp1([30,130],[1,120],F);
S1_F = interp1([0,120],[120,1],S1);
in_S1 = zeros(length(S1_F),L);
k = 1;
for i = 1:length(S1_F) 
    k = 1;
    while(k<L) 
           in_S1(i,int32(k)) = 1;
           k = k + S1_F(i);
    end
end

S2 = interp1([0,60],[0,120],(F-60).*((F-60)>0));
S2_F = interp1([0,120],[120,1],S2);
in_S2 = zeros(length(S2_F),L);
k = 1;
for i = 1:length(S2_F) 
    k = 1;
    while(k<L) 
           in_S2(i,int32(k)) = 1;
           k = k + S2_F(i);
    end
end

S3 = interp1([0,30],[0,120],(60-F).*((60-F)>0));
S3_F = interp1([0,120],[120,1],S3);
k = 1;
in_S3 = zeros(length(S3_F),L);
for i = 1:length(S3_F) 
    k = 1;
    while(k<L) 
           in_S3(i,int32(k)) = 1;
           k = k + S3_F(i);
    end
end

B = S1*800 - S2*3000 + S3*1200;  % 2*(in_S1(j,i)*1200 - in_S2(j,i)*3200 + in_S3(j,i)*1800)
T = S1*700 + S2*500 - S3*800;   %2*(in_S1(j,i)*700 + in_S2(j,i)*500 - in_S3(j,i)*800)
N = S1*3200 - S2*3200 - S3*3200; % 2*(in_S1(j,i)*20700 - in_S2(j,i)*21700 - in_S3(j,i)*3200)

% Neuron 1
Vb = zeros(1,L*length(S1_F));
Vo = -60;
V_th = 20;
tau = 2;
C = 1;
I = B/200;
dt = 1/1000;
k = 1;
S1 = zeros(1,L*length(S1_F));

for j = 1:length(S1_F)
    for i = 1:L
       if(Vb(k)>V_th)
            Vb(k+1) = Vo;
            S1(k+1) = 1;
       else
            Vb(k+1) = Vb(k) - ((Vb(k) - Vo)*dt)/tau + 2*(in_S1(j,i)*1200 - in_S2(j,i)*3200 + in_S3(j,i)*1800)*dt;
            S1(k+1) = 0;
       end
       k = k + 1;
    end
end



% Neuron 2
Vt = zeros(1,L*length(S2_F));
Vo = -60;
V_th = 20;
tau = 2;
C = 1;
I = B/200;
dt = 1/1000;
k = 1;
S2 = zeros(1,L*length(S2_F));

for j = 1:length(S2_F)
    for i = 1:L
       if(Vt(k)>V_th)
            Vt(k+1) = Vo;
            S2(k+1) = 1;
       else
            Vt(k+1) = Vt(k) - ((Vt(k) - Vo)*dt)/tau + 2*(in_S1(j,i)*700 + in_S2(j,i)*600 - in_S3(j,i)*800)*dt;
            S2(k+1) = 0;
       end
       k = k + 1;
    end
end

% Neuron 3
Vn = zeros(1,L*length(S3_F));
Vo = -60;
V_th = 20;
tau = 2;
C = 1;
I = B/200;
dt = 1/1000;
k = 1;
S3 = zeros(1,L*length(S1_F));

for j = 1:length(S3_F)
    for i = 1:L
       if(Vn(k)>V_th)
            Vn(k+1) = Vo;
            S3(k+1) = 1;
       else
            Vn(k+1) = Vn(k) - ((Vn(k) - Vo)*dt)/tau + 2*(in_S1(j,i)*20700 - in_S2(j,i)*22400 - in_S3(j,i)*900)*dt;
            S3(k+1) = 0;
       end
       k = k + 1;
    end
end

T = linspace(30,120,length(Vb));

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

%%

QRS = zeros(1,length(F)) + 160;

S4 = interp1([0,60],[0,120],(QRS-120).*((QRS-120)>0));
S4_F = interp1([0,120],[120,1],S4);
k = 1;
in_S4 = zeros(length(S4_F),L);
for i = 1:length(S4_F) 
    k = 1;
    while(k<L) 
           in_S4(i,int32(k)) = 1;
           k = k + S4_F(i);
    end
end

S5 = interp1([0,60],[0,120],(120-QRS).*((120-QRS)>0)); 
S5_F = interp1([0,120],[120,1],S5);
k = 1;
in_S5 = zeros(length(S5_F),L);
for i = 1:length(S5_F) 
    k = 1;
    while(k<L) 
           in_S5(i,int32(k)) = 1;
           k = k + S5_F(i);
    end
end

% Neuron 1
Vnb = zeros(1,L*length(S1_F));
Vo = -60;
V_th = 20;
tau = 2;
C = 1;
I = B/200;
dt = 1/1000;
k = 1;
Sb1 = zeros(1,L*length(S4_F));

for j = 1:length(S4_F)
    for i = 1:L
       if(Vnb(k)>V_th)
            Vnb(k+1) = Vo;
            Sb1(k+1) = 1;
       else
            Vnb(k+1) = Vnb(k) - ((Vnb(k) - Vo)*dt)/tau + 2*(S1(k)*32000 - S2(k)*90000 - S3(k)*60000 + in_S5(j,i)*5200 - in_S4(j,i)*18500)*dt;
            Sb1(k+1) = 0;
       end
       k = k + 1;
    end
end

% Neuron 2
Vwb = zeros(1,L*length(S1_F));
Vo = -60;
V_th = 20;
tau = 2;
C = 1;
I = B/200;
dt = 1/1000;
k = 1;
Sb2 = zeros(1,L*length(S4_F));

for j = 1:length(S4_F)
    for i = 1:L
       if(Vwb(k)>V_th)
            Vwb(k+1) = Vo;
            Sb2(k+1) = 1;
       else
            Vwb(k+1) = Vwb(k) - ((Vwb(k) - Vo)*dt)/tau + 2*(S1(k)*32000 - S2(k)*90000 - S3(k)*80000 - in_S5(j,i)*18500 + in_S4(j,i)*5200)*dt;
            Sb2(k+1) = 0;
       end
       k = k + 1;
    end
end

% Neuron 3
Vnt = zeros(1,L*length(S1_F));
Vo = -60;
V_th = 20;
tau = 2;
C = 1;
I = B/200;
dt = 1/1000;
k = 1;
St1 = zeros(1,L*length(S4_F));

for j = 1:length(S4_F)
    for i = 1:L
       if(Vnt(k)>V_th)
            Vnt(k+1) = Vo;
            St1(k+1) = 1;
       else
            Vnt(k+1) = Vnt(k) - ((Vnt(k) - Vo)*dt)/tau + 2*(-S1(k)*95000 + S2(k)*82000 - S3(k)*60000 + in_S5(j,i)*6200 - in_S4(j,i)*18500)*dt;
            St1(k+1) = 0;
       end
       k = k + 1;
    end
end

% Neuron 4
Vwt = zeros(1,L*length(S1_F));
Vo = -60;
V_th = 20;
tau = 2;
C = 1;
I = B/200;
dt = 1/1000;
k = 1;
St2 = zeros(1,L*length(S4_F));

for j = 1:length(S4_F)
    for i = 1:L
       if(Vwt(k)>V_th)
            Vwt(k+1) = Vo;
            St2(k+1) = 1;
       else
            Vwt(k+1) = Vwt(k) - ((Vwt(k) - Vo)*dt)/tau + 2*(-S1(k)*95000 + S2(k)*82000 - S3(k)*60000 - in_S5(j,i)*18500 + in_S4(j,i)*6200)*dt;
            St2(k+1) = 0;
       end
       k = k + 1;
    end
end

% Neuron 5
Vn = zeros(1,L*length(S1_F));
Vo = -60;
V_th = 20;
tau = 2;
C = 1;
I = B/200;
dt = 1/1000;
k = 1;
Sn = zeros(1,L*length(S4_F));

for j = 1:length(S4_F)
    for i = 1:L
       if(Vn(k)>V_th)
            Vn(k+1) = Vo;
            Sn(k+1) = 1;
       else
            Vn(k+1) = Vn(k) - ((Vn(k) - Vo)*dt)/tau + 2*(-S1(k)*4000 - S2(k)*4000 + S3(k)*50000 + in_S5(j,i)*0 - in_S4(j,i)*0)*dt;
            Sn(k+1) = 0;
       end
       k = k + 1;
    end
end

figure;
subplot(5,1,1);
plot(T,Sb2);
title("Neuron Spikes Tuned for wide Bradycardia");
xlabel("Freq(F)");
ylabel("Spikes");

subplot(5,1,2);
plot(T,Sb1);
title("Neuron Spikes Tuned for narrow Bradycardia");
xlabel("Freq(F)");
ylabel("Spikes");

subplot(5,1,3);
plot(T,St1);
title("Neuron Spikes Tuned for narrow Normal case");
xlabel("Freq(F)");
ylabel("Spikes");

subplot(5,1,4);
plot(T,St2);
title("Neuron Spikes Tuned for wide Normal case");
xlabel("Freq(F)");
ylabel("Spikes");

subplot(5,1,5);
plot(T,Sn);
title("Normal");
xlabel("Freq(F)");
ylabel("Spikes");

%% SNN With QRS and RR Inputs 

F = 25:120;
QRS = zeros(1,length(F)) + 160;
L = 1200;

S1 = interp1([30,130],[1,120],F);
S1_F = interp1([0,120],[120,1],S1);
in_S1 = zeros(length(S1_F),L);
k = 1;
for i = 1:length(S1_F) 
    k = 1;
    while(k<L) 
           in_S1(i,int32(k)) = 1;
           k = k + S1_F(i);
    end
end

S2 = interp1([0,60],[0,120],(F-60).*((F-60)>0));
S2_F = interp1([0,120],[120,1],S2);
in_S2 = zeros(length(S2_F),L);
k = 1;
for i = 1:length(S2_F) 
    k = 1;
    while(k<L) 
           in_S2(i,int32(k)) = 1;
           k = k + S2_F(i);
    end
end

S3 = interp1([0,30],[0,120],(60-F).*((60-F)>0));
S3_F = interp1([0,120],[120,1],S3);
k = 1;
in_S3 = zeros(length(S3_F),L);
for i = 1:length(S3_F) 
    k = 1;
    while(k<L) 
           in_S3(i,int32(k)) = 1;
           k = k + S3_F(i);
    end
end

S4 = interp1([0,60],[0,120],(QRS-120).*((QRS-120)>0));
S4_F = interp1([0,120],[120,1],S4);
k = 1;
in_S4 = zeros(length(S4_F),L);
for i = 1:length(S4_F) 
    k = 1;
    while(k<L) 
           in_S4(i,int32(k)) = 1;
           k = k + S4_F(i);
    end
end

S5 = interp1([0,60],[0,120],(120-QRS).*((120-QRS)>0)); 
S5_F = interp1([0,120],[120,1],S5);
k = 1;
in_S5 = zeros(length(S5_F),L);
for i = 1:length(S5_F) 
    k = 1;
    while(k<L) 
           in_S5(i,int32(k)) = 1;
           k = k + S5_F(i);
    end
end

W_B = S1*3000 - S2*12000 + S3*3600 + S4*3000 - S5*5000;
N_B = S1*3000 - S2*12000 + S3*3600 - S4*5000 + S5*3000;

W_T = S1*2100 + S2*1500 - S3*8000 + S4*3000 - S5*5000; 
N_T = S1*2100 + S2*1500 - S3*8000 - S4*5000 + S5*3000; 

N = S1*14000 - S2*10800 - S3*10800 - S4*0 - S5*0;

% Neuron 1
Vb = zeros(1,L*length(S1_F));
Vo = -60;
V_th = 20;
tau = 2;
C = 1;
I = B/200;
dt = 1/1000;
k = 1;
S1 = zeros(1,L*length(S1_F));

for j = 1:length(S1_F)
    for i = 1:L
       if(Vb(k)>V_th)
            Vb(k+1) = Vo;
            S1(k+1) = 1;
       else
            Vb(k+1) = Vb(k) - ((Vb(k) - Vo)*dt)/tau + 2*(in_S1(j,i)*3000 - in_S2(j,i)*12000 + in_S3(j,i)*4600 + in_S4(j,i)*3000 - in_S5(j,i)*5000)*dt;
            S1(k+1) = 0;
       end
       k = k + 1;
    end
end

T = linspace(30,120,length(Vb));

figure;
plot(T,S1);