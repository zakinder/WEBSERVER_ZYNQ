library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity frameProcess is
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
    rl             : in std_logic_vector(7 downto 0);
    rh             : in std_logic_vector(7 downto 0);
    gl             : in std_logic_vector(7 downto 0);
    gh             : in std_logic_vector(7 downto 0);
    bl             : in std_logic_vector(7 downto 0);
    bh             : in std_logic_vector(7 downto 0);
    Xcont          : in std_logic_vector(15 downto 0);
    Ycont          : in std_logic_vector(15 downto 0);
    dsR            : out std_logic_vector(7 downto 0);
    dsG            : out std_logic_vector(7 downto 0);
    dsB            : out std_logic_vector(7 downto 0);
    oValid         : out std_logic);
end entity;
architecture arch of frameProcess is
component imageFilter is
generic (
    img_width      : integer := 256;
    adwr_width     : integer := 16;
    p_data_width   : integer := 16;
    addr_width     : integer := 11);
port (                
    clk            : in std_logic;
    rst_l          : in std_logic;
    d_Ri           : in std_logic_vector(7 downto 0);
    d_Gi           : in std_logic_vector(7 downto 0);
    d_Bi           : in std_logic_vector(7 downto 0);
    iaddress       : in std_logic_vector(15 downto 0);
    iValid         : in std_logic;
    d_Ro           : out std_logic_vector(7 downto 0);
    d_Go           : out std_logic_vector(7 downto 0);
    d_Bo           : out std_logic_vector(7 downto 0);
    oValid         : out std_logic);
end component imageFilter;
component sobel is
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
    sRed           : out std_logic_vector(7 downto 0);
    sGreen         : out std_logic_vector(7 downto 0);
    sBlue          : out std_logic_vector(7 downto 0);
    sValid         : out std_logic);   
end component sobel;
component detect is
port (
    clk                         : in std_logic;
    rst_l                       : in std_logic;
    endOfFrame                  : in std_logic;
    iRed                        : in std_logic_vector(7 downto 0);
    iGreen                      : in std_logic_vector(7 downto 0);
    iBlue                       : in std_logic_vector(7 downto 0);
    pValid                      : in std_logic;
    Xcont                       : in std_logic_vector(15 downto 0);
    Ycont                       : in std_logic_vector(15 downto 0);
    rl                          : in std_logic_vector(7 downto 0);
    rh                          : in std_logic_vector(7 downto 0);
    gl                          : in std_logic_vector(7 downto 0);
    gh                          : in std_logic_vector(7 downto 0);
    bl                          : in std_logic_vector(7 downto 0);
    bh                          : in std_logic_vector(7 downto 0);
    pDetect                     : out std_logic;
    d_R                         : out std_logic_vector(7 downto 0);
    d_G                         : out std_logic_vector(7 downto 0);
    d_B                         : out std_logic_vector(7 downto 0);
    qValid                      : out std_logic);
end component detect;
---------------------------------------------------------------------------------
constant i_data_width  : integer := 8;
---------------------------------------------------------------------------------
    signal configReg   : integer;
---------------------------------------------------------------------------------
    signal fValid      : std_logic;
    signal fRed        : std_logic_vector(7 downto 0);
    signal fGreen      : std_logic_vector(7 downto 0);
    signal fBlue       : std_logic_vector(7 downto 0);
---------------------------------------------------------------------------------
    signal sRed        : std_logic_vector(i_data_width-1 downto 0);
    signal sGreen      : std_logic_vector(i_data_width-1 downto 0);
    signal sBlue       : std_logic_vector(i_data_width-1 downto 0);
    signal sValid      : std_logic;   
---------------------------------------------------------------------------------
    signal pRed        : std_logic_vector(i_data_width-1 downto 0);
    signal pGreen      : std_logic_vector(i_data_width-1 downto 0);
    signal pBlue       : std_logic_vector(i_data_width-1 downto 0);
    signal pDetect     : std_logic;
---------------------------------------------------------------------------------
    signal d1R         : std_logic_vector(i_data_width-1 downto 0);
    signal d2R         : std_logic_vector(i_data_width-1 downto 0);
    signal d1G         : std_logic_vector(i_data_width-1 downto 0);
    signal d2G         : std_logic_vector(i_data_width-1 downto 0);
    signal d1B         : std_logic_vector(i_data_width-1 downto 0);
    signal d2B         : std_logic_vector(i_data_width-1 downto 0);

---------------------------------------------------------------------------------
begin
configReg <= to_integer(unsigned(configReg5));
---------------------------------------------------------------------------------
mod5_1_inst: sobel
    generic map(
    img_width            => img_width,
    adwr_width           => adwr_width,
    p_data_width         => p_data_width,
    addr_width           => addr_width)
    port map(
    clk                 => clk,
    rst_l               => rst_l,
    configReg5          => configReg5,
    endOfFrame          => endOfFrame,
    d_R                 => d_R,
    d_G                 => d_G,
    d_B                 => d_B,
    iValid              => iValid,
    threshold           => threshold,
    iaddress            => iaddress,
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
    sRed                => sRed,
    sGreen              => sGreen,
    sBlue               => sBlue,
    sValid              => sValid);
---------------------------------------------------------------------------------
mod5_2_inst: imageFilter
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
    d_Ro               => fRed,
    d_Go               => fGreen,
    d_Bo               => fBlue,
    oValid             => fValid);
mod5_3_inst: detect
port map(
    clk                 => clk,
    rst_l               => rst_l,
    iRed                => fRed,
    iGreen              => fGreen,
    iBlue               => fBlue,
    rl                  => rl,
    rh                  => rh,
    gl                  => gl,
    gh                  => gh,
    bl                  => bl,
    bh                  => bh,
    endOfFrame          => endOfFrame,
    pValid              => fValid,
    Xcont               => Xcont,
    Ycont               => Ycont,
    d_R                 => pRed,
    d_G                 => pGreen,
    d_B                 => pBlue,
    pDetect             => pDetect,
    qValid              => open);
    
  TAP_SIGNED : process (clk, rst_l)
  begin
    if rst_l = '0' then
      d1R       <= (others => '0'); 
      d2R       <= (others => '0');
      d1G       <= (others => '0'); 
      d2G       <= (others => '0');
      d1B       <= (others => '0'); 
      d2B       <= (others => '0');
    elsif rising_edge(clk) then
      d1R      <= d_R;  
      d2R      <= d1R;
      d1G      <= d_G;  
      d2G      <= d1G;
      d1B      <= d_B;  
      d2B      <= d1B;
    end if;
  end process TAP_SIGNED;
---------------------------------------------------------------------------------
  VideoOut : process (clk, rst_l) begin
    if rst_l = '0' then
        dsR <= (others => '0');
        dsG <= (others => '0');
        dsB <= (others => '0');
    elsif rising_edge(clk) then
        if (configReg = 0) then
            oValid  <= sValid;
            dsR     <= sRed;
            dsG     <= sGreen;
            dsB     <= sBlue;
        elsif(configReg = 1)then
            oValid  <= sValid;
            dsR     <= sRed;
            dsG     <= sGreen;
            dsB     <= sBlue;
        elsif(configReg = 2)then
            oValid  <= sValid;
            if (pDetect = '1') then
                dsR  <= sRed;
                dsG  <= sGreen;
                dsB  <= sBlue;
            else     
                dsR  <= pRed;
                dsG  <= pGreen;
                dsB  <= pBlue;
            end if;
        elsif(configReg = 3)then
            oValid  <= fValid;
            dsR     <= fRed;
            dsG     <= fGreen;
            dsB     <= fBlue;
        else
            oValid  <= iValid;
            dsR     <= d_R;
            dsG     <= d_G;
            dsB     <= d_B;
        end if;
    end if;
  end process VideoOut;
---------------------------------------------------------------------------------
end architecture;