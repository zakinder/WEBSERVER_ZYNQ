library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity frameProcess is
generic (
    i_data_width   : integer := 8;
    s_data_width   : integer := 16;
    b_data_width   : integer := 32;
    i_precision    : integer := 12;
    i_full_range   : boolean := FALSE;
    img_width      : integer := 256;
    adwr_width     : integer := 16;
    addr_width     : integer := 11);
port (
    clk            : in std_logic;
    rclk           : in std_logic;
    rst_l          : in std_logic;
    -----------------------------------------------------------
    iRed           : in std_logic_vector(i_data_width-1 downto 0);
    iGreen         : in std_logic_vector(i_data_width-1 downto 0);
    iBlue          : in std_logic_vector(i_data_width-1 downto 0);
    iValid         : in std_logic;
    -----------------------------------------------------------
    configReg6     : in std_logic_vector(b_data_width-1 downto 0);
    configReg7     : in std_logic_vector(b_data_width-1 downto 0);
    configReg8     : in std_logic_vector(b_data_width-1 downto 0);
    configReg19    : in std_logic_vector(b_data_width-1 downto 0);
    configReg20    : in std_logic_vector(b_data_width-1 downto 0);
    configReg21    : in std_logic_vector(b_data_width-1 downto 0);
    configReg41    : out std_logic_vector(b_data_width-1 downto 0);
    gridLockDatao  : out std_logic_vector(b_data_width-1 downto 0);
    gridDataRdEn   : in std_logic;
    endOfFrame     : in std_logic;
    threshold      : in std_logic_vector(s_data_width-1 downto 0);
    -----------------------------------------------------------
    --debug
--    fifoEmptyhdb   : out std_logic;
--    fifoFullhdb    : out std_logic;
--    fifoWritehdb   : out std_logic;
--    gridDataRdEndb : out std_logic;
--    gridDataEndb   : out std_logic;
--    clearDatadb    : out std_logic;
--    gridLocationdb : out std_logic;
--    fifoDataindb   : out std_logic_vector(b_data_width-1 downto 0);
--    cpuGridContdb  : out std_logic_vector(s_data_width-1 downto 0);
--    fifoDataOutdb  : out std_logic_vector(b_data_width-1 downto 0);
    -----------------------------------------------------------
    -----------------------------------------------------------
    Kernal1        : in std_logic_vector(b_data_width-1 downto 0);
    Kernal2        : in std_logic_vector(b_data_width-1 downto 0);
    Kernal3        : in std_logic_vector(b_data_width-1 downto 0);
    Kernal4        : in std_logic_vector(b_data_width-1 downto 0);
    Kernal5        : in std_logic_vector(b_data_width-1 downto 0);
    Kernal6        : in std_logic_vector(b_data_width-1 downto 0);
    Kernal7        : in std_logic_vector(b_data_width-1 downto 0);
    Kernal8        : in std_logic_vector(b_data_width-1 downto 0);
    Kernal9        : in std_logic_vector(b_data_width-1 downto 0);
    KernalConfig   : in std_logic_vector(b_data_width-1 downto 0);
    -----------------------------------------------------------
    rl             : in std_logic_vector(i_data_width-1 downto 0);
    rh             : in std_logic_vector(i_data_width-1 downto 0);
    gl             : in std_logic_vector(i_data_width-1 downto 0);
    gh             : in std_logic_vector(i_data_width-1 downto 0);
    bl             : in std_logic_vector(i_data_width-1 downto 0);
    bh             : in std_logic_vector(i_data_width-1 downto 0);
    -----------------------------------------------------------
    iXcont         : in std_logic_vector(s_data_width-1 downto 0);
    iYcont         : in std_logic_vector(s_data_width-1 downto 0);
    oXcont         : out std_logic_vector(s_data_width-1 downto 0);
    oYcont         : out std_logic_vector(s_data_width-1 downto 0);
    -----------------------------------------------------------
    oRed           : out std_logic_vector(i_data_width-1 downto 0);
    oGreen         : out std_logic_vector(i_data_width-1 downto 0);
    oBlue          : out std_logic_vector(i_data_width-1 downto 0);
    oValid         : out std_logic);
    -----------------------------------------------------------
end entity;
architecture arch of frameProcess is
component imageFilter is
generic (
    i_data_width   : integer := 8;
    img_width      : integer := 256;
    adwr_width     : integer := 16;
    addr_width     : integer := 11);
port (                
    clk           : in std_logic;
    rst_l         : in std_logic;
    iRed          : in std_logic_vector(i_data_width-1 downto 0);
    iGreen        : in std_logic_vector(i_data_width-1 downto 0);
    iBlue         : in std_logic_vector(i_data_width-1 downto 0);
    iValid        : in std_logic;
    iaddress      : in std_logic_vector(15 downto 0);
    oRed          : out std_logic_vector(i_data_width-1 downto 0);
    oGreen        : out std_logic_vector(i_data_width-1 downto 0);
    oBlue         : out std_logic_vector(i_data_width-1 downto 0);
    oValid        : out std_logic);
end component imageFilter;
component imageFilter2 is
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
end component imageFilter2;
component sobel is
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
end component sobel;
component detect is
generic (
    i_data_width   : integer := 8);
port (
    clk             : in std_logic;
    rst_l           : in std_logic;
    pValid          : in std_logic;
    endOfFrame      : in std_logic;
    iRed            : in std_logic_vector(i_data_width-1 downto 0);
    iGreen          : in std_logic_vector(i_data_width-1 downto 0);
    iBlue           : in std_logic_vector(i_data_width-1 downto 0);
    rl              : in std_logic_vector(i_data_width-1 downto 0);
    rh              : in std_logic_vector(i_data_width-1 downto 0);
    gl              : in std_logic_vector(i_data_width-1 downto 0);
    gh              : in std_logic_vector(i_data_width-1 downto 0);
    bl              : in std_logic_vector(i_data_width-1 downto 0);
    bh              : in std_logic_vector(i_data_width-1 downto 0);
    Xcont           : in std_logic_vector(15 downto 0);
    Ycont           : in std_logic_vector(15 downto 0);
    pDetect         : out std_logic;
    oRed            : out std_logic_vector(i_data_width-1 downto 0);
    oGreen          : out std_logic_vector(i_data_width-1 downto 0);
    oBlue           : out std_logic_vector(i_data_width-1 downto 0);
    oValid          : out std_logic);
end component detect;
component pointOfInterest is
generic (
    i_data_width   : integer := 8;
    s_data_width   : integer := 16;
    b_data_width   : integer := 32);
port (
    clk             : in std_logic;
    rclk            : in std_logic;
    rst_l           : in std_logic;
    iValid          : in std_logic;
    iRed            : in std_logic_vector(i_data_width-1 downto 0);
    iGreen          : in std_logic_vector(i_data_width-1 downto 0);
    iBlue           : in std_logic_vector(i_data_width-1 downto 0);
    -----------------------------------------------------------
    iXcont          : in std_logic_vector(s_data_width-1 downto 0);
    iYcont          : in std_logic_vector(s_data_width-1 downto 0);
    -----------------------------------------------------------
    --debug
--    fifoEmptyhdb   : out std_logic;
--    fifoFullhdb    : out std_logic;
--    fifoWritehdb   : out std_logic;
--    gridDataRdEndb : out std_logic;
--    gridDataEndb   : out std_logic;
--    clearDatadb    : out std_logic;
--    gridLocationdb : out std_logic;
--    fifoDataindb   : out std_logic_vector(b_data_width-1 downto 0);
--    cpuGridContdb  : out std_logic_vector(s_data_width-1 downto 0);
--    fifoDataOutdb  : out std_logic_vector(b_data_width-1 downto 0);
    -----------------------------------------------------------
    endOfFrame      : in std_logic;
    gridDataRdEn    : in std_logic;
    gridLockDatao   : out std_logic_vector(b_data_width-1 downto 0);
    configReg19     : in std_logic_vector(b_data_width-1 downto 0);
    configReg20     : in std_logic_vector(b_data_width-1 downto 0);
    configReg21     : in std_logic_vector(b_data_width-1 downto 0);
    configReg41     : out std_logic_vector(b_data_width-1 downto 0);
    -----------------------------------------------------------
    oGridLocation   : out std_logic;
    oRed            : out std_logic_vector(i_data_width-1 downto 0);
    oGreen          : out std_logic_vector(i_data_width-1 downto 0);
    oBlue           : out std_logic_vector(i_data_width-1 downto 0);
    oValid          : out std_logic);
end component pointOfInterest;
component hsv_c is
    generic (
    i_data_width    : integer := 8);
    port (  
    pixclk          : in  std_logic;
    reset           : in  std_logic;
    iRed            : in  std_logic_vector(i_data_width-1 downto 0);
    iGreen          : in  std_logic_vector(i_data_width-1 downto 0);
    iBlue           : in  std_logic_vector(i_data_width-1 downto 0);
    oH              : out std_logic_vector(i_data_width-1 downto 0);
    oS              : out std_logic_vector(i_data_width-1 downto 0);
    oV              : out std_logic_vector(i_data_width-1 downto 0));
end component hsv_c;
component rgb_ycbcr is
generic (
    i_data_width    : integer:= 8;
    i_precision     : integer:= 12;
    i_full_range    : boolean:= FALSE);
port (                          
    clk             : in  std_logic;
    rst_l           : in  std_logic;
    iRed            : in  std_logic_vector(i_data_width-1 downto 0);
    iGreen          : in  std_logic_vector(i_data_width-1 downto 0);
    iBlue           : in  std_logic_vector(i_data_width-1 downto 0);
    iValid          : in  std_logic;
    y               : out std_logic_vector(i_data_width-1 downto 0);
    cb              : out std_logic_vector(i_data_width-1 downto 0);
    cr              : out std_logic_vector(i_data_width-1 downto 0);
    oValid          : out std_logic);
end component rgb_ycbcr;
component color_correction is
generic (
    i_data_width    : integer := 8;
    C_WHOLE_WIDTH   : integer := 3;
    C_FRAC_WIDTH    : integer := 8);
port (                          
    clk             : in std_logic;
    rst             : in std_logic;
    iRed            : in std_logic_vector(i_data_width-1 downto 0);
    iGreen          : in std_logic_vector(i_data_width-1 downto 0);
    iBlue           : in std_logic_vector(i_data_width-1 downto 0);
    iValid          : in std_logic;
    iXcont          : in std_logic_vector(15 downto 0);
    iYcont          : in std_logic_vector(15 downto 0);
    oXcont          : out std_logic_vector(15 downto 0);
    oYcont          : out std_logic_vector(15 downto 0);
    Xcont           : out std_logic_vector(15 downto 0);
    Ycont           : out std_logic_vector(15 downto 0);
    oRed            : out std_logic_vector(i_data_width-1 downto 0);
    oGreen          : out std_logic_vector(i_data_width-1 downto 0);
    oBlue           : out std_logic_vector(i_data_width-1 downto 0);
    oValid          : out std_logic);
end component color_correction;
---------------------------------------------------------------------------------
    type videoColor is record
        red           : std_logic_vector(i_data_width-1 downto 0);
        green         : std_logic_vector(i_data_width-1 downto 0);
        blue          : std_logic_vector(i_data_width-1 downto 0);
    end record;
    signal soble              : videoColor;
    signal grid               : videoColor;
    signal grid2               : videoColor;
    signal hsv                : videoColor;
    signal sharp              : videoColor;
    signal blur               : videoColor;
    signal channel            : videoColor;
    signal rgbcorrect         : videoColor;
    signal rgbcorrectSelect   : videoColor;
    signal ycbcr              : videoColor;
    signal correctValid       : std_logic;
    signal channelValid       : std_logic;
    signal sharpValid         : std_logic;
    signal blurValid          : std_logic;
    signal sobelValid         : std_logic;
    signal ycbcrValid         : std_logic;
    signal rgbcorrectSelectValid         : std_logic;
    signal gridLock           : std_logic;
    signal grid2Lock          : std_logic;
    signal Xcont              : std_logic_vector(15 downto 0);
    signal Ycont              : std_logic_vector(15 downto 0);
    signal XcontS             : std_logic_vector(15 downto 0);
    signal YcontS             : std_logic_vector(15 downto 0);
    signal rgbSum             : std_logic_vector(11 downto 0);
    signal rowdist            : integer;
    signal nrowdist           : integer;
    signal coldist            : integer;
    signal ncoldist           : integer;
    signal irgbSum            : integer;
    signal config_Reg6        : integer;
    signal config_Reg7        : integer;
    signal config_Reg8        : integer;
    signal xCounter           : integer;
    signal yCounter           : integer;
    signal gridValid         : std_logic;
---------------------------------------------------------------------------------
begin
---------------------------------------------------------------------------------
    config_Reg6 <= to_integer(unsigned(configReg6));
    config_Reg7 <= to_integer(unsigned(configReg7));
    config_Reg8 <= to_integer(unsigned(configReg8));
    xCounter    <= to_integer(unsigned(Xcont));
    yCounter    <= to_integer(unsigned(Ycont));
---------------------------------------------------------------------------------
-- COLOR_CORRECTION
---------------------------------------------------------------------------------
mod5_0_inst: color_correction
generic map(
    i_data_width         => i_data_width,
    C_WHOLE_WIDTH        => 3,
    C_FRAC_WIDTH         => 8)
port map(           
    clk                  => clk,
    rst                  => rst_l,
    iRed                 => iRed,
    iGreen               => iGreen,
    iBlue                => iBlue,
    iValid               => iValid,
    iXcont               => iXcont,
    iYcont               => iYcont,
    oXcont               => oXcont,
    oYcont               => oYcont,
    Xcont                => XcontS,
    Ycont                => YcontS,
    oRed                 => rgbcorrectSelect.red,
    oGreen               => rgbcorrectSelect.green,
    oBlue                => rgbcorrectSelect.blue,
    oValid               => rgbcorrectSelectValid);
---------------------------------------------------------------------------------
--CHANNEL OUT
---------------------------------------------------------------------------------
  ChannelCorrect : process (clk, rst_l) begin
    if rst_l = '0' then
        rgbcorrect.red    <= (others => '0');
        rgbcorrect.green  <= (others => '0');
        rgbcorrect.blue   <= (others => '0');
        correctValid      <= '0';
        Xcont             <= (others => '0');
        Ycont             <= (others => '0');
    elsif rising_edge(clk) then
        if (config_Reg8 = 0) then -- DIRECT.SOBLE
            correctValid         <= rgbcorrectSelectValid;
            rgbcorrect.red       <= rgbcorrectSelect.red;
            rgbcorrect.green     <= rgbcorrectSelect.green;
            rgbcorrect.blue      <= rgbcorrectSelect.blue;
            Xcont                <= XcontS;
            Ycont                <= YcontS;          
        else
            correctValid         <= iValid;
            rgbcorrect.red       <= iRed;
            rgbcorrect.green     <= iGreen;
            rgbcorrect.blue      <= iBlue;
            Xcont                <= iXcont;
            Ycont                <= iYcont;
        end if;
    end if;
  end process ChannelCorrect;
---------------------------------------------------------------------------------
-- SOBEL
---------------------------------------------------------------------------------
mod5_1_inst: sobel
    generic map(
    i_data_width         => i_data_width,
    img_width            => img_width,
    adwr_width           => adwr_width,
    addr_width           => addr_width)
    port map(
    clk                 => clk,
    rst_l               => rst_l,
    configReg6          => configReg6,
    endOfFrame          => endOfFrame,
    iRed                => rgbcorrect.red,
    iGreen              => rgbcorrect.green,
    iBlue               => rgbcorrect.blue,
    iValid              => correctValid,
    threshold           => threshold,
    iaddress            => Xcont,
    Kernal1             => Kernal1,
    Kernal2             => Kernal2,
    Kernal3             => Kernal3,
    Kernal4             => Kernal4,
    Kernal5             => Kernal5,
    Kernal6             => Kernal6,
    Kernal7             => Kernal7,
    Kernal8             => Kernal8,
    Kernal9             => Kernal9,
    KernalConfig        => KernalConfig,
    oRed                => soble.red,
    oGreen              => soble.green,
    oBlue               => soble.blue,
    oValid              => sobelValid);
---------------------------------------------------------------------------------
-- IMAGEFILTER
---------------------------------------------------------------------------------
mod5_2_inst: imageFilter
generic map(
    i_data_width       => i_data_width,
    img_width          => img_width,
    adwr_width         => 15,
    addr_width         => 11)
port map(
    clk                => clk,
    rst_l              => rst_l,
    --input
    iRed               => rgbcorrect.red,
    iGreen             => rgbcorrect.green,
    iBlue              => rgbcorrect.blue,
    iValid             => correctValid,
    iaddress           => Xcont,
    oRed               => sharp.red,
    oGreen             => sharp.green,
    oBlue              => sharp.blue,
    oValid             => sharpValid);
mod5_3_inst: imageFilter2
generic map(
    i_data_width       => i_data_width,
    img_width          => img_width,
    adwr_width         => 16,
    addr_width         => 11)
port map(
    clk                => clk,
    rst_l              => rst_l,
    iaddress           => Xcont,
    iValid             => correctValid,
    iRed               => rgbcorrect.red,
    iGreen             => rgbcorrect.green,
    iBlue              => rgbcorrect.blue,
    oRed               => blur.red,
    oGreen             => blur.green,
    oBlue              => blur.blue,
    oValid             => blurValid);
---------------------------------------------------------------------------------
-- DETECT
---------------------------------------------------------------------------------
mod5_4_inst: detect
generic map(
    i_data_width        => i_data_width)
port map(
    clk                 => clk,
    rst_l               => rst_l,
    iRed                => sharp.red,
    iGreen              => sharp.green,
    iBlue               => sharp.green,
    rl                  => rl,
    rh                  => rh,
    gl                  => gl,
    gh                  => gh,
    bl                  => bl,
    bh                  => bh,
    endOfFrame          => endOfFrame,
    pValid              => sharpValid,
    Xcont               => Xcont,
    Ycont               => Ycont,
    pDetect             => gridLock,
    oRed                => grid.red,
    oGreen              => grid.green,
    oBlue               => grid.blue,
    oValid              => open);
mod5_8_inst: pointOfInterest
generic map(
    i_data_width     => i_data_width,
    s_data_width     => s_data_width,
    b_data_width     => b_data_width)
port map(
    clk                 => clk,
    rclk                => rclk,
    rst_l               => rst_l,
    -----------------------------------------------------------
    iValid              => correctValid,
    iRed                => rgbcorrect.red,
    iGreen              => rgbcorrect.green,
    iBlue               => rgbcorrect.blue,
    -----------------------------------------------------------
    iXcont              => Xcont,
    iYcont              => Ycont,
    -----------------------------------------------------------
    --debug
--    fifoEmptyhdb   => fifoEmptyhdb,
--    fifoFullhdb    => fifoFullhdb,
--    fifoWritehdb   => fifoWritehdb,
--    gridDataRdEndb => gridDataRdEndb,
--    gridDataEndb   => gridDataEndb,
--    clearDatadb    => clearDatadb,
--    gridLocationdb => gridLocationdb,
--    fifoDataindb   => fifoDataindb,
--    cpuGridContdb  => cpuGridContdb,
--    fifoDataOutdb  => fifoDataOutdb,
    -----------------------------------------------------------
    endOfFrame          => endOfFrame,
    gridDataRdEn        => gridDataRdEn,
    gridLockDatao       => gridLockDatao,
    configReg19         => configReg19,
    configReg20         => configReg20,
    configReg21         => configReg21,
    configReg41         => configReg41,
    -----------------------------------------------------------
    oGridLocation       => grid2Lock,
    oRed                => grid2.red,
    oGreen              => grid2.green,
    oBlue               => grid2.blue,
    oValid              => gridValid);
---------------------------------------------------------------------------------
-- HSV
---------------------------------------------------------------------------------
mod5_5_inst: hsv_c
generic map(
    i_data_width  => i_data_width)
port map(   
    pixclk        => clk,
    reset         => rst_l,
    iRed          => rgbcorrect.red,
    iGreen        => rgbcorrect.green,
    iBlue         => rgbcorrect.blue,
    oH            => hsv.red,
    oS            => hsv.green,
    oV            => hsv.blue);
TESTPATTEN1: Process (clk) begin
 if rising_edge(clk) then
 	if correctValid = '1'  then
		if xcounter > 960 then
			rowdist <= xcounter - 960;
		else
			rowdist <= 960 - xcounter;
		end if;
		if rowdist > 480 then
			nrowdist <= rowdist - 480;
		else
			nrowdist <= 480 - rowdist;
		end if;	
		if ycounter > 540 then
			coldist <= ycounter -540;
		else
			coldist <= 540 - ycounter;
		end if;
		if coldist > 270 then
			ncoldist <= coldist - 270;
		else
			ncoldist <= 270 - coldist;
		end if;
		irgbSum <= nrowdist + ncoldist;
	rgbsum <= std_logic_vector(to_unsigned(irgbSum,12));
	end if;
end if;
end process TESTPATTEN1;
---------------------------------------------------------------------------------
--DIRECT LINES SELECT
---------------------------------------------------------------------------------
  VideoOut : process (clk, rst_l) begin
    if rst_l = '0' then
        channel.red   <= (others => '0');
        channel.green <= (others => '0');
        channel.blue  <= (others => '0');
        channelValid  <= '0';
    elsif rising_edge(clk) then
        if (config_Reg6 = 0) then -- DIRECT.SOBLE
            channelValid      <= sobelValid;
            channel.red       <= soble.red;
            channel.green     <= soble.green;
            channel.blue      <= soble.blue;
        elsif(config_Reg6 = 1)then -- DIRECT.SOBLE
            channelValid      <= sobelValid;
            channel.red       <= soble.red;
            channel.green     <= soble.green;
            channel.blue      <= soble.blue;
        elsif(config_Reg6 = 2)then -- DIRECT.GRID
            channelValid  <= sobelValid;
            if (gridLock = '1') then -- DIRECT.GRID.SOBLE
                channel.red   <= soble.red;
                channel.green <= soble.green;
                channel.blue  <= soble.blue;
            else                   -- DIRECT.GRID.LINES
                channel.red   <= grid.red;
                channel.green <= grid.green;
                channel.blue  <= grid.blue;
            end if;
        elsif(config_Reg6 = 3)then -- DIRECT.GRID
            channelValid  <= sobelValid;
            if (grid2Lock = '1') then -- DIRECT.GRID.SOBLE
                channel.red   <= soble.red;
                channel.green <= soble.green;
                channel.blue  <= soble.blue;
            else                   -- DIRECT.GRID.LINES
                channel.red   <= grid2.red;
                channel.green <= grid2.green;
                channel.blue  <= grid2.blue;
            end if;
        elsif(config_Reg6 = 3)then -- DIRECT.GRID
            channelValid  <= gridValid;
            if (grid2Lock = '1') then -- DIRECT.GRID.SOBLE
                channel.red   <= hsv.red;
                channel.green <= hsv.green;
                channel.blue  <= hsv.blue;
            else                   -- DIRECT.GRID.LINES
                channel.red   <= grid2.red;
                channel.green <= grid2.green;
                channel.blue  <= grid2.blue;
            end if;
        elsif(config_Reg6 = 4)then -- DIRECT.SHARP
            channelValid      <= sharpValid;
            channel.red       <= sharp.red;
            channel.green     <= sharp.green;
            channel.blue      <= sharp.green;
        elsif(config_Reg6 = 5)then -- DIRECT.SHARP
            channelValid      <= blurValid;
            channel.red       <= blur.red;
            channel.green     <= blur.green;
            channel.blue      <= blur.green;
        elsif(config_Reg6 = 6)then -- DIRECT.HSL
            channelValid      <= correctValid;
            channel.red       <= hsv.red;
            channel.green     <= hsv.green;
            channel.blue      <= hsv.blue;
        elsif(config_Reg6 = 7)then -- DIRECT.RGB
            channelValid      <= iValid;
            channel.red       <= iRed;
            channel.green     <= iGreen;
            channel.blue      <= iBlue;
        elsif(config_Reg6 = 8)then -- DIRECT.HSL
            channelValid      <= correctValid;
            channel.red       <= rgbsum(i_data_width-1 downto 0);
            channel.green     <= rgbsum(i_data_width-1 downto 0);
            channel.blue      <= rgbsum(i_data_width-1 downto 0);
        elsif(config_Reg6 = 9)then -- DIRECT.HSL
            channelValid      <= correctValid;
            channel.red       <= x"0" & rgbsum(3 downto 0);
            channel.green     <= x"0" & rgbsum(7 downto 4);
            channel.blue      <= x"0" & rgbsum(11 downto 8);
        elsif(config_Reg6 = 10)then -- DIRECT.HSL
            channelValid      <= correctValid;
            channel.red       <= rgbsum(i_data_width-1 downto 0);
            channel.green     <= x"0" & rgbsum(7 downto 4);
            channel.blue      <= x"0" & rgbsum(11 downto 8);
        elsif(config_Reg6 = 11)then -- DIRECT.HSL
            channelValid      <= correctValid;
            channel.red       <= x"0" & rgbsum(3 downto 0);
            channel.green     <= rgbsum(i_data_width-1 downto 0);
            channel.blue      <= x"0" & rgbsum(11 downto 8);
        elsif(config_Reg6 = 12)then -- DIRECT.HSL
            channelValid      <= correctValid;
            channel.red       <= x"0" & rgbsum(3 downto 0);
            channel.green     <= x"0" & rgbsum(7 downto 4);
            channel.blue      <= rgbsum(i_data_width-1 downto 0);
        else
            channelValid      <= correctValid;
            channel.red       <= rgbcorrect.red;
            channel.green     <= rgbcorrect.green;
            channel.blue      <= rgbcorrect.blue;
        end if;
    end if;
  end process VideoOut;
---------------------------------------------------------------------------------
-- YCBCR 
-- IN  : CHANNEL
-- OUT : oPIXELS
---------------------------------------------------------------------------------
mod5_6_inst: rgb_ycbcr
generic map(
    i_data_width         => i_data_width,
    i_precision          => i_precision,
    i_full_range         => FALSE)
port map(
    clk                  => clk,
    rst_l                => rst_l,
    iRed                 => channel.red,
    iGreen               => channel.green,
    iBlue                => channel.blue,
    iValid               => channelValid,
    y                    => ycbcr.red,
    cb                   => ycbcr.green,
    cr                   => ycbcr.blue,
    oValid               => ycbcrValid);
---------------------------------------------------------------------------------
--CHANNEL OUT
---------------------------------------------------------------------------------
  ChannelOut : process (clk, rst_l) begin
    if rst_l = '0' then
        oRed    <= (others => '0');
        oGreen  <= (others => '0');
        oBlue   <= (others => '0');
        oValid  <= '0';
    elsif rising_edge(clk) then
        if (config_Reg7 = 0) then -- DIRECT.SOBLE
            oValid     <= ycbcrValid;
            oRed       <= ycbcr.red;
            oGreen     <= ycbcr.green;
            oBlue      <= ycbcr.blue;
        else
            oValid     <= channelValid;
            oRed       <= channel.red;
            oGreen     <= channel.green;
            oBlue      <= channel.blue;
        end if;
    end if;
  end process ChannelOut;
---------------------------------------------------------------------------------
-- CPU SINGLE SELECT PARALLEL PROCESS
---------------------------------------------------------------------------------
-- VALUE     : TASK
-- 01        : COLOR_CORRECTION - EDGETYPE - PREWITT
-- 02        : COLOR_CORRECTION - EDGETYPE - SOBEL
-- 03        : COLOR_CORRECTION - GRIDLOCK
-- 04        : COLOR_CORRECTION - SHARP
-- 05        : COLOR_CORRECTION - HSL
-- 06        : COLOR_CORRECTION
-- 07        : 1-5 NON COLOR_CORRECTION
-- 08        : TESTPATTEN1
-- 09        : 
-- 10        : 
-- 11        : 
-- 12        : 
-- 13        : 
-- 14        : 
-- 15        : 
-- 16        : 
---------------------------------------------------------------------------------
--
---------------------------------------------------------------------------------
end architecture;