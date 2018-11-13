-- Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2017.2 (win64) Build 1909853 Thu Jun 15 18:39:09 MDT 2017
-- Date        : Mon Nov 12 22:15:07 2018
-- Host        : DESKTOP-7G37KAP running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               v:/SOBELDETECT/DEBUG/RELEASED/ZEDBOARD/vivado/zynq_soc/ZEDBOARD.srcs/sources_1/bd/zynq_soc/ip/zynq_soc_CLK_GEN_148MHZ_0/zynq_soc_CLK_GEN_148MHZ_0_stub.vhdl
-- Design      : zynq_soc_CLK_GEN_148MHZ_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7z020clg484-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity zynq_soc_CLK_GEN_148MHZ_0 is
  Port ( 
    clk_out1 : out STD_LOGIC;
    clk_out2 : out STD_LOGIC;
    clk_in1 : in STD_LOGIC
  );

end zynq_soc_CLK_GEN_148MHZ_0;

architecture stub of zynq_soc_CLK_GEN_148MHZ_0 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk_out1,clk_out2,clk_in1";
begin
end;
