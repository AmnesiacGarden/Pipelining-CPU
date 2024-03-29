library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
use ieee.std_logic_unsigned.all;

ENTITY branch IS
    PORT(pc, displacement, reg            : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
         bsel                             : IN STD_LOGIC;
         newPC                            : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END ENTITY branch;

ARCHITECTURE branch_behav OF branch IS
BEGIN
    name : PROCESS(pc, displacement,reg,bsel) IS
    
    BEGIN
        IF(bsel='1') THEN
            newPC <= pc + displacement;
			--newPC <= UNSIGNED(pc) + SIGNED(displacement);
        ELSE
            newPC <= reg;
        END IF;
    END PROCESS name;
END ARCHITECTURE branch_behav;

