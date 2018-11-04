library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
entity videoProcess_v1_0_rgb_m_axis is 
    generic (
    i_data_width           : integer := 8;
    s_data_width           : integer := 16);
    port (
    --stream clock/reset
    m_axis_mm2s_aclk     : in std_logic;
    m_axis_mm2s_aresetn  : in std_logic;
    --config
    configRegW           : in std_logic; -- config write
    configReg4           : in std_logic_vector(31 downto 0);
    --ycbcr
    color_valid          : in std_logic;
    mpeg444Y             : in std_logic_vector(i_data_width-1 downto 0);
    mpeg444CB            : in std_logic_vector(i_data_width-1 downto 0);
    mpeg444CR            : in std_logic_vector(i_data_width-1 downto 0);
    --image resolution
    pXcont               : in std_logic_vector(15 downto 0);
    pYcont               : in std_logic_vector(15 downto 0);
    endOfFrame           : in std_logic;
    --stream to master out
    rx_axis_tready_o     : in std_logic;
    rx_axis_tvalid       : out std_logic;
    rx_axis_tuser        : out std_logic;
    rx_axis_tlast        : out std_logic;
    rx_axis_tdata        : out std_logic_vector(s_data_width-1 downto 0);
    --tx channel
    rgb_m_axis_tvalid    : out std_logic;
    rgb_m_axis_tlast     : out std_logic;
    rgb_m_axis_tuser     : out std_logic;
    rgb_m_axis_tready    : in std_logic;
    rgb_m_axis_tdata     : out std_logic_vector(s_data_width-1 downto 0);
    --rx channel
    rgb_s_axis_tready    : out std_logic;
    rgb_s_axis_tvalid    : in std_logic;
    rgb_s_axis_tuser     : in std_logic;
    rgb_s_axis_tlast     : in std_logic;
    rgb_s_axis_tdata     : in std_logic_vector(s_data_width-1 downto 0));
end videoProcess_v1_0_rgb_m_axis;
architecture arch_imp of videoProcess_v1_0_rgb_m_axis is
    signal configReg4R       : std_logic_vector(31 downto 0):= (others => '0');
    signal configReg4Rr      : std_logic_vector(31 downto 0):= (others => '0');
    signal configRegW1r      : std_logic:='0';
    signal configRegW2r      : std_logic:='0';
    signal axis_sof          : std_logic;
    signal mpeg42XCR         : std_logic_vector(i_data_width-1 downto 0);
    signal mpeg42XBR         : std_logic :='0';
    signal mpeg42XXX         : std_logic :='0';
    signal tx_axis_tvalid    : std_logic;
    signal tx_axis_tlast     : std_logic;
    signal tx_axis_tuser     : std_logic;
    signal tx_axis_tready    : std_logic;
    signal tx_axis_tdata     : std_logic_vector(s_data_width-1 downto 0);
    type video_io_state is (VIDEO_SET_RESET,VIDEO_SKIP0_FRAME,VIDEO_SKIP1_FRAME,VIDEO_LINE,VIDEO_SOF_ON,VIDEO_SOF_OFF,VIDEO_END_OF_LINE);
    signal VIDEO_STATES      : video_io_state; 
    signal LINE_COUNTER      : integer := 0;
begin
process (m_axis_mm2s_aclk) begin
    if rising_edge(m_axis_mm2s_aclk) then
            mpeg42XBR  <= not(mpeg42XBR) and color_valid;
            mpeg42XXX  <= not(mpeg42XBR);
    end if;
end process;
FF1multi: process (m_axis_mm2s_aclk) begin
    if rising_edge(m_axis_mm2s_aclk) then
            configRegW1r  <= configRegW;
            configRegW2r  <= configRegW1r;
    end if;
end process FF1multi;
process (configRegW2r,configReg4,configReg4Rr) begin
    if(configRegW2r ='1')then
        configReg4Rr  <= configReg4;
    else
        configReg4Rr  <= configReg4Rr;
    end if;
end process;
process (m_axis_mm2s_aclk) begin
    if rising_edge(m_axis_mm2s_aclk) then
            mpeg42XCR  <= mpeg444CR;
            configReg4R <= configReg4Rr;
    end if;
end process;
process (m_axis_mm2s_aclk) begin
    if (rising_edge (m_axis_mm2s_aclk)) then
        if (m_axis_mm2s_aresetn = '0') then
            VIDEO_STATES <= VIDEO_SET_RESET;
        else
        tx_axis_tuser <=axis_sof;
        case (VIDEO_STATES) is
        when VIDEO_SET_RESET =>
            tx_axis_tlast  <= '0';
            tx_axis_tvalid <= '0';
            tx_axis_tdata  <= (others => '0');    
            axis_sof       <= '0';
            VIDEO_STATES   <= VIDEO_SKIP0_FRAME;
        if (pYcont = x"0001") then
            VIDEO_STATES <= VIDEO_SKIP0_FRAME;
        else
            VIDEO_STATES <= VIDEO_SET_RESET;
        end if;
        when VIDEO_SKIP0_FRAME =>
            tx_axis_tlast  <= '0';
            tx_axis_tvalid <= '0';
            tx_axis_tdata  <= (others => '0');
        if (pYcont = x"0000") then
            VIDEO_STATES <= VIDEO_SOF_ON;
        else
            VIDEO_STATES <= VIDEO_SKIP0_FRAME;
        end if;
        when VIDEO_SOF_ON =>
        if (color_valid = '1') then
            VIDEO_STATES <= VIDEO_SOF_OFF;
            axis_sof     <= '1';
        else
            VIDEO_STATES <= VIDEO_SOF_ON;
        end if;
        when VIDEO_SOF_OFF =>
            axis_sof  <= '0';
            if (configReg4R =x"00000000")then
                if(mpeg42XXX ='1')then
                    tx_axis_tdata  <= (mpeg444CB & mpeg444Y);
                else
                    tx_axis_tdata  <= (mpeg42XCR & mpeg444Y);
                end if;
            elsif (configReg4R =x"00000001")then
                tx_axis_tdata  <= pXcont;
            elsif (configReg4R =x"00000002")then
                tx_axis_tdata  <= pYcont;
            else
                if(mpeg42XXX ='1')then
                    tx_axis_tdata  <= (mpeg444CB & mpeg444Y);
                else
                    tx_axis_tdata  <= (mpeg42XCR & mpeg444Y);
                end if;
            end if;
            tx_axis_tvalid <= '1';
        if (color_valid = '1') then
            tx_axis_tlast  <= '0';
            VIDEO_STATES <= VIDEO_SOF_OFF;
        else
            tx_axis_tlast  <= '1';
            VIDEO_STATES <= VIDEO_END_OF_LINE;
        end if;
        when VIDEO_END_OF_LINE =>
            tx_axis_tlast  <= '0';
            tx_axis_tvalid <= '0';
            if (pYcont = x"0000") then
                VIDEO_STATES <= VIDEO_SOF_ON;
            elsif (color_valid = '1') then
                VIDEO_STATES <= VIDEO_SOF_OFF;
            else
                VIDEO_STATES <= VIDEO_END_OF_LINE;
            end if;
        when others =>
            VIDEO_STATES <= VIDEO_SET_RESET;
        end case;
        end if;
    end if;
end process;
process (m_axis_mm2s_aclk) begin
    if rising_edge(m_axis_mm2s_aclk) then 
        if m_axis_mm2s_aresetn = '0' then
                rx_axis_tvalid     <= '0';
                rx_axis_tuser      <= '0';
                rx_axis_tlast      <= '0';
                rx_axis_tdata      <= (others => '0');
                rgb_m_axis_tvalid  <= '0';
                rgb_m_axis_tuser   <= '0';
                rgb_m_axis_tlast   <= '0';
                rgb_m_axis_tdata   <= (others => '0');
                tx_axis_tready     <= '0';
        else
            if (configReg4R =x"00000000")then
                rgb_s_axis_tready  <= rx_axis_tready_o;
                rx_axis_tvalid     <= rgb_s_axis_tvalid;
                rx_axis_tuser      <= rgb_s_axis_tuser;
                rx_axis_tlast      <= rgb_s_axis_tlast;
                rx_axis_tdata      <= rgb_s_axis_tdata;
            else
                rx_axis_tvalid     <= tx_axis_tvalid;
                rx_axis_tuser      <= tx_axis_tuser;
                rx_axis_tlast      <= tx_axis_tlast;
                rx_axis_tdata      <= tx_axis_tdata;
            end if;
                tx_axis_tready     <= rgb_m_axis_tready;
                rgb_m_axis_tvalid  <= tx_axis_tvalid;
                rgb_m_axis_tuser   <= tx_axis_tuser;
                rgb_m_axis_tlast   <= tx_axis_tlast;
                rgb_m_axis_tdata   <= tx_axis_tdata;
        end if;
    end if;
end process;
end arch_imp;