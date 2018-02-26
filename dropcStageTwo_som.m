function handles = dropcStageTwo_som(handles)
%Begin stage 1: Give mouse water if they lick!

while handles.dropcData.trialIndex<160
    
    
    %Do one trial
    handles.dropcData.trialIndex=handles.dropcData.trialIndex+1;
    trialNo=handles.dropcData.trialIndex
    
    %Now run the trial
    resultOfTrial=-2;
    while (resultOfTrial == -2)
        %While mouse is doing short samples
        
        %Wait till the mouse pokes into the sampling chamber
        while (dropcNosePokeNow(handles)==0)
        end
        
        if (dropcStimulateWhiskerBegin(handles)==1)
            %This mouse stayed on during the final valve; do the
            %single trial!
            
            
            trialResult=dropcDoesMouseRespondNow(handles);
            handles.dropcData.trialTime(handles.dropcData.trialIndex)=toc;
            
            if (trialResult~=2)
                dropcTurnValvesOffNow(handles);
                handles.dropcData.odorType(handles.dropcData.trialIndex)=handles.dropcProg.typeOfOdor;
                handles.dropcData.odorValve(handles.dropcData.trialIndex)=handles.dropcProg.odorValve;
                handles.dropcData.trialScore(handles.dropcData.trialIndex)=trialResult;
                handles.dropcData.trialTime(handles.dropcData.trialIndex)=toc;
                
                dropcReinforceAppropriately(handles);
                
                %Mouse must leave
                while dropcNosePokeNow(handles)==1
                end
                
                result_of_trial=trialResult
                resultOfTrial=1;
            else
                
                %This is a short trial that ended after odor onset
                
                %Notify draq
                if handles.dropcProg.sendShorts==1
                    %Send a short
                    %                             handles.dropcDigOut.draqPortStatus=handles.dropcDraqOut.short_after+handles.dropcDraqOut.draq_trigger;
                    %                             dropcUpdateDraqPort(handles);
                    %
                    %                             start_toc=toc;
                    %                             while toc-start_toc<0.2
                    %                             end
                    %
                    %Extremely important. If you do not do this you do not transfer all
                    %trials to the draq computer
                    dropcStartDraq(handles)
                else
                    pause(handles.dropcProg.timePerTrial)
                end
                
                disp('Short after odor onset')
                %                         start_toc=toc;
                %                         while toc-start_toc<handles.dropcProg.timePerTrial
                %                         end
                
                
                handles.dropcData.odorType(handles.dropcData.trialIndex)=handles.dropcProg.typeOfOdor;
                handles.dropcData.odorValve(handles.dropcData.trialIndex)=handles.dropcProg.odorValve;
                handles.dropcData.trialScore(handles.dropcData.trialIndex)=trialResult;
                handles.dropcData.trialTime(handles.dropcData.trialIndex)=toc;
                
                dropcTurnValvesOffNow(handles);
                resultOfTrial= -2;
                
            end
            
        else
            
            %This is a short trial because mouse was not poking at end of FinalValve
            %It ended before odor onset
            
            %Notify draq
            
            handles.dropcDigOut.draqPortStatus=handles.dropcDraqOut.short_before+handles.dropcDraqOut.odor_onset;
            dropcUpdateDraqPort(handles);
            
            start_toc=toc;
            while toc-start_toc<handles.dropcProg.shortTime+handles.dropcProg.noRAsegments*handles.dropcProg.dt_ra
            end
            
            handles.dropcData.odorType(handles.dropcData.trialIndex)=handles.dropcProg.typeOfOdor;
            handles.dropcData.odorValve(handles.dropcData.trialIndex)=handles.dropcProg.odorValve;
            handles.dropcData.trialScore(handles.dropcData.trialIndex)=3;
            handles.dropcData.trialTime(handles.dropcData.trialIndex)=toc;
            
            %Turn FinalValve towards the odor port: turn on odor...)
            dataValue=bitcmp(uint8(0));
            putvalue(handles.dio.Line(17:24),dataValue);
            %dropcTurnValvesOffNow(handles);
            resultOfTrial= -2;
        end
    end
    
    save(handles.dropcProg.output_file,'handles');
    
    %         %Now plot the data
    %         figure(2)
    %
    %         %Percent correct per block
    %         subplot(2,2,1)
    %
    %         if handles.dropcData.trialIndex>20
    %             for trialNo=1:handles.dropcData.trialIndex
    %                 if handles.dropcData.odorType(trialNo)==handles.dropcProg.splusOdor
    %                     if handles.dropcData.trialScore(trialNo)==1
    %                         correctTrial(trialNo)=1;
    %                     else
    %                         correctTrial(trialNo)=0;
    %                     end
    %                 else
    %                      if handles.dropcData.trialScore(trialNo)==1
    %                         correctTrial(trialNo)=0;
    %                     else
    %                         correctTrial(trialNo)=1;
    %                      end
    %                 end
    %             end
    %
    %             max_block=floor(handles.dropcData.trialIndex/20);
    %             for block=1:max_block
    %                percent_correct(block)= 100*sum(correctTrial((block-1)*20+1:block*20))/20;
    %             end
    %             blockNo=1:max_block;
    %             plot(blockNo,percent_correct,'x-r')
    %             xlim([0 9])
    %             ylim([40 110])
    %             ylabel('Begin stage 2: Percent correct')
    %             xlabel('Block No')
    %             title('Percent correct')
    %
    %         end
    %
    %
    %         %ITI
    %         subplot(2,2,2)
    %         if handles.dropcData.trialIndex>2
    %             ITI=handles.dropcData.trialTime(2:end)-handles.dropcData.trialTime(1:end-1);
    %             trialNoITI=(1:length(ITI));
    %             plot(trialNoITI,ITI,'ob')
    %             xlim([0 170])
    %             ylabel('ITI (sec)')
    %             xlabel('Trial No')
    %             title('Begin stage 2: Inter trial intervals')
    %
    %         end
    %
    %         %Responses
    %         subplot(2,1,2)
    %         trialNo=1:200;
    %         spodor=(handles.dropcData.odorValve==handles.dropcProg.splusOdor);
    %         spscores=handles.dropcData.trialScore(spodor);
    %         sptrials=trialNo(spodor);
    %         plot(sptrials,spscores,'-or')
    %         hold on
    %         smodor=(handles.dropcData.odorValve==handles.dropcProg.sminusOdor);
    %         smscores=handles.dropcData.trialScore(smodor);
    %         smtrials=trialNo(smodor);
    %         plot(smtrials,smscores,'-xb')
    %         ylim([-0.2 1.2])
    %         xlim([0 170])
    %         ylabel('Lick 1=yes, 0=no')
    %         xlabel('Trial No')
    %         title('Begin stage 2: Licks per trial number S+: red o S-:blue x')
    
end
