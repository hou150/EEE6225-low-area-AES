function ciphertext = aes_encryption(inputdata,round_keys)

% Intro
fprintf('\n====start encryption====\n')
fprintf('\n inputdata is: \n'); 
disp(inputdata); 
fprintf('\n key is:       \n'); 
disp(char(reshape(round_keys(:,:,1)',[1 16])));

%Preallocations
global m prim_poly fixM;
encrypt = 'e'; % Encoding Mode. 'e' for encryption. 'd' for decryption.
r = 0;

% Inputs
plaintext_dec = double(inputdata);

% Initial Key Addition Layer; round (r) = 0 
inputdata = bitxor(plaintext_dec,reshape(round_keys(:,:,r+1)', [1 16]));
for r = 1:10
    % Byte substitution
    out_byte = byte_subs(inputdata, encrypt);
    out_byte = reshape(out_byte, [4,4]);
     
    % ShiftRows Sublayer
    % Shifting
    for i = 1:3
        out_byte(i+1,:) = circshift(out_byte(i+1,:),[0,3-((i+1)-2)]);
    end
    
    % MixColumn Sublayer
    if (r >= 1 && r <= 9)
        C = gf(fixM,m,prim_poly) * gf(out_byte,m,prim_poly);
        C = gf2dec(C,8,prim_poly);
    else
        C = reshape(out_byte, [1 16]);
    end
    
    % Key Addition Layer
    inputdata = bitxor(C,reshape(round_keys(:,:,r+1)', [1 16]));
    
end

% Ciphertext
ciphertext = inputdata;
fprintf('\n ciphertext:\n')
disp(reshape(ciphertext,[4,4]));
fprintf('\n====encryption end=====\n');

end