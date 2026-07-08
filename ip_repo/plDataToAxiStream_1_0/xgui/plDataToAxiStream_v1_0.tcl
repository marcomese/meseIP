# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  ipgui::add_param $IPINST -name "fifoDepth"
  ipgui::add_param $IPINST -name "dataInWidth"
  ipgui::add_param $IPINST -name "tDataWidth"

}

proc update_PARAM_VALUE.dataInWidth { PARAM_VALUE.dataInWidth } {
	# Procedure called to update dataInWidth when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.dataInWidth { PARAM_VALUE.dataInWidth } {
	# Procedure called to validate dataInWidth
	return true
}

proc update_PARAM_VALUE.fifoDepth { PARAM_VALUE.fifoDepth } {
	# Procedure called to update fifoDepth when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.fifoDepth { PARAM_VALUE.fifoDepth } {
	# Procedure called to validate fifoDepth
	return true
}

proc update_PARAM_VALUE.tDataWidth { PARAM_VALUE.tDataWidth } {
	# Procedure called to update tDataWidth when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.tDataWidth { PARAM_VALUE.tDataWidth } {
	# Procedure called to validate tDataWidth
	return true
}


proc update_MODELPARAM_VALUE.fifoDepth { MODELPARAM_VALUE.fifoDepth PARAM_VALUE.fifoDepth } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.fifoDepth}] ${MODELPARAM_VALUE.fifoDepth}
}

proc update_MODELPARAM_VALUE.dataInWidth { MODELPARAM_VALUE.dataInWidth PARAM_VALUE.dataInWidth } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.dataInWidth}] ${MODELPARAM_VALUE.dataInWidth}
}

proc update_MODELPARAM_VALUE.tDataWidth { MODELPARAM_VALUE.tDataWidth PARAM_VALUE.tDataWidth } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.tDataWidth}] ${MODELPARAM_VALUE.tDataWidth}
}

