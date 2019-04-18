clear;clc;
tic
I = double(imread(['.\images\Lena.bmp']));
[A,B] = size(I);
I_ori=I;
[AuxLM,I] = LocationMap(I);
insteadbit = AuxLM+ 18 + 18 + 2;

kkk=0;
for C = 20000
    C = C + insteadbit;
    C
    [ ph, pl, heng, shu, NL, zhi] = error_compute_1( I );
    capacity1 = floor(C/2);
    [ I_new, EC1, T1 ] = embed_high_1( I,ph,pl, heng, shu, NL,capacity1 );
    T1
    if EC1 < capacity1
        disp('over capacity!');
        break;
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%% µÚ¶þ²ã %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [ ph, pl, heng, shu, NL] = error_compute_2( I_new );
    capacity2 = C - capacity1;
    [ I_new2, EC2, T2 ] = embed_high_2( I_new ,ph, pl, heng, shu, NL, capacity2,T1 );
    T2
    if EC2 < capacity2
        disp('over capacity!');
        break;
    end
    didi=sum(sum(abs(I_ori-I_new2)));
    kkk = kkk+1;
    PSNR(kkk) = 10*log10(255^2*A*B/didi);

end






