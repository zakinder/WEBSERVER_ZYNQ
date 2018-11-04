library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity raw2rgb is
generic (
    rgbo_width     : integer := 8;
    cont_width     : integer := 16;
    p_data_width   : integer := 11);
port (
    clk            : in std_logic;
    rst_l          : in std_logic;
    i_tap0         : in std_logic_vector(p_data_width downto 0);
    i_tap1         : in std_logic_vector(p_data_width downto 0);
    i_tap2         : in std_logic_vector(p_data_width downto 0);
    ix_cont        : in std_logic_vector(cont_width-1 downto 0);
    iy_cont        : in std_logic_vector(cont_width-1 downto 0);
    ored           : out std_logic_vector(11 downto 0);
    ogreen         : out std_logic_vector(12 downto 0);
    oblue          : out std_logic_vector(11 downto 0));
end entity;
architecture arch of raw2rgb is
    signal rred          : unsigned(11 downto 0);
    signal rgreen        : unsigned(12 downto 0);
    signal rblue         : unsigned(11 downto 0);
    signal tap2_d1       : unsigned(p_data_width downto 0);
    signal tap1_d1       : unsigned(p_data_width downto 0);
    signal tap0_d1       : unsigned(p_data_width downto 0);
    signal tap2_d2       : unsigned(p_data_width downto 0);
    signal tap1_d2       : unsigned(p_data_width downto 0);
    signal tap0_d2       : unsigned(p_data_width downto 0);
begin
    process (clk)begin
        if rising_edge(clk) then
            if rst_l = '0' then
                    tap2_d1  <=(others => '0');
                    tap2_d2  <=(others => '0');
                    tap1_d1  <=(others => '0');
                    tap1_d2  <=(others => '0');
                    tap0_d1  <=(others => '0');
                    tap0_d2  <=(others => '0');
            else
                    tap2_d1  <=unsigned(i_tap2);
                    tap2_d2  <=tap2_d1;
                    tap1_d1  <=unsigned(i_tap1);
                    tap1_d2  <=tap1_d1;
                    tap0_d1  <=unsigned(i_tap0);
                    tap0_d2  <=tap0_d1;  
            end if;
        end if;
    end process;
    process (clk)
    variable loc_addr : std_logic_vector(1 downto 0);
    begin
        if rising_edge(clk) then
        if rst_l = '0' then
            rred   <=(others => '0');
            rgreen <=(others => '0');
            rblue  <=(others => '0'); 
        else
        loc_addr := iy_cont(0) & ix_cont(0);
        case loc_addr IS
            when b"11" => 
                if (iy_cont(11 downto 0) = x"001" ) then
                    rred   <= tap1_d1;
                    rgreen <= '0' & (tap2_d1 + unsigned(i_tap1));
                    rblue  <= unsigned(i_tap2);
                else          
                    rred   <= tap1_d1;
                    rgreen <= '0' & (unsigned(i_tap1) + tap0_d1);
                    rblue  <= unsigned(i_tap0);
                end if;
            when b"10" => 
                if (iy_cont(11 downto 0) = x"001" ) then
                    if (ix_cont(11 downto 0) = x"000" ) then
                        rred    <= tap2_d2;
                        rgreen  <= tap1_d2 & '0';
                        rblue   <= tap1_d1;
                    else
                        rred    <= unsigned(i_tap1);
                        rgreen  <= '0' & (tap1_d1 + unsigned(i_tap2));
                        rblue   <= tap2_d1;    
                    end if;
                else
                    if (ix_cont(11 downto 0) = x"000" ) then
                        rred    <= tap0_d2;
                        rgreen  <= tap0_d1 & '0';
                        rblue   <= tap1_d1;
                    else
                        rred    <= unsigned(i_tap1);
                        rgreen  <= '0' & (tap1_d1 + unsigned(i_tap0));
                        rblue   <= tap0_d1;    
                    end if;
                end if;
            when b"01" => 
                rred      <= tap0_d1;
                rgreen    <= '0' & (unsigned(i_tap0) + tap1_d1);
                rblue     <= unsigned(i_tap1);    
            when b"00" => 
                if (ix_cont(11 downto 0) = x"000" ) then
                    rred     <= tap1_d2;
                    rgreen   <= tap0_d2 & '0';
                    rblue    <= tap0_d1;
                else
                    rred     <= unsigned(i_tap0);
                    rgreen   <= '0' & (tap0_d1 + unsigned(i_tap1));
                    rblue    <= tap1_d1;    
                end if;
            when others => 
                rred     <= rred;
                rgreen   <= rgreen;
                rblue    <= rblue;
        end case;
        end if;
        end if; 
    end process;
    ored    <= std_logic_vector(rred(11 downto 0));
    ogreen  <= std_logic_vector(rgreen(12 downto 0));
    oblue   <= std_logic_vector(rblue(11 downto 0));
end architecture;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity tap_buffer is
generic (
    img_width     : integer := 4095;
    p_data_width    : integer := 11;
    addr_width    : integer := 11);
port (
    write_clk    : in std_logic;
    write_enb    : in std_logic;
    w_address    : in std_logic_vector(addr_width downto 0);
    idata        : in std_logic_vector(p_data_width downto 0);
    read_clk     : in std_logic;
    r_address    : in std_logic_vector(addr_width downto 0);
    odata        : out std_logic_vector(p_data_width downto 0));
end entity;
architecture arch of tap_buffer is
    type ram_type is array (0 to img_width) of std_logic_vector (p_data_width downto 0);
    signal rowbuffer : ram_type := (others => (others => '0'));
    signal oregister : std_logic_vector(p_data_width downto 0);
    signal w1s_address  : std_logic_vector(addr_width downto 0);   
    signal w2s_address  : std_logic_vector(addr_width downto 0);  
    signal w3s_address  : std_logic_vector(addr_width downto 0); 
    signal write1s_enb  : std_logic;
    signal write2s_enb  : std_logic;
    signal write3s_enb  : std_logic;  
    signal write_or_enb : std_logic;
begin
    process (write_clk) begin
        if rising_edge(write_clk) then
            w1s_address <=w_address;
            w2s_address <=w1s_address;
            w3s_address <=w2s_address;
        end if;
    end process;
    process (write_clk) begin
        if rising_edge(write_clk) then
            write1s_enb <=write_enb;
            write2s_enb <=write1s_enb;
            write3s_enb <=write2s_enb;
        end if;
    end process;
    write_or_enb <=write_enb or write3s_enb;
    process (write_clk) begin
    if rising_edge(write_clk) then
        if (write_or_enb ='1') then
            rowbuffer(to_integer(unsigned(w3s_address))) <= idata;
        end if;
    end if;
    end process;
    process (read_clk) begin
    if rising_edge(read_clk) then
        oregister <= rowbuffer(to_integer(unsigned(r_address)));
    end if;
    end process;
    process (read_clk) begin
    if rising_edge(read_clk) then
        odata <= oregister;
    end if;
    end process;
end architecture;