library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sobel is
generic (
    i_data_width   : integer := 8;
    img_width      : integer := 256;
    adwr_width     : integer := 16;
    addr_width     : integer := 11);
port (
    clk            : in std_logic;
    rst_l          : in std_logic;
    configReg6     : in std_logic_vector(31 downto 0);
    endOfFrame     : in std_logic;
    iRed           : in std_logic_vector(i_data_width-1 downto 0);
    iGreen         : in std_logic_vector(i_data_width-1 downto 0);
    iBlue          : in std_logic_vector(i_data_width-1 downto 0);
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
    oRed           : out std_logic_vector(i_data_width-1 downto 0);
    oGreen         : out std_logic_vector(i_data_width-1 downto 0);
    oBlue          : out std_logic_vector(i_data_width-1 downto 0);
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
--component squareRoot is
--port (                
--    clock      : in std_logic;
--    rst_l      : in std_logic;
--    data_in    : in unsigned(31 downto 0); 
--    data_out   : out unsigned(15 downto 0));
--end component squareRoot;
component squareRootTop is
port ( 
    aclk            : in std_logic;
    sFXtFoTvalid    : in std_logic;
    sFXtFoTdata     : in std_logic_vector(31 downto 0);
    mFOtFxRtvalid   : out std_logic;
    mFOtFxRtdata    : out std_logic_vector(31 downto 0));
end component squareRootTop;

---------------------------------------------------------------------------------
--GX
--[-1 +0 +1]
--[-2 +0 +2]
--[-1 +0 +1]
--ROW-1[-1 0 1]
signal Kernel_1_X : signed(i_data_width-1 downto 0) :=x"FF";
signal Kernel_2_X : signed(i_data_width-1 downto 0) :=x"00";
signal Kernel_3_X : signed(i_data_width-1 downto 0) :=x"01";
--ROW-2[-2 0 2]
signal Kernel_4_X : signed(i_data_width-1 downto 0) :=x"FE";
signal Kernel_5_X : signed(i_data_width-1 downto 0) :=x"00";
signal Kernel_6_X : signed(i_data_width-1 downto 0) :=x"02";
--ROW-3[-1 0 1]
signal Kernel_7_X : signed(i_data_width-1 downto 0) :=x"FF";
signal Kernel_8_X : signed(i_data_width-1 downto 0) :=x"00";
signal Kernel_9_X : signed(i_data_width-1 downto 0) :=x"01";
--GY
--[+1 +2 +1]
--[+0 +0 +0]
--[-1 -2 -1]
--ROW-1[+1 +2 +1]
signal Kernel_1_Y : signed(i_data_width-1 downto 0) :=x"01";
signal Kernel_2_Y : signed(i_data_width-1 downto 0) :=x"02";
signal Kernel_3_Y : signed(i_data_width-1 downto 0) :=x"01";
--ROW-2[+0 +0 +0]
signal Kernel_4_Y : signed(i_data_width-1 downto 0) :=x"00";
signal Kernel_5_Y : signed(i_data_width-1 downto 0) :=x"00";
signal Kernel_6_Y : signed(i_data_width-1 downto 0) :=x"00";
--ROW-3[-1 -2 -1]
signal Kernel_7_Y : signed(i_data_width-1 downto 0) :=x"FF";
signal Kernel_8_Y : signed(i_data_width-1 downto 0) :=x"FE";
signal Kernel_9_Y : signed(i_data_width-1 downto 0) :=x"FF";
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
        sqr        : std_logic_vector (31 downto 0);
        sbo        : unsigned (15 downto 0);
        sbof       : std_logic_vector (31 downto 0);
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
    
    signal en_datao     : std_logic;
    signal d1en         : std_logic;
    signal d2en         : std_logic;
    signal d3en         : std_logic;
    signal d4en         : std_logic;
    signal d5en         : std_logic;
    signal d6en         : std_logic;
    signal d7en         : std_logic;
    signal d8en         : std_logic;
    signal d9en         : std_logic;
    signal sFXtFoTvalid : std_logic;


    signal configReg   : integer;
    signal s_axis_a_tvalid         : std_logic := '1';
    signal m_axis_result_tvalid    : std_logic := '1';
---------------------------------------------------------------------------------
begin
configReg <= to_integer(unsigned(configReg6));
KUPDATE : process (clk) begin
  if rising_edge(clk) then
  if (endOfFrame = '1' and KernalConfig = x"00000001") then
      Kernel_1_X    <= signed(Kernal1(i_data_width-1 downto 0));
      Kernel_2_X    <= signed(Kernal2(i_data_width-1 downto 0));
      Kernel_3_X    <= signed(Kernal3(i_data_width-1 downto 0));
      Kernel_4_X    <= signed(Kernal4(i_data_width-1 downto 0));
      Kernel_5_X    <= signed(Kernal5(i_data_width-1 downto 0));
      Kernel_6_X    <= signed(Kernal6(i_data_width-1 downto 0));
      Kernel_7_X    <= signed(Kernal7(i_data_width-1 downto 0));
      Kernel_8_X    <= signed(Kernal8(i_data_width-1 downto 0));
      Kernel_9_X    <= signed(Kernal9(i_data_width-1 downto 0));
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
mod6_1_1_inst: buffer_controller
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
      d5en      <= '0';
      d6en      <= '0';
      d7en      <= '0';
      d8en      <= '0';
      sFXtFoTvalid    <= '0';

    elsif rising_edge(clk) then
      d1R      <= iRed;  
      d2R      <= d1R;
      d1G      <= iGreen;  
      d2G      <= d1G;
      d1B      <= iBlue;  
      d2B      <= d1B;
      d1en     <= en_datao;
      d2en     <= d1en;
      d3en     <= d2en;
      d4en     <= d3en;
      d5en     <= d4en;
      d6en     <= d5en;
      d7en     <= d6en;
      d8en     <= d7en;
      sFXtFoTvalid <=d9en;
    end if;
  end process TAP_SIGNED;
  
  d9en <= d4en or d8en;
  
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
        sobel.sqr    <= std_logic_vector(sobel.sxy(31 downto 0));
    end if;
  end process SQROOT;
--mod6_1_2_inst: squareRoot
--port map(
--    clock    => clk,
--    rst_l    => rst_l,
--    data_in  => sobel.sqr,
--    data_out => sobel.sbo);

mod6_1_2_inst: squareRootTop
port map(
    aclk              => clk,
    sFXtFoTvalid      => sFXtFoTvalid,
    sFXtFoTdata       => sobel.sqr,
    mFOtFxRtvalid     => oValid,
    mFOtFxRtdata      => sobel.sbof);
sobel.sbo    <= unsigned(std_logic_vector(sobel.sbof(15 downto 0)));
------------------------------------------------------------------------------------------------
  RT : process (clk, rst_l) begin
    if rst_l = '0' then
        oRed   <= (others => '0');
        oGreen <= (others => '0');
        oBlue  <= (others => '0');
    elsif rising_edge(clk) then
    if (sobel.sbo > unsigned(threshold)) then
            oRed   <= x"00";--BLACK
            oGreen <= x"00";--BLACK
            oBlue  <= x"00";--BLACK
    else
        if (configReg = 1) then
            oRed   <= d2R;--Replace WHITE with Original oRed
            oGreen <= d2G;--Replace WHITE with Original oGreen
            oBlue  <= d2B;--Replace WHITE with Original oBlue
        else
            oRed   <= x"FF";--WHITE
            oGreen <= x"FF";--WHITE
            oBlue  <= x"FF";--WHITE
        end if;
    end if;
    end if;
  end process RT;
------------------------------------------------------------------------------------------------
end architecture;
--library ieee;
--use ieee.std_logic_1164.all;
--use ieee.numeric_std.all;
--entity squareRoot is port( 
--    clock      : in std_logic;
--    rst_l      : in std_logic;
--    data_in    : in unsigned(31 downto 0); 
--    data_out   : out unsigned(15 downto 0)); 
--end squareRoot;
--architecture behaviour of squareRoot  is
--    function  sqrt  ( d : UNSIGNED ) return UNSIGNED is
--    variable a : unsigned(31 downto 0):=d;  --original input.
--    variable q : unsigned(15 downto 0):=(others => '0');  --result.
--    variable left,right,r : unsigned(17 downto 0):=(others => '0');  --input to adder/sub.r-remainder.
--    variable i : integer:=0;
--    begin
--    for i in 0 to 15 loop
--    right(0):='1';
--    right(1):=r(17);
--    right(17 downto 2):=q;
--    left(1 downto 0):=a(31 downto 30);
--    left(17 downto 2):=r(15 downto 0);
--    a(31 downto 2):=a(29 downto 0);  --shifting by 2 bit.
--    if ( r(17) = '1') then
--    r := left + right;
--    else
--    r := left - right;
--    end if;
--    q(15 downto 1) := q(14 downto 0);
--    q(0) := not r(17);
--    end loop; 
--    return q;
--    end sqrt;
--begin

--sqRoot : process (clock, rst_l) begin
--  if (rst_l = '0') then
--	data_out <=(others => '0');
--  elsif rising_edge(clock) then
--    data_out <= sqrt (data_in);
--  end if;
--end process sqRoot;


--end behaviour;
