# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "C_S00_AXI_BASEADDR" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_S00_AXI_HIGHADDR" -parent ${Page_0}

  ipgui::add_param $IPINST -name "nRegs"
  ipgui::add_param $IPINST -name "addrWidth"
  ipgui::add_param $IPINST -name "dataWidth"

}

proc update_PARAM_VALUE.addrWidth { PARAM_VALUE.addrWidth } {
	# Procedure called to update addrWidth when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.addrWidth { PARAM_VALUE.addrWidth } {
	# Procedure called to validate addrWidth
	return true
}

proc update_PARAM_VALUE.dataWidth { PARAM_VALUE.dataWidth } {
	# Procedure called to update dataWidth when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.dataWidth { PARAM_VALUE.dataWidth } {
	# Procedure called to validate dataWidth
	return true
}

proc update_PARAM_VALUE.nRegs { PARAM_VALUE.nRegs } {
	# Procedure called to update nRegs when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.nRegs { PARAM_VALUE.nRegs } {
	# Procedure called to validate nRegs
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_BASEADDR { PARAM_VALUE.C_S00_AXI_BASEADDR } {
	# Procedure called to update C_S00_AXI_BASEADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_BASEADDR { PARAM_VALUE.C_S00_AXI_BASEADDR } {
	# Procedure called to validate C_S00_AXI_BASEADDR
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_HIGHADDR { PARAM_VALUE.C_S00_AXI_HIGHADDR } {
	# Procedure called to update C_S00_AXI_HIGHADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_HIGHADDR { PARAM_VALUE.C_S00_AXI_HIGHADDR } {
	# Procedure called to validate C_S00_AXI_HIGHADDR
	return true
}


proc update_MODELPARAM_VALUE.nRegs { MODELPARAM_VALUE.nRegs PARAM_VALUE.nRegs } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.nRegs}] ${MODELPARAM_VALUE.nRegs}
}

proc update_MODELPARAM_VALUE.addrWidth { MODELPARAM_VALUE.addrWidth PARAM_VALUE.addrWidth } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.addrWidth}] ${MODELPARAM_VALUE.addrWidth}
}

proc update_MODELPARAM_VALUE.dataWidth { MODELPARAM_VALUE.dataWidth PARAM_VALUE.dataWidth } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.dataWidth}] ${MODELPARAM_VALUE.dataWidth}
}

