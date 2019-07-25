library ieee;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_1164.all;

--*****************************************************************************
--**** ENTITY BSHIFTER
--****
--**** Description: The Bshifter unit is responsible for controlling the type 
--****              of shift performed, depending on the sign of the amount to
--****              shift variable. For example if the amount is + then the 
--****              type of operation performed is the same where as if it was
--****              - then the opposite operation would be performed on the 
--****              inverse+1 amount. If the amount to shift extends beyond
--****              -15 to 15 then the data remains unchanged.
--*****************************************************************************
ENTITY bshifter IS
    PORT(amountToShift                  : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
          operation                     : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
          shiftLines                    : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
          shiftOp                       : OUT STD_LOGIC_VECTOR(1 DOWNTO 0));
END ENTITY bshifter;

ARCHITECTURE bshifter_behav OF bshifter IS
BEGIN
    name :PROCESS(amountToShift, operation) IS
    BEGIN
        CASE conv_integer(SIGNED(amountToShift)) IS
                
            --When the amount to shift is negative do the following
            WHEN -15 TO -1 =>
                CASE operation IS
                    --if operation was shift left then shift right by the 
                    --two's compliment +1 .. similarily for all others.
                    WHEN "00" =>
                        shiftOp <= "01";
                        shiftLines <= conv_std_logic_vector(SIGNED( not amountToShift),4) +1;
                    WHEN "01" | "10" =>
                        shiftOp <= "00";
                        shiftLines <= conv_std_logic_vector(SIGNED( not amountToShift),4) +1;
                    --When rotating right simply rotate by the signed amount   
                    WHEN OTHERS =>
                        shiftOp <= "11";
                        shiftLines <= 
                                conv_std_logic_vector(SIGNED(amountToShift),4);
                END CASE;

            --When amount to shift is positive, things remain unchanged.
            WHEN 0 TO 15 =>
                shiftOp <= operation;
                shiftLines <= conv_std_logic_vector(UNSIGNED(amountToShift),4);

            --When amount goes beyond the bounds then do change nothing as
            --we only want to perform shifts between -16 and 15 no more.
            WHEN OTHERS =>
                shiftOp <= operation;
                shiftLines <= "0000";
        END CASE;
    END PROCESS name;
END ARCHITECTURE bshifter_behav;
            
                
                    
                
          
          
