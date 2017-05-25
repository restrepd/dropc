
%Create the digital I/O object dio
%The installed adaptors and hardware IDs are found with daqhwinfo
dio = digitalio('mcc',1);

%Add eight output lines from port 0
addline(dio,0:7,'out');

%Write and read values
data = 13;
putvalue(dio.Line(1:4),data)
val1 = getvalue(dio);
bvdata = dec2binvec(data);
putvalue(dio.Line(1:4),bvdata)
val2 = getvalue(dio);

%Clean up
delete(dio)
clear dio

