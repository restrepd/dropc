%This is a test of microphone in
close all
clear all
dt=2.5; %Seconds per acquisition
freq=20000; %Acquisition rate

tic
%Create analog input object
ai=analoginput('winsound');

%Add channels
addchannel(ai,1:2);

%Set frequency
set(ai,'SampleRate',freq)
set(ai,'SamplesPerTrigger',freq*dt)

%Acquire data
start(ai)
data=getdata(ai);
plot(data)

%celan up
delete(ai)
clear ai
save('C:\Users\Olf2\Desktop\Steinke\ai_data2.mat','data')
toc