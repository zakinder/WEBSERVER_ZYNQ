--library ieee;
--use ieee.std_logic_1164.all;
--use ieee.numeric_std.all;
--entity buffer_controller is
--generic (
--    img_width     : integer := 4096;
--    adwr_width    : integer := 15;
--    p_data_width  : integer := 11;
--    addr_width    : integer := 11);
--port (
--    aclk        : in std_logic;
--    i_enable    : in std_logic;
--    i_data      : in std_logic_vector(p_data_width downto 0);
--    i_wadd      : in std_logic_vector(adwr_width downto 0);
--    i_radd      : in std_logic_vector(adwr_width downto 0);
--    taps0x      : out std_logic_vector(p_data_width downto 0);
--    taps1x      : out std_logic_vector(p_data_width downto 0);
--    taps2x      : out std_logic_vector(p_data_width downto 0));
--end entity;
--architecture arch of buffer_controller is
--component tap_buffer
--generic (
--    img_width    : integer := 4096;
--    p_data_width : integer := 11;
--    addr_width   : integer := 11);
--port (
--    write_clk    : in std_logic;
--    write_enb    : in std_logic;
--    w_address    : in std_logic_vector(addr_width downto 0);
--    idata        : in std_logic_vector(p_data_width downto 0);
--    read_clk     : in std_logic;
--    r_address    : in std_logic_vector(addr_width downto 0);
--    odata        : out std_logic_vector(p_data_width downto 0));
--end component;
--signal wrchx0_io  : std_logic;
--signal wrchx1_io  : std_logic;
--signal wrchx2_io  : std_logic;
--signal wrchx3_io  : std_logic;
--signal write_chs  : integer range 0 to 3;
--signal write_s    : std_logic;
--signal write_p    : std_logic;
--signal tap0_data  : std_logic_vector(p_data_width downto 0);
--signal tap1_data  : std_logic_vector(p_data_width downto 0);
--signal tap2_data  : std_logic_vector(p_data_width downto 0);
--signal tap3_data  : std_logic_vector(p_data_width downto 0);
--begin
--process (aclk) begin
--if (rising_edge(aclk)) then
--    write_s <=i_enable;
--end if;
--end process;
--write_p   <= '1' when (write_s ='1' and i_enable ='0') else '0';
--process (aclk) begin
--if (rising_edge(aclk) ) then
--    if (write_p = '1') then
--        if (write_chs = 3) then
--            write_chs <= 0;
--        else
--            write_chs <= write_chs + 1;
--        end if;
--    end if;
--end if;
--end process;
--wrchx0_io <= '1' when (write_chs = 0 and i_enable ='1')  else '0';
--wrchx1_io <= '1' when (write_chs = 1 and i_enable ='1')  else '0';
--wrchx2_io <= '1' when (write_chs = 2 and i_enable ='1')  else '0';
--wrchx3_io <= '1' when (write_chs = 3 and i_enable ='1')  else '0';
--tap1_readout: process(aclk) begin
--if (rising_edge(aclk) ) then
--if(i_enable ='1') then
--    if(wrchx0_io ='1') then
--        taps0x <= tap1_data;
--    elsif(wrchx1_io ='1') then
--        taps0x <= tap2_data;
--    elsif(wrchx2_io ='1') then
--        taps0x <= tap3_data;
--    elsif(wrchx3_io ='1') then
--        taps0x <= tap0_data;        
--    else
--        taps0x <= (others => '0');
--    end if;
--end if;
--end if;
--end process tap1_readout;
--tap2_readout: process(aclk) begin
--if (rising_edge(aclk) ) then
--if(i_enable ='1') then
--    if(wrchx0_io ='1') then
--        taps1x <= tap2_data;
--    elsif(wrchx1_io ='1') then
--        taps1x <= tap3_data;
--    elsif(wrchx2_io ='1') then
--        taps1x <= tap0_data;
--    elsif(wrchx3_io ='1') then
--        taps1x <= tap1_data;        
--    else
--        taps1x <= (others => '0');
--    end if;
--end if;
--end if;
--end process tap2_readout;
--tap3_readout: process(aclk) begin
--if (rising_edge(aclk) ) then
--if(i_enable ='1') then
--    if(wrchx0_io ='1') then
--        taps2x <= tap3_data;
--    elsif(wrchx1_io ='1') then
--        taps2x <= tap0_data;
--    elsif(wrchx2_io ='1') then
--        taps2x <= tap1_data;
--    elsif(wrchx3_io ='1') then
--        taps2x <= tap2_data;        
--    else
--        taps2x <= (others => '0');
--    end if;
--end if;
--end if;
--end process tap3_readout;
--int_line_d0: tap_buffer
--generic map(
--    img_width    => img_width,
--    p_data_width => p_data_width,
--    addr_width   => addr_width)
--port map(
--    write_clk => aclk, 
--    write_enb => wrchx0_io,
--    w_address => i_wadd(addr_width downto 0),
--    idata     => i_data,
--    read_clk  => aclk, 
--    r_address => i_radd(addr_width downto 0),
--    odata     => tap0_data);
--int_line_d1: tap_buffer
--generic map(
--    img_width    => img_width,
--    p_data_width => p_data_width,
--    addr_width   => addr_width)
--port map(
--    write_clk => aclk, 
--    write_enb => wrchx1_io,
--    w_address => i_wadd(addr_width downto 0),
--    idata     => i_data,
--    read_clk  => aclk, 
--    r_address => i_radd(addr_width downto 0),
--    odata     => tap1_data);    
--int_line_d2: tap_buffer
--generic map(
--    img_width    => img_width,
--    p_data_width => p_data_width,
--    addr_width   => addr_width)
--port map(
--    write_clk  => aclk, 
--    write_enb  => wrchx2_io,
--    w_address  => i_wadd(addr_width downto 0),
--    idata      => i_data,
--    read_clk   => aclk, 
--    r_address  => i_radd(addr_width downto 0),
--    odata      => tap2_data);
--int_line_d3: tap_buffer
--generic map(
--    img_width    => img_width,
--    p_data_width => p_data_width,
--    addr_width   => addr_width)
--port map(
--    write_clk => aclk,
--    write_enb => wrchx3_io,
--    w_address => i_wadd(addr_width downto 0),
--    idata     => i_data,
--    read_clk   => aclk, 
--    r_address  => i_radd(addr_width downto 0),
--    odata      => tap3_data);
--end architecture;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity buffer_controller is
generic (
    img_width     : integer := 4096;
    adwr_width    : integer := 15;
    p_data_width  : integer := 11;
    addr_width    : integer := 11);
port (
    aclk        : in std_logic;
    i_enable    : in std_logic;
    i_data      : in std_logic_vector(p_data_width downto 0);
    i_wadd      : in std_logic_vector(adwr_width downto 0);
    i_radd      : in std_logic_vector(adwr_width downto 0);
	en_datao    : out std_logic;
    taps0x      : out std_logic_vector(p_data_width downto 0);
    taps1x      : out std_logic_vector(p_data_width downto 0);
    taps2x      : out std_logic_vector(p_data_width downto 0));
end entity;
architecture arch of buffer_controller is
component tap_buffer
generic (
    img_width    : integer := 4096;
    p_data_width : integer := 11;
    addr_width   : integer := 11);
port (
    write_clk    : in std_logic;
    write_enb    : in std_logic;
    w_address    : in std_logic_vector(addr_width downto 0);
    idata        : in std_logic_vector(p_data_width downto 0);
    read_clk     : in std_logic;
    r_address    : in std_logic_vector(addr_width downto 0);
    odata        : out std_logic_vector(p_data_width downto 0));
end component;
signal wrchx0_io  : std_logic :='0';
signal wrchx1_io  : std_logic :='0';
signal wrchx2_io  : std_logic :='0';
signal wrchx3_io  : std_logic :='0';
signal w1rchx0_io  : std_logic :='0';
signal w1rchx1_io  : std_logic :='0';
signal w1rchx2_io  : std_logic :='0';
signal w1rchx3_io  : std_logic :='0';
signal w2rchx0_io  : std_logic :='0';
signal w2rchx1_io  : std_logic :='0';
signal w2rchx2_io  : std_logic :='0';
signal w2rchx3_io  : std_logic :='0';
signal w3rchx0_io  : std_logic :='0';
signal w3rchx1_io  : std_logic :='0';
signal w3rchx2_io  : std_logic :='0';
signal w3rchx3_io  : std_logic :='0';
signal write_chs  : integer range 0 to 3;
signal write_s    : std_logic;
signal write_p    : std_logic;
signal tap0_data  : std_logic_vector(p_data_width downto 0);
signal tap1_data  : std_logic_vector(p_data_width downto 0);
signal tap2_data  : std_logic_vector(p_data_width downto 0);
signal tap3_data  : std_logic_vector(p_data_width downto 0);
begin
process (aclk) begin
if (rising_edge(aclk)) then
    write_s <=i_enable;
end if;
end process;
write_p   <= '1' when (write_s ='1' and i_enable ='0') else '0';
process (aclk) begin
if (rising_edge(aclk) ) then
    if (write_p = '1') then
        if (write_chs = 3) then
            write_chs <= 0;
        else
            write_chs <= write_chs + 1;
        end if;
    end if;
end if;
end process;
wrchx0_io <= '1' when (write_chs = 0 and i_enable ='1')  else '0';
wrchx1_io <= '1' when (write_chs = 1 and i_enable ='1')  else '0';
wrchx2_io <= '1' when (write_chs = 2 and i_enable ='1')  else '0';
wrchx3_io <= '1' when (write_chs = 3 and i_enable ='1')  else '0';
process (aclk) begin
    if (rising_edge(aclk) ) then
        w1rchx0_io<=wrchx0_io;
        w1rchx1_io<=wrchx1_io;
        w1rchx2_io<=wrchx2_io;
        w1rchx3_io<=wrchx3_io;
        w2rchx0_io<=w1rchx0_io;
        w2rchx1_io<=w1rchx1_io;
        w2rchx2_io<=w1rchx2_io;
        w2rchx3_io<=w1rchx3_io;
		
        w3rchx0_io<=w2rchx0_io;
        w3rchx1_io<=w2rchx1_io;
        w3rchx2_io<=w2rchx2_io;
        w3rchx3_io<=w2rchx3_io;
		
    end if;
end process;
en_datao <= '1' when (w3rchx0_io ='1' or w3rchx1_io ='1' or w3rchx2_io ='1' or w3rchx3_io ='1')  else '0';

tap1_readout: process(aclk) begin
if (rising_edge(aclk) ) then
    if(wrchx0_io ='1' or w1rchx0_io ='1'     or w2rchx0_io ='1' or w3rchx0_io ='1') then
        taps0x <= tap1_data;
		taps1x <= tap2_data;
		taps2x <= tap3_data;
    elsif(wrchx1_io ='1' or w1rchx1_io ='1'  or w2rchx1_io ='1' or w3rchx1_io ='1') then
        taps0x <= tap2_data;
		taps1x <= tap3_data;
		taps2x <= tap0_data;
    elsif(wrchx2_io ='1' or w1rchx2_io ='1'  or w2rchx2_io ='1' or w3rchx2_io ='1') then
        taps0x <= tap3_data;
		taps1x <= tap0_data;
		taps2x <= tap1_data;
    elsif(wrchx3_io ='1' or w1rchx3_io ='1'  or w2rchx3_io ='1' or w3rchx3_io ='1') then
        taps0x <= tap0_data; 
        taps1x <= tap1_data; 
        taps2x <= tap2_data;		
    else
        taps0x <= (others => '0');
		taps1x <= (others => '0');
		taps2x <= (others => '0');
    end if;
end if;
end process tap1_readout;


int_line_d0: tap_buffer
generic map(
    img_width    => img_width,
    p_data_width => p_data_width,
    addr_width   => addr_width)
port map(
    write_clk => aclk, 
    write_enb => wrchx0_io,
    w_address => i_wadd(addr_width downto 0),
    idata     => i_data,
    read_clk  => aclk, 
    r_address => i_radd(addr_width downto 0),
    odata     => tap0_data);
int_line_d1: tap_buffer
generic map(
    img_width    => img_width,
    p_data_width => p_data_width,
    addr_width   => addr_width)
port map(
    write_clk => aclk, 
    write_enb => wrchx1_io,
    w_address => i_wadd(addr_width downto 0),
    idata     => i_data,
    read_clk  => aclk, 
    r_address => i_radd(addr_width downto 0),
    odata     => tap1_data);    
int_line_d2: tap_buffer
generic map(
    img_width    => img_width,
    p_data_width => p_data_width,
    addr_width   => addr_width)
port map(
    write_clk  => aclk, 
    write_enb  => wrchx2_io,
    w_address  => i_wadd(addr_width downto 0),
    idata      => i_data,
    read_clk   => aclk, 
    r_address  => i_radd(addr_width downto 0),
    odata      => tap2_data);
int_line_d3: tap_buffer
generic map(
    img_width    => img_width,
    p_data_width => p_data_width,
    addr_width   => addr_width)
port map(
    write_clk => aclk,
    write_enb => wrchx3_io,
    w_address => i_wadd(addr_width downto 0),
    idata     => i_data,
    read_clk   => aclk, 
    r_address  => i_radd(addr_width downto 0),
    odata      => tap3_data);
end architecture;