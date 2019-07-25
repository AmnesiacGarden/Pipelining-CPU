library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
use ieee.std_logic_unsigned.all;

--*****************************************************************************
--**** ENTITY BSHIFT4
--****
--**** Description: This design shifts 16-bit data 4 places either by logic
--****              shifts left or right, arithmetic shift right or rotate 
--****              right. It shifts only when the enable line is set high.
--****              Otherwise it passes the 16-bit data through unchanged
--**** Version    : 1.0
--**** Date       : 12/8/99
--**** Programmer : Jason Gorham
--*****************************************************************************
ENTITY bshift4 IS
    PORT(data                       : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
         enable                     : IN STD_LOGIC;
         operation                  : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
         result                     : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END ENTITY bshift4;

ARCHITECTURE shift4_behav OF bshift4 IS
BEGIN
    name : PROCESS(data, enable, operation) IS
    CONSTANT zero : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
    BEGIN
        IF(enable='1') THEN
            CASE operation IS
            
                -- shift left logic by 4
                WHEN "00" => 
                    result <= data(11 DOWNTO 0) & zero(15 DOWNTO 12);

                --shift right logic by 4
                WHEN "01" =>
                    result <= zero(3 DOWNTO 0) & data(15 DOWNTO 4);
            
                --arithmetic shift right by 4
                WHEN "10" =>
                    IF(data(15)='1') THEN
                        result <= "1111" & data(15 DOWNTO 4);
                    ELSE
                        result <= zero(3 DOWNTO 0) & data(15 DOWNTO 4);
                    END IF;
            
                --rotate right by 4
                WHEN OTHERS =>
                    result <= data(3 DOWNTO 0) & data(15 DOWNTO 4);

            END CASE;   
        ELSE
            --Enable line is not set high so let the data pass unchanged
            result <= data;
        END IF; 
    END PROCESS name;
END ARCHITECTURE shift4_behav;      

    
