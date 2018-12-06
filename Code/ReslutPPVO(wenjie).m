clc;clear;


Imgs = {'Lena', 'Baboon', 'Barbara', 'Airplane', 'Lake', 'Peppers', 'Boat', 'Elaine'};

for tt = 1 : 1 : 8
    istr = ['PPVO_2015_',Imgs{tt},'.mat'];
    r = load(istr);

    c = r.C;
    psnr = r.maxim;

    res = [c;psnr];
    save(istr, 'res');
end