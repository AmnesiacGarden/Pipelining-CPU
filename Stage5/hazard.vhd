library ieee;
use ieee.std_logic_1164.all;
entity hazard is
	port(opcode : in std_logic_vector(3 downto 0);
		 func, readone, readtwo, idexwrite : in std_logic_vector(2 downto 0);
		 idexMemWE, idexwe : in std_logic;
		 exmemwrite : in std_logic_vector(2 downto 0);
		 memstage : in std_logic;
		 pcenable, ifidenable,idexflush : out std_logic);
end entity hazard;

architecture hazard_behav of hazard is
begin
	name : process(opcode, func, readone, readtwo, idexwrite, idexMemWE,memstage,exmemwrite) is
	begin
		--IF we are going to use something in the MEM/IO stage look here....
		if(idexMemWE='1') then
			if(idexwrite=readone or idexwrite=readtwo) then
				pcenable <= '0';
				ifidenable <= '0';
				idexflush <= '1';
			else
				pcenable <= '1';
				ifidenable <= '1';
				idexflush <= '0';
			end if;
		
		--If we currently have a BRANCH INSTRUCTION and we are writing to the read registers of the
		--branch instruction in either the mem/io stage or ex stage than must stall.	
		else if((opcode="0010" and func="010") or (opcode="0010" and func="011") or opcode="0101") then --?? what instruction is this jason?
			
			--are we writing in the EX Stage?
			if(idexwe='1') then
				if(idexwrite = readone or idexwrite=readtwo) then
					pcenable <= '0';
					ifidenable <= '0';
					idexflush <= '1';
				else
					pcenable <= '1';
					ifidenable <= '1';
					idexflush <= '0';
				end if;
			
			--Else Are we writing in the MEM stage?
			elsif (memstage='1') then
				if(exmemwrite = readone or exmemwrite = readtwo) then
					pcenable <= '0';
					ifidenable <= '0';
					idexflush <= '1';
				else
					pcenable <= '1';
					ifidenable <= '1';
					idexflush <= '0';
				end if;

			--If neither than do not worry.
			else 
				pcEnable <='1';	
				ifidenable <= '1';
				idexflush <= '0';
			end if;
		else
			pcenable <= '1';
			ifidenable <= '1';
			idexflush <= '0';
		end if;
		end if;
	end process name;
end architecture hazard_behav;

		



			
		
		
