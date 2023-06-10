% shanon Entropy

clear;clc;
RR_ = load('04043.txt');
RR1 = RR_;
SE = zeros(length(RR1),1);
L = 256;
T = 0;

for i = L:length(RR1) 

    P = hist(RR1(i-L+1:i),L);
    P = P/sum(P);
    P = P + (P==0);
    %P(T+1:L-T) = zeros(L-(2*T),1) + 1;
    SE(i) = -sum(P.*log2(P));

end

j = 1;
SE1 = zeros(length(RR1),1);
L = 128;

while (j+L-1) < length(RR1)
 
    P1 = hist(RR1(j:j+L-1),L);
    j = j + L;
    P1 = P1/sum(P1) + (P1==0);
    SE1(j:j+L-1) = zeros(L,1) - sum(P1.*log2(P1));
  
end

figure;
subplot(4,1,1);
plot(RR1);

subplot(4,1,2);
plot(SE>4)

subplot(4,1,3);
plot(SE);
hold on 
plot(zeros(length(RR1),1)+4.5)
hold off

subplot(4,1,4);
plot(SE1);
hold on 
plot(zeros(length(RR1),1)+5)
hold off

% subplot(4,1,4);
% plot(SE1(1:length(RR1)).*SE);


%% RMS of RR difference 

D_RR = RR1(1:length(RR1)-1) - RR1(2:length(RR1));

RMS = zeros(length(D_RR),1);
L = 256;

for i = L:length(D_RR) 
    RMS(i) = sqrt(sum(D_RR(i-L+1:i).^2)/L);
end


RMS1 = zeros(length(D_RR),1);
L = 256;
j = 1;

while j+L-1 < length(D_RR) 
    RMS1(j:j+L-1) = zeros(L,1) + sqrt(sum(D_RR(j:j+L-1).^2)/L);
    j = j + L;
end

figure;
subplot(4,1,1);
plot(RR1);

subplot(4,1,2);
plot(RMS>25)

subplot(4,1,3);
plot(RMS);
hold on 
plot(zeros(length(RR1),1)+25)
hold off

subplot(4,1,4);
plot(RMS1);
hold on 
plot(zeros(length(RR1),1)+25)
hold off


%% Variance of RR  
% 
% VAR = zeros(length(RR1),1);
% M = zeros(length(RR1),1);
% L = 64;
% A 
% for i = L:length(RR1) 
%     VAR(i) = sqrt(sum((mean(RR1(i-L+1:i)) - RR1(i-L+1:i)).^2)/L);
%     M(i) = mean(mean(RR1(i-L+1:i))); 
% end
% 
% VAR1 = zeros(length(RR1),1);
% L = 64;
% j = 1;
% 
% while j+L-1 < length(RR1) 
%     VAR1(j:j+L-1) = zeros(L,1) + sqrt(sum((mean(RR1(j:j+L-1)) - RR1(j:j+L-1)).^2)/L);
%     j = j + L;
% end
% 
% figure;
% subplot(4,1,1);
% plot(RR1);
% 
% subplot(4,1,2);
% plot((M - RR1)./VAR)
% 
% subplot(4,1,3);
% plot(VAR);
% hold on 
% plot(zeros(length(RR1),1)+25)
% hold off
% 
% subplot(4,1,4);
% plot(VAR1);
% hold on 
% plot(zeros(length(RR1),1)+25)
% hold off

%% Zhou shanon entropy 

clear;clc;
RR_ = load('04048.txt');
RR1 = zeros(length(RR_),1);
N = 127;  
L = N;
RR1 = RR_(1000:4000);
SE = zeros(length(RR1),1);
        %%%%%%%%%%% Shanon Entropy %%%%%%%%%%%%

for i = L:length(RR1)

    S_BPS = floor((RR1(i-L+1:i).*(RR1(i-L+1:i)<315) + (RR1(i-L+1:i)>315)*315)/5);
    W = (S_BPS(3:length(S_BPS))) + (S_BPS(2:length(S_BPS)-1)*(2^6)) + (S_BPS(1:length(S_BPS)-2)*(2^12));
    P = hist(W,N);
    P = P/sum(P) + (P==0);
    SE(i) = -((sum(P~=1))*sum(P.*log2(P))/N)/log2(N);

end

        %%%%%%%%%%%%% RMS Diff of RR %%%%%%%%%%%%%

D_RR = RR1(1:length(RR1)-1) - RR1(2:length(RR1));

RMS = zeros(length(D_RR),1);
L = 256;

for i = L:length(D_RR) 
    RMS(i) = sqrt(sum(D_RR(i-L+1:i).^2)/L);
end

%figure;
%plot(SE)

         %%%%%%%%%%%%%%% SNN  %%%%%%%%%%%%%%%%%%%%%%

L = 120;

S1 = interp1([0,0.4],[1,120],SE(1:length(SE)-1));
S1 = interp1([0,120],[120,1],S1);
in_S1 = zeros(length(S1),L);
k = 1;
for i = 1:length(S1) 
    k = 1;
    while(k<L) 
           in_S1(i,int32(k)) = 1;
           k = k + S1(i);
    end
end

S2 = interp1([0,40],[1,120],RMS);
S2 = interp1([0,120],[120,1],S2);
in_S2 = zeros(length(S2),L);
k = 1;
for i = 1:length(S2) 
    k = 1;
    while(k<L) 
           in_S2(i,int32(k)) = 1;
           k = k + S2(i);
    end
end

AF = in_S1*30000 + in_S2*3000;

% Neuron 1
Vb = zeros(1,L*length(S1));
Vo = -60;
V_th = 20;
tau = 2;
C = 1;
I = AF;
dt = 1/1000;
k = 1;
S1 = zeros(1,L*length(S1));

for j = 1:length(S2)
    for i = 1:L
       if(Vb(k)>V_th)
            Vb(k+1) = Vo;
            S1(k+1) = 1;
       else
            Vb(k+1) = Vb(k) - ((Vb(k) - Vo)*dt)/tau + 2*(in_S1(j,i)*1000 + in_S2(j,i)*300)*dt;
            S1(k+1) = 0;
       end
       k = k + 1;
    end
end

figure;
subplot(4,1,1);
plot(RR1);

subplot(4,1,2);
plot(SE);

subplot(4,1,3);
plot(RMS);

subplot(4,1,4);
plot(S1)

%%  

Exp = exprnd()