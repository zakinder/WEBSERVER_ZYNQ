library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;
entity d5m_tb is
end d5m_tb;
    -------------------------------------------------------------------------
architecture behavioral of d5m_tb is
    constant i_data_width   : integer := 8;
    constant s_data_width   : integer := 16;
    constant b_data_width   : integer := 32;
    constant i_precision    : integer := 12;
    constant i_full_range   : boolean := FALSE;
    constant img_width      : integer := 127;
    constant adwr_width     : integer := 16;
    constant addr_width     : integer := 11;
component frameProcess is
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
    rclk          : in std_logic;
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
    configReg40    : in std_logic_vector(b_data_width-1 downto 0);
    configReg41    : out std_logic_vector(b_data_width-1 downto 0);
    gridLockDatao  : out std_logic_vector(31 downto 0);
    gridDataRdEn   : in std_logic;
    endOfFrame     : in std_logic;
    threshold      : in std_logic_vector(s_data_width-1 downto 0);
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
end component frameProcess;
component imageReadWrite is
        generic (
		i_data_width  : integer := 8;
        test          : string  := "test1"; 
        input_file    : string  := "input_image";  
        output_file   : string  := "output_image");
        port (                
        pixclk        : in  std_logic;
        iRed          : in  std_logic_vector(i_data_width-1 downto 0);
        iGreen        : in  std_logic_vector(i_data_width-1 downto 0);
        iBlue         : in  std_logic_vector(i_data_width-1 downto 0);
        startFrame    : in std_logic;
        runFrame      : out std_logic;
        fvalid        : out std_logic;
        lvalid        : out std_logic;
        oRed          : out std_logic_vector(i_data_width-1 downto 0);
        oGreen        : out std_logic_vector(i_data_width-1 downto 0);
        oBlue         : out std_logic_vector(i_data_width-1 downto 0);
        xCount        : out std_logic_vector(15 downto 0);
        yCount        : out std_logic_vector(15 downto 0);
        rl            : out std_logic_vector(i_data_width-1 downto 0);
        rh            : out std_logic_vector(i_data_width-1 downto 0);
        gl            : out std_logic_vector(i_data_width-1 downto 0);
        gh            : out std_logic_vector(i_data_width-1 downto 0);
        bl            : out std_logic_vector(i_data_width-1 downto 0);
        bh            : out std_logic_vector(i_data_width-1 downto 0);
        address       : out std_logic_vector(15 downto 0);
        endOfFrame    : out std_logic;
        oValid        : out std_logic);
end component imageReadWrite;
component imageRead is
        generic (
		i_data_width  : integer := 8;
        test          : string  := "test1"; 
        output_file   : string  := "output_image");
        port (                
        pixclk        : in  std_logic;
        iRed          : in  std_logic_vector(i_data_width-1 downto 0);
        iGreen        : in  std_logic_vector(i_data_width-1 downto 0);
        iBlue         : in  std_logic_vector(i_data_width-1 downto 0);
        iValid        : in std_logic;
        startFrame    : in std_logic;
        runFrame      : out std_logic;
        endOfFrame    : out std_logic);
end component imageRead;
    -------------------------------------------------------------------------
    procedure clk_gen(signal clk : out std_logic; constant freq : real) is
    constant period              : time := 1 sec / freq;
    constant high_time           : time := period / 2;
    constant low_time            : time := period - high_time;
    begin
        loop
            clk <= '1';
        wait for high_time;
            clk <= '0';
        wait for low_time;
    end loop;
    end procedure;
    -------------------------------------------------------------------------
    -------------------------------------------------------------------------
    type videoio is record
        Red               : std_logic_vector(i_data_width-1 downto 0);
        Green             : std_logic_vector(i_data_width-1 downto 0);
        Blue              : std_logic_vector(i_data_width-1 downto 0);
		valid             : std_logic;
		address           : std_logic_vector(15 downto 0);
    end record;
    type videoi is record
        Red               : std_logic_vector(11 downto 0);
        Green             : std_logic_vector(11 downto 0);
        Blue              : std_logic_vector(11 downto 0);
        valid             : std_logic;
        endOfFrame        : std_logic;
        runFrame          : std_logic;
        address           : std_logic_vector(15 downto 0);
        xCount            : std_logic_vector(15 downto 0);
        yCount            : std_logic_vector(15 downto 0);
    end record;
    signal v01VideoIO     : videoi;
    signal v02VideoIO     : videoi;
    signal v03VideoIO     : videoi;
    signal v04VideoIO     : videoi;
    signal v05VideoIO     : videoi;
    signal v06VideoIO     : videoi;
    signal threshold      :  std_logic_vector(s_data_width-1 downto 0) :=x"0004";
    signal m_axis_mm2s_aclk     : std_logic;
    signal m_axis_mm2s_aresetn     : std_logic;
    -------------------------------------------------------------------------
	signal Kernal1              : std_logic_vector(b_data_width-1 downto 0);
	signal Kernal2              : std_logic_vector(b_data_width-1 downto 0);
	signal Kernal3              : std_logic_vector(b_data_width-1 downto 0);
	signal Kernal4              : std_logic_vector(b_data_width-1 downto 0);
	signal Kernal5              : std_logic_vector(b_data_width-1 downto 0);
	signal Kernal6              : std_logic_vector(b_data_width-1 downto 0);
	signal Kernal7              : std_logic_vector(b_data_width-1 downto 0);
	signal Kernal8              : std_logic_vector(b_data_width-1 downto 0);
	signal Kernal9              : std_logic_vector(b_data_width-1 downto 0);
	signal KernalConfig         : std_logic_vector(b_data_width-1 downto 0);
    signal rl                   : std_logic_vector(i_data_width-1 downto 0) :=x"0A";
    signal rh                   : std_logic_vector(i_data_width-1 downto 0) :=x"50";
    signal gl                   : std_logic_vector(i_data_width-1 downto 0) :=x"0A";
    signal gh                   : std_logic_vector(i_data_width-1 downto 0) :=x"50";
    signal bl                   : std_logic_vector(i_data_width-1 downto 0) :=x"0A";
    signal bh                   : std_logic_vector(i_data_width-1 downto 0) :=x"50";
    signal configReg6           :  std_logic_vector(b_data_width-1 downto 0) :=x"00000003";
    signal configReg7           :  std_logic_vector(b_data_width-1 downto 0) :=x"00000001";
    signal configReg8           :  std_logic_vector(b_data_width-1 downto 0) :=x"00000001";
    
    signal configReg19          :  std_logic_vector(b_data_width-1 downto 0) :=x"00000000";
    signal configReg20          :  std_logic_vector(b_data_width-1 downto 0) :=x"0000007F";
    
    signal configReg40          :  std_logic_vector(b_data_width-1 downto 0) :=x"00000007";
    signal configReg41          :  std_logic_vector(b_data_width-1 downto 0);
    signal gridLockDatao        :  std_logic_vector(b_data_width-1 downto 0) :=x"00000001";
    signal gridDataRdEn         :  std_logic :='0';
    signal startFrame1          : std_logic;
    signal startFrame2          : std_logic;
    signal iValid,fvalid        : std_logic;
begin
    -------------------------------------------------------------------------
    clk_gen(m_axis_mm2s_aclk, 1000.00e6);
    -------------------------------------------------------------------------
    process begin
        m_axis_mm2s_aresetn  <= '0';
    wait for 100 ns;
        m_axis_mm2s_aresetn  <= '1';
    wait;
    end process;
hslMax: process (m_axis_mm2s_aclk) begin
  if rising_edge(m_axis_mm2s_aclk) then 
    if (v01VideoIO.runFrame = '1') then
        startFrame1 <= '1';
    elsif(v03VideoIO.runFrame = '1')then
        startFrame2 <= '1';
    else
        startFrame1 <= '0';
        startFrame2 <= '0';
    end if;
  end if;
end process hslMax;
IMAGE1_ReadWrite: imageReadWrite
    generic map (
    i_data_width       => 8,
    test               => "test1",
    input_file         => "input",
    output_file        => "output")
    port map (                  
    pixclk             => m_axis_mm2s_aclk,
    iRed               => v02VideoIO.Red(7 downto 0),
    iGreen             => v02VideoIO.Green(7 downto 0),
    iBlue              => v02VideoIO.Blue(7 downto 0),
    oRed               => v01VideoIO.Red(7 downto 0),
    oGreen             => v01VideoIO.Green(7 downto 0),
    oBlue              => v01VideoIO.Blue(7 downto 0),
    runFrame           => v01VideoIO.runFrame,
    xCount             => v01VideoIO.xCount,
    yCount             => v01VideoIO.yCount,
    startFrame         => startFrame1,
    fvalid             => fvalid,
    lvalid             => open,
    rl                 => rl,
    rh                 => rh,
    gl                 => gl,
    gh                 => gh,
    bl                 => bl,
    bh                 => bh,
    address            => v01VideoIO.address,
    endOfFrame         => v01VideoIO.endOfFrame,
    oValid             => v01VideoIO.Valid);
IMAGE2_ReadWrite: imageReadWrite
    generic map (
    i_data_width       => 8,
    test               => "test2",
    input_file         => "input",
    output_file        => "output")
    port map (                  
    pixclk             => m_axis_mm2s_aclk,
    iRed               => v04VideoIO.Red(7 downto 0),
    iGreen             => v04VideoIO.Green(7 downto 0),
    iBlue              => v04VideoIO.Blue(7 downto 0),
    oRed               => v03VideoIO.Red(7 downto 0),
    oGreen             => v03VideoIO.Green(7 downto 0),
    oBlue              => v03VideoIO.Blue(7 downto 0),
    runFrame           => v03VideoIO.runFrame,
    xCount             => v03VideoIO.xCount,
    yCount             => v03VideoIO.yCount,
    startFrame         => startFrame2,
    fvalid             => open,
    lvalid             => open,
    rl                 => open,
    rh                 => open,
    gl                 => open,
    gh                 => open,
    bl                 => open,
    bh                 => open,
    address            => v03VideoIO.address,
    endOfFrame         => v03VideoIO.endOfFrame,
    oValid             => v03VideoIO.Valid);
IMAGE3_ReadWrite: imageRead
    generic map (
    i_data_width       => 8,
    test               => "test3",
    output_file        => "output")
    port map (                  
    pixclk             => m_axis_mm2s_aclk,
    iRed               => v02VideoIO.Red(7 downto 0),
    iGreen             => v02VideoIO.Green(7 downto 0),
    iBlue              => v02VideoIO.Blue(7 downto 0),
    iValid             => iValid,
    startFrame         => fvalid,
    runFrame           => open,
    endOfFrame         => open); 
    
process (m_axis_mm2s_aclk) begin
      if rising_edge(m_axis_mm2s_aclk) then 
        if (configReg41(0) = '1') then
           configReg40 <= x"00000006";
           gridDataRdEn <='1';
        else
           configReg40 <= x"00000000";
           gridDataRdEn <='0';
        end if;        
      end if;
end process ;
    
hsslMax: process (m_axis_mm2s_aclk) begin
  if rising_edge(m_axis_mm2s_aclk) then 
    if (v01VideoIO.runFrame = '1') then
        v05VideoIO.Red        <= v01VideoIO.Red;
        v05VideoIO.Green      <= v01VideoIO.Green;
        v05VideoIO.Blue       <= v01VideoIO.Blue;
        v05VideoIO.Valid      <= v01VideoIO.Valid;
        v05VideoIO.xCount     <= v01VideoIO.xCount;
        v05VideoIO.yCount     <= v01VideoIO.yCount;
        v05VideoIO.address    <= v01VideoIO.address;
        v05VideoIO.endOfFrame <= v01VideoIO.endOfFrame;
        v02VideoIO.Red        <= v06VideoIO.Red;
        v02VideoIO.Green      <= v06VideoIO.Green;
        v02VideoIO.Blue       <= v06VideoIO.Blue;
    elsif(v03VideoIO.runFrame = '1')then
        v05VideoIO.Red        <= v03VideoIO.Red;
        v05VideoIO.Green      <= v03VideoIO.Green;
        v05VideoIO.Blue       <= v03VideoIO.Blue;
        v05VideoIO.Valid      <= v03VideoIO.Valid;
        v05VideoIO.xCount     <= v03VideoIO.xCount;
        v05VideoIO.yCount     <= v03VideoIO.yCount;
        v05VideoIO.address    <= v03VideoIO.address;
        v05VideoIO.endOfFrame <= v03VideoIO.endOfFrame;
        v04VideoIO.Red        <= v06VideoIO.Red;
        v04VideoIO.Green      <= v06VideoIO.Green;
        v04VideoIO.Blue       <= v06VideoIO.Blue;
    end if;
  end if;
end process hsslMax;
mod5_inst: frameProcess
generic map(
    i_data_width        => i_data_width,
    s_data_width        => s_data_width,
    b_data_width        => b_data_width,
    i_precision         => i_precision,
    i_full_range        => FALSE,
    img_width           => img_width,
    adwr_width          => 15,
    addr_width          => 11)
port map(
    clk                 => m_axis_mm2s_aclk,
    rclk                => m_axis_mm2s_aclk,
    rst_l               => m_axis_mm2s_aresetn,
    -----------------------------------------------------------
    iRed                => v05VideoIO.Red(7 downto 0),
    iGreen              => v05VideoIO.Green(7 downto 0),
    iBlue               => v05VideoIO.Blue(7 downto 0),
    iValid              => v05VideoIO.Valid,
    -----------------------------------------------------------
	configReg6          => configReg6,
	configReg7          => configReg7,
	configReg8          => configReg8,
    configReg19         => configReg19,
    configReg20         => configReg20,
    configReg40         => configReg40,
    configReg41         => configReg41,
    gridLockDatao       => gridLockDatao,
    gridDataRdEn        => gridDataRdEn,
    endOfFrame          => v05VideoIO.endOfFrame,
    threshold           => threshold,
    -----------------------------------------------------------
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
    -----------------------------------------------------------
    rl                  => rl,
    rh                  => rh,
    gl                  => gl,
    gh                  => gh,
    bl                  => bl,
    bh                  => bh,
    -----------------------------------------------------------
    iXcont              => v05VideoIO.xCount,
    iYcont              => v05VideoIO.yCount,
    -----------------------------------------------------------
    oXcont              => open,
    oYcont              => open,
    -----------------------------------------------------------
    oRed                => v06VideoIO.Red(7 downto 0),
    oGreen              => v06VideoIO.Green(7 downto 0),
    oBlue               => v06VideoIO.Blue(7 downto 0),
    oValid              => iValid);
end behavioral;