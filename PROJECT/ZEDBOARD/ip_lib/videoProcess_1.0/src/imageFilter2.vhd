library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity imageFilter2 is
generic (
    i_data_width  : integer := 8;
    img_width     : integer := 256;
    adwr_width    : integer := 16;
    addr_width    : integer := 11);
port (
    clk           : in std_logic;
    rst_l         : in std_logic;
    iRed          : in std_logic_vector(i_data_width-1 downto 0);
    iGreen        : in std_logic_vector(i_data_width-1 downto 0);
    iBlue         : in std_logic_vector(i_data_width-1 downto 0);
    iValid        : in std_logic;
    iaddress      : in std_logic_vector(adwr_width-1 downto 0);
    oRed          : out std_logic_vector(i_data_width-1 downto 0);
    oGreen        : out std_logic_vector(i_data_width-1 downto 0);
    oBlue         : out std_logic_vector(i_data_width-1 downto 0);
    oValid        : out std_logic);
end entity;
architecture arch of imageFilter2 is
component buffer_controller is
generic (
	img_width             : integer := 4096;
	adwr_width            : integer := 15;
	p_data_width          : integer := 11;
	addr_width            : integer := 11);
port (                
	aclk                  : in std_logic;
	i_enable              : in std_logic;
	i_data                : in std_logic_vector(p_data_width downto 0);
	i_wadd                : in std_logic_vector(adwr_width downto 0);
	i_radd                : in std_logic_vector(adwr_width downto 0);
	en_datao              : out std_logic;
	taps0x                : out std_logic_vector(p_data_width downto 0);
	taps1x                : out std_logic_vector(p_data_width downto 0);
	taps2x                : out std_logic_vector(p_data_width downto 0));
end component buffer_controller;
component imageRGB2mac is
port (                
	clk            : in std_logic;
	rst_l          : in std_logic;
	vTap0x         : in std_logic_vector(7 downto 0);
	vTap1x         : in std_logic_vector(7 downto 0);
	vTap2x         : in std_logic_vector(7 downto 0);
	Kernel_1       : in unsigned(7 downto 0);
	Kernel_2       : in unsigned(7 downto 0);
	Kernel_3       : in unsigned(7 downto 0);
	Kernel_4       : in unsigned(7 downto 0);
	Kernel_5       : in unsigned(7 downto 0);
	Kernel_6       : in unsigned(7 downto 0);
	Kernel_7       : in unsigned(7 downto 0);
	Kernel_8       : in unsigned(7 downto 0);
	Kernel_9       : in unsigned(7 downto 0);
    DataO          : out std_logic_vector(11 downto 0));
end component imageRGB2mac;
---------------------------------------------------------------------------------
    signal vTapRGB0x   : std_logic_vector(23 downto 0);
    signal vTapRGB1x   : std_logic_vector(23 downto 0);
    signal vTapRGB2x   : std_logic_vector(23 downto 0);
    signal v1TapRGB0x  : std_logic_vector(23 downto 0);
    signal v1TapRGB1x  : std_logic_vector(23 downto 0);
    signal v1TapRGB2x  : std_logic_vector(23 downto 0);
    signal enable      : std_logic;
    signal d1en        : std_logic;
    signal d2en        : std_logic;
    signal d3en        : std_logic;
    signal d4en        : std_logic;
    signal d1R         : std_logic_vector(i_data_width-1 downto 0);
    signal d2R         : std_logic_vector(i_data_width-1 downto 0);
    signal d1G         : std_logic_vector(i_data_width-1 downto 0);
    signal d2G         : std_logic_vector(i_data_width-1 downto 0);
    signal d1B         : std_logic_vector(i_data_width-1 downto 0);
    signal d2B         : std_logic_vector(i_data_width-1 downto 0);
    signal d2RGB       : std_logic_vector(23 downto 0);
    constant Kernel_1 : unsigned(i_data_width-1 downto 0) :=x"01";
    constant Kernel_2 : unsigned(i_data_width-1 downto 0) :=x"01";
    constant Kernel_3 : unsigned(i_data_width-1 downto 0) :=x"01";
    constant Kernel_4 : unsigned(i_data_width-1 downto 0) :=x"01";
    constant Kernel_5 : unsigned(i_data_width-1 downto 0) :=x"01";
    constant Kernel_6 : unsigned(i_data_width-1 downto 0) :=x"01";
    constant Kernel_7 : unsigned(i_data_width-1 downto 0) :=x"01";
    constant Kernel_8 : unsigned(i_data_width-1 downto 0) :=x"01";
    constant Kernel_9 : unsigned(i_data_width-1 downto 0) :=x"01";
    signal sRed       : std_logic_vector(11 downto 0);
    signal sGreen     : std_logic_vector(11 downto 0);
    signal sBlue      : std_logic_vector(11 downto 0);
---------------------------------------------------------------------------------
begin

    oRed   <=  sRed(11 downto 4);
    oGreen <=  sGreen(11 downto 4);
    oBlue  <=  sBlue(11 downto 4);

RGB_inst: buffer_controller
    generic map(
    img_width       => img_width,
    adwr_width      => 15,
    p_data_width    => 23,
    addr_width      => 11)
    port map(
    aclk            => clk,
    i_enable        => iValid,
    i_data          => d2RGB,
    i_wadd          => iaddress,
    i_radd          => iaddress,
    en_datao        => enable,
    taps0x          => v1TapRGB0x,
    taps1x          => v1TapRGB1x,
    taps2x          => v1TapRGB2x);
MAC_R_inst: imageRGB2mac
    port map(
    clk             => clk,
    rst_l           => rst_l,
    vTap0x          => vTapRGB0x(23 downto 16),
    vTap1x          => vTapRGB1x(23 downto 16),
    vTap2x          => vTapRGB2x(23 downto 16),
    Kernel_1        => Kernel_1,
    Kernel_2        => Kernel_2,
    Kernel_3        => Kernel_3,
    Kernel_4        => Kernel_4,
    Kernel_5        => Kernel_5,
    Kernel_6        => Kernel_6,
    Kernel_7        => Kernel_7,
    Kernel_8        => Kernel_8,
    Kernel_9        => Kernel_9,
    DataO           => sRed);
MAC_G_inst: imageRGB2mac
    port map(
    clk             => clk,
    rst_l           => rst_l,
    vTap0x          => vTapRGB0x(15 downto 8),
    vTap1x          => vTapRGB1x(15 downto 8),
    vTap2x          => vTapRGB2x(15 downto 8),
    Kernel_1        => Kernel_1,
    Kernel_2        => Kernel_2,
    Kernel_3        => Kernel_3,
    Kernel_4        => Kernel_4,
    Kernel_5        => Kernel_5,
    Kernel_6        => Kernel_6,
    Kernel_7        => Kernel_7, 
    Kernel_8        => Kernel_8,
    Kernel_9        => Kernel_9,
    DataO           => sGreen);
MAC_B_inst: imageRGB2mac
    port map(
    clk             => clk,
    rst_l           => rst_l,
    vTap0x          => vTapRGB0x(i_data_width-1 downto 0),
    vTap1x          => vTapRGB1x(i_data_width-1 downto 0),
    vTap2x          => vTapRGB2x(i_data_width-1 downto 0),
    Kernel_1        => Kernel_1,
    Kernel_2        => Kernel_2,
    Kernel_3        => Kernel_3,
    Kernel_4        => Kernel_4,
    Kernel_5        => Kernel_5,
    Kernel_6        => Kernel_6,
    Kernel_7        => Kernel_7, 
    Kernel_8        => Kernel_8,
    Kernel_9        => Kernel_9,
    DataO           => sBlue);
  TAP_SIGNED : process (clk, rst_l) begin
    if rst_l = '0' then
      d1en      <= '0';
      d2en      <= '0';
      d3en      <= '0';
      d4en      <= '0';
    elsif rising_edge(clk) then
      d1R      <= iRed;  
      d2R      <= d1R;
      d1G      <= iGreen;  
      d2G      <= d1G;
      d1B      <= iBlue;  
      d2B      <= d1B;
	  d2RGB    <= d1R & d1G & d1B;
      d1en     <= enable;
      d2en     <= d1en;
      oValid   <= d2en;
      d4en     <= d3en;
      if(enable = '1') then
          vTapRGB0x <=v1TapRGB0x;
          vTapRGB1x <=v1TapRGB1x;
          vTapRGB2x <=v1TapRGB2x;
      else
          vTapRGB0x <=(others => '0');
          vTapRGB1x <=(others => '0');
          vTapRGB2x <=(others => '0');
      end if;
    end if;
end process TAP_SIGNED;
end architecture;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity imageRGB2mac is
port (
    clk            : in std_logic;
    rst_l          : in std_logic;
    vTap0x         : in std_logic_vector(7 downto 0);
    vTap1x         : in std_logic_vector(7 downto 0);
    vTap2x         : in std_logic_vector(7 downto 0);
    Kernel_1       : in unsigned(7 downto 0);
    Kernel_2       : in unsigned(7 downto 0);
    Kernel_3       : in unsigned(7 downto 0);
    Kernel_4       : in unsigned(7 downto 0);
    Kernel_5       : in unsigned(7 downto 0);
    Kernel_6       : in unsigned(7 downto 0);
    Kernel_7       : in unsigned(7 downto 0);
    Kernel_8       : in unsigned(7 downto 0);
    Kernel_9       : in unsigned(7 downto 0);
    DataO          : out std_logic_vector(11 downto 0));
end entity;
architecture arch of imageRGB2mac is
---------------------------------------------------------------------------------
constant i_data_width : integer := 8;
    type vSB is record
        vTap0x                            : unsigned(i_data_width downto 0);
        vTap1x                            : unsigned(i_data_width downto 0);
        vTap2x                            : unsigned(i_data_width downto 0);
		address                           : std_logic_vector(15 downto 0);
    end record;
    type detap is record
        vTap0x                            : unsigned(i_data_width downto 0);
        vTap1x                            : unsigned(i_data_width downto 0);
        vTap2x                            : unsigned(i_data_width downto 0);
    end record;
    type s_pixel is record
        m1                                : unsigned (16 downto 0);
        m2                                : unsigned (16 downto 0);
        m3                                : unsigned (16 downto 0);
        mac                               : unsigned (i_data_width+3 downto 0);
    end record;
---------------------------------------------------------------------------------
    signal mac1X       : s_pixel;
    signal mac2X       : s_pixel;
    signal mac3X       : s_pixel;
    signal tpd1        : detap;
    signal tpd2        : detap;
    signal tpd3        : detap;
    signal Data        : unsigned(i_data_width+3 downto 0);
---------------------------------------------------------------------------------
begin
  TAP_DELAY : process (clk, rst_l)
  begin
    if rst_l = '0' then
      tpd1.vTap0x    <= (others => '0');
      tpd1.vTap1x    <= (others => '0');
      tpd1.vTap2x    <= (others => '0');
      tpd2.vTap0x    <= (others => '0');
      tpd2.vTap1x    <= (others => '0');
      tpd2.vTap2x    <= (others => '0'); 
      tpd3.vTap0x    <= (others => '0');
      tpd3.vTap1x    <= (others => '0');
      tpd3.vTap2x    <= (others => '0');
    elsif rising_edge(clk) then
      tpd1.vTap0x    <= unsigned('0' & vTap0x);
      tpd1.vTap1x    <= unsigned('0' & vTap1x);
      tpd1.vTap2x    <= unsigned('0' & vTap2x);
      tpd2.vTap0x    <= tpd1.vTap0x;
      tpd2.vTap1x    <= tpd1.vTap1x;
      tpd2.vTap2x    <= tpd1.vTap2x;
      tpd3.vTap0x    <= tpd2.vTap0x;
      tpd3.vTap1x    <= tpd2.vTap1x;
      tpd3.vTap2x    <= tpd2.vTap2x;
    end if;
  end process TAP_DELAY;
  --1st Row Pixels
  MAC_X_A : process (clk, rst_l) begin
    if rst_l = '0' then
		mac1X.m1    <= (others => '0');
		mac1X.m2    <= (others => '0');
		mac1X.m3    <= (others => '0');
		mac1X.mac   <= (others => '0');
    elsif rising_edge(clk) then
		mac1X.m1    <= (tpd1.vTap0x * Kernel_9);--1st Row 1st pixel
		mac1X.m2    <= (tpd2.vTap0x * Kernel_8);--1st Row 2nd pixel
		mac1X.m3    <= (tpd3.vTap0x * Kernel_7);--1st Row 3rd pixel
		mac1X.mac   <= mac1X.m1(i_data_width+3 downto 0) + mac1X.m2(i_data_width+3 downto 0) + mac1X.m3(i_data_width+3 downto 0);
    end if;
  end process MAC_X_A;
  MAC_X_B : process (clk, rst_l) begin
    if rst_l = '0' then
		mac2X.m1    <= (others => '0');
		mac2X.m2    <= (others => '0');
		mac2X.m3    <= (others => '0');
		mac2X.mac   <= (others => '0');
    elsif rising_edge(clk) then
		mac2X.m1    <= (tpd1.vTap1x * Kernel_6);--2nd Row 1st pixel
		mac2X.m2    <= (tpd2.vTap1x * Kernel_5);--2nd Row 2nd pixel
		mac2X.m3    <= (tpd3.vTap1x * Kernel_4);--2nd Row 3rd pixel
		mac2X.mac   <= mac2X.m1(i_data_width+3 downto 0) + mac2X.m2(i_data_width+3 downto 0) + mac2X.m3(i_data_width+3 downto 0);
    end if;
  end process MAC_X_B;
  MAC_X_C : process (clk, rst_l) begin
    if rst_l = '0' then
		mac3X.m1    <= (others => '0');
		mac3X.m2    <= (others => '0');
		mac3X.m3    <= (others => '0');
		mac3X.mac   <= (others => '0');
    elsif rising_edge(clk) then
		mac3X.m1    <= (tpd1.vTap2x * Kernel_3);--3rd Row 1st pixel
		mac3X.m2    <= (tpd2.vTap2x * Kernel_2);--3rd Row 2nd pixel
		mac3X.m3    <= (tpd3.vTap2x * Kernel_1);--3rd Row 3rd pixel
		mac3X.mac   <= mac3X.m1(i_data_width+3 downto 0) + mac3X.m2(i_data_width+3 downto 0) + mac3X.m3(i_data_width+3 downto 0);
    end if;
  end process MAC_X_C;

  PA_X : process (clk, rst_l) begin
    if rst_l = '0' then
		Data <= (others => '0');
    elsif rising_edge(clk) then
		Data <= mac1X.mac + mac2X.mac + mac3X.mac;
    end if;
  end process PA_X;
  DataO <= std_logic_vector(Data);
end architecture;