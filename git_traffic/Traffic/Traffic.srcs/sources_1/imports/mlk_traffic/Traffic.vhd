library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Traffic is
   
    port(
        clk     : in std_logic;                                     
        rst     : in std_logic ;   -- reset                       
        buton	: in std_logic;    -- yaya butonu                                 
        
        led         : out std_logic_vector(13 downto 0);  -- LED ÇIKIÞLAR 
        segment_out : out std_logic_vector (6 downto 0) := "0000001"; 
        an          : out std_logic_vector(7 downto 0)
    );
end Traffic;

architecture Behavioral of Traffic is

    type state_type is (s0,s1,s2,s3,s4,s5,s6,s7,s8,s9);
    signal state : state_type;
    signal state_signal : state_type;
    signal state_signal_next : state_type;
    signal led_signal : std_logic_vector(13 downto 0);
    
    signal clk_sig : std_logic;
    signal buton_signal : std_logic;
    signal count : std_logic_vector(3 downto 0); 
    
    constant sec9 : std_logic_vector(3 downto 0) := "1001";
    constant sec2 : std_logic_vector(3 downto 0) := "0010";
    constant sec1 : std_logic_vector(3 downto 0) := "0001";

begin

    --sseg: display port map(SW=>count, HEX0=>HEX0, HEX1=>HEX1);
    
    -- 100MHZ clock ile 1Hz (1 saniye) olusturma
    process(rst, clk)
    variable cnt : integer;
    begin
        if(rst='1') then
            clk_sig <= '0';
            cnt:=0;
        elsif rising_edge(clk) then
                if (cnt= 9 ) then -- 49.999.999
                clk_sig <= NOT(clk_sig); -- toggle
                cnt:=0;
            else
                cnt:=cnt+1;
            end if;
        end if;
    end process;
    
    process(clk_sig, rst, buton, state)
    begin
        if rst = '1' then 
            state <= s0;
            count <= sec1;
        elsif rising_edge(clk_sig) then
            case state is
                when s0 =>	
                    if buton = '1' then
                        buton_signal <= '1';
                        state <= s8;
                        state_signal <= s1;
                        state_signal_next <= s2;
                        count <= count;
                    elsif count > "0000" then
                        led_signal <= "01001001100001";
                        state <= s0;
                        count <= count - 1;
                    else 
                        state <= s1;
                        count <= sec1;
                    end if;
                when s1 =>
                    if count > "0000" then 								 							
                        led_signal <= "01001001010001";
                        state <= s1;
                        count <= count - 1;
                    else 
                        if buton_signal = '1' then							  
                            count <= "1000";
                            state <= s9;
                        else
                            state <= s2;
                            count <= sec9;
                        end if;
                    end if;
                when s2 =>
                    if buton = '1' then
                        buton_signal <= '1';
                        state <= s8;
                        state_signal <= s3;
                        state_signal_next <= s4;
                        count <= count;
                    elsif count > "0000" then 
                        led_signal <= "01001100001001";
                        state <= s2;
                        count <= count - 1;
                    else 
                        state <= s3;
                        count <= sec1;
                    end if;
                when s3 =>
                    if count > "0000" then 
                        led_signal <= "01001010001001";	
                        state <= s3;
                        count <= count - 1;		
                    else 
                        if buton_signal = '1' then
                            count <= "1001";
                            state <= s9;
                        else
                            state <= s4;
                            count <= sec9;
                        end if;
                    end if;
                when s4 =>
                    if buton = '1' then
                        buton_signal <= '1';
                        state <= s8;
                        state_signal <= s5;
                        state_signal_next <= s6;
                        count <= count;
                    elsif count > "0000" then 
                        led_signal <= "01100001001001";
                        state <= s4;
                        count <= count - 1;		
                    else 
                        state <= s5;
                        count <= sec1;
                    end if;
                when s5 =>
                    if count > "0000" then 
                        led_signal <= "01010001001001";
                        state <= s5;
                        count <= count - 1;                        
                    else 
                        if buton_signal = '1' then
                            count <= "1001";
                            state <= s9;
                        else
                            state <= s6;
                            count <= sec9;
                        end if;
                    end if;
                when s6 =>
                    if buton = '1' then
                        buton_signal <= '1';
                        state <= s8;
                        state_signal <= s7;
                        state_signal_next <= s0;
                        count <= count;
                    elsif count > "0000" then 
                        led_signal <= "01001001001100";
                        state <= s6;
                        count <= count - 1;		       
                    else 
                        state <= s7;
                        count <= sec1;
                    end if;
                when s7 =>
                    if count > "0000" then 
                        state <= s7;
                        count <= count - 1;			               
                        led_signal <= "01001001001010";
                    else 
                        if buton_signal = '1' then
                            count <= "1001";
                            state <= s9;
                        else
                            state <= s0;
                            count <= sec9;
                        end if;
                    end if;
                when s8 =>
                    if count > "0000" then 
                        count <= count - 1;
                    else
                        state <= state_signal;
                        count <= sec1;
                    end if;
                when s9 => 					
                    if count > "0000" then
                        count <= count - 1;
                        state <= s9;
                        led_signal <= "10001001001001";
                    else
                        state <= state_signal_next;
                        count <= sec9;
                        buton_signal <= '0';
                    end if;
                when others =>
                    state <= s0;
            end case;
        end if;
    end process;
       
    -- external pins assignments
    process(state) 
    begin
        case state is
            when s0 => led <= "01001001100001";
            when s1 => led <= "01001001010001";
            when s2 => led <= "01001100001001";
            when s3 => led <= "01001010001001";
            when s4 => led <= "01100001001001";
            when s5 => led <= "01010001001001";
            when s6 => led <= "01001001001100";
            when s7 => led <= "01001001001010";
            when s8 => led <= led_signal;
            when s9 => led <= "10001001001001";
            when others => led <= "00000000000000";
        end case;
    end process;
    
    process (count)
    begin
        case count is
            when "0000"=> -- 0
                an <= "11111110";
                segment_out <="0000001";
            when "0001"=> -- 1
                an <= "11111110";
                segment_out <="1001111";
            when "0010"=> -- 2
                an <= "11111110";
                segment_out <="0010010";
            when "0011"=> -- 3
                an <= "11111110";
                segment_out <="0000110";
            when "0100"=> -- 4
                an <= "11111110";
                segment_out <="1001100";
            when "0101"=> -- 5
                an <= "11111110";
                segment_out <="0100100";
            when "0110"=> -- 6
                an <= "11111110";
                segment_out <="0100000";
            when "0111"=> -- 7
                an <= "11111110";
                segment_out <="0001111";
            when "1000"=> -- 8
                an <= "11111110";
                segment_out <="0000000";
            when "1001"=> -- 9
                an <= "11111110";
                segment_out <="0000100";
            when "1010"=> -- 10
                an <= "11111100";
                segment_out <="0000001";
            when "1011"=> -- 11
                an <= "11111100";
                segment_out <="1001111";
            when "1100"=> -- 12
                an <= "11111100";
                segment_out <="1111111";
            when "1101"=>
                an <= "11111100";
                segment_out <="1111111";
            when "1110"=>
                an <= "11111100";
                segment_out <="1111111";
            when "1111"=>
                an <= "11111100";
                segment_out <="1111111";
            when others=>
                an <= "00000000";
                segment_out <="0000001";
        end case;
    end process;
    
end Behavioral;