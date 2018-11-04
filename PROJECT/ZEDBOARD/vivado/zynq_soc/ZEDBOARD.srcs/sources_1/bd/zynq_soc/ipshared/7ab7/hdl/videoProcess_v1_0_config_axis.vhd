library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity videoProcess_v1_0_config_axis is
    generic (
    C_S_AXI_DATA_WIDTH    : integer    := 32;
    C_S_AXI_ADDR_WIDTH    : integer    := 7);
    port (
		m_axis_mm2s_aclk        : in std_logic;
		m_axis_mm2s_aresetn     : in std_logic;
		seconds 				: in std_logic_vector(5 downto 0);
		minutes 				: in std_logic_vector(5 downto 0);
		hours   				: in std_logic_vector(4 downto 0);
		configRegW    			: out std_logic;
		configReg1    			: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		configReg2    			: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		configReg3    			: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		configReg4    			: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		configReg5    			: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		configReg6    			: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		configReg7    			: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		configReg8    			: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
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
end videoProcess_v1_0_config_axis;
architecture arch_imp of videoProcess_v1_0_config_axis is
    constant OPT_MEM_ADDR_BITS : integer := 4;
    constant ADDR_LSB  : integer := (C_S_AXI_DATA_WIDTH/32)+ 1;
	type pDataBuffer is array (0 to 31) of std_logic_vector(31 downto 0);
	signal dataBuffer     : pDataBuffer := (others => (others => '0'));
    signal axi_awaddr     : std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
    signal axi_awready    : std_logic;
    signal axi_wready     : std_logic;
    signal axi_bresp      : std_logic_vector(1 downto 0);
    signal axi_bvalid     : std_logic;
    signal axi_araddr     : std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
    signal axi_arready    : std_logic;
    signal axi_rdata      : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal axi_rresp      : std_logic_vector(1 downto 0);
    signal axi_rvalid     : std_logic;
    signal slv_reg0       : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal slv_reg1       : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal slv_reg2       : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal slv_reg3       : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal slv_reg4       : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal slv_reg5       : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal slv_reg6       : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal slv_reg7       : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal slv_reg8       : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal slv_reg9       : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal slv_reg10      : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal slv_reg11      : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal slv_reg12      : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal slv_reg13      : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal slv_reg14      : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal slv_reg15      : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal slv_reg16      : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal slv_reg17      : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal slv_reg18      : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal slv_reg19      : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal slv_reg20      : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal slv_reg21      : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal slv_reg22      : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal slv_reg23      : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal slv_reg24      : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal slv_reg25      : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal slv_reg26      : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal slv_reg27      : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal slv_reg28      : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal slv_reg29      : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal slv_reg30      : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal slv_reg31      : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal slv_reg_rden   : std_logic;
    signal slv_reg_wren   : std_logic;
    signal reg_data_out   : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal byte_index     : integer;
    signal aw_en          : std_logic;
    signal w1sync         : std_logic;    
    signal w2sync         : std_logic;
begin
    S_AXI_AWREADY    <= axi_awready;
    S_AXI_WREADY     <= axi_wready;
    S_AXI_BRESP      <= axi_bresp;
    S_AXI_BVALID     <= axi_bvalid;
    S_AXI_ARREADY    <= axi_arready;
    S_AXI_RDATA      <= axi_rdata;
    S_AXI_RRESP      <= axi_rresp;
    S_AXI_RVALID     <= axi_rvalid;
    process (S_AXI_ACLK)
    begin
      if rising_edge(S_AXI_ACLK) then 
        if S_AXI_ARESETN = '0' then
          axi_awready <= '0';
          aw_en <= '1';
        else
          if (axi_awready = '0' and S_AXI_AWVALID = '1' and S_AXI_WVALID = '1' and aw_en = '1') then
            axi_awready <= '1';
            elsif (S_AXI_BREADY = '1' and axi_bvalid = '1') then
                aw_en <= '1';
                axi_awready <= '0';
          else
            axi_awready <= '0';
          end if;
        end if;
      end if;
    end process;
    process (S_AXI_ACLK)
    begin
      if rising_edge(S_AXI_ACLK) then 
        if S_AXI_ARESETN = '0' then
          axi_awaddr <= (others => '0');
        else
          if (axi_awready = '0' and S_AXI_AWVALID = '1' and S_AXI_WVALID = '1' and aw_en = '1') then
            axi_awaddr <= S_AXI_AWADDR;
          end if;
        end if;
      end if;                   
    end process; 
    process (S_AXI_ACLK)
    begin
      if rising_edge(S_AXI_ACLK) then 
        if S_AXI_ARESETN = '0' then
          axi_wready <= '0';
        else
          if (axi_wready = '0' and S_AXI_WVALID = '1' and S_AXI_AWVALID = '1' and aw_en = '1') then
              axi_wready <= '1';
          else
            axi_wready <= '0';
          end if;
        end if;
      end if;
    end process; 
    slv_reg_wren <= axi_wready and S_AXI_WVALID and axi_awready and S_AXI_AWVALID ;
    process (S_AXI_ACLK)
    variable loc_addr :std_logic_vector(OPT_MEM_ADDR_BITS downto 0); 
    begin
      if rising_edge(S_AXI_ACLK) then 
        if S_AXI_ARESETN = '0' then
          slv_reg0 <= (others => '0');
          slv_reg1 <= (others => '0');
          slv_reg2 <= (others => '0');
          slv_reg3 <= (others => '0');
          slv_reg4 <= (others => '0');
          slv_reg5 <= (others => '0');
          slv_reg6 <= (others => '0');
          slv_reg7 <= (others => '0');
          slv_reg8 <= (others => '0');
          slv_reg9 <= (others => '0');
          slv_reg10 <= (others => '0');
          slv_reg11 <= (others => '0');
          slv_reg12 <= (others => '0');
          slv_reg13 <= (others => '0');
          slv_reg14 <= (others => '0');
          slv_reg15 <= (others => '0');
          slv_reg16 <= (others => '0');
          slv_reg17 <= (others => '0');
          slv_reg18 <= (others => '0');
          slv_reg19 <= (others => '0');
          slv_reg20 <= (others => '0');
          slv_reg21 <= (others => '0');
          slv_reg22 <= (others => '0');
          slv_reg23 <= (others => '0');
          slv_reg24 <= (others => '0');
          slv_reg25 <= (others => '0');
          slv_reg26 <= (others => '0');
          slv_reg27 <= (others => '0');
          slv_reg28 <= (others => '0');
          slv_reg29 <= (others => '0');
          slv_reg30 <= (others => '0');
          slv_reg31 <= (others => '0');
        else
          loc_addr := axi_awaddr(ADDR_LSB + OPT_MEM_ADDR_BITS downto ADDR_LSB);
          if (slv_reg_wren = '1') then
            case loc_addr is
              when b"00000" =>
                for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
                  if ( S_AXI_WSTRB(byte_index) = '1' ) then
                    slv_reg0(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
                  end if;
                end loop;
              when b"00001" =>
                for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
                  if ( S_AXI_WSTRB(byte_index) = '1' ) then
                    slv_reg1(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
                  end if;
                end loop;
              when b"00010" =>
                for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
                  if ( S_AXI_WSTRB(byte_index) = '1' ) then
                    slv_reg2(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
                  end if;
                end loop;
              when b"00011" =>
                for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
                  if ( S_AXI_WSTRB(byte_index) = '1' ) then
                    slv_reg3(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
                  end if;
                end loop;
              when b"00100" =>
                for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
                  if ( S_AXI_WSTRB(byte_index) = '1' ) then
                    slv_reg4(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
                  end if;
                end loop;
              when b"00101" =>
                for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
                  if ( S_AXI_WSTRB(byte_index) = '1' ) then
                    slv_reg5(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
                  end if;
                end loop;
              when b"00110" =>
                for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
                  if ( S_AXI_WSTRB(byte_index) = '1' ) then
                    slv_reg6(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
                  end if;
                end loop;
              when b"00111" =>
                for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
                  if ( S_AXI_WSTRB(byte_index) = '1' ) then
                    slv_reg7(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
                  end if;
                end loop;
              when b"01000" =>
                for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
                  if ( S_AXI_WSTRB(byte_index) = '1' ) then
                    slv_reg8(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
                  end if;
                end loop;
              when b"01001" =>
                for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
                  if ( S_AXI_WSTRB(byte_index) = '1' ) then
                    slv_reg9(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
                  end if;
                end loop;
              when b"01010" =>
                for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
                  if ( S_AXI_WSTRB(byte_index) = '1' ) then
                    slv_reg10(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
                  end if;
                end loop;
              when b"01011" =>
                for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
                  if ( S_AXI_WSTRB(byte_index) = '1' ) then
                    slv_reg11(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
                  end if;
                end loop;
              when b"01100" =>
                for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
                  if ( S_AXI_WSTRB(byte_index) = '1' ) then
                    slv_reg12(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
                  end if;
                end loop;
              when b"01101" =>
                for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
                  if ( S_AXI_WSTRB(byte_index) = '1' ) then
                    slv_reg13(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
                  end if;
                end loop;
              when b"01110" =>
                for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
                  if ( S_AXI_WSTRB(byte_index) = '1' ) then
                    slv_reg14(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
                  end if;
                end loop;
              when b"01111" =>
                for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
                  if ( S_AXI_WSTRB(byte_index) = '1' ) then
                    slv_reg15(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
                  end if;
                end loop;
              when b"10000" =>
                for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
                  if ( S_AXI_WSTRB(byte_index) = '1' ) then
                    slv_reg16(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
                  end if;
                end loop;
              when b"10001" =>
                for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
                  if ( S_AXI_WSTRB(byte_index) = '1' ) then
                    slv_reg17(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
                  end if;
                end loop;
              when b"10010" =>
                for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
                  if ( S_AXI_WSTRB(byte_index) = '1' ) then
                    slv_reg18(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
                  end if;
                end loop;
              when b"10011" =>
                for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
                  if ( S_AXI_WSTRB(byte_index) = '1' ) then
                    slv_reg19(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
                  end if;
                end loop;
              when b"10100" =>
                for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
                  if ( S_AXI_WSTRB(byte_index) = '1' ) then
                    slv_reg20(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
                  end if;
                end loop;
              when b"10101" =>
                for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
                  if ( S_AXI_WSTRB(byte_index) = '1' ) then
                    slv_reg21(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
                  end if;
                end loop;
              when b"10110" =>
                for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
                  if ( S_AXI_WSTRB(byte_index) = '1' ) then
                    slv_reg22(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
                  end if;
                end loop;
              when b"10111" =>
                for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
                  if ( S_AXI_WSTRB(byte_index) = '1' ) then
                    slv_reg23(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
                  end if;
                end loop;
              when b"11000" =>
                for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
                  if ( S_AXI_WSTRB(byte_index) = '1' ) then
                    slv_reg24(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
                  end if;
                end loop;
              when b"11001" =>
                for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
                  if ( S_AXI_WSTRB(byte_index) = '1' ) then
                    slv_reg25(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
                  end if;
                end loop;
              when b"11010" =>
                for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
                  if ( S_AXI_WSTRB(byte_index) = '1' ) then
                    slv_reg26(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
                  end if;
                end loop;
              when b"11011" =>
                for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
                  if ( S_AXI_WSTRB(byte_index) = '1' ) then
                    slv_reg27(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
                  end if;
                end loop;
              when b"11100" =>
                for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
                  if ( S_AXI_WSTRB(byte_index) = '1' ) then
                    slv_reg28(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
                  end if;
                end loop;
              when b"11101" =>
                for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
                  if ( S_AXI_WSTRB(byte_index) = '1' ) then
                    slv_reg29(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
                  end if;
                end loop;
              when b"11110" =>
                for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
                  if ( S_AXI_WSTRB(byte_index) = '1' ) then
                    slv_reg30(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
                  end if;
                end loop;
              when b"11111" =>
                for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
                  if ( S_AXI_WSTRB(byte_index) = '1' ) then
                    slv_reg31(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
                  end if;
                end loop;
              when others =>
                slv_reg0            <= slv_reg0;
                slv_reg1            <= slv_reg1;
                slv_reg2            <= slv_reg2;
                slv_reg3            <= slv_reg3;
                slv_reg4            <= slv_reg4;
                slv_reg5            <= slv_reg5;
                slv_reg6            <= slv_reg6;
                slv_reg7            <= slv_reg7;
                slv_reg8       <= slv_reg8;
                slv_reg9       <= slv_reg9;
                slv_reg10      <= slv_reg10;
                slv_reg11      <= slv_reg11;
                slv_reg12      <= slv_reg12;
                slv_reg13      <= slv_reg13;
                slv_reg14      <= slv_reg14;
                slv_reg15      <= slv_reg15;
                slv_reg16      <= slv_reg16;
                slv_reg17      <= slv_reg17;
                slv_reg18      <= slv_reg18;
                slv_reg19      <= slv_reg19;
                slv_reg20      <= slv_reg20;
                slv_reg21      <= slv_reg21;
                slv_reg22      <= slv_reg22;
                slv_reg23      <= slv_reg23;
                slv_reg24      <= slv_reg24;
                slv_reg25      <= slv_reg25;
                slv_reg26      <= slv_reg26;
                slv_reg27      <= slv_reg27;
                slv_reg28      <= slv_reg28;
                slv_reg29      <= slv_reg29;
                slv_reg30      <= slv_reg30;
                slv_reg31      <= slv_reg31;
            end case;
          end if;
        end if;
      end if;                   
    end process; 
    process (S_AXI_ACLK)
    begin
      if rising_edge(S_AXI_ACLK) then 
        if S_AXI_ARESETN = '0' then
          axi_bvalid  <= '0';
          axi_bresp   <= "00"; 
        else
          if (axi_awready = '1' and S_AXI_AWVALID = '1' and axi_wready = '1' and S_AXI_WVALID = '1' and axi_bvalid = '0'  ) then
            axi_bvalid <= '1';
            axi_bresp  <= "00"; 
          elsif (S_AXI_BREADY = '1' and axi_bvalid = '1') then   
            axi_bvalid <= '0';                                 
          end if;
        end if;
      end if;                   
    end process; 
    process (S_AXI_ACLK)
    begin
      if rising_edge(S_AXI_ACLK) then 
        if S_AXI_ARESETN = '0' then
          axi_arready <= '0';
          axi_araddr  <= (others => '1');
        else
          if (axi_arready = '0' and S_AXI_ARVALID = '1') then
            axi_arready <= '1';
            axi_araddr  <= S_AXI_ARADDR;           
          else
            axi_arready <= '0';
          end if;
        end if;
      end if;                   
    end process; 
    process (S_AXI_ACLK)
    begin
      if rising_edge(S_AXI_ACLK) then
        if S_AXI_ARESETN = '0' then
          axi_rvalid <= '0';
          axi_rresp  <= "00";
        else
          if (axi_arready = '1' and S_AXI_ARVALID = '1' and axi_rvalid = '0') then
            axi_rvalid <= '1';
            axi_rresp  <= "00"; 
          elsif (axi_rvalid = '1' and S_AXI_RREADY = '1') then
            axi_rvalid <= '0';
          end if;            
        end if;
      end if;
    end process;
    slv_reg_rden <= axi_arready and S_AXI_ARVALID and (not axi_rvalid) ;
    process (seconds, minutes, hours, slv_reg0, slv_reg1, slv_reg2, slv_reg3, slv_reg4, slv_reg5, slv_reg6, slv_reg7, slv_reg8, slv_reg9, slv_reg10, slv_reg11, slv_reg12, slv_reg13, slv_reg14, slv_reg15, slv_reg16, slv_reg17, slv_reg18, slv_reg19, slv_reg20, slv_reg21, slv_reg22, slv_reg23, slv_reg24, slv_reg25, slv_reg26, slv_reg27, slv_reg28, axi_araddr, S_AXI_ARESETN, slv_reg_rden)
    variable loc_addr :std_logic_vector(OPT_MEM_ADDR_BITS downto 0);
    begin
        loc_addr := axi_araddr(ADDR_LSB + OPT_MEM_ADDR_BITS downto ADDR_LSB);
        case loc_addr is
          when b"00000" =>
            reg_data_out <= slv_reg0;
          when b"00001" =>
            reg_data_out <= slv_reg1;
          when b"00010" =>
            reg_data_out <= slv_reg2;
          when b"00011" =>
            reg_data_out <= slv_reg3;
          when b"00100" =>
            reg_data_out <= slv_reg4;
          when b"00101" =>
            reg_data_out <= slv_reg5;
          when b"00110" =>
            reg_data_out <= slv_reg6;
          when b"00111" =>
            reg_data_out <= slv_reg7;
          when b"01000" =>
            reg_data_out <= slv_reg8;
          when b"01001" =>
            reg_data_out <= slv_reg9;
          when b"01010" =>
            reg_data_out <= slv_reg10;
          when b"01011" =>
            reg_data_out <= slv_reg11;
          when b"01100" =>
            reg_data_out <= slv_reg12;
          when b"01101" =>
            reg_data_out <= slv_reg13;
          when b"01110" =>
            reg_data_out <= slv_reg14;
          when b"01111" =>
            reg_data_out <= slv_reg15;
          when b"10000" =>
            reg_data_out <= slv_reg16;
          when b"10001" =>
            reg_data_out <= slv_reg17;
          when b"10010" =>
            reg_data_out <= slv_reg18;
          when b"10011" =>
            reg_data_out <= slv_reg19;
          when b"10100" =>
            reg_data_out <= slv_reg20;
          when b"10101" =>
            reg_data_out <= slv_reg21;
          when b"10110" =>
            reg_data_out <= slv_reg22;
          when b"10111" =>
            reg_data_out <= slv_reg23;
          when b"11000" =>
            reg_data_out <= slv_reg24;
          when b"11001" =>
            reg_data_out <= slv_reg25;
          when b"11010" =>
            reg_data_out <= slv_reg26;
          when b"11011" =>
            reg_data_out <= slv_reg27;
          when b"11100" =>
            reg_data_out <= slv_reg28;
          when b"11101" =>
            reg_data_out <= x"000000" & "00" & seconds;
          when b"11110" =>
            reg_data_out <= x"000000" & "00" & minutes;
          when b"11111" =>
            reg_data_out <= x"000000" & "000" & hours;
          when others =>
            reg_data_out  <= (others => '0');
        end case;
    end process; 
    process( S_AXI_ACLK ) is
    begin
      if (rising_edge (S_AXI_ACLK)) then
        if ( S_AXI_ARESETN = '0' ) then
          axi_rdata  <= (others => '0');
        else
          if (slv_reg_rden = '1') then
              axi_rdata <= reg_data_out;     
          end if;   
        end if;
      end if;
    end process;
    portaW: process (S_AXI_ACLK)begin
    if (rising_edge (S_AXI_ACLK)) then
		dataBuffer(0) <= slv_reg0;
		dataBuffer(1) <= slv_reg1;
		dataBuffer(2) <= slv_reg2;
		dataBuffer(3) <= slv_reg3;
		dataBuffer(4) <= slv_reg4;
		dataBuffer(5) <= slv_reg5;
		dataBuffer(6) <= slv_reg6;
		dataBuffer(7) <= slv_reg7;
		-------------------------
		dataBuffer(8)  <= slv_reg8;
		dataBuffer(9)  <= slv_reg9;
		dataBuffer(10) <= slv_reg10;
		dataBuffer(11) <= slv_reg11;
		dataBuffer(12) <= slv_reg12;
		dataBuffer(13) <= slv_reg13;
		dataBuffer(14) <= slv_reg14;
		dataBuffer(15) <= slv_reg15;
		dataBuffer(16) <= slv_reg16;
		dataBuffer(17) <= slv_reg17;
		dataBuffer(18) <= slv_reg18;
		dataBuffer(19) <= slv_reg19;
		-------------------------
    end if;
    end process portaW;
    portar: process (m_axis_mm2s_aclk)begin
    if (rising_edge (m_axis_mm2s_aclk)) then
		configReg1 <= dataBuffer(0);
		configReg2 <= dataBuffer(1);
		configReg3 <= dataBuffer(2);
		configReg4 <= dataBuffer(3);
		configReg5 <= dataBuffer(4);
		configReg6 <= dataBuffer(5);
		configReg7 <= dataBuffer(6);
		configReg8 <= dataBuffer(7);
		-------------------------
		Kernal1        <= dataBuffer(8);
		Kernal2        <= dataBuffer(9);
		Kernal3        <= dataBuffer(10);
		Kernal4        <= dataBuffer(11);
		Kernal5        <= dataBuffer(12);
		Kernal6        <= dataBuffer(13);
		Kernal7        <= dataBuffer(14);
		Kernal8        <= dataBuffer(15);
		Kernal9        <= dataBuffer(16);
		KernalConfig   <= dataBuffer(17);
		-------------------------
    end if;
    end process portar;
    wsync: process (m_axis_mm2s_aclk)begin
    if (rising_edge (m_axis_mm2s_aclk)) then
            w1sync      <= slv_reg_wren;
            w2sync      <= w1sync;
            configRegW  <= w2sync;
    end if;
    end process wsync;
end arch_imp;