% compare different result
% @author Wang Yangyang
% 

addpath(genpath('tools'));
dbstop if error;
clear;
clc;
disp('show result');

names = {
    { 'Lena';     36000; };
    { 'Baboon';   11000; };
    { 'Airplane'; 60000; };
    { 'Boat';     25000; };
    { 'Peppers';  29000; };
    { 'Lake';     26000; };
    { 'Barbara';  29000; };
    { 'Elaine';   24000; };
};

C =[0 0.5 1];
mtds = {
%     {'Proposed'; '2019'; '-o';  'k'};
%     {'IPVO'; '2013'; ':v';  'k'};
%     {'PVOK'; '2014'; ':s';  'k'};
    
    
    {'Proposed'; '2019'; '-o';  'k'};
%     {'Proposed'; '2018'; ':o';  'k'};
    {'PPVO'; '2015'; ':o';  'b'};
    {'IPVO'; '2013'; ':o';  'r'};
%     {'PVOK'; '2014'; ':o';  'g'};
    {'Wang'; '2016'; ':o';  'm'};
%     {'Kim'; '2018'; ':o';  'g'};
%     {'PVO';  '2013'; ':o'; 'b'}; 
%     {'PairwisePVO'; '2018'; '-o';  'b'};
%     {'APPVO'; '2018'; '-o';  'k'};
    {'Sachnev'; '2009'; ':o';  C(1,:)};
%     {'Proposed'; '2019'; '-o';  'k'};
};

for i = 1 : length(names)
    comp_main(names{i}{1}, mtds, names{i}{2});
end


