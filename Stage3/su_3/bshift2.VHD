library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
use ieee.std_logic_unsigned.all;

--*****************************************************************************
--**** ENTITY BSHIFT2
--****
--**** Description: This design shifts 16-bit data 2 places either by logic
--****              shifts left or right, arithmetic shift right or rotate 
--****              right. It shifts only when the enable line is set high.
--****              Otherwise it passes the 16-bit data through unchanged
--**** Version    : 1.0
--**** Date       : 12/8/99
--**** Programmer : Jason Gorham
--*****************************************************************************
ENTITY bshift2 IS
    PORT(data                           : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
         enable                         : IN STD_LOGIC;
         operation                      : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
         result                         : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END ENTITY bshift2;

ARCHITECTURE shift2_behav OF bshift2 IS

BEGIN
    name : PROCESS(data, enable, operation) IS
    CONSTANT zero : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
    BEGIN

        IF(enable='1') THEN
            CASE operation IS
                -- shift left logic by 2
                WHEN "00" => 
                    result <= data(13 DOWNTO 0) & zero(15 DOWNTO 14);

                --shift right logic by 2
                WHEN "01" =>
                    result <= zero(1 DOWNTO 0) & data(15 DOWNTO 2);
            
                --arithmetic shift right by 2
                WHEN "10" =>
                    IF(data(15)='1') THEN
                        result <= "11" & data(15 DOWNTO 2);
                    ELSE
                        result <= zero(1 DOWNTO 0) & data(15 DOWNTO 2);
                    END IF;
            
                --rotate right by 2
                WHEN OTHERS =>
                    result <= data(1 DOWNTO 0) & data(15 DOWNTO 2);

            END CASE;   
        ELSE
            --Enable is not set high so let data pass through unchanged
            result <= data;
        END IF; 
    END PROCESS name;
END ARCHITECTURE shift2_behav;      

    
