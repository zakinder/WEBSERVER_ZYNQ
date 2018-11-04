-- Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2017.2 (win64) Build 1909853 Thu Jun 15 18:39:09 MDT 2017
-- Date        : Sat Nov  3 03:19:47 2018
-- Host        : DESKTOP-7G37KAP running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               v:/ZEDBOARD/vivado/zynq_soc/ZEDBOARD.srcs/sources_1/bd/zynq_soc/ip/zynq_soc_videoProcess_0/zynq_soc_videoProcess_0_stub.vhdl
-- Design      : zynq_soc_videoProcess_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7z020clg484-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity zynq_soc_videoProcess_0 is
  Port ( 
    pixclk : in STD_LOGIC;
    ifval : in STD_LOGIC;
    ilval : in STD_LOGIC;
    idata : in STD_LOGIC_VECTOR ( 11 downto 0 );
    config_axis_awaddr : in STD_LOGIC_VECTOR ( 6 downto 0 );
    config_axis_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    config_axis_awvalid : in STD_LOGIC;
    config_axis_awready : out STD_LOGIC;
    config_axis_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    config_axis_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    config_axis_wvalid : in STD_LOGIC;
    config_axis_wready : out STD_LOGIC;
    config_axis_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    config_axis_bvalid : out STD_LOGIC;
    config_axis_bready : in STD_LOGIC;
    config_axis_araddr : in STD_LOGIC_VECTOR ( 6 downto 0 );
    config_axis_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    config_axis_arvalid : in STD_LOGIC;
    config_axis_arready : out STD_LOGIC;
    config_axis_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    config_axis_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    config_axis_rvalid : out STD_LOGIC;
    config_axis_rready : in STD_LOGIC;
    config_axis_aclk : in STD_LOGIC;
    config_axis_aresetn : in STD_LOGIC;
    rgb_s_axis_tdata : in STD_LOGIC_VECTOR ( 15 downto 0 );
    rgb_s_axis_tlast : in STD_LOGIC;
    rgb_s_axis_tvalid : in STD_LOGIC;
    rgb_s_axis_tuser : in STD_LOGIC;
    rgb_s_axis_tready : out STD_LOGIC;
    rgb_s_axis_aclk : in STD_LOGIC;
    rgb_s_axis_aresetn : in STD_LOGIC;
    m_axis_mm2s_tdata : out STD_LOGIC_VECTOR ( 15 downto 0 );
    m_axis_mm2s_tkeep : out STD_LOGIC_VECTOR ( 2 downto 0 );
    m_axis_mm2s_tstrb : out STD_LOGIC_VECTOR ( 2 downto 0 );
    m_axis_mm2s_tid : out STD_LOGIC_VECTOR ( 0 to 0 );
    m_axis_mm2s_tdest : out STD_LOGIC_VECTOR ( 0 to 0 );
    m_axis_mm2s_tlast : out STD_LOGIC;
    m_axis_mm2s_tvalid : out STD_LOGIC;
    m_axis_mm2s_tuser : out STD_LOGIC;
    m_axis_mm2s_tready : in STD_LOGIC;
    m_axis_mm2s_aclk : in STD_LOGIC;
    m_axis_mm2s_aresetn : in STD_LOGIC;
    rgb_m_axis_tdata : out STD_LOGIC_VECTOR ( 15 downto 0 );
    rgb_m_axis_tlast : out STD_LOGIC;
    rgb_m_axis_tuser : out STD_LOGIC;
    rgb_m_axis_tvalid : out STD_LOGIC;
    rgb_m_axis_tready : in STD_LOGIC;
    rgb_m_axis_aclk : in STD_LOGIC;
    rgb_m_axis_aresetn : in STD_LOGIC
  );

end zynq_soc_videoProcess_0;

architecture stub of zynq_soc_videoProcess_0 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "pixclk,ifval,ilval,idata[11:0],config_axis_awaddr[6:0],config_axis_awprot[2:0],config_axis_awvalid,config_axis_awready,config_axis_wdata[31:0],config_axis_wstrb[3:0],config_axis_wvalid,config_axis_wready,config_axis_bresp[1:0],config_axis_bvalid,config_axis_bready,config_axis_araddr[6:0],config_axis_arprot[2:0],config_axis_arvalid,config_axis_arready,config_axis_rdata[31:0],config_axis_rresp[1:0],config_axis_rvalid,config_axis_rready,config_axis_aclk,config_axis_aresetn,rgb_s_axis_tdata[15:0],rgb_s_axis_tlast,rgb_s_axis_tvalid,rgb_s_axis_tuser,rgb_s_axis_tready,rgb_s_axis_aclk,rgb_s_axis_aresetn,m_axis_mm2s_tdata[15:0],m_axis_mm2s_tkeep[2:0],m_axis_mm2s_tstrb[2:0],m_axis_mm2s_tid[0:0],m_axis_mm2s_tdest[0:0],m_axis_mm2s_tlast,m_axis_mm2s_tvalid,m_axis_mm2s_tuser,m_axis_mm2s_tready,m_axis_mm2s_aclk,m_axis_mm2s_aresetn,rgb_m_axis_tdata[15:0],rgb_m_axis_tlast,rgb_m_axis_tuser,rgb_m_axis_tvalid,rgb_m_axis_tready,rgb_m_axis_aclk,rgb_m_axis_aresetn";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "videoProcess_v1_0,Vivado 2017.2";
begin
end;
