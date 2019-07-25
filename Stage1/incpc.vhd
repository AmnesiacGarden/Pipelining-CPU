library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

--*****************************************************************************
--**** Increment Program Counter
--****
--**** Description: This entity simply adds 1 to the program counter & outputs
--****              the result.
--*****************************************************************************
ENTITY incpc IS
    PORT(pcIn                           : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
         pcVal                          : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END ENTITY incpc;

ARCHITECTURE pc_behav OF incpc IS
BEGIN
    name : PROCESS(pcIn) IS
    
    BEGIN
        pcVal <= pcIn +1;
    END PROCESS name;
END ARCHITECTURE pc_behav;

