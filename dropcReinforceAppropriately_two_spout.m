function dropcReinforceAppropriately_two_spout(handles,left_right,trialResult)
%Turns all valves off

do_dt_punish=0;

switch handles.dropcProg.reward_location_vs_odor
    case 0
        %This is begin
        if trialResult==1
            
            
            %Hit
            handles.dropcDigOut.draqPortStatus=handles.dropcDraqOut.hit+handles.dropcDraqOut.draq_trigger;
            dropcUpdateDraqPort(handles);
            start_toc=toc;
            while toc-start_toc<0.2
            end
            
            
            if rand(1)<=handles.dropcProg.fracReinforcement(1)
                
                
                
                %Notify draq
                %         if opto_on==0
                handles.dropcDigOut.draqPortStatus=handles.dropcDraqOut.final_valve;
                %         else
                %             handles.dropcDigOut.draqPortStatus=handles.dropcDraqOut.final_valve+handles.dropcDraqOut.opto_on;
                %         end
                dropcUpdateDraqPort(handles);
                
                dropcReinforceNow_two_spout(handles,left_right);
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
        
    case 1
        %Reward on odor
        if handles.dropcProg.rewarded_odor_side==left_right
            if trialResult==1
                
                
                %Hit
                handles.dropcDigOut.draqPortStatus=handles.dropcDraqOut.hit+handles.dropcDraqOut.draq_trigger;
                dropcUpdateDraqPort(handles);
                start_toc=toc;
                while toc-start_toc<0.2
                end
                
                
                if rand(1)<=handles.dropcProg.fracReinforcement(1)
                    
                    
                    
                    %Notify draq
                    %         if opto_on==0
                    handles.dropcDigOut.draqPortStatus=handles.dropcDraqOut.final_valve;
                    %         else
                    %             handles.dropcDigOut.draqPortStatus=handles.dropcDraqOut.final_valve+handles.dropcDraqOut.opto_on;
                    %         end
                    dropcUpdateDraqPort(handles);
                    
                    dropcReinforceNow_two_spout(handles,left_right);
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
        else
            handles.dropcData.isReinforced(handles.dropcData.trialIndex)=0;
        end
        
    case 2
        %Reward on spout location
        
        if handles.dropcProg.reward_left_vs_right==left_right
            if trialResult==1
                
                
                %Hit
                handles.dropcDigOut.draqPortStatus=handles.dropcDraqOut.hit+handles.dropcDraqOut.draq_trigger;
                dropcUpdateDraqPort(handles);
                start_toc=toc;
                while toc-start_toc<0.2
                end
                
                
                if rand(1)<=handles.dropcProg.fracReinforcement(1)
                    
                    
                    
                    %Notify draq
                    %         if opto_on==0
                    handles.dropcDigOut.draqPortStatus=handles.dropcDraqOut.final_valve;
                    %         else
                    %             handles.dropcDigOut.draqPortStatus=handles.dropcDraqOut.final_valve+handles.dropcDraqOut.opto_on;
                    %         end
                    dropcUpdateDraqPort(handles);
                    
                    dropcReinforceNow_two_spout(handles,left_right);
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
        else
            %Mouse licked on the wrong spout
            handles.dropcData.isReinforced(handles.dropcData.trialIndex)=0;
        end
end



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



