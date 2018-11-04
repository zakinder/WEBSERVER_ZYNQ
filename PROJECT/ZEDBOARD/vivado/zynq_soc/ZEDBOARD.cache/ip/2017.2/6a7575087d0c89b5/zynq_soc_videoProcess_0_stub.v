// Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2017.2 (win64) Build 1909853 Thu Jun 15 18:39:09 MDT 2017
// Date        : Sat Nov  3 03:19:42 2018
// Host        : DESKTOP-7G37KAP running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ zynq_soc_videoProcess_0_stub.v
// Design      : zynq_soc_videoProcess_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg484-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "videoProcess_v1_0,Vivado 2017.2" *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix(pixclk, ifval, ilval, idata, config_axis_awaddr, 
  config_axis_awprot, config_axis_awvalid, config_axis_awready, config_axis_wdata, 
  config_axis_wstrb, config_axis_wvalid, config_axis_wready, config_axis_bresp, 
  config_axis_bvalid, config_axis_bready, config_axis_araddr, config_axis_arprot, 
  config_axis_arvalid, config_axis_arready, config_axis_rdata, config_axis_rresp, 
  config_axis_rvalid, config_axis_rready, config_axis_aclk, config_axis_aresetn, 
  rgb_s_axis_tdata, rgb_s_axis_tlast, rgb_s_axis_tvalid, rgb_s_axis_tuser, 
  rgb_s_axis_tready, rgb_s_axis_aclk, rgb_s_axis_aresetn, m_axis_mm2s_tdata, 
  m_axis_mm2s_tkeep, m_axis_mm2s_tstrb, m_axis_mm2s_tid, m_axis_mm2s_tdest, 
  m_axis_mm2s_tlast, m_axis_mm2s_tvalid, m_axis_mm2s_tuser, m_axis_mm2s_tready, 
  m_axis_mm2s_aclk, m_axis_mm2s_aresetn, rgb_m_axis_tdata, rgb_m_axis_tlast, 
  rgb_m_axis_tuser, rgb_m_axis_tvalid, rgb_m_axis_tready, rgb_m_axis_aclk, 
  rgb_m_axis_aresetn)
/* synthesis syn_black_box black_box_pad_pin="pixclk,ifval,ilval,idata[11:0],config_axis_awaddr[6:0],config_axis_awprot[2:0],config_axis_awvalid,config_axis_awready,config_axis_wdata[31:0],config_axis_wstrb[3:0],config_axis_wvalid,config_axis_wready,config_axis_bresp[1:0],config_axis_bvalid,config_axis_bready,config_axis_araddr[6:0],config_axis_arprot[2:0],config_axis_arvalid,config_axis_arready,config_axis_rdata[31:0],config_axis_rresp[1:0],config_axis_rvalid,config_axis_rready,config_axis_aclk,config_axis_aresetn,rgb_s_axis_tdata[15:0],rgb_s_axis_tlast,rgb_s_axis_tvalid,rgb_s_axis_tuser,rgb_s_axis_tready,rgb_s_axis_aclk,rgb_s_axis_aresetn,m_axis_mm2s_tdata[15:0],m_axis_mm2s_tkeep[2:0],m_axis_mm2s_tstrb[2:0],m_axis_mm2s_tid[0:0],m_axis_mm2s_tdest[0:0],m_axis_mm2s_tlast,m_axis_mm2s_tvalid,m_axis_mm2s_tuser,m_axis_mm2s_tready,m_axis_mm2s_aclk,m_axis_mm2s_aresetn,rgb_m_axis_tdata[15:0],rgb_m_axis_tlast,rgb_m_axis_tuser,rgb_m_axis_tvalid,rgb_m_axis_tready,rgb_m_axis_aclk,rgb_m_axis_aresetn" */;
  input pixclk;
  input ifval;
  input ilval;
  input [11:0]idata;
  input [6:0]config_axis_awaddr;
  input [2:0]config_axis_awprot;
  input config_axis_awvalid;
  output config_axis_awready;
  input [31:0]config_axis_wdata;
  input [3:0]config_axis_wstrb;
  input config_axis_wvalid;
  output config_axis_wready;
  output [1:0]config_axis_bresp;
  output config_axis_bvalid;
  input config_axis_bready;
  input [6:0]config_axis_araddr;
  input [2:0]config_axis_arprot;
  input config_axis_arvalid;
  output config_axis_arready;
  output [31:0]config_axis_rdata;
  output [1:0]config_axis_rresp;
  output config_axis_rvalid;
  input config_axis_rready;
  input config_axis_aclk;
  input config_axis_aresetn;
  input [15:0]rgb_s_axis_tdata;
  input rgb_s_axis_tlast;
  input rgb_s_axis_tvalid;
  input rgb_s_axis_tuser;
  output rgb_s_axis_tready;
  input rgb_s_axis_aclk;
  input rgb_s_axis_aresetn;
  output [15:0]m_axis_mm2s_tdata;
  output [2:0]m_axis_mm2s_tkeep;
  output [2:0]m_axis_mm2s_tstrb;
  output [0:0]m_axis_mm2s_tid;
  output [0:0]m_axis_mm2s_tdest;
  output m_axis_mm2s_tlast;
  output m_axis_mm2s_tvalid;
  output m_axis_mm2s_tuser;
  input m_axis_mm2s_tready;
  input m_axis_mm2s_aclk;
  input m_axis_mm2s_aresetn;
  output [15:0]rgb_m_axis_tdata;
  output rgb_m_axis_tlast;
  output rgb_m_axis_tuser;
  output rgb_m_axis_tvalid;
  input rgb_m_axis_tready;
  input rgb_m_axis_aclk;
  input rgb_m_axis_aresetn;
endmodule
