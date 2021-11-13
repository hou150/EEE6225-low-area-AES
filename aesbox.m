function outputdata = aesbox(inputdata,key)
    disp (inputdata);
    disp (key);
    key=zerofill(key);
    inputdata=zerofill(inputdata);
    round_keys = key_expansion(double(key));
    ciphertext = aes_encryption(inputdata,round_keys);
    outputdata =char( aes_decryption(ciphertext, round_keys));
end
