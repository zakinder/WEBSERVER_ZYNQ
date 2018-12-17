library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity videoProcess_v1_0 is
generic (
    revision_number             : std_logic_vector(31 downto 0) := x"12152018";
    C_rgb_m_axis_TDATA_WIDTH    : integer := 16;
    C_rgb_m_axis_START_COUNT    : integer := 32;
    C_rgb_s_axis_TDATA_WIDTH    : integer := 16;
    C_m_axis_mm2s_TDATA_WIDTH   : integer := 16;
    C_m_axis_mm2s_START_COUNT   : integer := 32;
    C_config_axis_DATA_WIDTH    : integer := 32;
    C_config_axis_ADDR_WIDTH    : integer := 7;
    i_data_width                : integer := 8;
    s_data_width                : integer := 16;
    b_data_width                : integer := 32;
    i_precision                 : integer := 12;
    i_full_range                : boolean := FALSE;
    conf_data_width             : integer := 32;
    conf_addr_width             : integer := 4;
    img_width                   : integer := 4096;
    p_data_width                : integer := 11);
port (
    -- d5m input
    pixclk                      : in std_logic;
    ifval                       : in std_logic;
    ilval                       : in std_logic;
    idata                       : in std_logic_vector(p_data_width downto 0);
    --tx channel                
    rgb_m_axis_aclk             : in std_logic;
    rgb_m_axis_aresetn          : in std_logic;
    rgb_m_axis_tvalid           : out std_logic;
    rgb_m_axis_tlast            : out std_logic;
    rgb_m_axis_tuser            : out std_logic;
    rgb_m_axis_tready           : in std_logic;
    rgb_m_axis_tdata            : out std_logic_vector(C_rgb_m_axis_TDATA_WIDTH-1 downto 0);
    --rx channel                
    rgb_s_axis_aclk             : in std_logic;
    rgb_s_axis_aresetn          : in std_logic;
    rgb_s_axis_tready           : out std_logic;
    rgb_s_axis_tvalid           : in std_logic;
    rgb_s_axis_tuser            : in std_logic;
    rgb_s_axis_tlast            : in std_logic;
    rgb_s_axis_tdata            : in std_logic_vector(C_rgb_s_axis_TDATA_WIDTH-1 downto 0);
    --destination channel       
    m_axis_mm2s_aclk            : in std_logic;
    m_axis_mm2s_aresetn         : in std_logic;
    m_axis_mm2s_tready          : in std_logic;
    m_axis_mm2s_tvalid          : out std_logic;
    m_axis_mm2s_tuser           : out std_logic;
    m_axis_mm2s_tlast           : out std_logic;
    m_axis_mm2s_tdata           : out std_logic_vector(C_m_axis_mm2s_TDATA_WIDTH-1 downto 0);
    m_axis_mm2s_tkeep           : out std_logic_vector(2 downto 0);
    m_axis_mm2s_tstrb           : out std_logic_vector(2 downto 0);
    m_axis_mm2s_tid             : out std_logic_vector(0 downto 0);
    m_axis_mm2s_tdest           : out std_logic_vector(0 downto 0);
    --video configuration       
    config_axis_aclk            : in std_logic;
    config_axis_aresetn         : in std_logic;
    config_axis_awaddr          : in std_logic_vector(C_config_axis_ADDR_WIDTH-1 downto 0);
    config_axis_awprot          : in std_logic_vector(2 downto 0);
    config_axis_awvalid         : in std_logic;
    config_axis_awready         : out std_logic;
    config_axis_wdata           : in std_logic_vector(C_config_axis_DATA_WIDTH-1 downto 0);
    config_axis_wstrb           : in std_logic_vector((C_config_axis_DATA_WIDTH/8)-1 downto 0);
    config_axis_wvalid          : in std_logic;
    config_axis_wready          : out std_logic;
    config_axis_bresp           : out std_logic_vector(1 downto 0);
    config_axis_bvalid          : out std_logic;
    config_axis_bready          : in std_logic;
    config_axis_araddr          : in std_logic_vector(C_config_axis_ADDR_WIDTH-1 downto 0);
    config_axis_arprot          : in std_logic_vector(2 downto 0);
    config_axis_arvalid         : in std_logic;
    config_axis_arready         : out std_logic;
    config_axis_rdata           : out std_logic_vector(C_config_axis_DATA_WIDTH-1 downto 0);
    config_axis_rresp           : out std_logic_vector(1 downto 0);
    config_axis_rvalid          : out std_logic;
    config_axis_rready          : in std_logic);
end videoProcess_v1_0;
architecture arch_imp of videoProcess_v1_0 is
component videoProcess_v1_0_rgb_m_axis is
generic (
    i_data_width                : integer := 8;
    s_data_width                : integer := 16);
port (                          
    --stream clock/reset        
    m_axis_mm2s_aclk            : in std_logic;
    m_axis_mm2s_aresetn         : in std_logic;
    --config                    
    configRegW                  : in std_logic; -- config write
    configReg4                  : in std_logic_vector(31 downto 0);
    --ycbcr                     
    color_valid                 : in std_logic;
    mpeg444Y                    : in std_logic_vector(i_data_width-1 downto 0);
    mpeg444CB                   : in std_logic_vector(i_data_width-1 downto 0);
    mpeg444CR                   : in std_logic_vector(i_data_width-1 downto 0);
    --image resolution          
    pXcont                      : in std_logic_vector(15 downto 0);
    pYcont                      : in std_logic_vector(15 downto 0);
    endOfFrame                  : in std_logic;
    --stream to master out      
    rx_axis_tready_o            : in std_logic;
    rx_axis_tvalid              : out std_logic;
    rx_axis_tuser               : out std_logic;
    rx_axis_tlast               : out std_logic;
    rx_axis_tdata               : out std_logic_vector(s_data_width-1 downto 0);
    --tx channel                
    rgb_m_axis_tvalid           : out std_logic;
    rgb_m_axis_tlast            : out std_logic;
    rgb_m_axis_tuser            : out std_logic;
    rgb_m_axis_tready           : in std_logic;
    rgb_m_axis_tdata            : out std_logic_vector(s_data_width-1 downto 0);
    --rx channel                
    rgb_s_axis_tready           : out std_logic;
    rgb_s_axis_tvalid           : in std_logic;
    rgb_s_axis_tuser            : in std_logic;
    rgb_s_axis_tlast            : in std_logic;
    rgb_s_axis_tdata            : in std_logic_vector(s_data_width-1 downto 0));
end component videoProcess_v1_0_rgb_m_axis;
component videoProcess_v1_0_m_axis_mm2s is
generic (
    s_data_width: integer:= 32);
port (
    aclk                        : in std_logic;
    aresetn                     : in std_logic;
    rgb_s_axis_tready           : out std_logic;
    rgb_s_axis_tvalid           : in std_logic;
    rgb_s_axis_tuser            : in std_logic;
    rgb_s_axis_tlast            : in std_logic;
    rgb_s_axis_tdata            : in std_logic_vector(s_data_width-1  downto 0);
    m_axis_mm2s_tkeep           : out std_logic_vector(2 downto 0);
    m_axis_mm2s_tstrb           : out std_logic_vector(2 downto 0);
    m_axis_mm2s_tid             : out std_logic_vector(0 downto 0);
    m_axis_mm2s_tdest           : out std_logic_vector(0 downto 0);  
    m_axis_mm2s_tready          : in std_logic;
    m_axis_mm2s_tvalid          : out std_logic;
    m_axis_mm2s_tuser           : out std_logic;
    m_axis_mm2s_tlast           : out std_logic;
    m_axis_mm2s_tdata           : out std_logic_vector(s_data_width-1 downto 0));
end component videoProcess_v1_0_m_axis_mm2s;
component d5m_raw_data is
port (
    pixclk                      : in std_logic;
    ifval                       : in std_logic;
    ilval                       : in std_logic;
    idata                       : in std_logic_vector(11 downto 0);
    endOfFrame                  : out std_logic;
    p_tdata                     : out std_logic_vector(11 downto 0);
    p_tvalid                    : out std_logic;
    m_axis_xcont                : out std_logic_vector(15 downto 0);
    m_axis_ycont                : out std_logic_vector(15 downto 0);   
    m_axis_aclk                 : in std_logic;
    m_axis_aresetn              : in std_logic);
end component d5m_raw_data;
component videoProcess_v1_0_config_axis is
generic (
    C_S_AXI_DATA_WIDTH: integer:= 32;
    C_S_AXI_ADDR_WIDTH: integer:= 4);
port (
        m_axis_mm2s_aclk        : in std_logic;
        m_axis_mm2s_aresetn     : in std_logic;
        seconds                 : in std_logic_vector(5 downto 0);
        minutes                 : in std_logic_vector(5 downto 0);
        hours                   : in std_logic_vector(4 downto 0);
        configRegW              : out std_logic;
        configReg1              : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
        configReg2              : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
        configReg3              : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
        configReg4              : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
        configReg5              : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
        configReg6              : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
        configReg7              : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
        configReg8              : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
        configReg19             : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
        configReg20             : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
        configReg40 			: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
        configReg41             : in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
        gridLockDatao           : in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
        gridDataRdEn            : out std_logic;
		Kernal1                 : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		Kernal2                 : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		Kernal3                 : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		Kernal4                 : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		Kernal5                 : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		Kernal6                 : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		Kernal7                 : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		Kernal8                 : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		Kernal9                 : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		KernalConfig            : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
        S_AXI_ACLK              : in std_logic;
        S_AXI_ARESETN           : in std_logic;
        S_AXI_AWADDR            : in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
        S_AXI_AWPROT            : in std_logic_vector(2 downto 0);
        S_AXI_AWVALID           : in std_logic;
        S_AXI_AWREADY           : out std_logic;
        S_AXI_WDATA             : in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
        S_AXI_WSTRB             : in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
        S_AXI_WVALID            : in std_logic;
        S_AXI_WREADY            : out std_logic;
        S_AXI_BRESP             : out std_logic_vector(1 downto 0);
        S_AXI_BVALID            : out std_logic;
        S_AXI_BREADY            : in std_logic;
        S_AXI_ARADDR            : in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
        S_AXI_ARPROT            : in std_logic_vector(2 downto 0);
        S_AXI_ARVALID           : in std_logic;
        S_AXI_ARREADY           : out std_logic;
        S_AXI_RDATA             : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
        S_AXI_RRESP             : out std_logic_vector(1 downto 0);
        S_AXI_RVALID            : out std_logic;
        S_AXI_RREADY            : in std_logic);
end component videoProcess_v1_0_config_axis;
component buffer_controller is
generic (
    img_width                   : integer := 4096;
    adwr_width                  : integer := 15;
    p_data_width                : integer := 11;
    addr_width                  : integer := 11);
port (                          
    aclk                        : in std_logic;
    i_enable                    : in std_logic;
    i_data                      : in std_logic_vector(p_data_width downto 0);
    i_wadd                      : in std_logic_vector(adwr_width downto 0);
    i_radd                      : in std_logic_vector(adwr_width downto 0);
    en_datao                    : out std_logic;
    taps0x                      : out std_logic_vector(p_data_width downto 0);
    taps1x                      : out std_logic_vector(p_data_width downto 0);
    taps2x                      : out std_logic_vector(p_data_width downto 0));
end component buffer_controller;
component raw2rgb is 
generic (
    rgbo_width                  : integer := 8;
    cont_width                  : integer := 16;
    p_data_width                : integer := 11);
port (                          
    clk                         : in std_logic;
    rst_l                       : in std_logic;
    i_tap0                      : in std_logic_vector(p_data_width downto 0);
    i_tap1                      : in std_logic_vector(p_data_width downto 0);
    i_tap2                      : in std_logic_vector(p_data_width downto 0);
    ix_cont                     : in std_logic_vector(cont_width-1 downto 0);
    iy_cont                     : in std_logic_vector(cont_width-1 downto 0);
    ored                        : out std_logic_vector(11 downto 0);
    ogreen                      : out std_logic_vector(12 downto 0);
    oblue                       : out std_logic_vector(11 downto 0));
end component raw2rgb;
component digi_clk is
port (
    clk1                        : in std_logic;
    seconds                     : out std_logic_vector(5 downto 0);
    minutes                     : out std_logic_vector(5 downto 0);
    hours                       : out std_logic_vector(4 downto 0));
end component digi_clk;
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
    constant rgb_msb            : integer := 12;
    constant rgb_lsb            : integer := 5;
    constant XYCOORD            : integer := 16;
    signal rx_axis_tready       : std_logic;
    signal rx_axis_tvalid       : std_logic;
    signal rx_axis_tuser        : std_logic;
    signal rx_axis_tlast        : std_logic;
    signal rx_axis_tdata        : std_logic_vector(C_m_axis_mm2s_TDATA_WIDTH-1 downto 0);
    signal configReg1           : std_logic_vector(C_config_axis_DATA_WIDTH-1 downto 0):= (others => '0');
    signal configReg2           : std_logic_vector(C_config_axis_DATA_WIDTH-1 downto 0):= (others => '0');
    signal configReg3           : std_logic_vector(C_config_axis_DATA_WIDTH-1 downto 0):= (others => '0');
    signal configReg4           : std_logic_vector(C_config_axis_DATA_WIDTH-1 downto 0):= (others => '0');
    signal configReg5           : std_logic_vector(C_config_axis_DATA_WIDTH-1 downto 0):= (others => '0');
    signal configReg6           : std_logic_vector(C_config_axis_DATA_WIDTH-1 downto 0):= (others => '0');
    signal configReg7           : std_logic_vector(C_config_axis_DATA_WIDTH-1 downto 0):= (others => '0');
    signal configReg8           : std_logic_vector(C_config_axis_DATA_WIDTH-1 downto 0):= (others => '0');
    signal configReg19          : std_logic_vector(C_config_axis_DATA_WIDTH-1 downto 0):= (others => '0');
    signal configReg20          : std_logic_vector(C_config_axis_DATA_WIDTH-1 downto 0):= (others => '0');
    signal configRegW           : std_logic:='0';
    signal en1pvalid            : std_logic:='0';
    signal en2pvalid            : std_logic:='0';
    signal en4pvalid            : std_logic:='0';
    signal en5pvalid            : std_logic:='0';
    signal en6pvalid            : std_logic:='0';
    signal seconds              : std_logic_vector(5 downto 0);
    signal minutes              : std_logic_vector(5 downto 0);
    signal hours                : std_logic_vector(4 downto 0);
	signal Kernal1              : std_logic_vector(conf_data_width-1 downto 0);
	signal Kernal2              : std_logic_vector(conf_data_width-1 downto 0);
	signal Kernal3              : std_logic_vector(conf_data_width-1 downto 0);
	signal Kernal4              : std_logic_vector(conf_data_width-1 downto 0);
	signal Kernal5              : std_logic_vector(conf_data_width-1 downto 0);
	signal Kernal6              : std_logic_vector(conf_data_width-1 downto 0);
	signal Kernal7              : std_logic_vector(conf_data_width-1 downto 0);
	signal Kernal8              : std_logic_vector(conf_data_width-1 downto 0);
	signal Kernal9              : std_logic_vector(conf_data_width-1 downto 0);
	signal KernalConfig         : std_logic_vector(conf_data_width-1 downto 0);
    signal vTap0x               : std_logic_vector(p_data_width downto 0);
    signal vTap1x               : std_logic_vector(p_data_width downto 0);
    signal vTap2x               : std_logic_vector(p_data_width downto 0);
    signal mpegY                : std_logic_vector(i_data_width-1 downto 0);
    signal mpegCB               : std_logic_vector(i_data_width-1 downto 0);
    signal mpegCR               : std_logic_vector(i_data_width-1 downto 0);
    signal vRed                 : std_logic_vector(p_data_width downto 0);
    signal vGreen               : std_logic_vector(p_data_width+1 downto 0);
    signal vBlue                : std_logic_vector(p_data_width downto 0);
    signal cRed                 : std_logic_vector(i_data_width-1 downto 0);
    signal cGreen               : std_logic_vector(i_data_width-1 downto 0);
    signal cBlue                : std_logic_vector(i_data_width-1 downto 0);
    signal d_R                  : std_logic_vector(i_data_width-1 downto 0);
    signal d_G                  : std_logic_vector(i_data_width-1 downto 0);
    signal d_B                  : std_logic_vector(i_data_width-1 downto 0);
    signal dsR                  : std_logic_vector(i_data_width-1 downto 0);
    signal dsG                  : std_logic_vector(i_data_width-1 downto 0);
    signal dsB                  : std_logic_vector(i_data_width-1 downto 0);
    signal p1Xcont              : std_logic_vector(XYCOORD-1 downto 0);
    signal p1Ycont              : std_logic_vector(XYCOORD-1 downto 0);
    signal p2Xcont              : std_logic_vector(XYCOORD-1 downto 0);
    signal p2Ycont              : std_logic_vector(XYCOORD-1 downto 0);
    signal rl                   : std_logic_vector(i_data_width-1 downto 0) :=x"0A";
    signal rh                   : std_logic_vector(i_data_width-1 downto 0) :=x"50";
    signal gl                   : std_logic_vector(i_data_width-1 downto 0) :=x"0A";
    signal gh                   : std_logic_vector(i_data_width-1 downto 0) :=x"50";
    signal bl                   : std_logic_vector(i_data_width-1 downto 0) :=x"0A";
    signal bh                   : std_logic_vector(i_data_width-1 downto 0) :=x"50";
    signal pData                : std_logic_vector(p_data_width downto 0);
    signal endOfFrame           : std_logic;
    signal oData                : std_logic_vector(i_data_width-1 downto 0);
    signal threshold            : std_logic_vector(15 downto 0) :=x"0100";
    
    signal configReg40 			   :  std_logic_vector(C_config_axis_DATA_WIDTH-1 downto 0);
    signal configReg41             :  std_logic_vector(C_config_axis_DATA_WIDTH-1 downto 0);
    signal gridLockDatao           :  std_logic_vector(C_config_axis_DATA_WIDTH-1 downto 0);
    signal gridDataRdEn            :  std_logic;
    
begin
---------------------------------------------------------------------------------
-- PSELECT
---------------------------------------------------------------------------------
PSELECT: process (m_axis_mm2s_aclk)begin
    if (rising_edge (m_axis_mm2s_aclk)) then
        if(configRegW ='1') then
            rl        <= configReg1(7 downto 0);
            rh        <= configReg1(15 downto 8);
            gl        <= configReg2(7 downto 0);
            gh        <= configReg2(15 downto 8);
            bl        <= configReg3(7 downto 0);
            bh        <= configReg3(15 downto 8);
            threshold <= configReg5(15 downto 0);
        end if; 
    end if;
end process PSELECT;
---------------------------------------------------------------------------------
-- d5m_raw_data
---------------------------------------------------------------------------------
mod1_inst: d5m_raw_data
port map(
    pixclk              => pixclk,
    ifval               => ifval,
    ilval               => ilval,
    idata               => idata,
    endOfFrame          => endOfFrame,
    p_tdata             => pData,
    p_tvalid            => en1pvalid,
    m_axis_xcont        => p1Xcont,
    m_axis_ycont        => p1Ycont,
    m_axis_aclk         => m_axis_mm2s_aclk,
    m_axis_aresetn      => m_axis_mm2s_aresetn);
---------------------------------------------------------------------------------
-- buffer_controller
---------------------------------------------------------------------------------
mod2_inst: buffer_controller
    generic map(
    img_width            => img_width,
    adwr_width           => 15,
    p_data_width         => p_data_width,
    addr_width           => 11)
    port map(
    aclk                 => m_axis_mm2s_aclk,
    i_enable             => en1pvalid,
    i_data               => pData,
    i_wadd               => p1Xcont,
    i_radd               => p1Xcont,
    en_datao             => en6pvalid,
    taps0x               => vTap0x,
    taps1x               => vTap1x,
    taps2x               => vTap2x);
---------------------------------------------------------------------------------
-- raw2rgb
---------------------------------------------------------------------------------
mod3_inst: raw2rgb
generic map(
    rgbo_width           => i_data_width,
    cont_width           => 16,
    p_data_width         => p_data_width)
port map(
    clk                  => m_axis_mm2s_aclk,
    rst_l                => m_axis_mm2s_aresetn,
    i_tap0               => vTap0x,
    i_tap1               => vTap1x,
    i_tap2               => vTap2x,
    ix_cont              => p1Xcont,
    iy_cont              => p1Ycont,
    ored                 => vRed,
    ogreen               => vGreen,
    oblue                => vBlue);
---------------------------------------------------------------------------------
-- frameProcess
---------------------------------------------------------------------------------

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
    rclk                => config_axis_aclk,
    rst_l               => m_axis_mm2s_aresetn,
    -----------------------------------------------------------
    iRed                => vRed(rgb_msb-1 downto rgb_lsb-1),
    iGreen              => vGreen(rgb_msb downto rgb_lsb),
    iBlue               => vBlue(rgb_msb-1 downto rgb_lsb-1),
    iValid              => en1pvalid,
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
    threshold           => threshold,
    endOfFrame          => endOfFrame,
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
    iXcont              => p1Xcont,
    iYcont              => p1Ycont,
    -----------------------------------------------------------
    oXcont              => p2Xcont,
    oYcont              => p2Ycont,
    -----------------------------------------------------------
    oRed                => dsR,
    oGreen              => dsG,
    oBlue               => dsB,
    oValid              => en4pvalid);
---------------------------------------------------------------------------------
-- videoProcess_v1_0_rgb_m_axis
---------------------------------------------------------------------------------
mod7_inst: videoProcess_v1_0_rgb_m_axis
generic map (
    i_data_width         => i_data_width,
    s_data_width         => s_data_width)
port map (
    --stream clock/reset
    m_axis_mm2s_aclk     =>  rgb_s_axis_aclk,
    m_axis_mm2s_aresetn  =>  rgb_s_axis_aresetn,
    --config
    configRegW           =>  configRegW,
    configReg4           =>  configReg4,
    --ycbcr
    color_valid          =>  en4pvalid,--en5pvalid,
    mpeg444Y             =>  dsR,--mpegY,
    mpeg444CB            =>  dsG,--mpegCB,
    mpeg444CR            =>  dsB,--mpegCR,
    --image resolution
    pXcont               =>  p2Xcont,
    pYcont               =>  p2Ycont,
    endOfFrame           =>  endOfFrame,
    --stream to master
    rx_axis_tready_o     =>  rx_axis_tready,
    rx_axis_tvalid       =>  rx_axis_tvalid,
    rx_axis_tuser        =>  rx_axis_tuser,
    rx_axis_tlast        =>  rx_axis_tlast,
    rx_axis_tdata        =>  rx_axis_tdata,
    --tx channel
    rgb_m_axis_tvalid    =>  rgb_m_axis_tvalid,
    rgb_m_axis_tlast     =>  rgb_m_axis_tlast,
    rgb_m_axis_tuser     =>  rgb_m_axis_tuser,
    rgb_m_axis_tready    =>  rgb_m_axis_tready,
    rgb_m_axis_tdata     =>  rgb_m_axis_tdata,
    --rx channel
    rgb_s_axis_tready    =>  rgb_s_axis_tready,
    rgb_s_axis_tvalid    =>  rgb_s_axis_tvalid,
    rgb_s_axis_tuser     =>  rgb_s_axis_tuser,
    rgb_s_axis_tlast     =>  rgb_s_axis_tlast,
    rgb_s_axis_tdata     =>  rgb_s_axis_tdata);
---------------------------------------------------------------------------------
-- videoProcess_v1_0_m_axis_mm2s
---------------------------------------------------------------------------------
mod8_inst: videoProcess_v1_0_m_axis_mm2s
generic map(
    s_data_width         => s_data_width)
port map(
    aclk                 => rgb_m_axis_aclk,
    aresetn              => rgb_m_axis_aresetn,
    rgb_s_axis_tready    => rx_axis_tready,
    rgb_s_axis_tvalid    => rx_axis_tvalid,
    rgb_s_axis_tuser     => rx_axis_tuser,
    rgb_s_axis_tlast     => rx_axis_tlast,
    rgb_s_axis_tdata     => rx_axis_tdata,
    m_axis_mm2s_tkeep    => m_axis_mm2s_tkeep,
    m_axis_mm2s_tstrb    => m_axis_mm2s_tstrb,
    m_axis_mm2s_tid      => m_axis_mm2s_tid,
    m_axis_mm2s_tdest    => m_axis_mm2s_tdest,
    m_axis_mm2s_tready   => m_axis_mm2s_tready,
    m_axis_mm2s_tvalid   => m_axis_mm2s_tvalid,
    m_axis_mm2s_tuser    => m_axis_mm2s_tuser,
    m_axis_mm2s_tlast    => m_axis_mm2s_tlast,    
    m_axis_mm2s_tdata    => m_axis_mm2s_tdata);
---------------------------------------------------------------------------------
-- videoProcess_v1_0_config_axis
---------------------------------------------------------------------------------
mod9_inst : videoProcess_v1_0_config_axis
generic map(
    C_S_AXI_DATA_WIDTH   => conf_data_width,
    C_S_AXI_ADDR_WIDTH   => C_config_axis_ADDR_WIDTH)
port map(
    m_axis_mm2s_aclk     => m_axis_mm2s_aclk,
	m_axis_mm2s_aresetn  => m_axis_mm2s_aresetn,
    seconds              => seconds,
    minutes              => minutes,
    hours                => hours,
    configRegW           => configRegW,
    configReg1           => configReg1,
    configReg2           => configReg2,
    configReg3           => configReg3,
    configReg4           => configReg4,
    configReg5           => configReg5,
    configReg6           => configReg6,
    configReg7           => configReg7,
    configReg8           => configReg8,
    configReg19          => configReg19,
    configReg20          => configReg20,
    configReg40          => configReg40,
    configReg41          => configReg41,
    gridLockDatao        => gridLockDatao,
    gridDataRdEn         => gridDataRdEn,
	Kernal1              => Kernal1,
	Kernal2              => Kernal2,
	Kernal3              => Kernal3,
	Kernal4              => Kernal4,
	Kernal5              => Kernal5,
	Kernal6              => Kernal6,
	Kernal7              => Kernal7,
	Kernal8              => Kernal8,
	Kernal9              => Kernal9,
	KernalConfig         => KernalConfig,
    S_AXI_ACLK           => config_axis_aclk,
    S_AXI_ARESETN        => config_axis_aresetn,
    S_AXI_AWADDR         => config_axis_awaddr,
    S_AXI_AWPROT         => config_axis_awprot,
    S_AXI_AWVALID        => config_axis_awvalid,
    S_AXI_AWREADY        => config_axis_awready,
    S_AXI_WDATA          => config_axis_wdata,
    S_AXI_WSTRB          => config_axis_wstrb,
    S_AXI_WVALID         => config_axis_wvalid,
    S_AXI_WREADY         => config_axis_wready,
    S_AXI_BRESP          => config_axis_bresp,
    S_AXI_BVALID         => config_axis_bvalid,
    S_AXI_BREADY         => config_axis_bready,
    S_AXI_ARADDR         => config_axis_araddr,
    S_AXI_ARPROT         => config_axis_arprot,
    S_AXI_ARVALID        => config_axis_arvalid,
    S_AXI_ARREADY        => config_axis_arready,
    S_AXI_RDATA          => config_axis_rdata,
    S_AXI_RRESP          => config_axis_rresp,
    S_AXI_RVALID         => config_axis_rvalid,
    S_AXI_RREADY         => config_axis_rready);
---------------------------------------------------------------------------------
-- digi_clk
---------------------------------------------------------------------------------
mod10_inst: digi_clk
port map(
    clk1                 => config_axis_aclk,
    seconds              => seconds,
    minutes              => minutes,
    hours                => hours);
end arch_imp;