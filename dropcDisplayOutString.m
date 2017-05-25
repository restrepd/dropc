function dropcDisplayOutString(out_string)

not_end=1;
from_ii=1;
length_string=length(out_string);
while not_end==1
    if from_ii+62>length_string
        disp(out_string(from_ii:end))
        not_end=0;
    else
        disp(out_string(from_ii:from_ii+62))
        from_ii=from_ii+63;
    end
end
