// Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2017.2 (win64) Build 1909853 Thu Jun 15 18:39:09 MDT 2017
// Date        : Sat Nov  3 03:17:22 2018
// Host        : DESKTOP-7G37KAP running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               v:/ZEDBOARD/vivado/zynq_soc/ZEDBOARD.srcs/sources_1/bd/zynq_soc/ip/zynq_soc_VIDEO_OUT_0/zynq_soc_VIDEO_OUT_0_stub.v
// Design      : zynq_soc_VIDEO_OUT_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg484-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "v_axi4s_vid_out_v4_0_6,Vivado 2017.2" *)
module zynq_soc_VIDEO_OUT_0(aclk, aclken, aresetn, s_axis_video_tdata, 
  s_axis_video_tvalid, s_axis_video_tready, s_axis_video_tuser, s_axis_video_tlast, fid, 
  vid_io_out_clk, vid_io_out_ce, vid_io_out_reset, vid_active_video, vid_vsync, vid_hsync, 
  vid_vblank, vid_hblank, vid_field_id, vid_data, vtg_vsync, vtg_hsync, vtg_vblank, vtg_hblank, 
  vtg_active_video, vtg_field_id, vtg_ce, locked, overflow, underflow, status)
/* synthesis syn_black_box black_box_pad_pin="aclk,aclken,aresetn,s_axis_video_tdata[15:0],s_axis_video_tvalid,s_axis_video_tready,s_axis_video_tuser,s_axis_video_tlast,fid,vid_io_out_clk,vid_io_out_ce,vid_io_out_reset,vid_active_video,vid_vsync,vid_hsync,vid_vblank,vid_hblank,vid_field_id,vid_data[15:0],vtg_vsync,vtg_hsync,vtg_vblank,vtg_hblank,vtg_active_video,vtg_field_id,vtg_ce,locked,overflow,underflow,status[31:0]" */;
  input aclk;
  input aclken;
  input aresetn;
  input [15:0]s_axis_video_tdata;
  input s_axis_video_tvalid;
  output s_axis_video_tready;
  input s_axis_video_tuser;
  input s_axis_video_tlast;
  input fid;
  input vid_io_out_clk;
  input vid_io_out_ce;
  input vid_io_out_reset;
  output vid_active_video;
  output vid_vsync;
  output vid_hsync;
  output vid_vblank;
  output vid_hblank;
  output vid_field_id;
  output [15:0]vid_data;
  input vtg_vsync;
  input vtg_hsync;
  input vtg_vblank;
  input vtg_hblank;
  input vtg_active_video;
  input vtg_field_id;
  output vtg_ce;
  output locked;
  output overflow;
  output underflow;
  output [31:0]status;
endmodule
