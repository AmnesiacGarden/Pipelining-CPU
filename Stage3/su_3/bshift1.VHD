library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
use ieee.std_logic_unsigned.all;

--*****************************************************************************
--**** ENTITY BSHIFT1
--****
--**** Description: This design shifts 16-bit data 1 place either by logic
--****              shifts left or right, arithmetic shift right or rotate 
--****              right. It shifts only when the enable line is set high.
--****              Otherwise it passes the 16-bit data through unchanged
--**** Version    : 1.0
--**** Date       : 12/8/99
--**** Programmer : Jason Gorham
--*****************************************************************************
ENTITY bshift1 IS
    PORT(data                           : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
         enable                         : IN STD_LOGIC;
         operation                      : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
         result                         : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END ENTITY bshift1;

ARCHITECTURE shift1_behav OF bshift1 IS

BEGIN
    name : PROCESS(data, enable, operation) IS
    BEGIN

        IF(enable='1') THEN
            CASE operation IS
                -- shift left logic by 1
                WHEN "00" => 
                    result <= data(14 DOWNTO 0) & "0";
                
                --shift right logic by 1
                WHEN "01" =>
                    result <= "0" & data(15 DOWNTO 1);
            
                --arithmetic shift right by 1
                WHEN "10" =>
                    IF(data(15)='1') THEN
                        result <= "1" & data(15 DOWNTO 1);
                    ELSE
                        result <= "0" & data(15 DOWNTO 1);
                    END IF;
            
                --rotate right by 1
                WHEN OTHERS =>
                    result <= data(0) & data(15 DOWNTO 1);

            END CASE;   
        ELSE
            --Enable is not set high so let data pass through unchanged
            result <= data;
        END IF; 
    END PROCESS name;
END ARCHITECTURE shift1_behav;      

    
