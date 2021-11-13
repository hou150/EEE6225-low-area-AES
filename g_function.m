function g = g_function(w, r)

    % Shifting 矩阵行右移三
    w1 = circshift(w,[0,3]); 
    
    % Byte Substitution
    out_byte = byte_subs(w,'e');

    % Round coefficient values.
    switch (r)
       case 1
          con = 1;
       case 2
          con = 2;
       case 3
          con = 4;
       case 4
          con = 8;
       case 5
          con = 16;
       case 6
          con = 32;
       case 7
          con = 64;
       case 8
          con = 128;
       case 9
          con = 27;
       case 10
          con = 54;     
       otherwise
          disp('Maximum round exceeded.')
    end
    % Output
    g = [bitxor(out_byte(0+1),con) out_byte(1+1) out_byte(2+1) out_byte(3+1)];

end
