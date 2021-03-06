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