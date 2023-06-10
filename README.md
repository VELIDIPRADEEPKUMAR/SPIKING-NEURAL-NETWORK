# SPIKING-NEURAL-NETWORK
Arrhythmia is a common heart condition affecting millions of people in India, and real-
time detection is critical for timely treatment and prevention of complications. How-
ever, real-time analysis can pose challenges in terms of power consumption. Therefore,
in this work, we propose a novel approach for efficient computation by designing dig-
ital circuits inspired by neuromorphic technology. Our goal is to detect arrhythmias,
such as "Atrial-fibrillation," "Tachycardia," and "Bradycardia," from electrocardiogram
(ECG) signals. To achieve this, we use a digitally developed AdEx neuron model to
encode ECG signals in the form of spikes for processing. Three main features, includ-
ing "RR" interval, "QRS" interval, and randomness in the RR interval, are utilized to
detect arrhythmias from the ECG signal. For estimating randomness in the RR interval,
we have implemented a custom circuit that computes the Shannon entropy and variance
for 128 samples of the RR intervals. In the final stage of our approach, we employ an
AdEx neuron-based spiking neural network for the decision process of determining the
arrhythmia from the extracted features. Our method has been optimized for real-time
processing while minimizing power consumption. Overall, this work presents a promis-
ing solution for real-time arrhythmia detection from ECG signals using neuromorphic
ASIC technology. Our proposed approach has the potential to improve the accuracy
and speed of arrhythmia diagnosis, leading to timely treatment and improved patient
outcomes.

## System Architecture

The goal of our research was to classify different types of arrhythmia using a neuro-
morphic system that we designed. Our system architecture, illustrated in Fig., is
complex and involves several stages. Firstly, we encoded the ECG signal into a spike
train by employing an AdEx neuron. Secondly, we used a timing extraction circuit
to extract the RR and QRS intervals from the encoded ECG signal. Additionally, we
used a custom randomness estimator circuit to determine the third feature, which is the
RR interval randomness. Finally, we used a Spiking Neural Network to classify the
arrhythmia by analyzing the three features.

![System Architecture](SPIKING-NEURAL-NETWORK/sys_arch.png)


##Encoding ECG Signal
To encode ECG into Spikes we used an AdEx (Adaptive Exponential Integrate-and-
Fire) Neuron model. It is designed to capture the adaptive firing properties of real neu-
rons and is often used in neuromorphic computing to encode signals into spike trains.

### Dynamics of Modified AdEx Neuron Model
Here We are presenting our modified AdEx neuron equations, these are final Difference
equations representing AdEx neuron dynamics with all digital approximations.

vn+1 = vn − (dt/C)*gL*vn + (dt/C)*gL*EL + E + ( dt/C K2)*I − (dt/CK1)*ωn ----> (3.1)

en = en−1(1 + ∆v + (∆v^2)/2! ) ----> (3.2)

ωn+1 = ωn + (dt/τω)*a*K1*(vn − EL) − (dt/τω)*ωn ----> (3.3)

E = (dt/C)*gL*∆T*en ----> (3.4)

where "ω" stands for the adaptation variable, and "v" represents the membrane po-
tential. The input current is indicated by "I", The letters "C", "gL”, ”EL”, ”VT ”, ”ΔT ",

and "a" stand for the membrane capacitance, leak conductance, leak reversal potential,
threshold, and slope factor, respectively.
From a MATLAB simulation, We find out that the range of ’v’ and ’ω’ are in mV
and nV respectively. Because of the two different voltage ranges, resource consumption
will increase.
In order to keep the resource consumption minimum, numerical modeling is adopted
by using 2 constants K1 and K2, where K1 accounts for ω, which brings the voltage
range from nV to mV, whereas the constant K2 brings scales up the current from nA to
mA.

### Digital Implementation

As we know from chapter 2 that AdEx neuron model has 2 variables, but with our
approximation, we had 3 variables now, namely membrane potential (V), Adaptation
variable (ω), and Exponential variable (E).

So, to implement the difference equations(3.1)(3.2)(3.3)(3.4), we construed digital
hardware that functions sequence to compute the difference equations. The architecture
for the digital circuit is shown in FIG:-2.1. There are 3 registers namely ω, V and E
used to emulate the neuron dynamics.

fIGURE //

## Randomness Estimation Algorithm

The aim of this stage is to quantify the randomness in the RR interval. So, we adapted
two techniques, namely Shannon entropy, and variance. Fig 3.3 shows the flow diagram
of the Randomness finding algorithm. Which uses a moving window of RR 128 samples
of intervals.

fIG 

Also, we are using symbolic dynamics to describe the dynamic behavior of RR
interval which was first introduced in paper [2]. Symbolic dynamics is a technique that
transforms the information of RR variability into a series of fewer symbols, where each
symbol represents a particular state of the RR interval. Below is the function eq-3.5
which transforms the RR interval into symbols.

symn = 63 if RR > 504 
          else ⌊RR⌋      ----> (3.5)

where ⌊.⌋ is a floor function. Now, by using these symbols we will generate word
sequence Wn. The exploring of the chaotic behavior of the symbolic series symn to
generate different instantaneous states of RR by applying a 3-symbols template and
examining its entropic properties. The value of the word Wn can be calculated using
Eq-3.6.

Wn = (symn−2 ∗ 2^12) + (symn−1 ∗ 2^6) + symn  ----> (3.6)

## Spiking Neural Network 
Spiking Neural Networks (SNNs) are a type of artificial neural network inspired by the
way neurons communicate and process information in the brain. Unlike traditional ar-
tificial neural networks, which rely on continuous activation values, SNNs operate on
discrete-time spikes or impulses, allowing them to better model the asynchronous and
event-driven nature of biological neural networks.SNN consume less power compared
to traditional neural networks due to their event-driven nature. In SNNs, neurons com-
municate through spikes, which are discrete, brief electrical pulses that are triggered
only when the neuron receives enough input to exceed a certain threshold. This sparsity
of spikes means that SNNs can have much lower activity and use less power.

Fig 

The Two-layered Spiking Neural Network was modeled with input signals including
RR, RR-N, N-RR, QRS - 120, 120 - QRS, Shanon entropy, and Variance for the pur-
pose of classifying arrhythmia. The input layer extracts features of tachycardia, bradycardia, and normal arrhythmia, which are then fed to the final layer along with QRS interval features. The final layer classifies arrhythmia into five classes of arrhythmia namely Wide tachycardia, Narrow Tachycardia, wide bradycardia, narrow bradycardia,
and normal case by using neurons from No1 to No5. This two-layer architecture simpli-
fies weight tuning and improves classification accuracy. Also, there was an additional
neuron (No6) for classifying atrial fibrillation using Shannon entropy and variance of
RR interval. The entire system is illustrated in Figure 3.4.
