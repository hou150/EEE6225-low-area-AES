% sbox lookup table. Indexing is (input+1)
sbox_in = csvread('sbox.csv');

sbox_table = transpose(reshape(sbox_in(1:256), [16,16]));

% inv_sbox lookup table. Indexing is (input+1)
inv_sbox_in = csvread('inv_sbox.csv');

inv_sbox_table = reshape(inv_sbox_in(1:256), [16,16]);

setGlobal(sbox_table, inv_sbox_table);


%global Constants
global m prim_poly fixM fixM_d; 
m = 8; % GF(2^m)
prim_poly = 283;

%MixColumn Layer matrix
fixM = [02 03 01 01;
        01 02 03 01;
        01 01 02 03;
        03 01 01 02];
%Inv MixColumn Layer matrix
fixM_d = [14 11 13 09;
          09 14 11 13;
          13 09 14 11;
          11 13 09 14];