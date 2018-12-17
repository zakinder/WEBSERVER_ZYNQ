library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity pointOfInterest is
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
    endOfFrame      : in std_logic;
    gridDataRdEn    : in std_logic;
    gridLockDatao   : out std_logic_vector(b_data_width-1 downto 0);
    configReg19     : in std_logic_vector(b_data_width-1 downto 0);
    configReg20     : in std_logic_vector(b_data_width-1 downto 0);
    configReg40     : in std_logic_vector(b_data_width-1 downto 0);
    configReg41     : out std_logic_vector(b_data_width-1 downto 0);
    -----------------------------------------------------------
    oGridLocation   : out std_logic;
    oRed            : out std_logic_vector(i_data_width-1 downto 0);
    oGreen          : out std_logic_vector(i_data_width-1 downto 0);
    oBlue           : out std_logic_vector(i_data_width-1 downto 0);
    oValid          : out std_logic);
end entity;
architecture arch of pointOfInterest is
--------------------------------------------------------------
component gridLockFifo is
generic (
    DATA_WIDTH :integer := 24;
    ADDR_WIDTH :integer := 13);
port (
    -- Reading port.
    Data_out    : out std_logic_vector (DATA_WIDTH-1 downto 0);
    empty_out   : out std_logic;
    ReadEn_in   : in  std_logic;
    RClk        : in  std_logic;
    -- Writing port.
    Data_in     : in  std_logic_vector (DATA_WIDTH-1 downto 0);
    Full_out    : out std_logic;
    WriteEn_in  : in  std_logic;
    WClk        : in  std_logic;
    cleared     : in  std_logic);
end component;
    --------------------------------------------------------------
    signal LEFTCOORD       : integer := 1;
    signal RIGHTCOORD      : integer := 1920;
    signal TOPCOORD        : integer := 5;
    signal BOTTOMCOORD     : integer := 1080;
    signal newRightX       : integer := 0;
    signal newLeftX        : integer := 65535;
    signal newTopY         : integer := 65535;
    signal newBotY         : integer := 0;
    signal updateRightX    : integer := 0;
    signal updateLeftX     : integer := 65535;
    signal updateTopY      : integer := 65535;
    signal updateBotY      : integer := 0;
    signal leftX           : integer;
    signal rightX          : integer;
    signal topY            : integer;
    signal botY            : integer;
    signal prevLeftX       : integer;
    signal prevRightX      : integer;
    signal prevTopY        : integer;
    signal prevBotY        : integer;
    signal prev2LeftX      : integer;
    signal prev2RightX     : integer;
    signal prev2TopY       : integer;
    signal prev2BotY       : integer;
    signal prev3LeftX      : integer;
    signal prev3RightX     : integer;
    signal prev3TopY       : integer;
    signal prev3BotY       : integer;   
    --------------------------------------------------------------
    signal pXcont           : integer;
    signal pYcont           : integer;
    signal gridLocationCont : integer := 0;
    signal gridContMax      : integer := 0;
    signal point_Interest   : integer;
    signal deltaConfig      : integer;
    signal Cur_Color_R      : std_logic_vector(i_data_width-1 downto 0);
    signal Cur_Color_G      : std_logic_vector(i_data_width-1 downto 0);
    signal Cur_Color_B      : std_logic_vector(i_data_width-1 downto 0); 
    --------------------------------------------------------------
    type autoResolution is (idleMode,waitFrameLock,frameWrite,dataReadAtSink,frameLocked,frameRead,frameStreamMode,ClearFifoRegisters);
    signal autoResolutionFrame : autoResolution;
    signal gridLocation    : std_logic;
    signal gridLocationR   : std_logic;
    signal gridLockData    : std_logic_vector(23 downto 0);
    signal fifoDatainR     : std_logic_vector(23 downto 0);
    signal clearData       : std_logic;
    signal fifoDatain      : std_logic_vector(23 downto 0); 
    signal fifoWriteh      : std_logic; 
    signal fifoEmptyh      : std_logic; 
    signal fifoFullh       : std_logic; 
    signal cpuAckLock      : std_logic; 
    signal cpuReadData     : std_logic; 
    signal cpuReadytoRead  : std_logic; 
    signal cpuStreamMode   : std_logic;
    signal cpuIdleMode     : std_logic;
    signal lockData        : std_logic; 
    signal cpuGridCont     : std_logic_vector(15 downto 0);
    signal gridDataEn      : std_logic;
    
    
begin
    -----------------------------------------------------------
    point_Interest      <= to_integer(unsigned(configReg19(s_data_width-1 downto 0)));
    deltaConfig         <= to_integer(unsigned(configReg20(s_data_width-1 downto 0)));
    cpuGridCont         <= std_logic_vector(to_unsigned(gridContMax,16));
    oGridLocation       <= gridLocation;
    -----------------------------------------------------------
    pixelRangeP: process (clk)begin
        if rising_edge(clk) then
            if (((pXcont >= point_Interest) and (pXcont <= deltaConfig)) and ((pYcont >= point_Interest) and (pYcont <= deltaConfig))) and (iValid = '1') then
                gridLocation <='1';
            else
                gridLocation <='0';
            end if;
            gridLocationR <= gridLocation;
            fifoDatainR   <= (iRed & iGreen & iBlue);
        end if;
    end process pixelRangeP;
    gridLocationP: process (clk)begin
        if rising_edge(clk) then
            if (gridLocation ='1') then
                gridLocationCont <= gridLocationCont + 1;
            elsif(endOfFrame ='1') then
                gridContMax      <= gridLocationCont;
                gridLocationCont <= 0;
            else
                gridLocationCont <= gridLocationCont;
            end if;
        end if;
    end process gridLocationP;
    -----------------------------------------------------------
    cpuAckLock     <=configReg40(0);
    cpuReadData    <=configReg40(1);
    cpuReadytoRead <=configReg40(2);
    cpuStreamMode  <=configReg40(3);
    cpuIdleMode    <=configReg40(4);
    -----------------------------------------------------------
    configReg41    <=x"00" & cpuGridCont & "00000" & fifoFullh & fifoEmptyh & lockData;
    gridLockDatao  <=x"00" & gridLockData;
    -----------------------------------------------------------
    process (clk) begin
        if (rising_edge (clk)) then
            if (rst_l = '0') then
                autoResolutionFrame <= idleMode;
                lockData  <= '0';
                clearData <= '1';
            else
            case (autoResolutionFrame) is
            when idleMode =>
                if (cpuIdleMode = '1') then
                    autoResolutionFrame <= idleMode;            
                else
                    autoResolutionFrame <= waitFrameLock;    
                end if;
            when waitFrameLock =>
                    lockData  <= '0';
                    clearData <= '0';
                if (gridLocation = '1') then
                    autoResolutionFrame <= frameWrite;            
                else
                    autoResolutionFrame <= waitFrameLock;    
                end if;
            when dataReadAtSink =>
                if (endOfFrame = '1') then
                    autoResolutionFrame <= frameWrite;
                else
                    autoResolutionFrame <= dataReadAtSink;
                end if;
            when frameWrite =>
                    --Delayed 1 cycle
                    fifoWriteh    <= gridLocationR;
                    fifoDatain    <= fifoDatainR;
                if (fifoFullh = '1') then
                    autoResolutionFrame <= frameLocked;
                else
                    autoResolutionFrame <= frameWrite;
                end if;
            when frameLocked =>
                    lockData   <= '1';
                    fifoWriteh <= '0';
                if (cpuReadytoRead = '1') then
                    autoResolutionFrame <= frameRead;
                else
                    autoResolutionFrame <= frameLocked;
                end if;
            when frameRead =>
                gridDataEn <=gridDataRdEn;
                if (fifoEmptyh = '1') then
                    autoResolutionFrame <= frameStreamMode;
                    clearData  <= '1';
                    lockData   <= '0';
                else
                    autoResolutionFrame <= frameRead;
                    clearData <= '0';
                    lockData  <= '1';
                end if;
            when frameStreamMode =>
                clearData <= '0';
                if (cpuStreamMode = '1') then
                    autoResolutionFrame <= idleMode;
                else
                    autoResolutionFrame <= frameStreamMode;
                end if;
            when ClearFifoRegisters =>
                    fifoWriteh    <= '1';
                    fifoDatain    <=(others => '0');
                if (fifoFullh = '1') then
                    autoResolutionFrame <= frameLocked;
                else
                    autoResolutionFrame <= ClearFifoRegisters;
                end if;
            when others =>
                autoResolutionFrame <= waitFrameLock;
            end case;
            end if;
        end if;
    end process;
    -----------------------------------------------------------
    gridLockFifo_int : gridLockFifo
    generic map(
        DATA_WIDTH => 24,
        ADDR_WIDTH => 14)
    port map(
        Data_out     => gridLockData,
        empty_out    => fifoEmptyh,
        ReadEn_in    => gridDataEn,
        RClk         => rclk,
        Data_in      => fifoDatain,
        Full_out     => fifoFullh,
        WriteEn_in   => fifoWriteh,
        WClk         => clk,
        cleared      => clearData);
    -----------------------------------------------------------
    dataOutP: process (clk)begin
        if rising_edge(clk) then
            pXcont  <= to_integer((unsigned(iXcont)));
            pYcont  <= to_integer((unsigned(iYcont)));
            oValid  <= iValid;
            oRed    <= Cur_Color_R;
            oGreen  <= Cur_Color_G;
            oBlue   <= Cur_Color_B;
        end if;
    end process dataOutP;
    -----------------------------------------------------------
    pixelCoordP: process (clk)begin
        if rising_edge(clk) then
            if iValid = '1' then
               ------------------------------------
                --Process coordinate to be fetched
                ------------------------------------
                if (gridLocation = '1') then 
                    ------------------------------------
                    --Left Coordinate Point
                    ------------------------------------
                    if (pXcont <= newLeftX) then
                        if ( pXcont >= LEFTCOORD) then 
                            newLeftX <= pXcont - 1;
                        end if;   
                    end if;
                    ------------------------------------
                    --Right Coordinate Point
                    ------------------------------------
                    if (pXcont >= newRightX) then
                        if ( pXcont <= RIGHTCOORD) then 
                            newRightX <= pXcont + 1;
                        end if;   
                    end if;
                    ------------------------------------
                    --Top Coordinate Point
                    ------------------------------------
                    if (pYcont <= newTopY) then
                        if ( pYcont >= TOPCOORD) then 
                            newTopY <= pYcont - 1;
                        end if;   
                    end if;
                    ------------------------------------
                    --Bottom Coordinate Point
                    ------------------------------------
                    if (pYcont >= newBotY) then
                        if ( pYcont <= BOTTOMCOORD) then 
                            newBotY <= pYcont + 1;
                        end if;   
                    end if;
                end if;--gridLocation
                ------------------------------------
                -- STREAM SELECTED OBJECT PIXELS TO DISPLAY WITH MTBOX 4 COORDINATES
                ------------------------------------
                -- 3RD FRAME DISPLAY 1ST
                ------------------------------------
                if ((pYcont = prev3BotY) and ((pXcont >= prev3LeftX) and (pXcont <= prev3RightX)))then
                    Cur_Color_R        <=    x"FF";
                    Cur_Color_G        <=    x"00";
                    Cur_Color_B        <=    x"00";
                elsif ((pYcont = prev3TopY) and ((pXcont >= prev3LeftX) and (pXcont <= prev3RightX)))then
                    Cur_Color_R        <=    x"FF";
                    Cur_Color_G        <=    x"00";
                    Cur_Color_B        <=    x"00";
                elsif ((pXcont = prev3LeftX) and ((pYcont >= prev3TopY) and (pYcont <= prev3BotY)))then
                    Cur_Color_R        <=    x"FF";
                    Cur_Color_G        <=    x"00";
                    Cur_Color_B        <=    x"00";
                elsif ((pXcont = prev3RightX) and ((pYcont >= prev3TopY) and (pYcont <= prev3BotY)))then
                    Cur_Color_R        <=    x"FF";
                    Cur_Color_G        <=    x"00";
                    Cur_Color_B        <=    x"00";
                ------------------------------------
                -- 2ND FRAME DISPLAY 2ND
                ------------------------------------
                elsif ((pYcont = prev2BotY) and ((pXcont >= prev2LeftX) and (pXcont <= prev2RightX)))then
                    Cur_Color_R        <=    x"00";
                    Cur_Color_G        <=    x"FF";
                    Cur_Color_B        <=    x"00";
                elsif ((pYcont = prev2TopY) and ((pXcont >= prev2LeftX) and (pXcont <= prev2RightX)))then
                    Cur_Color_R        <=    x"00";
                    Cur_Color_G        <=    x"FF";
                    Cur_Color_B        <=    x"00";
                elsif ((pXcont = prev2LeftX) and ((pYcont >= prev2TopY) and (pYcont <= prev2BotY)))then
                    Cur_Color_R        <=    x"00";
                    Cur_Color_G        <=    x"FF";
                    Cur_Color_B        <=    x"00";
                elsif ((pXcont = prev2RightX) and ((pYcont >= prev2TopY) and (pYcont <= prev2BotY)))then
                    Cur_Color_R        <=    x"00";
                    Cur_Color_G        <=    x"FF";
                    Cur_Color_B        <=    x"00";
                ------------------------------------
                -- 1ST FRAME DISPLAY 3RD
                ------------------------------------
                elsif ((pYcont = prevBotY) and ((pXcont >= prevLeftX) and (pXcont <= prev2RightX)))then
                    Cur_Color_R        <=    x"00";
                    Cur_Color_G        <=    x"00";
                    Cur_Color_B        <=    x"FF";
                elsif ((pYcont = prevTopY) and ((pXcont >= prevLeftX) and (pXcont <= prev2RightX)))then
                    Cur_Color_R        <=    x"00";
                    Cur_Color_G        <=    x"00";
                    Cur_Color_B        <=    x"FF";
                elsif ((pXcont = prevLeftX) and ((pYcont >= prevTopY) and (pYcont <= prevBotY)))then
                    Cur_Color_R        <=    x"00";
                    Cur_Color_G        <=    x"00";
                    Cur_Color_B        <=    x"FF";
                elsif ((pXcont = prev2RightX) and ((pYcont >= prevTopY) and (pYcont <= prevBotY)))then
                    Cur_Color_R        <=    x"00";
                    Cur_Color_G        <=    x"00";
                    Cur_Color_B        <=    x"FF";
                ------------------------------------
                -- INIT FRAME DISPLAY LAST
                ------------------------------------
                elsif ((pYcont = botY) and ((pXcont >= leftX) and (pXcont <= rightX)))then
                    Cur_Color_R        <=    x"80";
                    Cur_Color_G        <=    x"00";
                    Cur_Color_B        <=    x"80";
                elsif ((pYcont = topY) and ((pXcont >= leftX) and (pXcont <= rightX)))then
                    Cur_Color_R        <=    x"80";
                    Cur_Color_G        <=    x"00";
                    Cur_Color_B        <=    x"80";
                elsif ((pXcont = leftX) and ((pYcont >= topY) and (pYcont <= botY)))then
                    Cur_Color_R        <=    x"80";
                    Cur_Color_G        <=    x"00";
                    Cur_Color_B        <=    x"80";
                elsif ((pXcont = rightX) and ((pYcont >= topY) and (pYcont <= botY)))then
                    Cur_Color_R        <=    x"80";
                    Cur_Color_G        <=    x"00";
                    Cur_Color_B        <=    x"80";
                else
                    Cur_Color_R        <=    iRed;
                    Cur_Color_G        <=    iGreen;
                    Cur_Color_B        <=    iBlue;
                end if;
            end if;--iValid
            ----------------------------------------------------------- 
            --endOfFrame
            -----------------------------------------------------------
            if (endOfFrame = '1')then
                -----------------------------------------------------------
                --UPDATE COORDINATES TO DEFAULT
                newLeftX        <=  updateLeftX ; --MAX+BLANK OFFSET
                newRightX       <=  updateRightX; --MIN+BLANK OFFSET
                newTopY         <=  updateTopY  ; --MAX+BLANK OFFSET
                newBotY         <=  updateBotY  ; --MIN+BLANK OFFSET
                -----------------------------------------------------------
                --FETCH NEW COORDINATES
                leftX           <= newLeftX;
                rightX          <= newRightX;
                topY            <= newTopY;
                botY            <= newBotY;
                -----------------------------------------------------------
                -----------------------------------------------------------
                -- PROCESS
                -- PROCESSING 3 TIMES EACH MTBOX IF OBJECT WAS DETECTED
                -- 1ST FRAME
                prevLeftX       <= leftX;
                prevRightX      <= rightX;
                prevTopY        <= topY;
                prevBotY        <= botY;
                -- 2ND FRAME
                prev2LeftX      <= prevLeftX;
                prev2RightX     <= prevRightX;
                prev2TopY       <= prevTopY;
                prev2BotY       <= prevBotY;
                -- 3RD FRAME
                prev3LeftX      <= prev2LeftX;
                prev3RightX     <= prev2RightX;
                prev3TopY       <= prev2TopY;
                prev3BotY       <= prev2BotY;
            end if;--endOfFrame
            -----------------------------------------------------------
        end if;
    end process pixelCoordP;
    -----------------------------------------------------------
end architecture;