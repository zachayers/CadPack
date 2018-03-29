fast : dialog {
	label = "CadPack Fastener Bin";
	: text {
	  label = "Version 2.0";
	}
	: row {
		children_alignment = top;
		: boxed_column {
			label = "Fasteners - Imperial";
			fixed_height = true;
			: button {
			key = "flat_head_e";
			label = "Flat Head";
			}
			: button {
			key = "hex_head_e";
			label = "Hex Head";
			}
			: button {
			key = "hex_nut_e";
			label = "Hex Nut";
			}
			: button {
			key = "jam_nut_e";
			label = "Jam Nut";
			}
			: button {
			key = "pan_head_e";
			label = "Pan Head";
			}
			: button {
			key = "round_head_e";
			label = "Round Head";
			}
			: button {
			key = "socket_head_e";
			label = "Socket Head";
			}
			: button {
			key = "set_screw_e_cup";
			label = "Set Screw - Cup point";
			}
			: button {
			key = "set_screw_e_dog";
			label = "Set Screw - Dog point";
			}
			: button {
			key = "stud_e";
			label = "Studs";
			}
		}
		:column {
		fixed_height = true;
		: boxed_column {
			label = "Fasteners - Metric";
			fixed_height = true;
			: button {
			key = "flat_head_m";
			label = "Flat Head";
			}
			: button {
			key = "hex_head_m";
			label = "Hex Head";
			}
			: button {
			key = "hex_nut_m";
			label = "Hex Nut";
			}
			: button {
			key = "jam_nut_m";
			label = "Jam Nut";
			}
			: button {
			key = "pan_head_m";
			label = "Pan Head";
			}
			: button {
			key = "round_head_m";
			label = "Round Head";
			}
			: button {
			key = "socket_head_m";
			label = "Socket Head";
			}
			: button {
			key = "set_screw_m_cup";
			label = "Set Screw - Cup point";
			}
			: button {
			key = "set_screw_m_dog";
			label = "Set Screw - Dog point";
			}
			: button {
			key = "stud_m";
			label = "Studs";
			}
		}
		}
		:column {
		fixed_height = true;
		: boxed_column {
			label = "Dimensions";
			:row {
			:text {	label = "Head Dia.:";}
                        :text { is_bold = true;
				width = 6;
                                key = "head_dia";}
			}
			:row {
			:text {	label = "Head Thk.:";}
			:text { is_bold = true;
                                width = 6;
				key = "head_thk";}
			}
			:row {
			:text {	label = "Nut Dia.:";}
			:text { is_bold = true;
                                width = 6;  
				key = "nut_dia";}
			}
			:row {
			:text {	label = "Nut Thk.:";}
			:text { is_bold = true;
                                width = 6;
				key = "nut_thk";}
			}
			:row {
			:text {	label = "Jam Nut Dia.:";}
			:text { is_bold = true;
                                width = 6;
				key = "jam_nut_dia";}
			}
			:row {
			:text {	label = "Jam Nut Thk.:";}
			:text { is_bold = true;
                                width = 6;
				key = "jam_nut_thk";}
			}
			:row {
			:text {	label = "Flat Wash. Dia.:";}
                        :text { is_bold = true;
                                width = 6;
				key = "flat_dia";}
			}
			:row {
			:text {	label = "Flat Wash. Thk.:";}
			:text { is_bold = true;
                                width = 6;
				key = "flat_thk";}
			}			
			:row {
			:text {	label = "Lock Wash. Dia.:";}
			:text { is_bold = true;
                                width = 6;
				key = "lock_dia";}
			}
			:row {
			:text {	label = "Lock Wash. Thk.:";}
			:text { is_bold = true;
                                width = 6;
				key = "lock_thk";}
			}
			:row {
			:text {	label = "Root Dia. Coarse:";}
			:text { is_bold = true;
                                width = 6;
				key = "root_dia_c";}
			}
			:row {
			:text {	label = "Root Dia. Fine:";}
			:text { is_bold = true;
                                width = 6;
				key = "root_dia_f";}
			}
			:row {
			:text {	label = "Hex Key Size:";}
			:text { is_bold = true;
                                width = 6;
				key = "hex_key";}
			}
		}
	}
		: column {
		fixed_height = true;
			: list_box {
			label = "Sizes";
			width = 20;
			height = 20;
			key = "get_size";
			}
		}
	}
	:row {
	fixed_width = true;
	children_alignment = top;
			: boxed_radio_column {
			fixed_width = true;
			label = "View";
				: radio_button {
				key = "2d_top";
				label = "2D Top";
				}
				: radio_button {
				key = "2d_side";
				label = "2D Side";
				}
				: radio_button {
				key = "3d_solid";
				label = "3D Solid";
				}
			}
			: boxed_radio_column {
			fixed_width = true;
			label = "Washer Type";
				: radio_button {
				key = "washer_none";
				label = "No Washers";
				}
				: radio_button {
				key = "washer_lock";
				label = "Lock Washer";
				}
				: radio_button {
				key = "washer_flat";
				label = "Flat Washer";
				}
				: radio_button {
				key = "washer_both";
				label = "Both Washers";
				}
			}
			:boxed_column {
			label = "Screw Shank, Set Screw, and Stud";
			fixed_width = true;
			: toggle {
			key = "shank";
			label = "Add Screw Shank";
			}
			: edit_box {
			label = "Shank, Set Screw, or Stud Length:";
			edit_width=10;
			key = "shank_length";
			}
			: edit_box {
			label = "Thread Length:";
			edit_width=10;
			key = "thread_length";
			}
			: boxed_radio_row {
			fixed_width = true;
			fixed_height = true;
			label = "Thread Type";
				: radio_button {
				key = "thread_coarse";
				label = "Coarse";
				}
				: radio_button {
				key = "thread_fine";
				label = "Fine";
				}
			}
		}
			: boxed_column {
			label = "Metric Scale";
			fixed_height = true;
				: toggle {
				key = "met_scale";
				label = "1/25.4";
				}
			}
	}	
:row {
fixed_width = true;
alignment = centered;
ok_cancel;
: button {
  label                   = "Help";
  fixed_width             =  true;
  key                     = "fast_help";
  }
}
}

fast_help : dialog {
label                     = "Help for Fastener Bin";

: list_box {
   width                  =  100;
   height                 =  35;
   fixed_height           =  true;
   key                    = "fast_help";
 }
 ok_only;
}