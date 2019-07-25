library ieee;
use ieee.std_logic_1164.all;

--******************************************************************************
--**** ENTITY MVIBOX
--**** Description: This entity describes the move immediate unit. This entity
--****              takes a 8-bit register value and an 8-bit immediate value 
--****              and sets creates a new value equals to either 00 and the 8-
--****              bits immediate or it sets the 8-bit immediate and the 
--****              exisiting 8-bits register value.
--******************************************************************************
ENTITY mvibox IS
    PORT(reg1                              : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
         immed                             : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
         write                             : IN STD_LOGIC;
         result                            : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END ENTITY mvibox;

ARCHITECTURE mvi_behav OF mvibox IS
BEGIN

    name: PROCESS(reg1, immed, write) IS

    BEGIN
        IF(write='0') THEN

            result <= "00000000" & immed;
        ELSE            
            result <= immed & reg1;
        END IF;
    END PROCESS name;
END ARCHITECTURE mvi_behav;

