
viewslide : dialog {
  label = "Welding Symbol Definitions";
  : image {
    key = "welds";
    color = 250;
    aspect_ratio = 1.6;
    height = 35;
  }
  ok_only;
}

weld_info : dialog {
  aspect_ratio = 0;
  label = "About WELD.LSP - CadPack Weld Symbol Utility";
  : list_box {
      list = "info_list";
      key = "info_text";
      width =  55;
      height = 15;
  }
  ok_only;
}

weld_help : dialog {
  aspect_ratio = 0;
  label = "CadPack Weld Symbol Utility - Help";
  : list_box {
      list = "help_list";
      key = "help_text";
      width =  50;
      height = 20;
  }
  : row {
    ok_only;
    : button {
        label = "Show";
        mnemonic = "S";
        key = "slide1";
    }
    : button {
        label = "Details";
        mnemonic = "D";
        key = "slide2";
    }
  }
}

weld : dialog {
  label = "CadPack Weld Symbol Utility";
    : row {
      : boxed_column {
        label = "Near Side";
        : popup_list {
            label = "Weld Type";
            mnemonic = "y";
            list = "weld_list";
            key = "weld_type_near";
        }
        : edit_box {
            label = "Weld Size";
            mnemonic = "e";
            key = "weld_size_near";
            width = 15;
            edit_width = 15;
            edit_limit = 15;
        }
        : edit_box {
            label = "Effective Throat (E)";
            mnemonic = "(";
            key = "throat_near";
            width = 5;
            edit_width = 5;
            edit_limit = 5;
        }
        : edit_box {
            label = "Length-Pitch";
            mnemonic = "P";
            key = "pitch_near";
            width = 15;
            edit_width = 15;
            edit_limit = 15;
        }
        : edit_box {
            label = "Groove/C-Sink Angle (deg)";
            mnemonic = "G";
            key = "weld_ang_near";
            width = 3;
            edit_width = 3;
            edit_limit = 3;
        }
        : edit_box {
            label = "Spot/Proj. Quantity (N)";
            mnemonic = "j";
            key = "spot_qty_near";
            width = 2;
            edit_width = 2;
            edit_limit = 2;
        }
        : edit_box {
            label = "Root Opening or Depth";
            mnemonic = "i";
            key = "depth_near";
            width = 5;
            edit_width = 5;
            edit_limit = 5;
        }
        : popup_list {
            label = "Finish Symbol";
            mnemonic = "S";
            list = "finish_list";
            key = "finish_near";
        }
        : popup_list {
            label = "Contour";
            mnemonic = "u";
            list = "contour_list";
            key = "contour_near";
        }
      }
      : boxed_column {
        label = "Far Side";
        : popup_list {
            label = "Weld Type";
            mnemonic = "l";
            list = "weld_list";
            key = "weld_type_far";
        }
        : edit_box {
            label = "Weld Size";
            mnemonic = "d";
            key = "weld_size_far";
            width = 15;
            edit_width = 15;
            edit_limit = 15;
        }
        : edit_box {
            label = "Effective Throat (E)";
            mnemonic = "v";
            key = "throat_far";
            width = 5;
            edit_width = 5;
            edit_limit = 5;
        }
        : edit_box {
            label = "Length-Pitch";
            mnemonic = "-";
            key = "pitch_far";
            width = 15;
            edit_width = 15;
            edit_limit = 15;
        }
        : edit_box {
            label = "Groove/C-Sink Angle (deg)";
            mnemonic = "r";
            key = "weld_ang_far";
            width = 3;
            edit_width = 3;
            edit_limit = 3;
        }
        : edit_box {
            label = "Spot/Proj. Quantity (N)";
            mnemonic = "Q";
            key = "spot_qty_far";
            width = 2;
            edit_width = 2;
            edit_limit = 2;
        }
        : edit_box {
            label = "Root Opening or Depth";
            mnemonic = "o";
            key = "depth_far";
            width = 5;
            edit_width = 5;
            edit_limit = 5;
        }
        : popup_list {
            label = "Finish Symbol";
            mnemonic = "n";
            list = "finish_list";
            key = "finish_far";
        }
        : popup_list {
            label = "Contour";
            mnemonic = "C";
            list = "contour_list";
            key = "contour_far";
        }
      }
    }
    : boxed_row {
      label = "Supplementary Symbols";
      : toggle {
          label = "Melt Through";
          mnemonic = "M";
          key = "melt_thru";
          value = "0";
      }
      : toggle {
          label = "Stagger";
          mnemonic = "a";
          key = "stagger";
          value = "0";
      }
      : toggle {
          label = "Weld All Around";
          mnemonic = "W";
          key = "weld_all_around";
          value = "0";
      }
      : toggle {
          label = "Field Weld";
          mnemonic = "F";
          key = "field_weld";
          value = "0";
      }
      : toggle {
          label = "Tail";
          mnemonic = "T";
          key = "tail";
          value = "0";
      }
    }
  ok_cancel_help_info;
}

