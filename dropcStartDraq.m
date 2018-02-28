<<<<<<< HEAD
function dropcStartDraq(handles)
%Start draq

handles.dropcDigOut.draqPortStatus=uint8(0);
dropcUpdateDraqPort(handles);
pause(0.2)

for ii=1:1
    handles.dropcDigOut.draqPortStatus=handles.dropcDraqOut.draq_trigger;
    dropcUpdateDraqPort(handles);
    pause(0.2)
    %     start_toc=toc;
    %     while toc-start_toc<0.002
    %     end

    handles.dropcDigOut.draqPortStatus=uint8(0);
    dropcUpdateDraqPort(handles);
    pause(0.2)
end

=======
function dropcStartDraq(handles)
%Start draq

handles.dropcDigOut.draqPortStatus=uint8(0);
dropcUpdateDraqPort(handles);
pause(0.2)

for ii=1:1
    handles.dropcDigOut.draqPortStatus=handles.dropcDraqOut.draq_trigger;
    dropcUpdateDraqPort(handles);
    pause(0.2)
    %     start_toc=toc;
    %     while toc-start_toc<0.002
    %     end

    handles.dropcDigOut.draqPortStatus=uint8(0);
    dropcUpdateDraqPort(handles);
    pause(0.2)
end

>>>>>>> db888181d401cf2289c1ad70c7831093bc78040b
pause(handles.dropcProg.timePerTrial)