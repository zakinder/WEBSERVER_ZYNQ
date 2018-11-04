

set_property PACKAGE_PIN W18 [get_ports io_hdmio_clk]
set_property PACKAGE_PIN U16 [get_ports io_hdmio_de]
set_property PACKAGE_PIN V17 [get_ports io_hdmio_hsync]
set_property PACKAGE_PIN U15 [get_ports io_hdmio_spdif]
set_property PACKAGE_PIN W17 [get_ports io_hdmio_vsync]


set_property PACKAGE_PIN Y13 [get_ports {io_hdmio_data[0]}]
set_property PACKAGE_PIN AA13 [get_ports {io_hdmio_data[1]}]
set_property PACKAGE_PIN AA14 [get_ports {io_hdmio_data[2]}]
set_property PACKAGE_PIN Y14 [get_ports {io_hdmio_data[3]}]
set_property PACKAGE_PIN AB15 [get_ports {io_hdmio_data[4]}]
set_property PACKAGE_PIN AB16 [get_ports {io_hdmio_data[5]}]
set_property PACKAGE_PIN AA16 [get_ports {io_hdmio_data[6]}]
set_property PACKAGE_PIN AB17 [get_ports {io_hdmio_data[7]}]
set_property PACKAGE_PIN AA17 [get_ports {io_hdmio_data[8]}]
set_property PACKAGE_PIN Y15 [get_ports {io_hdmio_data[9]}]
set_property PACKAGE_PIN W13 [get_ports {io_hdmio_data[10]}]
set_property PACKAGE_PIN W15 [get_ports {io_hdmio_data[11]}]
set_property PACKAGE_PIN V15 [get_ports {io_hdmio_data[12]}]
set_property PACKAGE_PIN U17 [get_ports {io_hdmio_data[13]}]
set_property PACKAGE_PIN V14 [get_ports {io_hdmio_data[14]}]
set_property PACKAGE_PIN V13 [get_ports {io_hdmio_data[15]}]


set_property PACKAGE_PIN AA18 [get_ports hdmi_iic_scl_io]
set_property SLEW SLOW [get_ports hdmi_iic_scl_io]
set_property DRIVE 8 [get_ports hdmi_iic_scl_io]
set_property IOSTANDARD LVCMOS33 [get_ports hdmi_iic_scl_io]


set_property PACKAGE_PIN Y16 [get_ports hdmi_iic_sda_io]
set_property SLEW SLOW [get_ports hdmi_iic_sda_io]
set_property DRIVE 8 [get_ports hdmi_iic_sda_io]
set_property IOSTANDARD LVCMOS33 [get_ports hdmi_iic_sda_io]


set_property IOSTANDARD LVCMOS33 [get_ports {io_hdmio_data[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports {io_hdmio_data[14]}]
set_property IOSTANDARD LVCMOS33 [get_ports {io_hdmio_data[13]}]
set_property IOSTANDARD LVCMOS33 [get_ports {io_hdmio_data[12]}]
set_property IOSTANDARD LVCMOS33 [get_ports {io_hdmio_data[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {io_hdmio_data[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {io_hdmio_data[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {io_hdmio_data[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {io_hdmio_data[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {io_hdmio_data[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {io_hdmio_data[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {io_hdmio_data[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {io_hdmio_data[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {io_hdmio_data[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {io_hdmio_data[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {io_hdmio_data[0]}]

set_property IOSTANDARD LVCMOS33 [get_ports io_hdmio_clk]
set_property IOSTANDARD LVCMOS33 [get_ports io_hdmio_de]
set_property IOSTANDARD LVCMOS33 [get_ports io_hdmio_hsync]
set_property IOSTANDARD LVCMOS33 [get_ports io_hdmio_spdif]
set_property IOSTANDARD LVCMOS33 [get_ports io_hdmio_vsync]

set_clock_groups -name asynchronous -asynchronous -group [get_clocks [get_clocks -of_objects [get_pins zynq_soc_i/CLK_GEN_148MHZ/inst/mmcm_adv_inst/CLKOUT0]]] -group [get_clocks *clk_fpga*]
create_generated_clock -name io_hdmio_clk -source [get_pins zynq_soc_i/HDMI_OUTPUT/HDMI/U0/V6_GEN.ODDR_hdmi_clk_o/C] -divide_by 1 -invert [get_ports io_hdmio_clk]


set_false_path -from [get_ports *pixclk*]

set_false_path -from [get_clocks clk_fpga_2] -to [get_clocks clk_fpga_0]
