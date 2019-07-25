library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

--*****************************************************************************
--**** Program Counter
--****
--**** Description: This enitity represents the program counter.
--*****************************************************************************
ENTITY progc IS
    PORT(pcIn                           : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
          clk,enable                    : IN STD_LOGIC;
         pcOut                          : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END ENTITY progc;


ARCHITECTURE progc_behav OF progc IS
BEGIN
    --When ever the clock changes do the following routine
    name : PROCESS(clk) IS
    VARIABLE regValue : STD_LOGIC_VECTOR(15 DOWNTO 0);
    BEGIN
    
        --if clock goes high and enable is high
        --then change the value of the counter
        IF(clk='1') THEN
            IF(enable='1') THEN
                regValue := pcin ;
            END IF;
        END IF;
                        
        --output the current program counter
        pcOut <= regValue;          
    END PROCESS name;
END ARCHITECTURE progc_behav;
