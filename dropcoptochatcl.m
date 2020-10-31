%Closed loop optogenetics with the DT9612

close all
clear all

%Output file
handles.output_file='C:\Users\Diego Restrepo\data\test.mat';

%Does it exist?
file_exists=exist(handles.output_file,'file');
run_program = 1;
if file_exists==2
    % Ask whether to overwrite
    choice = questdlg('File exists. Overwrite?', ...
        'Overwrite?', ...
        'Yes','No','No');
    % Handle response
    switch choice
        case 'Yes'
            
            run_program = 1;
        case 'No'
            
            run_program = 0;
            
    end
end

%If you want to find the device and what channels are available uncomment this
% devs=daq.getDevices;
% devs(1)

%Start the device
d=daq('dt');

%Add analog input
addinput(d,"DT9816(00)","0","Voltage")

%Acquire and show data before starting the triggers
handles.dt_before=5;
data=read(d,seconds(handles.dt_before),"OutputFormat","Matrix");
figure(1)
t=[1:length(data)]*0.001; %Note: the default acquisition frequency is 1 kHz
plot(t,data)
xlabel('Time (sec)')
ylabel('Volts')
title('Sniff data before peak generation')
handles.data_before=data;

%Add digital output
addoutput(d,"DT9816(00)","port0/line0","Digital")

%Turn off laser
write(d,0)

%Time between triggers (sec)
% handles.delta_t_between_triggers=60*5;
handles.delta_t_between_triggers=1;

%Duration of trigger
handles.delta_t_trigger=0.02;

%The program outputs a number of peaks (a burst of peaks) several times

%Number of peak bursts
handles.no_peak_bursts=6;

%Number of peaks detected per burst
handles.no_peaks=4*30;

%Sniff and peak data are saved here
handles.sniff_data=zeros(handles.no_peak_bursts,2,60*1000);  %Note that we use 60*1000, you may want to change this if you give many peaks
handles.sniff_data_ii=zeros(1,handles.no_peak_bursts);
handles.peaks=zeros(handles.no_peak_bursts,2,handles.no_peaks);

%Peaks are detected only if the signal is above the threshold
handles.threshold=0.4;


fprintf(1,'dropcoptochat started\n')

tic
% while toc<handles.delta_t_between_triggers
% end

for ii_peak_burst=1:handles.no_peak_bursts
    
    handles.sniff_data(ii_peak_burst,1,1)=read(d,1,"OutputFormat","Matrix");
    handles.sniff_data(ii_peak_burst,2,1)=toc;
    first_toc=handles.sniff_data(ii_peak_burst,2,1);
    ii=1;
    
    
    for peakNo=1:handles.no_peaks
        
        %Find the peak
        no_peak_found=1;
        last_slope=-2;
        while no_peak_found==1
            ii=ii+1;            
            handles.sniff_data(ii_peak_burst,1,ii)=read(d,1,"OutputFormat","Matrix");
            handles.sniff_data(ii_peak_burst,2,ii)=toc;
            this_slope=handles.sniff_data(ii_peak_burst,1,ii)-handles.sniff_data(ii_peak_burst,1,ii-1);
            if (this_slope<0)&(last_slope>0)&(handles.sniff_data(ii_peak_burst,1,ii-1)>handles.threshold)
                handles.peaks(ii_peak_burst,1,peakNo)=handles.sniff_data(ii_peak_burst,1,ii);
                handles.peaks(ii_peak_burst,2,peakNo)=handles.sniff_data(ii_peak_burst,2,ii);
                no_peak_found=0;
            end
            last_slope=this_slope;
        end
        
        %Turn on laser
        write(d,1)
        
        %Wait for trigger time
        this_tic=toc;
        while (toc-this_tic)<handles.delta_t_trigger
        end
        
        %Turn off laser
        write(d,0)
        
    end
    
    handles.sniff_data_ii(ii_peak_burst)=ii;
    
    %Show the peaks
    figure(ii_peak_burst+1)
    these_times=zeros(1,ii);
    these_times(1,:)=handles.sniff_data(ii_peak_burst,2,1:ii);
    these_sniffs=zeros(1,ii);
    these_sniffs(1,:)=handles.sniff_data(ii_peak_burst,1,1:ii);
    plot(these_times,these_sniffs,'-b')
    hold on
    these_times=zeros(1,handles.no_peaks);
    these_times(1,:)=handles.peaks(ii_peak_burst,2,:);
    these_peaks=zeros(1,handles.no_peaks);
    these_peaks(1,:)=handles.peaks(ii_peak_burst,1,:);
    plot(these_times,these_peaks,'or')
    title(['Sniffs and laser output for trigger No ' num2str(ii_peak_burst)])
    xlabel('Time (sec)')
    ylabel('Volts')

    %Wait between triggers
    
    while (toc-first_toc)<handles.delta_t_between_triggers
    end
        
end

save(handles.output_file,'handles')

daqreset

