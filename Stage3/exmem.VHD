library ieee;
use ieee.std_logic_1164.all;

--******************************************************************************
--**** ENTITY
--**** Description: This entity describes the Execution/Memory pipeline
--****              register. Values are writen into the EXMEM pipeline register
--****              on the positive clock edge.
--******************************************************************************         
ENTITY exmem IS
    PORT(exmempcIn, result, read            : STD_LOGIC_VECTOR(15 DOWNTO 0);
         clk                                : IN STD_LOGIC;
         wb                                 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
         exmempc, resultOut, readOut        : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
         wbOut                              : OUT STD_LOGIC_VECTOR(2 DOWNTO 0));
END ENTITY exmem;

ARCHITECTURE exmem_behav OF exmem IS
BEGIN
    name : PROCESS(clk) IS
    
    -- This variable is used to store the contents of the EXMEM pipe register
    VARIABLE regValue : STD_LOGIC_VECTOR(50 DOWNTO 0);
    
    BEGIN
        
        -- On the positive edge of the clock write in the values that are at
        -- the inputs to the pipeline register.
        IF(clk='1') THEN
            regValue(50 DOWNTO 0) := exmempcIn(15 DOWNTO 0) & 
                                     result(15 DOWNTO 0) & read(15 DOWNTO 0) &     
                                     wb(2 DOWNTO 0);
        END IF;
        
        exmempc <= regValue(50 DOWNTO 35);      -- PC value in the EX stage
        resultOut <= regValue(34 DOWNTO 19);    -- Result from ALU
        readOut <= regValue(18 DOWNTO 3);       -- Read Value from ALU
        wbOut <= regValue(2 DOWNTO 0);          -- Write Back Register
        
    END PROCESS name;
END ARCHITECTURE exmem_behav;
        
