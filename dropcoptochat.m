handles.dropcProg.output_file='C:\Users\Diego Restrepo\data\test.mat';


%% Then do all that needs to be done before the experiment starts
file_exists=exist(handles.dropcProg.output_file,'file');
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

%Create the digital I/O object dio
%The installed adaptors and hardware IDs are found with daqhwinfo
handles.dio = digitalio('dtol',0);

%Add digital output
addline(handles.dio,8:15,'out');

%Turn off laser
putvalue(handles.dio.Line(1:8),uint8(0));

%Time between triggers (sec)
delta_t_between_triggers=60*5;

%Duration of trigger
delta_t_trigger=1;

%Number of triggers
no_triggers=6;

fprintf(1,'dropcoptochat started\n')

tic
while toc<delta_t_between_triggers
end

for ii=1:no_triggers
    
    
    %Turn on laser
    putvalue(handles.dio.Line(1:8),uint8(255));
    
    %Wait for trigger time
    this_tic=toc;
    while (toc-this_tic)<delta_trigger
    end
    
    %Turn off laser
    putvalue(handles.dio.Line(1:8),uint8(0));
    
    fprintf(1,'Trigger No %d at time %d\n', ii,toc)
     
    %Wait between triggers
    this_tic=toc;
    while (toc-this_tic)<(delta_t_between_triggers-delta_trigger)
    end

   
end



