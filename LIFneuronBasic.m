Ax1=1;
Ax2=-1;
Ax3=2;
Ax4=-2;

%Taking user inputs to set neuron model parameters
synaptic_mode_prompt='Select synaptic integration mode: Type 0 for deterministic, 1 for stochastic.';
S=input(synaptic_mode_prompt);
leak_prompt='Enter signed leak value ';
leak=input(leak_prompt);
leak_reversal_mode_prompt='Select mode of leak: Type 0 for direct signed leak integration, 1 for leak reversal mode (direct signed leak integration if membrane potential is positive, reversal of the sign of leak if membrane potential is negative, and zero leak if membrane potential is zero.'; 
E=input(leak_reversal_mode_prompt);
leak_stochasticity_prompt='Select leak stochasticity mode: Type 0 for deterministic, 1 for stochastic.';
L=input(leak_stochasticity_prompt);
spike_threshold_prompt='Enter positive spike threshold value ';
spike_threshold=input(spike_threshold_prompt);
negative_threshold_prompt='Enter unsigned negative threshold value ';
negative_threshold=input(negative_threshold_prompt);
stochasticity_in_threshold_prompt='Enter maximum value of stochasticity of threshold (enter 0 for a completely deterministic threshold)';
max=input(stochasticity_in_threshold_prompt);
reset_potential_prompt='Enter an unsigned reset potential ';
reset_potential=input(reset_potential_prompt);
reset_mode_prompt='Select reset mode: Enter 0 for resetting membrane potential to the chosen signed reset potential, 1 for resetting to V(t)-V(threshold) and 2 for resetting to V(t), ie, no change in membrane potential after spiking';
reset_mode=input(reset_mode_prompt);
negative_reset_mode_prompt='Enter negative reset mode: Type 0 for bounce and 1 for saturate';
neg_reset=input(negative_reset_mode_prompt);
time_prompt='Enter total simulation time ';
timesteps=input(time_prompt);
numberofinput_prompt='Enter number of inputs ';
sizeofinput=input(numberofinput_prompt);
input_default=ones(1,sizeofinput);
weight_default=ones(1,sizeofinput);
axon_type_default=Ax1*ones(1,sizeofinput);
input_prompt='Enter input spike matrix, type "input_default" for the default ones matrix ';
weight_prompt='Enter weight matrix, type "weight_default" for the default ones matrix  ';
axon_type_prompt='Enter matrix containing axon types. Axons can be of type Ax1, Ax2, Ax3 and Ax4, type "axon_type_default" for the default matrix that sets all axons to type Ax1 ';

% input_spikes=input(input_prompt);
% weight=input(weight_prompt);
axon_type=input(axon_type_prompt);

v=zeros(1,timesteps+1);
spike=zeros(1,timesteps+1);
v(1)=reset_potential;

for time=1:timesteps
    
    input_spikes=input(input_prompt);
    weight=input(weight_prompt);
 
%Synaptic integration
for i=1:sizeofinput
        r1=randi([abs(axon_type(i))-3,abs(axon_type(i))+3],1);
if r1<abs(axon_type(i))
    F1=1;
else F1=0;
end
   v(time+1)=v(time+1)+input_spikes(i)*weight(i)*((1-S)*axon_type(i)+ S*F1*sign(axon_type(i)));
end

%Leak integration
r_leak=randi([abs(leak)-3,abs(leak)+3],1);
if r_leak<abs(leak)
    F2=1;
else F2=0;
end
   Z=(1-E)+E*sign(v(time+1));
    v(time+1)=v(time+1)+Z*((1-L)*leak+ L*F2*sign(leak));
        
%threshold, fire, reset
r_thresh=i([-max,max],1);
if reset_mode==0
    R=reset_potential;
    Rn=-reset_potential;
elseif reset_mode==1
    R=v(time+1)-(spike_threshold+r_thresh);
    Rn=v(time+1)+(negative_threshold+r_thresh);
elseif reset_mode==2
    R=v(time+1);
    Rn=v(time+1);
end
  
if v(time+1)>=(spike_threshold+r_thresh)
        spike(time+1)=1;
        v(time+2)=R;
elseif v(time+1)<-(negative_threshold*neg_reset+(negative_threshold+r_thresh)*(1-neg_reset))
       v(time+1)=-(negative_threshold*neg_reset)+Rn;
    v(time+2)=v(time+1);
else v(time+2)=v(time+1);
end
end
figure, plot(spike)
figure, plot(v)


        
    
    
           

