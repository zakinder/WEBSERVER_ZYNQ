library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity sobel is
generic (
    img_width      : integer := 256;
    adwr_width     : integer := 16;
    p_data_width   : integer := 16;
    addr_width     : integer := 11);
port (
    clk            : in std_logic;
    rst_l          : in std_logic;
    configReg5     : in std_logic_vector(31 downto 0);
    endOfFrame     : in std_logic;
    pDetect        : in std_logic;
    d_R            : in std_logic_vector(7 downto 0);
    d_G            : in std_logic_vector(7 downto 0);
    d_B            : in std_logic_vector(7 downto 0);
    iValid         : in std_logic;
    threshold      : in std_logic_vector(15 downto 0);
    iaddress       : in std_logic_vector(15 downto 0);
    Kernal1        : in std_logic_vector(31 downto 0);
    Kernal2        : in std_logic_vector(31 downto 0);
    Kernal3        : in std_logic_vector(31 downto 0);
    Kernal4        : in std_logic_vector(31 downto 0);
    Kernal5        : in std_logic_vector(31 downto 0);
    Kernal6        : in std_logic_vector(31 downto 0);
    Kernal7        : in std_logic_vector(31 downto 0);
    Kernal8        : in std_logic_vector(31 downto 0);
    Kernal9        : in std_logic_vector(31 downto 0);
    KernalConfig   : in std_logic_vector(31 downto 0);
    dsR            : out std_logic_vector(7 downto 0);
    dsG            : out std_logic_vector(7 downto 0);
    dsB            : out std_logic_vector(7 downto 0);
    oValid         : out std_logic);
end entity;
architecture arch of sobel is
component buffer_controller is
generic (
    img_width     : integer := 4096;
    adwr_width    : integer := 15;
    p_data_width  : integer := 11;
    addr_width    : integer := 11);
port (
    aclk          : in std_logic;
    i_enable      : in std_logic;
    i_data        : in std_logic_vector(p_data_width downto 0);
    i_wadd        : in std_logic_vector(adwr_width downto 0);
    i_radd        : in std_logic_vector(adwr_width downto 0);
    en_datao      : out std_logic;
    taps0x        : out std_logic_vector(p_data_width downto 0);
    taps1x        : out std_logic_vector(p_data_width downto 0);
    taps2x        : out std_logic_vector(p_data_width downto 0));
end component buffer_controller;
component squareRoot is
port (                
    clock      : in std_logic;
    rst_l      : in std_logic;
    data_in    : in unsigned(31 downto 0); 
    data_out   : out unsigned(15 downto 0));
end component squareRoot;
component imageFilter is
generic (
    img_width     : integer := 256;
    adwr_width    : integer := 16;
    p_data_width  : integer := 16;
    addr_width    : integer := 11);
port (                
    clk           : in std_logic;
    rst_l         : in std_logic;
    d_Ri          : in std_logic_vector(7 downto 0);
    d_Gi          : in std_logic_vector(7 downto 0);
    d_Bi          : in std_logic_vector(7 downto 0);
    iaddress      : in std_logic_vector(15 downto 0);
    iValid        : in std_logic;
    d_Ro          : out std_logic_vector(7 downto 0);
    d_Go          : out std_logic_vector(7 downto 0);
    d_Bo          : out std_logic_vector(7 downto 0);
    oValid        : out std_logic);
end component imageFilter;
---------------------------------------------------------------------------------
constant i_data_width : integer := 8;
---------------------------------------------------------------------------------
--GX
--[-1 +0 +1]
--[-2 +0 +2]
--[-1 +0 +1]
--ROW-1[-1 0 1]
signal Kernel_1_X : signed(7 downto 0) :=x"FF";
signal Kernel_2_X : signed(7 downto 0) :=x"00";
signal Kernel_3_X : signed(7 downto 0) :=x"01";
--ROW-2[-2 0 2]
signal Kernel_4_X : signed(7 downto 0) :=x"FE";
signal Kernel_5_X : signed(7 downto 0) :=x"00";
signal Kernel_6_X : signed(7 downto 0) :=x"02";
--ROW-3[-1 0 1]
signal Kernel_7_X : signed(7 downto 0) :=x"FF";
signal Kernel_8_X : signed(7 downto 0) :=x"00";
signal Kernel_9_X : signed(7 downto 0) :=x"01";
--GY
--[+1 +2 +1]
--[+0 +0 +0]
--[-1 -2 -1]
--ROW-1[+1 +2 +1]
signal Kernel_1_Y : signed(7 downto 0) :=x"01";
signal Kernel_2_Y : signed(7 downto 0) :=x"02";
signal Kernel_3_Y : signed(7 downto 0) :=x"01";
--ROW-2[+0 +0 +0]
signal Kernel_4_Y : signed(7 downto 0) :=x"00";
signal Kernel_5_Y : signed(7 downto 0) :=x"00";
signal Kernel_6_Y : signed(7 downto 0) :=x"00";
--ROW-3[-1 -2 -1]
signal Kernel_7_Y : signed(7 downto 0) :=x"FF";
signal Kernel_8_Y : signed(7 downto 0) :=x"FE";
signal Kernel_9_Y : signed(7 downto 0) :=x"FF";
---------------------------------------------------------------------------------
    type vSB is record
        vTap0x     : signed(i_data_width downto 0);
        vTap1x     : signed(i_data_width downto 0);
        vTap2x     : signed(i_data_width downto 0);
        address    : std_logic_vector(15 downto 0);
    end record;
    type detap is record
        vTap0x     : signed(i_data_width downto 0);
        vTap1x     : signed(i_data_width downto 0);
        vTap2x     : signed(i_data_width downto 0);
    end record;
    type s_pixel is record
        m1         : signed (17 downto 0);
        m2         : signed (17 downto 0);
        m3         : signed (17 downto 0);
        mac        : signed (16 downto 0);
    end record;
    type presults is record
        pax        : signed (16 downto 0);
        pay        : signed (16 downto 0);
        mx         : signed (34 downto 0);
        my         : signed (34 downto 0);
        sxy        : signed (34 downto 0);
        sqr        : unsigned (31 downto 0);
        sbo        : unsigned (15 downto 0);
    end record;
---------------------------------------------------------------------------------
    signal vsobel      : vSB;
    signal vTap0x      : std_logic_vector(i_data_width-1 downto 0);
    signal vTap1x      : std_logic_vector(i_data_width-1 downto 0);
    signal vTap2x      : std_logic_vector(i_data_width-1 downto 0);
    signal d1R         : std_logic_vector(i_data_width-1 downto 0);
    signal d2R         : std_logic_vector(i_data_width-1 downto 0);
    signal d1G         : std_logic_vector(i_data_width-1 downto 0);
    signal d2G         : std_logic_vector(i_data_width-1 downto 0);
    signal d1B         : std_logic_vector(i_data_width-1 downto 0);
    signal d2B         : std_logic_vector(i_data_width-1 downto 0);
    signal mac1X       : s_pixel;
    signal mac2X       : s_pixel;
    signal mac3X       : s_pixel;
    signal mac1Y       : s_pixel;
    signal mac2Y       : s_pixel;
    signal mac3Y       : s_pixel;
    signal sobel       : presults;
    signal tpd1        : detap;
    signal tpd2        : detap;
    signal tpd3        : detap;
    signal en_datao    : std_logic;
    signal d1en        : std_logic;
    signal d2en        : std_logic;
    signal d3en        : std_logic;
    signal d4en        : std_logic;
    signal fValid      : std_logic;
    signal d_Ro        : std_logic_vector(7 downto 0);
    signal d_Go        : std_logic_vector(7 downto 0);
    signal d_Bo        : std_logic_vector(7 downto 0);
    signal configReg   : integer;
    signal Red         : std_logic_vector(i_data_width-1 downto 0);
    signal Green       : std_logic_vector(i_data_width-1 downto 0);
    signal Blue        : std_logic_vector(i_data_width-1 downto 0);
---------------------------------------------------------------------------------
begin
configReg <= to_integer(unsigned(configReg5));
KUPDATE : process (clk) begin
  if rising_edge(clk) then
  if (endOfFrame = '1' and KernalConfig = x"00000001") then
      Kernel_1_X    <= signed(Kernal1(7 downto 0));
      Kernel_2_X    <= signed(Kernal2(7 downto 0));
      Kernel_3_X    <= signed(Kernal3(7 downto 0));
      Kernel_4_X    <= signed(Kernal4(7 downto 0));
      Kernel_5_X    <= signed(Kernal5(7 downto 0));
      Kernel_6_X    <= signed(Kernal6(7 downto 0));
      Kernel_7_X    <= signed(Kernal7(7 downto 0));
      Kernel_8_X    <= signed(Kernal8(7 downto 0));
      Kernel_9_X    <= signed(Kernal9(7 downto 0));
      Kernel_1_Y    <= signed(Kernal1(15 downto 8));
      Kernel_2_Y    <= signed(Kernal2(15 downto 8));
      Kernel_3_Y    <= signed(Kernal3(15 downto 8));
      Kernel_4_Y    <= signed(Kernal4(15 downto 8));
      Kernel_5_Y    <= signed(Kernal5(15 downto 8));
      Kernel_6_Y    <= signed(Kernal6(15 downto 8));
      Kernel_7_Y    <= signed(Kernal7(15 downto 8));
      Kernel_8_Y    <= signed(Kernal8(15 downto 8));
      Kernel_9_Y    <= signed(Kernal9(15 downto 8));
  end if;
  end if;
end process KUPDATE;
mod1_inst: buffer_controller
    generic map(
    img_width            => img_width,
    adwr_width           => 15,
    p_data_width         => 7,
    addr_width           => 11)
    port map(
    aclk                 => clk,
    i_enable             => iValid,
    i_data               => d2G,
    i_wadd               => iaddress,
    i_radd               => iaddress,
    en_datao             => en_datao,
    taps0x               => vTap0x,
    taps1x               => vTap1x,
    taps2x               => vTap2x);
SHARP_inst: imageFilter
generic map(
    img_width          => img_width,
    adwr_width         => 15,
    p_data_width       => 7,
    addr_width         => 11)
port map(
    clk                => clk,
    rst_l              => rst_l,
    --input
    d_Ri               => d_R,
    d_Gi               => d_G,
    d_Bi               => d_B,
    iValid             => iValid,
    iaddress           => iaddress,
    --output
    d_Ro               => d_Ro,
    d_Go               => d_Go,
    d_Bo               => d_Bo,
    oValid             => fValid);
  -------------------------------------------------------------------------
  -- data should be at 4 cycle after pValid
  -------------------------------------------------------------------------
  TAP_SIGNED : process (clk, rst_l)
  begin
    if rst_l = '0' then
      d1R       <= (others => '0'); 
      d2R       <= (others => '0');
      d1G       <= (others => '0'); 
      d2G       <= (others => '0');
      d1B       <= (others => '0'); 
      d2B       <= (others => '0');
      d1en      <= '0';
      d2en      <= '0';
      d3en      <= '0';
      d4en      <= '0';
    elsif rising_edge(clk) then
      d1R      <= d_R;  
      d2R      <= d1R;
      d1G      <= d_G;  
      d2G      <= d1G;
      d1B      <= d_B;  
      d2B      <= d1B;
      d1en     <= en_datao;
      d2en     <= d1en;
      d3en     <= d2en;
      d4en     <= d3en;
    end if;
  end process TAP_SIGNED;
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
      tpd1.vTap0x    <= signed('0' & vTap0x);
      tpd1.vTap1x    <= signed('0' & vTap1x);
      tpd1.vTap2x    <= signed('0' & vTap2x);
      tpd2.vTap0x    <= tpd1.vTap0x;
      tpd2.vTap1x    <= tpd1.vTap1x;
      tpd2.vTap2x    <= tpd1.vTap2x;
      tpd3.vTap0x    <= tpd2.vTap0x;
      tpd3.vTap1x    <= tpd2.vTap1x;
      tpd3.vTap2x    <= tpd2.vTap2x;
    end if;
  end process TAP_DELAY;
  MAC_X_A : process (clk, rst_l) begin
    if rst_l = '0' then
        mac1X.m1    <= (others => '0');
        mac1X.m2    <= (others => '0');
        mac1X.m3    <= (others => '0');
        mac1X.mac   <= (others => '0');
    elsif rising_edge(clk) then
        mac1X.m1    <= '0' & (tpd1.vTap0x * Kernel_9_X);
        mac1X.m2    <= '0' & (tpd2.vTap0x * Kernel_8_X);
        mac1X.m3    <= '0' & (tpd3.vTap0x * Kernel_7_X);
        mac1X.mac   <= mac1X.m1(16 downto 0) + mac1X.m2(16 downto 0) + mac1X.m3(16 downto 0);
    end if;
  end process MAC_X_A;
  MAC_X_B : process (clk, rst_l) begin
    if rst_l = '0' then
        mac2X.m1    <= (others => '0');
        mac2X.m2    <= (others => '0');
        mac2X.m3    <= (others => '0');
        mac2X.mac   <= (others => '0');
    elsif rising_edge(clk) then
        mac2X.m1    <= '0' & (tpd1.vTap1x * Kernel_6_X);
        mac2X.m2    <= '0' & (tpd2.vTap1x * Kernel_5_X);
        mac2X.m3    <= '0' & (tpd3.vTap1x * Kernel_4_X);
        mac2X.mac   <= mac2X.m1(16 downto 0) + mac2X.m2(16 downto 0) + mac2X.m3(16 downto 0);
    end if;
  end process MAC_X_B;
  MAC_X_C : process (clk, rst_l) begin
    if rst_l = '0' then
        mac3X.m1    <= (others => '0');
        mac3X.m2    <= (others => '0');
        mac3X.m3    <= (others => '0');
        mac3X.mac   <= (others => '0');
    elsif rising_edge(clk) then
        mac3X.m1    <= '0' & (tpd1.vTap2x * Kernel_3_X);
        mac3X.m2    <= '0' & (tpd2.vTap2x * Kernel_2_X);
        mac3X.m3    <= '0' & (tpd3.vTap2x * Kernel_1_X);
        mac3X.mac   <= mac3X.m1(16 downto 0) + mac3X.m2(16 downto 0) + mac3X.m3(16 downto 0);
    end if;
  end process MAC_X_C;
  MAC_Y_A : process (clk, rst_l) begin
    if rst_l = '0' then
        mac1Y.m1    <= (others => '0');
        mac1Y.m2    <= (others => '0');
        mac1Y.m3    <= (others => '0');
        mac1Y.mac   <= (others => '0');
    elsif rising_edge(clk) then
        mac1Y.m1    <= '0' & (tpd1.vTap0x * Kernel_9_Y);
        mac1Y.m2    <= '0' & (tpd1.vTap0x * Kernel_8_Y);
        mac1Y.m3    <= '0' & (tpd1.vTap0x * Kernel_7_Y);
        mac1Y.mac   <= mac1Y.m1(16 downto 0) + mac1Y.m2(16 downto 0) + mac1Y.m3(16 downto 0);
    end if;
  end process MAC_Y_A;
  MAC_Y_B : process (clk, rst_l) begin
    if rst_l = '0' then
        mac2Y.m1    <= (others => '0');
        mac2Y.m2    <= (others => '0');
        mac2Y.m3    <= (others => '0');
        mac2Y.mac   <= (others => '0');
    elsif rising_edge(clk) then
        mac2Y.m1    <= '0' & (tpd1.vTap1x * Kernel_6_Y);
        mac2Y.m2    <= '0' & (tpd1.vTap1x * Kernel_5_Y);
        mac2Y.m3    <= '0' & (tpd1.vTap1x * Kernel_4_Y);
        mac2Y.mac   <= mac2Y.m1(16 downto 0) + mac2Y.m2(16 downto 0) + mac2Y.m3(16 downto 0);
    end if;
  end process MAC_Y_B;
  MAC_Y_C : process (clk, rst_l) begin
    if rst_l = '0' then
        mac3Y.m1    <= (others => '0');
        mac3Y.m2    <= (others => '0');
        mac3Y.m3    <= (others => '0');
        mac3Y.mac   <= (others => '0');
    elsif rising_edge(clk) then
        mac3Y.m1    <= '0' & (tpd1.vTap2x * Kernel_3_Y);
        mac3Y.m2    <= '0' & (tpd1.vTap2x * Kernel_2_Y);
        mac3Y.m3    <= '0' & (tpd1.vTap2x * Kernel_1_Y);
        mac3Y.mac   <= mac3Y.m1(16 downto 0) + mac3Y.m2(16 downto 0) + mac3Y.m3(16 downto 0);
    end if;
  end process MAC_Y_C;
  PA_X : process (clk, rst_l) begin
    if rst_l = '0' then
        sobel.pax <= (others => '0');
    elsif rising_edge(clk) then
        sobel.pax <= mac1X.mac + mac2X.mac + mac3X.mac;
    end if;
  end process PA_X;
  PA_Y : process (clk, rst_l) begin
    if rst_l = '0' then
        sobel.pay <= (others => '0');
    elsif rising_edge(clk) then
        sobel.pay <= mac1Y.mac + mac2Y.mac + mac3Y.mac;
    end if;
  end process PA_Y;
  GX : process (clk, rst_l) begin
    if rst_l = '0' then
        sobel.mx <= (others => '0');
    elsif rising_edge(clk) then
        sobel.mx <= '0' & (sobel.pax * sobel.pax);
    end if;
  end process GX;
  GY : process (clk, rst_l) begin
    if rst_l = '0' then
        sobel.my <= (others => '0');
    elsif rising_edge(clk) then
        sobel.my <= '0' & (sobel.pay * sobel.pay);
    end if;
  end process GY;
  GS : process (clk, rst_l) begin
    if rst_l = '0' then
        sobel.sxy <= (others => '0');
    elsif rising_edge(clk) then
        sobel.sxy <= (sobel.mx + sobel.my);
    end if;
  end process GS;
  
  SQROOT : process (clk, rst_l) begin
    if rst_l = '0' then
        sobel.sqr <=(others => '0');
    elsif rising_edge(clk) then
        sobel.sqr    <= unsigned(std_logic_vector(sobel.sxy(31 downto 0)));
    end if;
  end process SQROOT;
  
inst_squareRoot: squareRoot
port map(
    clock    => clk,
    rst_l    => rst_l,
    data_in  => sobel.sqr,
    data_out => sobel.sbo); 
  
  RT : process (clk, rst_l) begin
    if rst_l = '0' then
        Red   <= (others => '0');
        Green <= (others => '0');
        Blue  <= (others => '0');
    elsif rising_edge(clk) then
    if (sobel.sbo > unsigned(threshold)) then
            Red   <= x"00";--BLACK
            Green <= x"00";--BLACK
            Blue  <= x"00";--BLACK
    else
        if (configReg = 1) then
            Red   <= d2R;--Replace WHITE with Original Red
            Green <= d2G;--Replace WHITE with Original Green
            Blue  <= d2B;--Replace WHITE with Original Blue
        else
            Red   <= x"FF";--WHITE
            Green <= x"FF";--WHITE
            Blue  <= x"FF";--WHITE
        end if;
    end if;
    end if;
  end process RT;
  VideoOut : process (clk, rst_l) begin
    if rst_l = '0' then
        dsR <= (others => '0');
        dsG <= (others => '0');
        dsB <= (others => '0');
    elsif rising_edge(clk) then
        if (configReg = 0) then
            oValid  <= d4en;
            dsR     <= Red;
            dsG     <= Green;
            dsB     <= Blue;
        elsif(configReg = 1)then
            oValid  <= d4en;
            dsR     <= Red;
            dsG     <= Green;
            dsB     <= Blue;
        elsif(configReg = 2)then
            oValid  <= d4en;
            if (pDetect = '1') then
                dsR  <= Red;
                dsG  <= Green;
                dsB  <= Blue;
            else     
                dsR  <= d2R;
                dsG  <= d2G;
                dsB  <= d2B;
            end if;
        elsif(configReg = 3)then
            oValid  <= fValid;
            dsR     <= d_Ro;
            dsG     <= d_Go;
            dsB     <= d_Bo;
        else
            oValid  <= iValid;
            dsR     <= d_R;
            dsG     <= d_G;
            dsB     <= d_B;
        end if;
    end if;
  end process VideoOut;
end architecture;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity imageFilter is
generic (
    img_width     : integer := 256;
    adwr_width    : integer := 16;
    p_data_width  : integer := 16;
    addr_width    : integer := 11);
port (
    clk           : in std_logic;
    rst_l         : in std_logic;
    d_Ri          : in std_logic_vector(7 downto 0);
    d_Gi          : in std_logic_vector(7 downto 0);
    d_Bi          : in std_logic_vector(7 downto 0);
    iValid        : in std_logic;
    iaddress      : in std_logic_vector(15 downto 0);
    d_Ro          : out std_logic_vector(7 downto 0);
    d_Go          : out std_logic_vector(7 downto 0);
    d_Bo          : out std_logic_vector(7 downto 0);
    oValid        : out std_logic);
end entity;
architecture arch of imageFilter is
component buffer_controller is
generic (
    img_width    : integer := 4096;
    adwr_width   : integer := 15;
    p_data_width : integer := 11;
    addr_width   : integer := 11);
port (           
    aclk         : in std_logic;
    i_enable     : in std_logic;
    i_data       : in std_logic_vector(p_data_width downto 0);
    i_wadd       : in std_logic_vector(adwr_width downto 0);
    i_radd       : in std_logic_vector(adwr_width downto 0);
    en_datao     : out std_logic;
    taps0x       : out std_logic_vector(p_data_width downto 0);
    taps1x       : out std_logic_vector(p_data_width downto 0);
    taps2x       : out std_logic_vector(p_data_width downto 0));
end component buffer_controller;
component imageRGBmac is
port (                
    clk         : in std_logic;
    rst_l       : in std_logic;
    vTap0x      : in std_logic_vector(7 downto 0);
    vTap1x      : in std_logic_vector(7 downto 0);
    vTap2x      : in std_logic_vector(7 downto 0);
    DataO       : out std_logic_vector(7 downto 0));
end component imageRGBmac;
---------------------------------------------------------------------------------
constant i_data_width                : integer := 8;
---------------------------------------------------------------------------------
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
---------------------------------------------------------------------------------
begin
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
MAC_R_inst: imageRGBmac
    port map(
    clk             => clk,
    rst_l           => rst_l,
    vTap0x          => vTapRGB0x(23 downto 16),
    vTap1x          => vTapRGB1x(23 downto 16),
    vTap2x          => vTapRGB2x(23 downto 16),
    DataO           => d_Ro);
MAC_G_inst: imageRGBmac
    port map(
    clk             => clk,
    rst_l           => rst_l,
    vTap0x          => vTapRGB0x(15 downto 8),
    vTap1x          => vTapRGB1x(15 downto 8),
    vTap2x          => vTapRGB2x(15 downto 8),
    DataO           => d_Go);
MAC_B_inst: imageRGBmac
    port map(
    clk             => clk,
    rst_l           => rst_l,
    vTap0x          => vTapRGB0x(7 downto 0),
    vTap1x          => vTapRGB1x(7 downto 0),
    vTap2x          => vTapRGB2x(7 downto 0),
    DataO           => d_Bo);
  TAP_SIGNED : process (clk, rst_l) begin
    if rst_l = '0' then
      d1en      <= '0';
      d2en      <= '0';
      d3en      <= '0';
      d4en      <= '0';
    elsif rising_edge(clk) then
      d1R      <= d_Ri;  
      d2R      <= d1R;
      d1G      <= d_Gi;  
      d2G      <= d1G;
      d1B      <= d_Bi;  
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
entity imageRGBmac is
port (
    clk            : in std_logic;
    rst_l          : in std_logic;
    vTap0x         : in std_logic_vector(7 downto 0);
    vTap1x         : in std_logic_vector(7 downto 0);
    vTap2x         : in std_logic_vector(7 downto 0);
    DataO          : out std_logic_vector(7 downto 0));
end entity;
architecture arch of imageRGBmac is
---------------------------------------------------------------------------------
constant i_data_width : integer := 8;
    type vSB is record
        vTap0x    : signed(i_data_width downto 0);
        vTap1x    : signed(i_data_width downto 0);
        vTap2x    : signed(i_data_width downto 0);
        address   : std_logic_vector(15 downto 0);
    end record;
    type detap is record
        vTap0x    : signed(i_data_width downto 0);
        vTap1x    : signed(i_data_width downto 0);
        vTap2x    : signed(i_data_width downto 0);
    end record;
    type s_pixel is record
        m1        : signed (16 downto 0);
        m2        : signed (16 downto 0);
        m3        : signed (16 downto 0);
        mac       : signed (i_data_width+3 downto 0);
    end record;
---------------------------------------------------------------------------------
    signal mac1X      : s_pixel;
    signal mac2X      : s_pixel;
    signal mac3X      : s_pixel;
    signal tpd1       : detap;
    signal tpd2       : detap;
    signal tpd3       : detap;
    signal o1Data     : signed(i_data_width+3 downto 0);
    signal o2Data     : signed(i_data_width+3 downto 0);
    constant Kernel_1 : signed(7 downto 0) :=x"00";
    constant Kernel_2 : signed(7 downto 0) :=x"FF";
    constant Kernel_3 : signed(7 downto 0) :=x"00";
    constant Kernel_4 : signed(7 downto 0) :=x"FF";
    constant Kernel_5 : signed(7 downto 0) :=x"05";
    constant Kernel_6 : signed(7 downto 0) :=x"FF";
    constant Kernel_7 : signed(7 downto 0) :=x"00";
    constant Kernel_8 : signed(7 downto 0) :=x"FF";
    constant Kernel_9 : signed(7 downto 0) :=x"00";
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
      tpd1.vTap0x    <= signed('0' & vTap0x);
      tpd1.vTap1x    <= signed('0' & vTap1x);
      tpd1.vTap2x    <= signed('0' & vTap2x);
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
        o1Data <= (others => '0');
    elsif rising_edge(clk) then
        o1Data <= mac1X.mac + mac2X.mac + mac3X.mac;
    end if;
  end process PA_X;
  U_DATA : process(o1Data)begin
    if(o1Data(11) = '1')then
        o2Data <= (others => '0');
    else
        o2Data <= o1Data;
    end if;
  end process U_DATA;
  O_DATA : process(o2Data)begin
    if(o2Data(8) = '1')then
        DataO <= (others => '1');
    else
        DataO <= std_logic_vector(o2Data(7 downto 0));
    end if;
  end process O_DATA;
end architecture;