function dropcReinforceAppropriately(handles)
%Turns all valves off

do_dt_punish=0;

if handles.dropcProg.typeOfOdor==handles.dropcProg.splusOdor
    %S+
    if handles.dropcData.trialScore(handles.dropcData.trialIndex)==1

        %Hit
        handles.dropcDigOut.draqPortStatus=handles.dropcDraqOut.hit+handles.dropcDraqOut.draq_trigger;
        dropcUpdateDraqPort(handles);
        start_toc=toc;
        while toc-start_toc<0.2
        end
        
        
        if rand(1)<=handles.dropcProg.fracReinforcement(1)
            
            %Turn on (or not) opto stimulus during reinforcement
            opto_on=0;
            handles.dropcData.allTrialOptoOn(handles.dropcData.allTrialIndex+1)=0;
            
            %Send out light pulse
            if (handles.dropcProg.whenOptoOn==3)

                dataValue=uint8(0);
                putvalue(handles.dio.Line(9:12),dataValue);
                opto_on=1;
                handles.dropcData.allTrialOptoOn(handles.dropcData.allTrialIndex+1)=1;
        
                
            end
            
            %Notify draq
            if opto_on==0
                handles.dropcDigOut.draqPortStatus=handles.dropcDraqOut.final_valve;
            else
                handles.dropcDigOut.draqPortStatus=handles.dropcDraqOut.final_valve+handles.dropcDraqOut.opto_on;
            end
            dropcUpdateDraqPort(handles);
            
            dropcReinforceNow(handles);
            handles.dropcData.isReinforced(handles.dropcData.trialIndex)=1;
            
        else
            handles.dropcData.isReinforced(handles.dropcData.trialIndex)=0;
        end
        
    else

        %Miss
        handles.dropcDigOut.draqPortStatus=handles.dropcDraqOut.miss+handles.dropcDraqOut.draq_trigger;
        dropcUpdateDraqPort(handles);

        start_toc=toc;
        while toc-start_toc<0.2
        end

        handles.dropcData.isReinforced(handles.dropcData.trialIndex)=0;

    end

end

if handles.dropcProg.typeOfOdor==handles.dropcProg.sminusOdor
    %S-

    if (handles.dropcProg.go_nogo==1)

        %This is a go_nogo
        if handles.dropcData.trialScore(handles.dropcData.trialIndex)==0

            %Correct Rejection
            handles.dropcDigOut.draqPortStatus=handles.dropcDraqOut.correct_rejection+handles.dropcDraqOut.draq_trigger;
            dropcUpdateDraqPort(handles);

            start_toc=toc;
            while toc-start_toc<0.2
            end

            if rand(1)<=handles.dropcProg.fracReinforcement(2)


                reinforceNow(handles);
                handles.dropcData.isReinforced(handles.dropcData.trialIndex)=1;

            else
                handles.dropcData.isReinforced(handles.dropcData.trialIndex)=0;
            end

        else

            %False Alarm
            handles.dropcDigOut.draqPortStatus=handles.dropcDraqOut.false_alarm+handles.dropcDraqOut.draq_trigger;
            dropcUpdateDraqPort(handles);

            start_toc=toc;
            while toc-start_toc<0.2
            end

            if handles.dropcProg.dt_punish>0
                do_dt_punish=1;
            end
                
            handles.dropcData.isReinforced(handles.dropcData.trialIndex)=0;

        end

    else

        %This is a go_go
        if handles.dropcData.trialScore(handles.dropcData.trialIndex)==0

            %Correct Rejection

            handles.dropcDigOut.draqPortStatus=handles.dropcDraqOut.correct_rejection+handles.dropcDraqOut.draq_trigger;
            dropcUpdateDraqPort(ohandles);

            start_toc=toc;
            while toc-start_toc<0.2
            end

            handles.dropcData.isReinforced(handles.dropcData.trialIndex)=0;


        else

            %False Alarm

            handles.dropcDigOut.draqPortStatus=handles.dropcDraqOut.false_alarm+handles.dropcDraqOut.draq_trigger;
            dropcUpdateDraqPort(handles);

            start_toc=toc;
            while toc-start_toc<0.2
            end

            handles.dropcData.isReinforced(handles.dropcData.trialIndex)=0;

            if rand(1)<=handles.dropcProg.fracReinforcement(2)


                dropcReinforceNow(handles);
                handles.dropcData.isReinforced(handles.dropcData.trialIndex)=1;

            else
                handles.dropcData.isReinforced(handles.dropcData.trialIndex)=0;

            end
        end
    end
end% end of S-

%Extremely important. If you do not do this you do not transfer all
%trials to the draq computer
dropcStartDraq(handles)

%This turns all off
handles.dropcDigOut.draqPortStatus=uint8(0);
dropcUpdateDraqPort(handles);

if do_dt_punish==1
    start_toc=toc;
    while toc-start_toc<handles.dropcProg.dt_punish
    end
end



