library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;
entity videoProcess_tb is
end videoProcess_tb;
    -------------------------------------------------------------------------
architecture behavioral of videoProcess_tb is
    -------------------------------------------------------------------------
    constant revision_number                      : std_logic_vector(31 downto 0) := x"10262018";
    constant C_rgb_m_axis_TDATA_WIDTH             : integer := 16;
    constant C_rgb_m_axis_START_COUNT             : integer := 32;
    constant C_rgb_s_axis_TDATA_WIDTH             : integer := 16;
    constant C_m_axis_mm2s_TDATA_WIDTH            : integer := 16;
    constant C_m_axis_mm2s_START_COUNT            : integer := 32;
    constant C_config_axis_DATA_WIDTH             : integer := 32;
    constant C_config_axis_ADDR_WIDTH             : integer := 7;
    constant i_data_width                         : integer := 8;
    constant s_data_width                         : integer := 16;
    constant i_precision                          : integer := 12;
    constant i_full_range                         : boolean := FALSE;
    constant conf_data_width                      : integer := 32;
    constant conf_addr_width                      : integer := 4;
    constant img_width                            : integer := 112;
    constant p_data_width                         : integer := 11;
    constant C_S_AXIS_TDATA_WIDTH                 : integer := 16;
    
    
    
--    component videoProcess_v1_0_rgb_s_axis is
--    generic (    
--    C_S_AXIS_TDATA_WIDTH    : integer := 16);
--    port (
--	S_AXIS_ACLK	    : in std_logic;
--	S_AXIS_ARESETN	: in std_logic;
--	S_AXIS_TREADY	: out std_logic;
--	S_AXIS_TDATA	: in std_logic_vector(C_S_AXIS_TDATA_WIDTH-1 downto 0);
--	S_AXIS_TSTRB	: in std_logic_vector(2 downto 0);
--	S_AXIS_TLAST	: in std_logic;
--	S_AXIS_TVALID	: in std_logic);
--    end component videoProcess_v1_0_rgb_s_axis;
    
    component videoProcess_v1_0 is
    generic (
    revision_number             : std_logic_vector(31 downto 0) := x"10262018";
    C_rgb_m_axis_TDATA_WIDTH    : integer := 16;
    C_rgb_m_axis_START_COUNT    : integer := 32;
    C_rgb_s_axis_TDATA_WIDTH    : integer := 16;
    C_m_axis_mm2s_TDATA_WIDTH   : integer := 16;
    C_m_axis_mm2s_START_COUNT   : integer := 32;
    C_config_axis_DATA_WIDTH    : integer := 32;
    C_config_axis_ADDR_WIDTH    : integer := 7;
    i_data_width                : integer := 8;
    s_data_width                : integer := 16;
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
    end component videoProcess_v1_0;
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
    -- d5m input
    signal pixclk                : std_logic;
    signal ifval                 : std_logic;
    signal ilval                 : std_logic;
    signal en_datao              : std_logic;
    signal cValid                : std_logic;
    --tx channel
    signal rgb_m_axis_aclk       : std_logic;
    signal rgb_m_axis_aresetn    : std_logic :='0';
    signal rgb_m_axis_tvalid     : std_logic;
    signal rgb_m_axis_tlast      : std_logic;
    signal rgb_m_axis_tuser      : std_logic;
    signal rgb_m_axis_tready     : std_logic;
    signal rgb_m_axis_tdata      : std_logic_vector(s_data_width-1 downto 0);
    --rx channel
    signal rgb_s_axis_aclk       : std_logic;
    signal rgb_s_axis_aresetn    : std_logic :='0';
    signal rgb_s_axis_tready     : std_logic;
    signal rgb_s_axis_tvalid     : std_logic;
    signal rgb_s_axis_tuser      : std_logic;
    signal rgb_s_axis_tlast      : std_logic;
    signal rgb_s_axis_tdata      : std_logic_vector(s_data_width-1 downto 0);
    --destination channel
    signal m_axis_mm2s_aclk      : std_logic;
    signal m_axis_mm2s_aresetn   : std_logic :='0';
    signal m_axis_mm2s_tready    : std_logic;
    signal m_axis_mm2s_tvalid    : std_logic;
    signal m_axis_mm2s_tuser     : std_logic;
    signal m_axis_mm2s_tlast     : std_logic;
    signal m_axis_mm2s_tdata     : std_logic_vector(s_data_width-1 downto 0);
    signal m_axis_mm2s_tkeep     : std_logic_vector(2 downto 0);
    signal m_axis_mm2s_tstrb     : std_logic_vector(2 downto 0);
    signal m_axis_mm2s_tid       : std_logic_vector(0 downto 0);
    signal m_axis_mm2s_tdest     : std_logic_vector(0 downto 0);
    --video configuration
    signal config_axis_aclk      : std_logic;
    signal config_axis_aresetn   : std_logic :='0';
    signal config_axis_awaddr    : std_logic_vector(C_config_axis_ADDR_WIDTH-1 downto 0);
    signal config_axis_awprot    : std_logic_vector(2 downto 0);
    signal config_axis_awvalid   : std_logic;
    signal config_axis_awready   : std_logic;
    signal config_axis_wdata     : std_logic_vector(conf_data_width-1 downto 0);
    signal config_axis_wstrb     : std_logic_vector((conf_data_width/8)-1 downto 0);
    signal config_axis_wvalid    : std_logic;
    signal config_axis_wready    : std_logic;
    signal config_axis_bresp     : std_logic_vector(1 downto 0);
    signal config_axis_bvalid    : std_logic;
    signal config_axis_bready    : std_logic;
    signal config_axis_araddr    : std_logic_vector(C_config_axis_ADDR_WIDTH-1 downto 0);
    signal config_axis_arprot    : std_logic_vector(2 downto 0);
    signal config_axis_arvalid   : std_logic;
    signal config_axis_arready   : std_logic;
    signal config_axis_rdata     : std_logic_vector(conf_data_width-1 downto 0);
    signal config_axis_rresp     : std_logic_vector(1 downto 0);
    signal config_axis_rvalid    : std_logic;
    signal config_axis_rready    : std_logic;
    constant LINE_HIGHT      :  integer:=122;
    type camlink_buffer_bus is record
        frame_high        : integer range 0 to LINE_HIGHT;
        valid_high        : integer range 0 to LINE_HIGHT;
        d5mdata           : integer range 0 to LINE_HIGHT;
        fvalid            : std_logic;
        lvalid            : std_logic;
        horizontal_blank  : std_logic;
        vertical_blank    : std_logic;
        valid_image_data  : std_logic;
    end record;
    signal video : camlink_buffer_bus;
    signal idata          :  std_logic_vector(p_data_width downto 0);

begin
    -------------------------------------------------------------------------
    clk_gen(pixclk, 90.00e6);
    clk_gen(m_axis_mm2s_aclk, 100.00e6);
    clk_gen(rgb_m_axis_aclk, 100.00e6);
    clk_gen(rgb_s_axis_aclk, 100.00e6);
    clk_gen(config_axis_aclk, 75.00e6);
    -------------------------------------------------------------------------
    rgb_s_axis_tvalid    <= rgb_m_axis_tvalid;
    rgb_s_axis_tlast     <= rgb_m_axis_tlast;
    rgb_s_axis_tuser     <= rgb_m_axis_tuser;
    rgb_m_axis_tready    <= rgb_s_axis_tready;
    rgb_s_axis_tdata     <= rgb_m_axis_tdata;
    -------------------------------------------------------------------------
    process begin
        m_axis_mm2s_aresetn  <= '0';
        config_axis_aresetn  <= '0';
        rgb_s_axis_aresetn   <= '0';
        rgb_m_axis_aresetn   <= '0';
    wait for 100 ns;
        m_axis_mm2s_aresetn  <= '1';
        config_axis_aresetn  <= '1';
        rgb_s_axis_aresetn   <= '1';
        rgb_m_axis_aresetn   <= '1';   
    wait;
    end process;
   
    process (pixclk,m_axis_mm2s_aresetn) begin
        if (m_axis_mm2s_aresetn ='0') then 
            video.frame_high <= 0;
        elsif (rising_edge(pixclk) ) then
            if (video.valid_high = img_width + 40) then
                if (video.frame_high > LINE_HIGHT) then
                    video.frame_high <= 0;
                else
                    video.frame_high <= video.frame_high + 1;
                end if;
            end if;
        end if;
    end process;
    process (pixclk,m_axis_mm2s_aresetn) begin
        if (m_axis_mm2s_aresetn ='0') then
            video.valid_high <= 0;
        elsif(rising_edge(pixclk) ) then
            if (video.valid_high > img_width + 40) then
                video.valid_high <= 1;
            else
                video.valid_high <= video.valid_high + 1;
            end if;
        end if;
    end process;
    -------------------------------------------------------------------------------------------
        video.fvalid  <='1' when (video.frame_high < LINE_HIGHT and m_axis_mm2s_aresetn ='1') else '0';
        video.lvalid  <='1' when (video.valid_high < img_width and video.fvalid ='1') else '0';
    -------------------------------------------------------------------------------------------
        process(video.fvalid,video.lvalid,video.d5mdata) begin
            if (video.fvalid ='1' and video.lvalid ='1') then
                idata         <= std_logic_vector(to_unsigned(video.d5mdata, 12));
            else
                idata         <=(others => '0');
            end if;
        end process;
    -------------------------------------------------------------------------------------------

    -------------------------------------------------------------------------------------------
    process (pixclk,m_axis_mm2s_aresetn) begin
        if (m_axis_mm2s_aresetn ='0') then
            video.horizontal_blank <= '0';
            video.vertical_blank   <= '0';
            video.valid_image_data <= '0';
            video.d5mdata          <= 0;
        elsif(rising_edge(pixclk) ) then
            if (video.fvalid ='1' and video.lvalid ='1') then
                video.valid_image_data <= '1';
                video.d5mdata <= video.d5mdata + 100;
            else
                video.valid_image_data <= '0';
                video.d5mdata          <= 0;
            end if;
            if (video.fvalid ='1' and video.lvalid ='0') then
                video.horizontal_blank <= '1';
            else
                video.horizontal_blank <= '0';
            end if;
            if (video.fvalid ='0' and video.lvalid ='0') then
                video.vertical_blank <= '1';
            else
                video.vertical_blank <= '0';
            end if;
        end if;
    end process; 
    -------------------------------------------------------------------------------------------
    
--videoProcess_inst:  videoProcess_v1_0_rgb_s_axis    
--generic map( 
--    C_S_AXIS_TDATA_WIDTH    => C_S_AXIS_TDATA_WIDTH)
--port map(
--    S_AXIS_ACLK             => rgb_m_axis_aclk,
--    S_AXIS_ARESETN          => rgb_m_axis_aresetn,
--    S_AXIS_TREADY           => m_axis_mm2s_tready,
--    S_AXIS_TDATA            => m_axis_mm2s_tdata,
--    S_AXIS_TSTRB            => m_axis_mm2s_tstrb,
--    S_AXIS_TLAST            => m_axis_mm2s_tlast,
--    S_AXIS_TVALID           => m_axis_mm2s_tvalid);

d5m_camera_inst: videoProcess_v1_0
generic map(
    revision_number             => revision_number,
    C_rgb_m_axis_TDATA_WIDTH    => C_rgb_m_axis_TDATA_WIDTH,
    C_rgb_m_axis_START_COUNT    => C_rgb_m_axis_START_COUNT,
    C_rgb_s_axis_TDATA_WIDTH    => C_rgb_s_axis_TDATA_WIDTH,
    C_m_axis_mm2s_TDATA_WIDTH   => C_m_axis_mm2s_TDATA_WIDTH,
    C_m_axis_mm2s_START_COUNT   => C_m_axis_mm2s_START_COUNT,
    C_config_axis_DATA_WIDTH    => C_config_axis_DATA_WIDTH,
    C_config_axis_ADDR_WIDTH    => C_config_axis_ADDR_WIDTH,
    i_data_width                => i_data_width,
    s_data_width                => s_data_width,
    i_precision                 => i_precision,
    i_full_range                => i_full_range,
    conf_data_width             => conf_data_width,
    conf_addr_width             => conf_addr_width,
    img_width                   => img_width,
    p_data_width                => p_data_width)
port map(
    -- d5m input
    pixclk                      => pixclk,
    ifval                       => video.fvalid,
    ilval                       => video.lvalid,
    idata                       => idata,
    --tx channel
    rgb_m_axis_aclk             => rgb_m_axis_aclk,
    rgb_m_axis_aresetn          => rgb_m_axis_aresetn,
    rgb_m_axis_tvalid           => rgb_m_axis_tvalid,
    rgb_m_axis_tlast            => rgb_m_axis_tlast,
    rgb_m_axis_tuser            => rgb_m_axis_tuser,
    rgb_m_axis_tready           => rgb_m_axis_tready,
    rgb_m_axis_tdata            => rgb_m_axis_tdata,
    --rx channel                
    rgb_s_axis_aclk             => rgb_s_axis_aclk,
    rgb_s_axis_aresetn          => rgb_s_axis_aresetn,
    rgb_s_axis_tready           => rgb_s_axis_tready,
    rgb_s_axis_tvalid           => rgb_s_axis_tvalid,
    rgb_s_axis_tuser            => rgb_s_axis_tuser,
    rgb_s_axis_tlast            => rgb_s_axis_tlast,
    rgb_s_axis_tdata            => rgb_s_axis_tdata,
    --destination channel       
    m_axis_mm2s_aclk            => m_axis_mm2s_aclk,
    m_axis_mm2s_aresetn         => m_axis_mm2s_aresetn,
    m_axis_mm2s_tready          => m_axis_mm2s_tready,
    m_axis_mm2s_tvalid          => m_axis_mm2s_tvalid,
    m_axis_mm2s_tuser           => m_axis_mm2s_tuser,
    m_axis_mm2s_tlast           => m_axis_mm2s_tlast,
    m_axis_mm2s_tdata           => m_axis_mm2s_tdata,
    m_axis_mm2s_tkeep           => m_axis_mm2s_tkeep,
    m_axis_mm2s_tstrb           => m_axis_mm2s_tstrb,
    m_axis_mm2s_tid             => m_axis_mm2s_tid,
    m_axis_mm2s_tdest           => m_axis_mm2s_tdest,
    --video configuration       
    config_axis_aclk            => config_axis_aclk,
    config_axis_aresetn         => config_axis_aresetn,
    config_axis_awaddr          => config_axis_awaddr,
    config_axis_awprot          => config_axis_awprot,
    config_axis_awvalid         => config_axis_awvalid,
    config_axis_awready         => config_axis_awready,
    config_axis_wdata           => config_axis_wdata,
    config_axis_wstrb           => config_axis_wstrb,
    config_axis_wvalid          => config_axis_wvalid,
    config_axis_wready          => config_axis_wready,
    config_axis_bresp           => config_axis_bresp,
    config_axis_bvalid          => config_axis_bvalid,
    config_axis_bready          => config_axis_bready,
    config_axis_araddr          => config_axis_araddr,
    config_axis_arprot          => config_axis_arprot,
    config_axis_arvalid         => config_axis_arvalid,
    config_axis_arready         => config_axis_arready,
    config_axis_rdata           => config_axis_rdata,
    config_axis_rresp           => config_axis_rresp,
    config_axis_rvalid          => config_axis_rvalid,
    config_axis_rready          => config_axis_rready);
end behavioral;