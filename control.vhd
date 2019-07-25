library ieee;
use ieee.std_logic_1164.all;

entity control is
	port(opcode : in std_logic_vector(3 downto 0);
		 funct : in std_logic_vector(2 downto 0);
		 zero : in std_logic;
		 outputEnable : out std_logic;
		 pcSelect : out std_logic_vector(1 downto 0);
		 buSelect : out std_logic;
		 wbstage : out std_logic_vector(2 downto 0);
		 aluSelect,ie : out std_logic;
		 exstageSel : out std_logic_vector(1 downto 0);
		 aluOp : out std_logic_vector(3 downto 0);
		 regSelect : out std_logic_vector(1 downto 0);
		 ifidFlush : out std_logic;
		 memstagewe : out std_logic_vector(1 downto 0);
		 retfi,jal : out std_logic);
		 end entity control;

architecture control_behav of control is
begin
	name : process(opcode, funct, zero) is
		
		
	begin
		case(opcode) is
			when "0000" =>
				--Standard Control Values for 0000 opcode
				jal <= '0';
				aluSelect <= '0';
				outputEnable <= '0';
				exstageSel <= "00";
				buSelect <= '0';
				pcSelect <= "00";
				regSelect <= "00";
				ifidFlush <= '0';
				memstagewe <= "00";
				ie <= '0';				
				retfi <= '0';
				
				--Special control values for different function bits.
				case(funct) is
					when "000" => --nop
						wbstage <= "000";
						aluOp <= "1111";
					when "001" => --signed addition
						wbstage <= "011";
						aluOp <= "0101";
					when "010" => --unsigned addition
						wbstage <= "011";
						aluOp <= "0111";
					when "011" => --signed subtraction
						wbstage <= "011";
						aluOp <= "0110";
					when "100" => --unsigned subtraction
						wbstage <= "011";
						aluOp <= "1000";
					when "101" => --signed set less than
						wbstage <= "011";
						aluOp <= "1010";
					when "110" => --unsigned set less than
						wbstage <= "011";
						aluOp <= "1001";
					when others =>
						wbstage <= "011";
						aluOp <= "0100";
				end case;
			
			when "0001" =>
				--Standard control lines for this opcode.
				outputEnable <= '0';
				aluSelect <= '0';
				jal <= '0';
				wbstage <= "011";
				buSelect <= '0';
				pcSelect <= "00";
				regSelect <= "00";
				ifidFlush <= '0';
				memstagewe <= "00";
				ie <= '0';
				retfi <= '0';
				
				case(funct) is
					when "000" => --Logic AND
						exstageSel <="00";
						aluOp <= "0000";
					when "001" => --Logic OR
						exstageSel <= "00";
						aluOp <= "0001";
					when "010" => -- Logic XOR
						exstageSel <= "00";
						aluOp <= "0010";
					when "011" => --Logic NOR
						exstageSel <= "00";
						aluOp <= "0011";
					when "100" => --Logic Shift Left
						exstageSel <= "01";
						aluOp <= "0000";
					when "101" => --Logic Shift Right
						exstageSel <= "01";
						aluOp <= "0001";
					when "110" => --Arithmetic Shift Right
						exstageSel <="01";
						aluOp <= "0010";
					when others => --Rotate Right
						exstageSel <= "01";
						aluOp <= "0011";
				end case;

			when "0010" =>
				--Standard Control Line Values for this opcode.
				aluSelect <= '0';
				buSelect <= '0';
				pcSelect <= "00";
				regSelect <= "00";
				retfi <= '0';
				jal <='0';

				--Control Values Associated with the function bits..
				case(funct) is
					when "000" => --Input Port
						wbstage <= "101";
						outputEnable <= '0';
						exstageSel <= "00";
						aluOp <= "1111";
						ifidFlush <= '0';
						memstagewe <= "10";
						ie <= '0';
					when "001" => --Output Port
						wbstage <= "000";
						outputEnable <= '1';
						aluOp <= "1111";
						exstageSel <= "00";
						ifidFlush <= '0';
						memstagewe <= "00";
						ie <= '0';
					when "010" => --Some branch I think
						buSelect <= '0';
						wbstage <= "000";
						outputEnable <= '0';
						aluOp <= "0000";
						exstageSel <= "00";
						memstagewe <= "00";
						ie <= '0';
						if(zero='1') then
							pcSelect <= "01";
							ifidFlush <= '1';
						else
							pcSelect <= "00";
							ifidFlush <= '0';
						end if;
					when "011" => --BNZ Register
						buSelect <= '0';
						wbstage <= "000";
						outputEnable <= '0';
						aluOp <= "0000";
						exstageSel <= "00";
						memstagewe <= "00";
						ie <= '0';
						if(zero='0') then
							pcSelect <= "01";
							ifidFlush <= '1';
						else
							pcSelect <= "00";
							ifidFlush <= '0';
						end if;
					when others => --No IDEA!!
						buSelect <= '0';
						wbstage <= "000";
						outputEnable <= '0';
						aluOp <= "0000";
						exstageSel <= "00";
						pcSelect <= "00";
						ie <= '1';
						ifidFlush <= '0';
						memstagewe <= "00";
		
				end case;
				
											
			when "0011" =>
				if(funct="000") then
					--this is the JAL register instruction
					wbstage <= "011";
					outputEnable <= '0';
					aluOp <= "0000";
					exstageSel <= "00";
					aluSelect <= '0';
					buSelect <= '0';
					pcSelect <= "10";
					regSelect <= "00";
					ifidFlush <= '1';
					memstagewe <= "00";
					ie <= '0';
					retfi <= '0';
					jal <='1';
					
				elsif(funct="001") then
					--this is the RET from Jal instruction..
					wbstage <= "000";
					outputEnable <= '0';
					aluOp <= "0000";
					exstageSel <= "00";
					aluSelect <= '0';
					buSelect <= '0';
					pcSelect <= "10"; --new pc value = readOne
					regSelect <= "00";
					ifidFlush <= '0';
					memstagewe <= "00";
					ie <= '0';
					retfi <= '0';

				elsif(funct="010") then
					--this is the RETI instruction
					aluSelect <= '0';
					outputEnable <= '0';
					exstageSel <= "00";
					buSelect <= '0';
					regSelect <= "00";
					ifidFlush <= '0';
					wbstage <= "000";
					memstagewe <= "00";
					ie <= '0';				
					jal <= '0';

					pcSelect <="11";
					retfi <= '1';


							
							aluOp <= "0000";
						
							
							
			
					
							
				else
					pcSelect <= "00";
				end if;
			
					
			when "0100" =>
				--MVIL and MVIH
				buSelect <= '0';
				pcSelect <= "00";
				ifidFlush <= '0';
				memstagewe <= "00";
				regSelect <= "01";
				wbstage <= "011";
				exstageSel <= "10";
				outputEnable <= '0';
				aluSelect <= '0';
				retfi <= '0';
				ie <= '0';
				jal <= '0';
				if(funct(0)='0') then --MVIL
					aluOp <= "0000";
				else
					aluOp<="0001";
				end if;

			
			when "0101" =>
				 -- Standard Control Lines for this opcode
				buSelect <= '1';
				wbstage <= "000";
				outputEnable <= '0';
				aluOp <= "0000";
				exstageSel <= "00";
				regSelect <= "01";
				memstagewe <= "00";
				ie <= '0';
				retfi <= '0';
				jal <= '0';
				--Branch Zero PC Relative
				if(funct(0)='0') then
					if(zero='1') then
						pcSelect <= "01";
						ifidFlush <= '1';

					else
						pcSelect <= "00";
						ifidFlush <= '0';

					end if;
				end if;

				--Branch Not Zero PC Relative
				if(funct(0)='1') then
					
					if(zero='0') then
						pcSelect <= "01";
						ifidFlush <= '1';

					else
						pcSelect <= "00";
						ifidFlush <= '0';

					end if;
				end if;



			when "0111" =>
		
				--SLLI and SRLI
				wbstage <= "011";
				exstageSel <= "01";
				outputEnable <= '0';
				aluSelect <= '1';
				buSelect <= '0';
				pcSelect <= "00";
				regSelect <= "00";
				ifidFlush <= '0';
				memstagewe <= "00";
				ie <= '0';
				jal <= '0';
				retfi <= '0';
				if(funct(0) = '0') then
					aluOp <= "0000";
				else
					aluOp <= "0001";
				end if;

			
			when "1000" =>
		
				--SRAI and RORI
				wbstage <= "011";
				exstageSel <= "01";
				outputEnable <= '0';
				aluSelect <= '1';
				buSelect <= '0';
				pcSelect <= "00";
				regSelect <= "00";
				ifidFlush <= '0';
				memstagewe <= "00";
				ie <= '0';
				retfi <= '0';
				jal <= '0';
				if(funct(0) = '0') then
					aluOp <= "0010";
				else
					aluOp <= "0011";
				end if;


			

			--ADDI
			when "1001" =>
				wbstage <= "011";
				exstageSel <= "00";
				outputEnable <= '0';
				aluSelect<='1';
				aluOp <= "0101";
				buSelect <= '0';
				pcSelect <= "00";
				regSelect <= "00";
				ifidFlush <= '0';
				memstagewe <= "00";
				ie <= '0';
				retfi <= '0';
				jal <= '0';
			
			--SUBI
			when "1010" =>
				wbstage <= "011";
				exstageSel <= "00";
				outputEnable <= '0';
				aluSelect<='1';
				aluOp <= "0110";
				buSelect <= '0';
				pcSelect <= "00";
				regSelect <= "00";
				ifidFlush <= '0';	
				memstagewe <= "00";
				ie <= '0';
				retfi <='0';
				jal <= '0';

			--LW
			when "1011" =>
				wbstage <= "001";
				exstageSel <= "00";
				outputEnable <= '0';
				aluSelect<='1';
				aluOp <= "0101";
				buSelect <= '0';
				pcSelect <= "00";
				regSelect <= "00";
				ifidFlush <= '0';
				memstagewe <= "10";
				ie <= '0';
				retfi <= '0';
				jal <= '0';


			--SW
			when "1100" =>
				wbstage <= "000";
				exstageSel <= "00";
				outputEnable <= '0';
				aluSelect<='1';
				aluOp <= "0101";
				buSelect <= '0';
				pcSelect <= "00";
				regSelect <= "10";
				ifidFlush <= '0';
				memstagewe <= "11";
				ie <= '0';
				retfi <= '0';
				jal <= '0';

				--Standard Control Values
						when others =>
							wbstage <= "000";
							outputEnable <= '0';
							aluOp <= "0000";
							exstageSel <= "00";
							aluSelect <= '0';
							buSelect <= '0';
							pcSelect <= "00";
							regSelect <= "00";
							ifidFlush <= '0';
							memstagewe <= "00";
							ie <= '0';
							retfi <= '0';
							jal <= '0';
		end case;
	end process name;
end architecture control_behav;


