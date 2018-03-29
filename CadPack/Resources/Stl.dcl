stl : dialog {
	label = "CadPack Steel Mill";
	: text {
	  label = "Version 1.1";
	}
	: row {
		children_alignment = top;
		:column {
		: boxed_column {
			label = "Structural Shapes";
			: button {
			key = "w_shape";
			label = "W-Shapes";
			}
			: button {
			key = "m_shape";
			label = "M-Shapes";
			}
			: button {
			key = "hp_shape";
			label = "HP-Shapes";
			}
			: button {
			key = "s_shape";
			label = "S-Shapes";
			}
			: button {
			key = "c_shape";
			label = "C-Shapes";
			}
			: button {
			key = "c_bar_shape";
			label = "C-Bar-Shapes";
			}
			: button {
			key = "mc_shape";
			label = "MC-Shapes";
			}
			: button {
			key = "l_shape";
			label = "L-Shapes";
			}
			: button {
			key = "wt_shape";
			label = "WT-Shapes";
			}
			: button {
			key = "mt_shape";
			label = "MT-Shapes";
			}
			: button {
			key = "st_shape";
			label = "ST-Shapes";
			}
		}
                }
		:column {
		: boxed_column {
			label = "Formed Shapes";
			: button {
			key = "form_ang_shape";
			label = "Formed Angle";
			}
			: button {
			key = "form_chann_shape";
			label = "Formed Channel";
			}
			: button {
			key = "form_zee_shape";
			label = "Formed Zee";
			}
		}
		: boxed_column {
			label = "Pipe and Tube";
			: button {
			key = "std_pipe";
			label = "Pipe - STD";
			}
			: button {
			key = "xs_pipe";
			label = "Pipe - XS";
			}
			: button {
			key = "xxs_pipe";
			label = "Pipe - XXS";
			}
			: button {
			key = "tube_round";
			label = "Tubing - Round";
			}
		}
		: boxed_column {
			label = "Tubing - SQ/RECT";
			: button {
			key = "ts_square";
			label = "TS-Square";
			}
			: button {
			key = "ts_rect";
			label = "TS-Rectangular";
			}
		}
		}
		:column {
		: boxed_column {
			label = "Metric Shapes";
			: button {
			key = "met_w_shape";
			label = "Metric W-Shapes";
			}
			: button {
			key = "met_r_shape";
			label = "Metric R-Shapes";
			}
			: button {
			key = "met_c_shape";
			label = "Metric C-Shapes";
			}
			: button {
			key = "met_a_shape";
			label = "Metric A-Shapes";
			}
		}
		: boxed_column {
			label = "Shape Dimensions";
                        :row {
			:text {	label = "Depth:";}
			:text { is_bold = true;
                                key = "depth";}
			}
			:row {
			:text {	label = "Web thk.:";}
			:text { is_bold = true;
                                key = "web";}
			}
			:row {
			:text {	label = "Width:";}
			:text { is_bold = true;
				key = "width";}
			}
			:row {
			:text {	label = "Flg. Thk.:";}
			:text { is_bold = true;
                                key = "flange";}
			}			
			:row {
			:text {	label = "K Dim.:";}
			:text { is_bold = true;
				key = "k_dim";}
			}
		}
		: boxed_column {
			label = "Pipe and Tube Dim's.";
			:row {
			:text {	label = "O.D.:";}
			:text { is_bold = true;
				key = "od_pipe";}
			}
			:row {
			:text {	label = "I.D.:";}
			:text { is_bold = true;
				key = "id_pipe";}
			}
		}
	}

		: column {
		fixed_height = true;
		: boxed_column {
			label = "Tubing-SQ/RECT Dim's.";
			:row {
			:text {	label = "Depth:";}
			:text { is_bold = true;
				key = "depth_tube";}
			}
			:row {
			:text {	label = "Width:";}
			:text { is_bold = true;
				key = "width_tube";}
			}
			:row {
			:text {	label = "Wall Thk.:";}
			:text { is_bold = true;
				key = "thk_tube";}
			}
		}
                : boxed_column {
			label = "Metric Scale";
				: toggle {
				key = "stl_met_scale";
				label = "1/25.4";
				}
		}
			: list_box {
			label = "Sizes";
			width = 20;
			height = 15;
			key = "get_size";
			}
		}
	}
	:row {
		: column {
		is_default =true;
			: boxed_radio_row {
			label = "View";
				: radio_button {
				key = "2d_end";
				label = "2D End";
				}
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
				: radio_button {
				key = "3d_surface";
				label = "3D Surface";
				}
			}
			: edit_box {
			label = "Length:";
			edit_width=10;
			fixed_width=true;
			key = "length";
			}
		}
	}
:row {
fixed_width = true;
alignment = centered;
ok_cancel;
: button {
  label = "Help";
  fixed_width =  true;
  key = "stl_help";
  }
}
}

stl_help : dialog {
label = "Help for STL";

: list_box {
width =  100;
height =  35;
fixed_height =  true;
key = "stl_help";
}
ok_only;
}

stl_form_ang_dialog : dialog {
label = "Formed Angle";

: edit_box {
label = "Horiz. Leg Dim.:";
edit_width=10;
key = "form_ang_horiz";
}
: edit_box {
label = "Vert. Leg Dim.:";
edit_width=10;
key = "form_ang_vert";
}
: edit_box {
label = "Thickness:";
edit_width=10;
key = "form_ang_thk";
}

ok_cancel;
}

stl_form_chann_dialog : dialog {
label = "Formed Channel";

: edit_box {
label = "Bottom Leg Dim.:";
edit_width=10;
key = "form_chann_bott";
}
: edit_box {
label = "Top Leg Dim.:";
edit_width=10;
key = "form_chann_top";
}
: edit_box {
label = "Vert. Web Dim.:";
edit_width=10;
key = "form_chann_web";
}
: edit_box {
label = "Thickness:";
edit_width=10;
key = "form_chann_thk";
}
ok_cancel;
}

stl_form_zee_dialog : dialog {
label = "Formed Zee";

: edit_box {
label = "Bottom Leg Dim.:";
edit_width=10;
key = "form_zee_bott";
}
: edit_box {
label = "Top Leg Dim.:";
edit_width=10;
key = "form_zee_top";
}
: edit_box {
label = "Vert. Web Dim.:";
edit_width=10;
key = "form_zee_web";
}
: edit_box {
label = "Thickness:";
edit_width=10;
key = "form_zee_thk";
}
ok_cancel;
}