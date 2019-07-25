library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
use ieee.std_logic_unsigned.all;

--******************************************************************************
--** ENTITY Forward
--**
--** Description: This entity describes the forwarding unit,which is responsible
--**              for forwarding data hazards from the Mem and WB stages back to
--**              the EX stage.
--******************************************************************************
ENTITY forward IS
    PORT(exmRegWrite,memwbRegWrite          : in std_logic;
         exmWriteReg, memwbWriteReg         : in std_logic_vector(2 downto 0);
         idexReadOne,idexReadTwo            : in std_logic_vector(2 downto 0);
         aluSelA, aluSelB                   : out std_logic_vector(1 downto 0));
END ENTITY forward;

ARCHITECTURE forward_behav OF forward IS
BEGIN

    name : PROCESS(exmRegWrite, exmWriteReg, idexReadOne, idexReadTwo) IS

    BEGIN
        --if Register from EX/MEM stage is going to be written 
        IF(exmRegWrite='1') THEN
            IF(memwbRegWrite='0') THEN
                -- if the write register = read register one then select the 
                -- write 
                IF(exmWriteReg=idexReadOne) THEN
                    aluSelA <= "01";
                ELSE
                    aluSelA <= "00";
                END IF;
                    
                IF(exmWriteReg=idexReadTwo) THEN
                    aluSelB <= "01";
                ELSE
                    aluSelB <= "00";
                END IF;
            ELSE
                --Means that both exmRegWrite and memwbRegWrite = 1
                --do some stuff;
                IF(exmWriteReg=idexReadOne) THEN
                    aluSelA <= "01";
                ELSE IF(memwbWriteReg=idexReadOne) THEN
                    aluSelA <= "10";
                ELSE
                    aluSelA <= "00";
                END IF;
                END IF;

                IF(exmWriteReg=idexReadTwo) THEN
                    aluSelB <= "01";
                ELSE IF(memwbWriteReg=idexReadTwo) THEN
                    aluSelB <= "10";
                ELSE
                    aluSelB <= "00";
                END IF;
                END IF;
            END IF;
        ELSE IF(memwbRegWrite='1') THEN
                    -- this means exstage is zero 
                IF(memwbWriteReg=idexReadTwo) THEN
                    aluSelB <= "10";
                ELSE
                    aluSelB <= "00";
                END IF;

                IF(memwbWriteReg=idexReadOne) THEN
                    aluSelA <= "10";
                ELSE
                    aluSelA <= "00";
                END IF;
        ELSE
                aluSelA <= "00";
                aluSelB <= "00";
        END IF;
        END IF;
                    
    END PROCESS name;
END ARCHITECTURE forward_behav;

