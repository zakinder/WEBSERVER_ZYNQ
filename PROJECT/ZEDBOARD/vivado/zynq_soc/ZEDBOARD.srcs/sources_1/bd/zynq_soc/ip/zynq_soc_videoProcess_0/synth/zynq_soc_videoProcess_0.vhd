-- (c) Copyright 1995-2018 Xilinx, Inc. All rights reserved.
-- 
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
-- 
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
-- 
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
-- 
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.
-- 
-- DO NOT MODIFY THIS FILE.

-- IP VLNV: xilinx.com:user:videoProcess:1.0
-- IP Revision: 11

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY zynq_soc_videoProcess_0 IS
  PORT (
    pixclk : IN STD_LOGIC;
    ifval : IN STD_LOGIC;
    ilval : IN STD_LOGIC;
    idata : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    config_axis_awaddr : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
    config_axis_awprot : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    config_axis_awvalid : IN STD_LOGIC;
    config_axis_awready : OUT STD_LOGIC;
    config_axis_wdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    config_axis_wstrb : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    config_axis_wvalid : IN STD_LOGIC;
    config_axis_wready : OUT STD_LOGIC;
    config_axis_bresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    config_axis_bvalid : OUT STD_LOGIC;
    config_axis_bready : IN STD_LOGIC;
    config_axis_araddr : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
    config_axis_arprot : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    config_axis_arvalid : IN STD_LOGIC;
    config_axis_arready : OUT STD_LOGIC;
    config_axis_rdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    config_axis_rresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    config_axis_rvalid : OUT STD_LOGIC;
    config_axis_rready : IN STD_LOGIC;
    config_axis_aclk : IN STD_LOGIC;
    config_axis_aresetn : IN STD_LOGIC;
    rgb_s_axis_tdata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    rgb_s_axis_tlast : IN STD_LOGIC;
    rgb_s_axis_tvalid : IN STD_LOGIC;
    rgb_s_axis_tuser : IN STD_LOGIC;
    rgb_s_axis_tready : OUT STD_LOGIC;
    rgb_s_axis_aclk : IN STD_LOGIC;
    rgb_s_axis_aresetn : IN STD_LOGIC;
    m_axis_mm2s_tdata : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    m_axis_mm2s_tkeep : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    m_axis_mm2s_tstrb : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    m_axis_mm2s_tid : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    m_axis_mm2s_tdest : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    m_axis_mm2s_tlast : OUT STD_LOGIC;
    m_axis_mm2s_tvalid : OUT STD_LOGIC;
    m_axis_mm2s_tuser : OUT STD_LOGIC;
    m_axis_mm2s_tready : IN STD_LOGIC;
    m_axis_mm2s_aclk : IN STD_LOGIC;
    m_axis_mm2s_aresetn : IN STD_LOGIC;
    rgb_m_axis_tdata : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    rgb_m_axis_tlast : OUT STD_LOGIC;
    rgb_m_axis_tuser : OUT STD_LOGIC;
    rgb_m_axis_tvalid : OUT STD_LOGIC;
    rgb_m_axis_tready : IN STD_LOGIC;
    rgb_m_axis_aclk : IN STD_LOGIC;
    rgb_m_axis_aresetn : IN STD_LOGIC
  );
END zynq_soc_videoProcess_0;

ARCHITECTURE zynq_soc_videoProcess_0_arch OF zynq_soc_videoProcess_0 IS
  ATTRIBUTE DowngradeIPIdentifiedWarnings : STRING;
  ATTRIBUTE DowngradeIPIdentifiedWarnings OF zynq_soc_videoProcess_0_arch: ARCHITECTURE IS "yes";
  COMPONENT videoProcess_v1_0 IS
    GENERIC (
      C_config_axis_DATA_WIDTH : INTEGER; -- Width of S_AXI data bus
      C_config_axis_ADDR_WIDTH : INTEGER; -- Width of S_AXI address bus
      C_rgb_s_axis_TDATA_WIDTH : INTEGER; -- AXI4Stream sink: Data Width
      C_m_axis_mm2s_TDATA_WIDTH : INTEGER; -- Width of S_AXIS address bus. The slave accepts the read and write addresses of width C_M_AXIS_TDATA_WIDTH.
      C_m_axis_mm2s_START_COUNT : INTEGER; -- Start count is the numeber of clock cycles the master will wait before initiating/issuing any transaction.
      C_rgb_m_axis_TDATA_WIDTH : INTEGER; -- Width of S_AXIS address bus. The slave accepts the read and write addresses of width C_M_AXIS_TDATA_WIDTH.
      C_rgb_m_axis_START_COUNT : INTEGER; -- Start count is the numeber of clock cycles the master will wait before initiating/issuing any transaction.
      revision_number : STD_LOGIC_VECTOR(31 DOWNTO 0);
      i_data_width : INTEGER;
      s_data_width : INTEGER;
      i_precision : INTEGER;
      i_full_range : BOOLEAN;
      conf_data_width : INTEGER;
      conf_addr_width : INTEGER;
      img_width : INTEGER;
      p_data_width : INTEGER
    );
    PORT (
      pixclk : IN STD_LOGIC;
      ifval : IN STD_LOGIC;
      ilval : IN STD_LOGIC;
      idata : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
      config_axis_awaddr : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
      config_axis_awprot : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      config_axis_awvalid : IN STD_LOGIC;
      config_axis_awready : OUT STD_LOGIC;
      config_axis_wdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      config_axis_wstrb : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      config_axis_wvalid : IN STD_LOGIC;
      config_axis_wready : OUT STD_LOGIC;
      config_axis_bresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      config_axis_bvalid : OUT STD_LOGIC;
      config_axis_bready : IN STD_LOGIC;
      config_axis_araddr : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
      config_axis_arprot : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      config_axis_arvalid : IN STD_LOGIC;
      config_axis_arready : OUT STD_LOGIC;
      config_axis_rdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      config_axis_rresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      config_axis_rvalid : OUT STD_LOGIC;
      config_axis_rready : IN STD_LOGIC;
      config_axis_aclk : IN STD_LOGIC;
      config_axis_aresetn : IN STD_LOGIC;
      rgb_s_axis_tdata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
      rgb_s_axis_tlast : IN STD_LOGIC;
      rgb_s_axis_tvalid : IN STD_LOGIC;
      rgb_s_axis_tuser : IN STD_LOGIC;
      rgb_s_axis_tready : OUT STD_LOGIC;
      rgb_s_axis_aclk : IN STD_LOGIC;
      rgb_s_axis_aresetn : IN STD_LOGIC;
      m_axis_mm2s_tdata : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
      m_axis_mm2s_tkeep : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
      m_axis_mm2s_tstrb : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
      m_axis_mm2s_tid : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
      m_axis_mm2s_tdest : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
      m_axis_mm2s_tlast : OUT STD_LOGIC;
      m_axis_mm2s_tvalid : OUT STD_LOGIC;
      m_axis_mm2s_tuser : OUT STD_LOGIC;
      m_axis_mm2s_tready : IN STD_LOGIC;
      m_axis_mm2s_aclk : IN STD_LOGIC;
      m_axis_mm2s_aresetn : IN STD_LOGIC;
      rgb_m_axis_tdata : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
      rgb_m_axis_tlast : OUT STD_LOGIC;
      rgb_m_axis_tuser : OUT STD_LOGIC;
      rgb_m_axis_tvalid : OUT STD_LOGIC;
      rgb_m_axis_tready : IN STD_LOGIC;
      rgb_m_axis_aclk : IN STD_LOGIC;
      rgb_m_axis_aresetn : IN STD_LOGIC
    );
  END COMPONENT videoProcess_v1_0;
  ATTRIBUTE X_CORE_INFO : STRING;
  ATTRIBUTE X_CORE_INFO OF zynq_soc_videoProcess_0_arch: ARCHITECTURE IS "videoProcess_v1_0,Vivado 2017.2";
  ATTRIBUTE CHECK_LICENSE_TYPE : STRING;
  ATTRIBUTE CHECK_LICENSE_TYPE OF zynq_soc_videoProcess_0_arch : ARCHITECTURE IS "zynq_soc_videoProcess_0,videoProcess_v1_0,{}";
  ATTRIBUTE CORE_GENERATION_INFO : STRING;
  ATTRIBUTE CORE_GENERATION_INFO OF zynq_soc_videoProcess_0_arch: ARCHITECTURE IS "zynq_soc_videoProcess_0,videoProcess_v1_0,{x_ipProduct=Vivado 2017.2,x_ipVendor=xilinx.com,x_ipLibrary=user,x_ipName=videoProcess,x_ipVersion=1.0,x_ipCoreRevision=11,x_ipLanguage=VHDL,x_ipSimLanguage=MIXED,C_config_axis_DATA_WIDTH=32,C_config_axis_ADDR_WIDTH=7,C_rgb_s_axis_TDATA_WIDTH=16,C_m_axis_mm2s_TDATA_WIDTH=16,C_m_axis_mm2s_START_COUNT=32,C_rgb_m_axis_TDATA_WIDTH=16,C_rgb_m_axis_START_COUNT=32,revision_number=0x10212018,i_data_width=8,s_data_width=16,i_precision=12,i_full_range=FALSE,conf_" & 
"data_width=32,conf_addr_width=4,img_width=4096,p_data_width=11}";
  ATTRIBUTE X_INTERFACE_INFO : STRING;
  ATTRIBUTE X_INTERFACE_INFO OF config_axis_awaddr: SIGNAL IS "xilinx.com:interface:aximm:1.0 config_axis AWADDR";
  ATTRIBUTE X_INTERFACE_INFO OF config_axis_awprot: SIGNAL IS "xilinx.com:interface:aximm:1.0 config_axis AWPROT";
  ATTRIBUTE X_INTERFACE_INFO OF config_axis_awvalid: SIGNAL IS "xilinx.com:interface:aximm:1.0 config_axis AWVALID";
  ATTRIBUTE X_INTERFACE_INFO OF config_axis_awready: SIGNAL IS "xilinx.com:interface:aximm:1.0 config_axis AWREADY";
  ATTRIBUTE X_INTERFACE_INFO OF config_axis_wdata: SIGNAL IS "xilinx.com:interface:aximm:1.0 config_axis WDATA";
  ATTRIBUTE X_INTERFACE_INFO OF config_axis_wstrb: SIGNAL IS "xilinx.com:interface:aximm:1.0 config_axis WSTRB";
  ATTRIBUTE X_INTERFACE_INFO OF config_axis_wvalid: SIGNAL IS "xilinx.com:interface:aximm:1.0 config_axis WVALID";
  ATTRIBUTE X_INTERFACE_INFO OF config_axis_wready: SIGNAL IS "xilinx.com:interface:aximm:1.0 config_axis WREADY";
  ATTRIBUTE X_INTERFACE_INFO OF config_axis_bresp: SIGNAL IS "xilinx.com:interface:aximm:1.0 config_axis BRESP";
  ATTRIBUTE X_INTERFACE_INFO OF config_axis_bvalid: SIGNAL IS "xilinx.com:interface:aximm:1.0 config_axis BVALID";
  ATTRIBUTE X_INTERFACE_INFO OF config_axis_bready: SIGNAL IS "xilinx.com:interface:aximm:1.0 config_axis BREADY";
  ATTRIBUTE X_INTERFACE_INFO OF config_axis_araddr: SIGNAL IS "xilinx.com:interface:aximm:1.0 config_axis ARADDR";
  ATTRIBUTE X_INTERFACE_INFO OF config_axis_arprot: SIGNAL IS "xilinx.com:interface:aximm:1.0 config_axis ARPROT";
  ATTRIBUTE X_INTERFACE_INFO OF config_axis_arvalid: SIGNAL IS "xilinx.com:interface:aximm:1.0 config_axis ARVALID";
  ATTRIBUTE X_INTERFACE_INFO OF config_axis_arready: SIGNAL IS "xilinx.com:interface:aximm:1.0 config_axis ARREADY";
  ATTRIBUTE X_INTERFACE_INFO OF config_axis_rdata: SIGNAL IS "xilinx.com:interface:aximm:1.0 config_axis RDATA";
  ATTRIBUTE X_INTERFACE_INFO OF config_axis_rresp: SIGNAL IS "xilinx.com:interface:aximm:1.0 config_axis RRESP";
  ATTRIBUTE X_INTERFACE_INFO OF config_axis_rvalid: SIGNAL IS "xilinx.com:interface:aximm:1.0 config_axis RVALID";
  ATTRIBUTE X_INTERFACE_INFO OF config_axis_rready: SIGNAL IS "xilinx.com:interface:aximm:1.0 config_axis RREADY";
  ATTRIBUTE X_INTERFACE_INFO OF config_axis_aclk: SIGNAL IS "xilinx.com:signal:clock:1.0 config_axis_CLK CLK, xilinx.com:signal:clock:1.0 config_axis_aclk CLK";
  ATTRIBUTE X_INTERFACE_INFO OF config_axis_aresetn: SIGNAL IS "xilinx.com:signal:reset:1.0 config_axis_RST RST, xilinx.com:signal:reset:1.0 config_axis_aresetn RST";
  ATTRIBUTE X_INTERFACE_INFO OF rgb_s_axis_tdata: SIGNAL IS "xilinx.com:interface:axis:1.0 rgb_s_axis TDATA";
  ATTRIBUTE X_INTERFACE_INFO OF rgb_s_axis_tlast: SIGNAL IS "xilinx.com:interface:axis:1.0 rgb_s_axis TLAST";
  ATTRIBUTE X_INTERFACE_INFO OF rgb_s_axis_tvalid: SIGNAL IS "xilinx.com:interface:axis:1.0 rgb_s_axis TVALID";
  ATTRIBUTE X_INTERFACE_INFO OF rgb_s_axis_tuser: SIGNAL IS "xilinx.com:interface:axis:1.0 rgb_s_axis TUSER";
  ATTRIBUTE X_INTERFACE_INFO OF rgb_s_axis_tready: SIGNAL IS "xilinx.com:interface:axis:1.0 rgb_s_axis TREADY";
  ATTRIBUTE X_INTERFACE_INFO OF rgb_s_axis_aclk: SIGNAL IS "xilinx.com:signal:clock:1.0 rgb_s_axis_CLK CLK, xilinx.com:signal:clock:1.0 rgb_s_axis_aclk CLK";
  ATTRIBUTE X_INTERFACE_INFO OF rgb_s_axis_aresetn: SIGNAL IS "xilinx.com:signal:reset:1.0 rgb_s_axis_RST RST, xilinx.com:signal:reset:1.0 rgb_s_axis_aresetn RST";
  ATTRIBUTE X_INTERFACE_INFO OF m_axis_mm2s_tdata: SIGNAL IS "xilinx.com:interface:axis:1.0 m_axis_mm2s TDATA";
  ATTRIBUTE X_INTERFACE_INFO OF m_axis_mm2s_tkeep: SIGNAL IS "xilinx.com:interface:axis:1.0 m_axis_mm2s TKEEP";
  ATTRIBUTE X_INTERFACE_INFO OF m_axis_mm2s_tstrb: SIGNAL IS "xilinx.com:interface:axis:1.0 m_axis_mm2s TSTRB";
  ATTRIBUTE X_INTERFACE_INFO OF m_axis_mm2s_tid: SIGNAL IS "xilinx.com:interface:axis:1.0 m_axis_mm2s TID";
  ATTRIBUTE X_INTERFACE_INFO OF m_axis_mm2s_tdest: SIGNAL IS "xilinx.com:interface:axis:1.0 m_axis_mm2s TDEST";
  ATTRIBUTE X_INTERFACE_INFO OF m_axis_mm2s_tlast: SIGNAL IS "xilinx.com:interface:axis:1.0 m_axis_mm2s TLAST";
  ATTRIBUTE X_INTERFACE_INFO OF m_axis_mm2s_tvalid: SIGNAL IS "xilinx.com:interface:axis:1.0 m_axis_mm2s TVALID";
  ATTRIBUTE X_INTERFACE_INFO OF m_axis_mm2s_tuser: SIGNAL IS "xilinx.com:interface:axis:1.0 m_axis_mm2s TUSER";
  ATTRIBUTE X_INTERFACE_INFO OF m_axis_mm2s_tready: SIGNAL IS "xilinx.com:interface:axis:1.0 m_axis_mm2s TREADY";
  ATTRIBUTE X_INTERFACE_INFO OF m_axis_mm2s_aclk: SIGNAL IS "xilinx.com:signal:clock:1.0 m_axis_mm2s_CLK CLK, xilinx.com:signal:clock:1.0 m_axis_mm2s_aclk CLK";
  ATTRIBUTE X_INTERFACE_INFO OF m_axis_mm2s_aresetn: SIGNAL IS "xilinx.com:signal:reset:1.0 m_axis_mm2s_RST RST, xilinx.com:signal:reset:1.0 m_axis_mm2s_aresetn RST";
  ATTRIBUTE X_INTERFACE_INFO OF rgb_m_axis_tdata: SIGNAL IS "xilinx.com:interface:axis:1.0 rgb_m_axis TDATA";
  ATTRIBUTE X_INTERFACE_INFO OF rgb_m_axis_tlast: SIGNAL IS "xilinx.com:interface:axis:1.0 rgb_m_axis TLAST";
  ATTRIBUTE X_INTERFACE_INFO OF rgb_m_axis_tuser: SIGNAL IS "xilinx.com:interface:axis:1.0 rgb_m_axis TUSER";
  ATTRIBUTE X_INTERFACE_INFO OF rgb_m_axis_tvalid: SIGNAL IS "xilinx.com:interface:axis:1.0 rgb_m_axis TVALID";
  ATTRIBUTE X_INTERFACE_INFO OF rgb_m_axis_tready: SIGNAL IS "xilinx.com:interface:axis:1.0 rgb_m_axis TREADY";
  ATTRIBUTE X_INTERFACE_INFO OF rgb_m_axis_aclk: SIGNAL IS "xilinx.com:signal:clock:1.0 rgb_m_axis_CLK CLK, xilinx.com:signal:clock:1.0 rgb_m_axis_aclk CLK";
  ATTRIBUTE X_INTERFACE_INFO OF rgb_m_axis_aresetn: SIGNAL IS "xilinx.com:signal:reset:1.0 rgb_m_axis_RST RST, xilinx.com:signal:reset:1.0 rgb_m_axis_aresetn RST";
BEGIN
  U0 : videoProcess_v1_0
    GENERIC MAP (
      C_config_axis_DATA_WIDTH => 32,
      C_config_axis_ADDR_WIDTH => 7,
      C_rgb_s_axis_TDATA_WIDTH => 16,
      C_m_axis_mm2s_TDATA_WIDTH => 16,
      C_m_axis_mm2s_START_COUNT => 32,
      C_rgb_m_axis_TDATA_WIDTH => 16,
      C_rgb_m_axis_START_COUNT => 32,
      revision_number => X"10212018",
      i_data_width => 8,
      s_data_width => 16,
      i_precision => 12,
      i_full_range => false,
      conf_data_width => 32,
      conf_addr_width => 4,
      img_width => 4096,
      p_data_width => 11
    )
    PORT MAP (
      pixclk => pixclk,
      ifval => ifval,
      ilval => ilval,
      idata => idata,
      config_axis_awaddr => config_axis_awaddr,
      config_axis_awprot => config_axis_awprot,
      config_axis_awvalid => config_axis_awvalid,
      config_axis_awready => config_axis_awready,
      config_axis_wdata => config_axis_wdata,
      config_axis_wstrb => config_axis_wstrb,
      config_axis_wvalid => config_axis_wvalid,
      config_axis_wready => config_axis_wready,
      config_axis_bresp => config_axis_bresp,
      config_axis_bvalid => config_axis_bvalid,
      config_axis_bready => config_axis_bready,
      config_axis_araddr => config_axis_araddr,
      config_axis_arprot => config_axis_arprot,
      config_axis_arvalid => config_axis_arvalid,
      config_axis_arready => config_axis_arready,
      config_axis_rdata => config_axis_rdata,
      config_axis_rresp => config_axis_rresp,
      config_axis_rvalid => config_axis_rvalid,
      config_axis_rready => config_axis_rready,
      config_axis_aclk => config_axis_aclk,
      config_axis_aresetn => config_axis_aresetn,
      rgb_s_axis_tdata => rgb_s_axis_tdata,
      rgb_s_axis_tlast => rgb_s_axis_tlast,
      rgb_s_axis_tvalid => rgb_s_axis_tvalid,
      rgb_s_axis_tuser => rgb_s_axis_tuser,
      rgb_s_axis_tready => rgb_s_axis_tready,
      rgb_s_axis_aclk => rgb_s_axis_aclk,
      rgb_s_axis_aresetn => rgb_s_axis_aresetn,
      m_axis_mm2s_tdata => m_axis_mm2s_tdata,
      m_axis_mm2s_tkeep => m_axis_mm2s_tkeep,
      m_axis_mm2s_tstrb => m_axis_mm2s_tstrb,
      m_axis_mm2s_tid => m_axis_mm2s_tid,
      m_axis_mm2s_tdest => m_axis_mm2s_tdest,
      m_axis_mm2s_tlast => m_axis_mm2s_tlast,
      m_axis_mm2s_tvalid => m_axis_mm2s_tvalid,
      m_axis_mm2s_tuser => m_axis_mm2s_tuser,
      m_axis_mm2s_tready => m_axis_mm2s_tready,
      m_axis_mm2s_aclk => m_axis_mm2s_aclk,
      m_axis_mm2s_aresetn => m_axis_mm2s_aresetn,
      rgb_m_axis_tdata => rgb_m_axis_tdata,
      rgb_m_axis_tlast => rgb_m_axis_tlast,
      rgb_m_axis_tuser => rgb_m_axis_tuser,
      rgb_m_axis_tvalid => rgb_m_axis_tvalid,
      rgb_m_axis_tready => rgb_m_axis_tready,
      rgb_m_axis_aclk => rgb_m_axis_aclk,
      rgb_m_axis_aresetn => rgb_m_axis_aresetn
    );
END zynq_soc_videoProcess_0_arch;
