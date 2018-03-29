
;--------------------------INTERNAL ERROR HANDLER---------------------;
(defun FAST_ERR (msg) 
  (if (or (/= msg "Function cancelled") ; If an error (such as ESC) occurs
          (= msg "quit / exit abort"))
  (princ)
  (princ (strcat "\nError: " msg))) ; while this command is active...
  (setvar "OSMODE" os)              ; Restore saved modes
  (setvar "PLINEWID" plw)
  (setq *error* olderr)            ; Restore old *error* handler
  (princ)
);end FAST_ERR
;------------------------------MAIN PROGRAM----------------------------;
(defun dtr (a)
(* pi (/ a 180.0)))
;----------------------------------------------------------------------;     
(defun rtd (a)
(/ (* a 180.0) pi))
;----------------------------------------------------------------------;
;Read data file and parse "size string", nth 0, for display in
;list box as variable display_list. 
(defun FAST_READ_DIM_FILE (/ a aa)
(setq fast_def_newtile nil
      fast_def_size nil
      fast_def_which_view nil
      fast_def_display_list nil
      fast_def_index nil
      fast_def_w nil
      fast_def_thread nil
      fast_def_shank nil
      fast_def_lg nil
      fast_def_td nil
      fast_def_scale nil
      fast_def_df nil
      fast_def_tf nil
      fast_def_dl nil
      fast_def_tl nil
      fast_def_dhh nil
      fast_def_thh nil
      fast_def_idc nil
      fast_def_idf nil
      fast_def_id nil
      fast_def_od nil
      fast_def_dsh nil
      fast_def_tsh nil
      fast_def_rhx nil
      fast_def_dfh nil
      fast_def_ho nil
      fast_def_tfh nil
      fast_def_slw nil
      fast_def_sdfh nil
      fast_def_drh nil
      fast_def_trh nil
      fast_def_sdrh nil
      fast_def_dph nil
      fast_def_tph nil
      fast_def_radph nil
      fast_def_sdph nil
      fast_def_dcp nil
      fast_def_ddp nil
      fast_def_ldp nil
      fast_def_ssrhx nil
      fast_def_dhn nil
      fast_def_thn nil
      fast_def_djn nil
      fast_def_tjn nil
      fast_def_check nil     
      fast_def_2dtop nil
      fast_def_2dside nil
      fast_def_3dsolid nil
      fast_def_washernone nil
      fast_def_washerlock nil
      fast_def_washerflat nil
      fast_def_washerboth nil
      fast_def_threadcoarse nil
      fast_def_threadfine nil
      fast_def_shank nil
      fast_def_shanklength nil
      fast_def_threadlength nil
      fast_def_metscale nil
      fast_def_headdia nil
      fast_def_headthk nil
      fast_def_flatdia nil
      fast_def_flatthk nil
      fast_def_lockdia nil
      fast_def_lockthk nil
      fast_def_rootdiac nil
      fast_def_rootdiaf nil
      fast_def_nutdia nil
      fast_def_nutthk nil
      fast_def_jamnutdia nil
      fast_def_jamnutthk nil
      fast_def_hexkey nil
      size nil
      df nil
      tf nil
      dl nil
      tl nil
      dhh nil
      thh nil
      idc nil
      idf nil
      od nil
      dsh nil
      tsh nil
      rhx nil
      dfh nil
      ho nil
      tfh nil
      slw nil
      sdfh nil
      drh nil
      trh nil
      sdrh nil
      dph nil
      tph nil
      radph nil
      sdph nil
      dcp nil
      ddp nil
      ldp nil
      ssrhx nil
      dhn nil
      thn nil
      djn nil
      tjn nil
      check nil)
      
(set_tile "head_dia" "")
(set_tile "head_thk" "")
(set_tile "flat_dia" "")
(set_tile "flat_thk" "")
(set_tile "lock_dia" "")
(set_tile "lock_thk" "")
(set_tile "root_dia_c" "")
(set_tile "root_dia_f" "")
(set_tile "nut_dia" "")
(set_tile "nut_thk" "")
(set_tile "jam_nut_dia" "")
(set_tile "jam_nut_thk" "")
(set_tile "hex_key" "")
	(setq a "")
        (FAST_DEFAULTS)              
	(FAST_OPEN_DIM_FILE)
	(while (/= a nil)
		(setq a (read-line fast_dim_file))
		(if (/= a nil)
			(progn
				(setq a (nth 0 (read a))
				      aa (append aa (list a)))
			);end progn
		);end if
	);end while
	(setq display_list aa)
(close fast_dim_file)
(start_list "get_size")
(mapcar 'add_list display_list)
(end_list) 
);end FAST_READ_DIM_FILE
;-----------------------------------------------------------------------;
;Read selected size, size, from list box and read dimension list from
;data file. Set dimension variables.
(defun FAST_DIM_LIST (/ test)
(FAST_OPEN_DIM_FILE)
(progn
(while (/= size test)
(setq size_dims (read (read-line fast_dim_file))
      test (strcase (nth 0 size_dims))
);end setq
);end while
(close fast_dim_file)
);end progn
(FAST_SET_DIM)
);end FAST_DIM_LIST
;-----------------------------------------------------------------------;
;Find and open data file, fast_*.dim
(defun FAST_OPEN_DIM_FILE ()	
(if (= newtile "flat_head_e") (setq fast_dim_file (open (findfile "fast_e.dim") "r")))
(if (= newtile "hex_head_e") (setq fast_dim_file (open (findfile "fast_e.dim") "r")))
(if (= newtile "hex_nut_e") (setq fast_dim_file (open (findfile "fast_e.dim") "r")))
(if (= newtile "jam_nut_e") (setq fast_dim_file (open (findfile "fast_e.dim") "r")))
(if (= newtile "pan_head_e") (setq fast_dim_file (open (findfile "fast_e.dim") "r")))
(if (= newtile "round_head_e") (setq fast_dim_file (open (findfile "fast_e.dim") "r")))
(if (= newtile "socket_head_e") (setq fast_dim_file (open (findfile "fast_e.dim") "r")))
(if (= newtile "set_screw_e_cup") (setq fast_dim_file (open (findfile "fast_e.dim") "r")))
(if (= newtile "set_screw_e_dog") (setq fast_dim_file (open (findfile "fast_e.dim") "r")))  
(if (= newtile "stud_e") (setq fast_dim_file (open (findfile "fast_e.dim") "r")))
(if (= newtile "flat_head_m") (setq fast_dim_file (open (findfile "fast_m.dim") "r")))
(if (= newtile "hex_head_m") (setq fast_dim_file (open (findfile "fast_m.dim") "r")))
(if (= newtile "hex_nut_m") (setq fast_dim_file (open (findfile "fast_m.dim") "r")))
(if (= newtile "jam_nut_m") (setq fast_dim_file (open (findfile "fast_m.dim") "r")))
(if (= newtile "pan_head_m") (setq fast_dim_file (open (findfile "fast_m.dim") "r")))
(if (= newtile "round_head_m") (setq fast_dim_file (open (findfile "fast_m.dim") "r")))
(if (= newtile "socket_head_m") (setq fast_dim_file (open (findfile "fast_m.dim") "r")))
(if (= newtile "set_screw_m_cup") (setq fast_dim_file (open (findfile "fast_m.dim") "r")))
(if (= newtile "set_screw_m_dog") (setq fast_dim_file (open (findfile "fast_m.dim") "r")))  
(if (= newtile "stud_m") (setq fast_dim_file (open (findfile "fast_m.dim") "r")))
);end FAST_OPEN_DIM_FILE
;-----------------------------------------------------------------------;
(defun FAST_SET_DIM ()
(if (and (= newtile "flat_head_e") (/= size nil)) (progn (FAST_E_SETDIM)
                                                  (FAST_FLAT_HEAD_SETDIM)))
(if (and (= newtile "hex_head_e") (/= size nil)) (progn (FAST_E_SETDIM)
                                                 (FAST_HEX_HEAD_SETDIM)))
(if (and (= newtile "hex_nut_e") (/= size nil)) (progn (FAST_E_SETDIM)
                                                (FAST_HEX_NUT_SETDIM)))
(if (and (= newtile "jam_nut_e") (/= size nil)) (progn (FAST_E_SETDIM)
                                                (FAST_JAM_NUT_SETDIM)))
(if (and (= newtile "pan_head_e") (/= size nil)) (progn (FAST_E_SETDIM)
                                                 (FAST_PAN_HEAD_SETDIM)))
(if (and (= newtile "round_head_e") (/= size nil)) (progn (FAST_E_SETDIM)
                                                   (FAST_ROUND_HEAD_SETDIM)))
(if (and (= newtile "socket_head_e") (/= size nil)) (progn (FAST_E_SETDIM)
                                                    (FAST_SOCKET_HEAD_SETDIM)))
(if (and (= newtile "set_screw_e_cup") (/= size nil)) (progn (FAST_E_SETDIM)
                                                  (FAST_SET_SCREW_SETDIM)))
(if (and (= newtile "set_screw_e_dog") (/= size nil)) (progn (FAST_E_SETDIM)
                                                  (FAST_SET_SCREW_SETDIM)))
(if (and (= newtile "stud_e") (/= size nil)) (FAST_E_SETDIM))
(if (and (= newtile "flat_head_m") (/= size nil)) (progn (FAST_M_SETDIM)
                                                  (FAST_FLAT_HEAD_SETDIM)))
(if (and (= newtile "hex_head_m") (/= size nil)) (progn (FAST_M_SETDIM)
                                                 (FAST_HEX_HEAD_SETDIM)))
(if (and (= newtile "hex_nut_m") (/= size nil)) (progn (FAST_M_SETDIM)
                                                (FAST_HEX_NUT_SETDIM)))
(if (and (= newtile "jam_nut_m") (/= size nil)) (progn (FAST_M_SETDIM)
                                                (FAST_JAM_NUT_SETDIM)))
(if (and (= newtile "pan_head_m") (/= size nil)) (progn (FAST_M_SETDIM)
                                                 (FAST_PAN_HEAD_SETDIM)))
(if (and (= newtile "round_head_m") (/= size nil)) (progn (FAST_M_SETDIM)
                                                   (FAST_ROUND_HEAD_SETDIM)))
(if (and (= newtile "socket_head_m") (/= size nil)) (progn (FAST_M_SETDIM)
                                                    (FAST_SOCKET_HEAD_SETDIM)))
(if (and (= newtile "set_screw_m_cup") (/= size nil)) (progn (FAST_M_SETDIM)
                                                  (FAST_SET_SCREW_SETDIM)))
(if (and (= newtile "set_screw_m_dog") (/= size nil)) (progn (FAST_M_SETDIM)
                                                  (FAST_SET_SCREW_SETDIM)))
(if (and (= newtile "stud_m") (/= size nil)) (FAST_M_SETDIM))
);end FAST_SET_DIM
;-----------------------------------------------------------------------;
(defun FAST_E_SETDIM ();Set dimension variables from data list
     (setq df (nth 1 size_dims) ;dia. flat washer
           tf (nth 2 size_dims) ;thickness flat washer
           dl (nth 3 size_dims) ;dia. lock washer
           tl (nth 4 size_dims) ;thickness lock washer
           dhh (nth 5 size_dims) ;dia. hex head
           thh (nth 6 size_dims) ;thickness hex head
           idc (nth 7 size_dims) ;root dia UNC
           idf (nth 8 size_dims) ;root dia UNF
           od (nth 9 size_dims) ;major dia. thread
           dsh (nth 10 size_dims) ;dia. socket head
           tsh (nth 11 size_dims) ;thickness socket head
           rhx (nth 12 size_dims) ;hex key size socket head
           dfh (nth 14 size_dims) ;dia. flat head
           ho (nth 15 size_dims) ;dia screw hole
           tfh (nth 16 size_dims) ;thickness flat head
           slw (nth 17 size_dims) ;slot width flat, round, and pan head
           sdfh (nth 18 size_dims) ;slot depth flat head
           drh (nth 19 size_dims) ;dia. round head
           trh (nth 20 size_dims) ;thickness round head
           sdrh (nth 21 size_dims) ;slot depth round head
           dph (nth 22 size_dims) ;dia. pan head
           tph (nth 23 size_dims) ;thickness pan head
           radph (nth 24 size_dims) ;head radius pan head
           sdph (nth 25 size_dims) ;slot depth pan head
           dcp (nth 26 size_dims) ;dia. setscrew cup point
           ddp (nth 27 size_dims) ;dia. setscrew half dog point
           ldp (nth 28 size_dims) ;length setscrew half dog point
           ssrhx (nth 29 size_dims) ;hex key size, setscrew
	   dhn (nth 30 size_dims) ;dia. hex nut
           thn (nth 31 size_dims) ;thickness hex nut
           djn (nth 32 size_dims) ;dia. jam nut
           tjn (nth 33 size_dims) ;thickness jam nut
           check 1)
(if (= thread "thread_coarse") (setq id idc))
(if (= thread "thread_fine") (setq id idf))  
(if (= df 0.0) (set_tile "flat_dia" "") (set_tile "flat_dia" (rtos df 2 3)))
(if (= tf 0.0) (set_tile "flat_thk" "") (set_tile "flat_thk" (rtos tf 2 3)))
(if (= dl 0.0) (set_tile "lock_dia" "") (set_tile "lock_dia" (rtos dl 2 3)))
(if (= tl 0.0) (set_tile "lock_thk" "") (set_tile "lock_thk" (rtos tl 2 3)))
(if (= idc 0.0) (set_tile "root_dia_c" "") (set_tile "root_dia_c" (rtos idc 2 3)))
(if (= idf 0.0) (set_tile "root_dia_f" "") (set_tile "root_dia_f" (rtos idf 2 3)))
(if (= dhn 0.0) (set_tile "nut_dia" "") (set_tile "nut_dia" (rtos dhn 2 3)))
(if (= thn 0.0) (set_tile "nut_thk" "") (set_tile "nut_thk" (rtos thn 2 3)))
(if (= djn 0.0) (set_tile "jam_nut_dia" "") (set_tile "jam_nut_dia" (rtos djn 2 3)))
(if (= tjn 0.0) (set_tile "jam_nut_thk" "") (set_tile "jam_nut_thk" (rtos tjn 2 3)))
;(fast_washers_setdim)
);End FAST_E_SETDIM
;--------------------------------------------------------------------;
(defun FAST_M_SETDIM ();Set Metric dimension variables from data list
(setq df (nth 1 size_dims) ;dia. flat washer metric
      tf (nth 2 size_dims) ;thickness flat washer metric
      dl (nth 3 size_dims) ;dia. lock washer metric
      tl (nth 4 size_dims) ;thickness lock washer metric
      dhh (nth 5 size_dims) ;dia. hex head metric
      thh (nth 6 size_dims) ;thickness hex head metric
      id (nth 7 size_dims) ;root dia coarse thread metric
      od (nth 8 size_dims) ;major dia. thread metric
      dsh (nth 9 size_dims) ;dia. socket head metric
      tsh (nth 10 size_dims) ;thickness socket head metric
      rhx (nth 11 size_dims) ;hex key size socket head metric
      dfh (nth 12 size_dims) ;dia. flat head metric
      ho (nth 13 size_dims) ;dia. screw hole
      tfh (nth 15 size_dims) ;thickness flat head metric
      slw (nth 16 size_dims) ;slot width metric, same for pan, round, flat.
      sdfh (nth 17 size_dims) ;slot depth flat head metric
      drh (nth 18 size_dims) ;dia. round head metric
      trh (nth 19 size_dims) ;thickness round head metric
      sdrh (nth 20 size_dims) ;slot depth round head metric
      dph (nth 21 size_dims) ;dia. pan head metric
      tph (nth 22 size_dims) ;thickness pan head metric
      radph (nth 23 size_dims) ;radius pan head metric
      sdph (nth 24 size_dims) ;slot depth pan head metric
      dcp (nth 25 size_dims) ;dia. setscrew cup point
      ddp (nth 26 size_dims) ;dia. setscrew half dog point
      ldp (nth 27 size_dims) ;length setscrew half dog point
      ssrhx (nth 28 size_dims) ;hex key size, setscrew
      dhn (nth 29 size_dims) ;dia. hex nut
      thn (nth 30 size_dims) ;thickness hex nut
      djn (nth 31 size_dims) ;dia. jam nut
      tjn (nth 32 size_dims) ;thickness jam nut
      check 1)
(if (= scale "1") (FAST_SCALE_TO_E))	
(if (= df 0.0) (set_tile "flat_dia" "") (set_tile "flat_dia" (rtos df 2 3)))
(if (= tf 0.0) (set_tile "flat_thk" "") (set_tile "flat_thk" (rtos tf 2 3)))
(if (= dl 0.0) (set_tile "lock_dia" "") (set_tile "lock_dia" (rtos dl 2 3)))
(if (= tl 0.0) (set_tile "lock_thk" "") (set_tile "lock_thk" (rtos tl 2 3)))
(if (= id 0.0) (set_tile "root_dia_c" "") (set_tile "root_dia_c" (rtos id 2 3)))
(if (= dhn 0.0) (set_tile "nut_dia" "") (set_tile "nut_dia" (rtos dhn 2 3)))
(if (= thn 0.0) (set_tile "nut_thk" "") (set_tile "nut_thk" (rtos thn 2 3)))
(if (= djn 0.0) (set_tile "jam_nut_dia" "") (set_tile "jam_nut_dia" (rtos djn 2 3)))
(if (= tjn 0.0) (set_tile "jam_nut_thk" "") (set_tile "jam_nut_thk" (rtos tjn 2 3)))
;(fast_washers_setdim)
);End FAST_M_SETDIM
;---------------------------------------------------------;
(defun FAST_SCALE_TO_E ()
(setq df (/ df 25.4)
      tf (/ tf 25.4)
      dl (/ dl 25.4)
      tl (/ tl 25.4)
      dhh (/ dhh 25.4)
      thh (/ thh 25.4)
      id (/ id 25.4)
      od (/ od 25.4)
      dsh (/ dsh 25.4)
      tsh (/ tsh 25.4)
      rhx (/ rhx 25.4)      
      dfh (/ dfh 25.4)
      ho (/ ho 25.4)
      tfh (/ tfh 25.4)
      slw (/ slw 25.4)
      sdfh (/ sdfh 25.4)
      drh (/ drh 25.4)
      trh (/ trh 25.4)
      sdrh (/ sdrh 25.4)
      dph (/ dph 25.4)
      tph (/ tph 25.4)
      radph (/ radph 25.4)
      sdph (/ sdph 25.4)
      dcp (/ dcp 25.4)
      ddp (/ ddp 25.4)
      ldp (/ ldp 25.4)
      ssrhx (/ ssrhx 25.4)
      dhn (/ dhn 25.4)
      thn (/ thn 25.4)
      djn (/ djn 25.4)
      tjn (/ tjn 25.4)
);end setq
);End FAST_SCALE_TO_E
;---------------------------------------------------------;
(defun FAST_WASHERS_SETDIM ();Set washer dimensions and offsets
(setq ang1 (dtr 90) ang2 (dtr 45) ang3 (dtr 135))
(if (= w "washer_lock") (setq xl (polar ins (dtr 180) tl) 
                              insl ins
                              insn xl
                              inss insn))                  
(if (= w "washer_flat") (setq xf (polar ins (dtr 180) tf)
                              insf ins
                              insn xf
                              inss insn))                  
(if (= w "washer_both") (setq xl (polar ins (dtr 180) tl) 
                              xf (polar ins (dtr 180) tf)
                              xb (polar ins (dtr 180) (+ tf tl)) 
                              insf ins
                              insl xf
                              insn xb
                              inss insn))                  
(if (= w "washer_none") (setq insn ins
                              inss insn))
);End FAST_WASHERS_SETDIM
;--------------------------------------------------------------------;
(defun FAST_FLAT_HEAD_SETDIM ()
(if (= dfh 0.0) (set_tile "head_dia" "") (set_tile "head_dia" (rtos dfh 2 3)))
(if (= tfh 0.0) (set_tile "head_thk" "") (set_tile "head_thk" (rtos tfh 2 3)))
(if (= dfh 0.0) (setq check 0))
);End FAST_FLAT_HEAD_SETDIM
;-----------------------------------------------------------------------;
(defun FAST_HEX_HEAD_SETDIM ()
(if (= dhh 0.0) (set_tile "head_dia" "") (set_tile "head_dia" (rtos dhh 2 3)))
(if (= thh 0.0) (set_tile "head_thk" "") (set_tile "head_thk" (rtos thh 2 3)))
(if (= dhh 0.0) (setq check 0))
);End FAST_HEX_HEAD_SETDIM
;-----------------------------------------------------------------------;
(defun FAST_HEX_NUT_SETDIM ()
(if (= dhn 0.0) (set_tile "nut_dia" "") (set_tile "nut_dia" (rtos dhn 2 3)))
(if (= thn 0.0) (set_tile "nut_thk" "") (set_tile "nut_thk" (rtos thn 2 3)))
(if (= dhn 0.0) (setq check 0))
);End FAST_HEX_NUT_SETDIM
;-----------------------------------------------------------------------;
(defun FAST_JAM_NUT_SETDIM ()
(if (= djn 0.0) (set_tile "jam_nut_dia" "") (set_tile "jam_nut_dia" (rtos djn 2 3)))
(if (= tjn 0.0) (set_tile "jam_nut_thk" "") (set_tile "jam_nut_thk" (rtos tjn 2 3)))
(if (= djn 0.0) (setq check 0))
);End FAST_JAM_NUT_SETDIM
;-----------------------------------------------------------------------;
(defun FAST_PAN_HEAD_SETDIM ()
(if (= dph 0.0) (set_tile "head_dia" "") (set_tile "head_dia" (rtos dph 2 3)))
(if (= tph 0.0) (set_tile "head_thk" "") (set_tile "head_thk" (rtos tph 2 3)))
(if (= dph 0.0) (setq check 0))
);End FAST_PAN_HEAD_SETDIM
;-----------------------------------------------------------------------;
(defun FAST_ROUND_HEAD_SETDIM ()
(if (= drh 0.0) (set_tile "head_dia" "") (set_tile "head_dia" (rtos drh 2 3)))
(if (= trh 0.0) (set_tile "head_thk" "") (set_tile "head_thk" (rtos trh 2 3)))
(if (= drh 0.0) (setq check 0))
);End FAST_ROUND_HEAD_SETDIM
;-----------------------------------------------------------------------;
(defun FAST_SOCKET_HEAD_SETDIM ()
(if (= dsh 0.0) (set_tile "head_dia" "") (set_tile "head_dia" (rtos dsh 2 3)))
(if (= tsh 0.0) (set_tile "head_thk" "") (set_tile "head_thk" (rtos tsh 2 3)))
(if (= rhx 0.0) (set_tile "hex_key" "") (set_tile "hex_key" (rtos rhx 2 3)))
(if (= dsh 0.0) (setq check 0))
);End FAST_SOCKET_HEAD_SETDIM
;-----------------------------------------------------------------------;
(defun FAST_SET_SCREW_SETDIM ()
(if (= ssrhx 0.0) (set_tile "hex_key" "") (set_tile "hex_key" (rtos ssrhx 2 3)))
(if (= ssrhx 0.0) (setq check 0))
);End FAST_SET_SCREW_SETDIM
;-----------------------------------------------------------------------;
(defun DRAW_FAST ()
(if (and (/= newtile nil) (= which_view "2d_top")) (DRAW_2D_TOP))
(if (and (/= newtile nil) (= which_view "2d_side")) (DRAW_2D_SIDE))
(if (and (/= newtile nil) (= which_view "3d_solid")) (DRAW_3D_SOLID))
); end DRAW_FAST
;-----------------------------------------------------------------------;
(defun DRAW_2D_TOP ()
(initget 137 "R")
(setq ins (getpoint "\n<Select 2D TOP insert point>/Reference: "))
(if (= ins "R") (progn
(setq bpt (getpoint "\nEnter BASE point: "))
(setq rpt (getpoint "\nEnter x,y REFERENCE from BASE point: "))
(setq ins (list (+ (car bpt) (car rpt)) (+ (cadr bpt) (cadr rpt))))
);end progn
);end if
(setvar "OSMODE" 16384)
(if (= newtile "flat_head_e") (FAST_FLAT_HEAD_TOP))
(if (= newtile "hex_head_e") (FAST_HEX_HEAD_TOP))
(if (= newtile "hex_nut_e") (FAST_HEX_NUT_TOP))
(if (= newtile "jam_nut_e") (FAST_HEX_NUT_TOP))
(if (= newtile "pan_head_e") (FAST_PAN_HEAD_TOP))
(if (= newtile "round_head_e") (FAST_ROUND_HEAD_TOP))
(if (= newtile "socket_head_e") (FAST_SOCKET_HEAD_TOP))
(if (= newtile "set_screw_e_cup") (FAST_SETSCREW_TOP))
(if (= newtile "set_screw_e_dog") (FAST_SETSCREW_TOP))
(if (= newtile "stud_e") (FAST_STUD_TOP))
(if (= newtile "flat_head_m") (FAST_FLAT_HEAD_TOP))
(if (= newtile "hex_head_m") (FAST_HEX_HEAD_TOP))
(if (= newtile "hex_nut_m") (FAST_HEX_NUT_TOP))
(if (= newtile "jam_nut_m") (FAST_HEX_NUT_TOP))
(if (= newtile "pan_head_m") (FAST_PAN_HEAD_TOP))
(if (= newtile "round_head_m") (FAST_ROUND_HEAD_TOP))
(if (= newtile "socket_head_m") (FAST_SOCKET_HEAD_TOP))
(if (= newtile "set_screw_m_cup") (FAST_SETSCREW_TOP))
(if (= newtile "set_screw_m_dog") (FAST_SETSCREW_TOP))
(if (= newtile "stud_m") (FAST_STUD_TOP))
);end DRAW_2D_TOP
;-----------------------------------------------------------------------;
(defun DRAW_2D_SIDE ()
(initget 137 "R")
(setq ins (getpoint "\n<Select 2D SIDE insert point>/Reference: "))
(if (= ins "R") (progn
(setq bpt (getpoint "\nEnter BASE point: "))
(setq rpt (getpoint "\nEnter x,y REFERENCE from BASE point: "))
(setq ins (list (+ (car bpt) (car rpt)) (+ (cadr bpt) (cadr rpt))))
);end progn
);end if
(setvar "OSMODE" 16384)
(FAST_WASHERS_SETDIM)  
(if (= newtile "flat_head_e") (FAST_FLAT_HEAD_SIDE))
(if (= newtile "hex_head_e") (FAST_HEX_HEAD_SIDE))
(if (= newtile "hex_nut_e") (FAST_HEX_NUT_SIDE))
(if (= newtile "jam_nut_e") (FAST_JAM_NUT_SIDE))
(if (= newtile "pan_head_e") (FAST_PAN_HEAD_SIDE))
(if (= newtile "round_head_e") (FAST_ROUND_HEAD_SIDE))
(if (= newtile "socket_head_e") (FAST_SOCKET_HEAD_SIDE))
(if (= newtile "set_screw_e_cup") (FAST_SETSCREW_CUP_SIDE))
(if (= newtile "set_screw_e_dog") (FAST_SETSCREW_DOG_SIDE))
(if (= newtile "stud_e") (FAST_STUD_SIDE))
(if (= newtile "flat_head_m") (FAST_FLAT_HEAD_SIDE))
(if (= newtile "hex_head_m") (FAST_HEX_HEAD_SIDE))
(if (= newtile "hex_nut_m") (FAST_HEX_NUT_SIDE))
(if (= newtile "jam_nut_m") (FAST_JAM_NUT_SIDE))
(if (= newtile "pan_head_m") (FAST_PAN_HEAD_SIDE))
(if (= newtile "round_head_m") (FAST_ROUND_HEAD_SIDE))
(if (= newtile "socket_head_m") (FAST_SOCKET_HEAD_SIDE))
(if (= newtile "set_screw_m_cup") (FAST_SETSCREW_CUP_SIDE))
(if (= newtile "set_screw_m_dog") (FAST_SETSCREW_DOG_SIDE))
(if (= newtile "stud_m") (FAST_STUD_SIDE))
);end DRAW_2D_SIDE
;-----------------------------------------------------------------------;
(defun DRAW_3D_SOLID ()
(initget 137 "R")
(setq ins (getpoint "\n<Select 3D SOLID insert point>/Reference: "))
(if (= ins "R") (progn
(setq bpt (getpoint "\nEnter BASE point: "))
(setq rpt (getpoint "\nEnter x,y REFERENCE from BASE point: "))
(setq ins (list (+ (car bpt) (car rpt)) (+ (cadr bpt) (cadr rpt))))
);end progn
);end if
(setvar "OSMODE" 16384)
(FAST_WASHERS_SETDIM)
(if (= newtile "flat_head_e") (FAST_FLAT_HEAD_3D_SOLID))
(if (= newtile "hex_head_e") (FAST_HEX_HEAD_3D_SOLID))
(if (= newtile "hex_nut_e") (FAST_HEX_NUT_3D_SOLID))
(if (= newtile "jam_nut_e") (FAST_JAM_NUT_3D_SOLID))
(if (= newtile "pan_head_e") (FAST_PAN_HEAD_3D_SOLID))
(if (= newtile "round_head_e") (FAST_ROUND_HEAD_3D_SOLID))
(if (= newtile "socket_head_e") (FAST_SOCKET_HEAD_3D_SOLID))
(if (= newtile "set_screw_e_cup") (FAST_SETSCREW_CUP_3D_SOLID))
(if (= newtile "set_screw_e_dog") (FAST_SETSCREW_DOG_3D_SOLID))
(if (= newtile "stud_e") (FAST_STUD_3D_SOLID))
(if (= newtile "flat_head_m") (FAST_FLAT_HEAD_3D_SOLID))
(if (= newtile "hex_head_m") (FAST_HEX_HEAD_3D_SOLID))
(if (= newtile "hex_nut_m") (FAST_HEX_NUT_3D_SOLID))
(if (= newtile "jam_nut_m") (FAST_JAM_NUT_3D_SOLID))
(if (= newtile "pan_head_m") (FAST_PAN_HEAD_3D_SOLID))
(if (= newtile "round_head_m") (FAST_ROUND_HEAD_3D_SOLID))
(if (= newtile "socket_head_m") (FAST_SOCKET_HEAD_3D_SOLID))
(if (= newtile "set_screw_m_cup") (FAST_SETSCREW_CUP_3D_SOLID))
(if (= newtile "set_screw_m_dog") (FAST_SETSCREW_DOG_3D_SOLID))
(if (= newtile "stud_m") (FAST_STUD_3D_SOLID))
);end DRAW_3D_SOLID
;-----------------------------------------------------------------------;
(defun FAST_FLAT_SIDE (/ dpf pt1 pt2 pt3 pt4)
(setq dpf (* df 0.5)
      pt1 (polar insf (dtr 90) dpf)
      pt2 (polar pt1 (dtr 180) tf)
      pt3 (polar insf (dtr 270) dpf)
      pt4 (polar pt3 (dtr 180) tf))
(command "pline" insf pt1 pt2 pt4 pt3 insf ""))
;End FAST_FLAT_SIDE
;--------------------------------------------------------------------;
(defun FAST_FLAT_3D_SOLID (/ dpf idf pt1 pt2 pt3 pt4 pt5 ent1) 
(setq dpf (* df 0.5)
      idf (* od 0.5)
      pt1 (polar insf (dtr 90) idf)
      pt2 (polar insf (dtr 90) dpf)
      pt3 (polar pt2 (dtr 180) tf)
      pt4 (polar pt1 (dtr 180) tf)
      pt5 (polar insf (dtr 180) tf))
(command "pline" pt1 pt2 pt3 pt4 "c")
(setq ent1 (entlast))
(command "revolve" ent1 "" pt5 insf "360" "")
(setq ent_list (ssadd (entlast) ent_list))
);end FAST_FLAT_3D_SOLID
;--------------------------------------------------------------------;
(defun FAST_LOCK_SIDE (/ dpl pt1 pt2 pt3 pt4 pt5 pt6 pt7)
(setq dpl (* dl 0.5)
      pt1 (polar insl (dtr 90) dpl)
      pt2 (polar pt1 (dtr 180) tl)
      pt3 (polar insl (dtr 180) tl)
      pt4 (polar pt3 (dtr 90) tl)
      pt5 (polar insl (dtr 270) tl)
      pt6 (polar insl (dtr 270) dpl)
      pt7 (polar pt6 (dtr 180) tl))
(command "pline" insl pt1 pt2 pt7 pt6 insl pt4 pt3 pt5 ""))
;End FAST_LOCK_SIDE
;--------------------------------------------------------------------;
(defun FAST_LOCK_3D_SOLID (/ dpl idl pt1 pt2 pt3 pt4 pt5 ent1)
(setq dpl (* dl 0.5)
      idl (* od 0.5)
      pt1 (polar insl (dtr 90) idl)
      pt2 (polar insl (dtr 90) dpl)
      pt3 (polar pt2 (dtr 180) tl)
      pt4 (polar pt1 (dtr 180) tl)
      pt5 (polar insl (dtr 180) tl))
(command "pline" pt1 pt2 pt3 pt4 "c")
(setq ent1 (entlast))
(command "revolve" ent1 "" pt5 insl "350" "")
(setq ent_list (ssadd (entlast) ent_list))
)end FAST_LOCK_3D_SOLID
;--------------------------------------------------------------------;
(defun FAST_FLAT_HEAD_TOP (/ rad_hd dia_hd a b c d e pt1 pt2 pt3 pt4 pt5
pt6 ent1 ent2)
  (setq rad_hd (* dfh 0.5)
        dia_hd dfh
        b (* slw 0.5)
        a (sqrt (- (expt rad_hd 2) (expt b 2)))
        c (* rad_hd 0.33)
        d (* rad_hd 0.5)
        e (* rad_hd 1.5))
  (setq pt1 (polar ins (dtr 315) b)
        pt2 (polar ins (dtr 135) b)
        pt3 (polar pt2 (dtr 45) a)
        pt4 (polar pt2 (dtr 225) a)
        pt5 (polar pt1 (dtr 225) a)
        pt6 (polar pt1 (dtr 45) a))
  (command "circle" ins "d" dia_hd)
  (command "line" pt3 pt4 "")
  (setq ent1 (entlast))
  (command "line" pt5 pt6 "")
  (setq ent2 (entlast))
  (command "rotate" ent1 ent2 "" ins)
);End FAST_FLAT_HEAD_TOP
;--------------------------------------------------------------------;
(defun FAST_FLAT_HEAD_SIDE (/ pt1 pt3 pt4 pt5 pt6
pt7 pt8 pt9 pt10 dfh1)
  (setq dfh (* dfh 0.5)
        slw (* slw 0.5)
        dfh1 (* od 0.5))
  (setq pt1 (polar ins (dtr 0) tfh)
        inss ins
        pt2 (polar pt1 (dtr 90) dfh1)
        pt3 (polar pt1 (dtr 270) dfh1)
        pt4 (polar ins (dtr 90) dfh)
        pt5 (polar ins (dtr 270) dfh)
        pt6 (polar ins (dtr 0) sdfh)
        pt7 (polar pt6 (dtr 90) slw)
        pt8 (polar pt6 (dtr 270) slw)
        pt9 (polar ins (dtr 90) slw)
        pt10 (polar ins (dtr 270) slw)
        ins pt1
  )
  (command "pline" pt1 pt2 pt4 pt9 pt7 pt8 pt10 pt5 pt3 pt1 "")
  (setq ent_list (ssget "L"))
  (if (= shank "1") (FAST_SHANK_SIDE))
  (command "rotate" ent_list "" ins)
);End FAST_FLAT_HEAD_SIDE
;--------------------------------------------------------------------;
(defun FAST_FLAT_HEAD_3D_SOLID (/ pt1 pt2 pt3 ent1 ent2 pt4 pt5 pt6
pt7 ent3 ent4 pt8 pt9 pt10 pt11 pt12 pt13 ent8)
(progn
(setq dfh (* dfh 0.5)
      slw (* slw 0.5)
      dfh1 (* od 0.5))
(setq pt1 (polar ins (dtr 0) tfh)
      pt2 (polar pt1 (dtr 90) dfh1)
      pt3 (polar ins (dtr 90) dfh)
);end setq
(command "pline" pt1 pt2 pt3 ins "c")
(setq ent1 (entlast))
(command "revolve" ent1 "" ins pt1 "360")
(setq ent2 (entlast))
(command "ucs" "o" ins)
(command "ucs" "y" "270")
(setq ins '(0.0 0.0 0.0))
(setq pt4 (polar ins (dtr 90) dfh)
      pt5 (polar pt4 (dtr 0) slw)
      pt6 (polar ins (dtr 270) dfh)
      pt7 (polar pt6 (dtr 180) slw))
(command "rectang" pt7 pt5 "")
(setq ent3 (entlast))
(command "extrude" ent3 "" (- 0.0 sdfh) "")
(setq ent4 (entlast))
(command "subtract" ent2 "" ent4 "" "y")
(setq ent_list (ssget "L"))
(command "ucs" "w")
);end progn

(if (= shank "1")
(progn
(setq od (* od 0.5)
      id (* id 0.5)
      pt8 (polar inss (dtr 0) lg)
      pt9 (polar pt8 (dtr 90) id)
      pt10 (polar pt8 (dtr 90) od)
      pt11 (polar pt10 (dtr 180) (- od id))
      pt12 (polar pt10 (dtr 180) (- lg tfh))
      pt13 (polar pt12 (dtr 270) od)
);end setq
(command "pline" pt8 pt9 pt11 pt12 pt13 "c")
(setq ent8 (entlast))
(command "revolve" ent8 "" pt13 pt8 "360" "")
(setq ent_list (ssadd (entlast) ent_list))
);end progn
);end if
(command "rotate" ent_list "" inss)
);end FAST_FLAT_HEAD_3D_SOLID
;--------------------------------------------------------------------;
(defun FAST_HEX_HEAD_TOP (/ rh c d pt1 pt2 pt3 pt4 ln1 ln2 ent1 ent2
ent3 ent4)
(setq rh (* dhh 0.5))
(command "circle" ins "d" dhh)
(command "polygon" 6 ins "c" (polar ins (dtr 0) rh))
(setq ent1 (entlast))
(if (or (= w "washer_lock") (= w "washer_both")) (command "circle" ins "d" dl))
(if (or (= w "washer_flat") (= w "washer_both")) (command "circle" ins "d" df))
(if (= which_view "2d_top")
(command "rotate" ent1 "" ins))
);End FAST_HEX_HEAD_TOP
;--------------------------------------------------------------------;
(defun FAST_HEX_HEAD_SIDE (/ e k g h pt1 pt2 pt3
pt4 pt5 pt6 pt7 pt8 pt9 pt10 pt11 ent1 ent2 ent3)
(setq e (* (* dhh 1.1547) 0.5)  
      k (* e 0.5)
      g (- thh (* e 0.125))
      h (* e 0.75)
      pt1 (polar insn (dtr 90) e)
      pt2 (polar insn (dtr 90) k)
      pt3 (polar insn (dtr 180) thh)
      pt4 (polar pt2 (dtr 180) g)
      pt5 (polar pt3 (dtr 90) h)
      pt6 (polar pt1 (dtr 180) g)
      pt7 (polar insn (dtr 270) e)
      pt8 (polar insn (dtr 270) k)
      pt9 (polar pt8 (dtr 180) g)
      pt10 (polar pt3 (dtr 270) h)
      pt11 (polar pt7 (dtr 180) g))
(command "pline" pt10 pt5 pt3 "a" "d" pt5 pt4 "s" pt5 pt6 "l" pt1 pt2 
 pt4 pt2 pt8 pt9 pt8 pt7 pt11 "a" "s" pt10 pt9 "s" pt3 pt4 "")
(setq ent_list (ssget "L"))
(if (or (= w "washer_lock") (= w "washer_both")) (FAST_LOCK_SIDE))
(setq ent_list (ssadd (entlast) ent_list))
(if (or (= w "washer_flat") (= w "washer_both")) (FAST_FLAT_SIDE))
(setq ent_list (ssadd (entlast) ent_list))
(if (= shank "1") (FAST_SHANK_SIDE))
(command "rotate" ent_list "" ins)  
);End FAST_HEX_HEAD_SIDE
;--------------------------------------------------------------------;
(defun FAST_HEX_HEAD_3D_SOLID (/ rh e g h pt1 pt2 pt3p pt4 pt5 ent1
ent2 ent3 ent4)
(progn
(setq rh (* dhh 0.5)
      e (* (* dhh 1.154700538) 0.5)  
      g (- thh (* e 0.125))
      h (* e 0.75)
      pt1 (polar insn (dtr 90) e)
      pt2 (polar pt1 (dtr 180) g)
      pt3 (polar insn (dtr 180) thh)
      pt4 (polar pt3 (dtr 90) h)
      pt5 (polar pt3 (dtr 90) e)
);end setq
(command "pline" pt3 pt4 "a" "d" pt5 pt2 "line" pt1 insn "c")
(setq ent1 (entlast))
(command "revolve" ent1 "" pt3 insn "360")
(setq ent2 (entlast))
(command "ucs" "o" insn)
(command "ucs" "y" "270")
(setq insn '(0.0 0.0 0.0))
(command "polygon" 6 insn "c" (polar insn (dtr 0) rh))
(setq ent3 (entlast))
(command "extrude" ent3 "" thh "")
(setq ent4 (entlast))
(command "intersect" ent2 ent4 "")
(setq ent_list (ssget "L"))
(command "ucs" "w")
);end progn
(if (or (= w "washer_lock") (= w "washer_both")) (FAST_LOCK_3D_SOLID))
(if (or (= w "washer_flat") (= w "washer_both")) (FAST_FLAT_3D_SOLID))
(if (= shank "1") (FAST_SHANK_3D_SOLID))
(command "rotate" ent_list "" ins)    
);end FAST_HEX_HEAD_3D_SOLID
;--------------------------------------------------------------------;
(defun FAST_SHANK_SIDE (/ scr_rad ang1 pt1 pt2 pt3 pt4 
pt5 pt6 pt7 pt8 pt9 pt10 pt11 pt12 pt13 pt14 pt15 pt16 pt17 
ln1 ln2 ln3)

(if (= scale "1")
(setq lg (/ lg 25.4)
      td (/ td 25.4)))          

(setq scr_rad (* od 0.5)
      id (* id 0.5))
(setq pt1 (polar inss (dtr 0) lg))
(if (>= td (distance ins pt1)) (setq td (distance ins pt1)))
(setq pt2 (polar pt1 (dtr 90) scr_rad)
      pt3 (polar pt1 (dtr 90) id)
      pt4 (polar pt2 (dtr 180) (- scr_rad id))
      pt5 (polar pt1 (dtr 180) (- scr_rad id))
      pt6 (polar pt1 (dtr 180) td)
      pt7 (polar pt6 (dtr 90) scr_rad)
      pt8 (polar pt6 (dtr 90) id)
      pt9 (polar ins (dtr 90) scr_rad)
      pt12 (polar pt1 (dtr 270) scr_rad)
      pt13 (polar pt1 (dtr 270) id)
      pt14 (polar pt12 (dtr 180) (- scr_rad id))
      pt15 (polar pt6 (dtr 270) scr_rad)
      pt16 (polar pt6 (dtr 270) id)
      pt17 (polar ins (dtr 270) scr_rad))
(command "pline" pt9 pt7 pt15 pt7 pt4 pt14 pt4 pt3 pt13
          pt14 pt17 "")
(setq ent_list (ssadd (entlast) ent_list))
(command "pline" pt8 pt3 pt13 pt16 "")
(setq ent_list (ssadd (entlast) ent_list))
(command "chprop" "L" "" "lt" "hidden2" "")
);End FAST_SHANK_SIDE  
;--------------------------------------------------------------------;
(defun FAST_SHANK_3D_SOLID (/ pt1 pt2 pt3 pt4 pt5 ent1)
(if (= scale "1")
(setq lg (/ lg 25.4)))
(setq od (* od 0.5)
      id (* id 0.5)
      pt1 (polar inss (dtr 0) lg)
      pt2 (polar pt1 (dtr 90) id)
      pt3 (polar pt1 (dtr 90) od)
      pt4 (polar pt3 (dtr 180) (- od id))
      pt5 (polar inss (dtr 90) od)
);end setq
(command "pline" pt1 pt2 pt4 pt5 inss "c")
(setq ent1 (entlast))
(command "revolve" ent1 "" pt1 inss "360" "")
(setq ent_list (ssadd (entlast) ent_list))
);end FAST_SHANK_3D_SOLID
;--------------------------------------------------------------------;
(defun FAST_HEX_NUT_TOP (/ chm rhn ent1)
  (setq chm (* od 0.8))  
  (command "circle" ins "d" od)
  (command "circle" ins "d" chm)
  (setq rhn (* dhn 0.5))
  (command "circle" ins "d" dhn)
  (command "polygon" 6 ins "c" (polar ins (dtr 0) rhn))
  (setq ent1 (entlast)) 
  (if (or (= w "washer_lock") (= w "washer_both")) (command "circle" ins "d" dl))
  (if (or (= w "washer_flat") (= w "washer_both")) (command "circle" ins "d" df))
  (command "rotate" ent1 "" ins)
);End FAST_HEX_NUT_TOP
;-------------------------------------------------------------------;
(defun FAST_HEX_NUT_SIDE (/ e k g h pt1 pt2 pt3 pt4 pt5 pt6 pt7 pt8
pt9 pt10 pt11)
(setq e (* (* dhn 1.1547) 0.5)  
      k (* e 0.5)
      g (- thn (* dhn 0.0625))
      h (* e 0.75)
      pt1 (polar insn (dtr 90) e)
      pt2 (polar insn (dtr 90) k)
      pt3 (polar insn (dtr 180) thn)
      pt4 (polar pt2 (dtr 180) g)
      pt5 (polar pt3 (dtr 90) h)
      pt6 (polar pt1 (dtr 180) g)
      pt7 (polar insn (dtr 270) e)
      pt8 (polar insn (dtr 270) k)
      pt9 (polar pt8 (dtr 180) g)
      pt10 (polar pt3 (dtr 270) h)
      pt11 (polar pt7 (dtr 180) g))
(command "pline" pt10 pt5 pt3 "a" "d" pt5 pt4 "s" pt5 pt6 "l" pt1 pt2 
 pt4 pt2 pt8 pt9 pt8 pt7 pt11 "a" "s" pt10 pt9 "s" pt3 pt4 "")
(setq ent_list (ssget "L"))
(if (or (= w "washer_lock") (= w "washer_both")) (FAST_LOCK_SIDE))
(setq ent_list (ssadd (entlast) ent_list))
(if (or (= w "washer_flat") (= w "washer_both")) (FAST_FLAT_SIDE))
(setq ent_list (ssadd (entlast) ent_list))
(command "rotate" ent_list "" ins)    
);End FAST_HEX_NUT_SIDE
;--------------------------------------------------------------------;
(defun FAST_HEX_NUT_3D_SOLID (/ rh e g h pt1 pt2 pt3 pt4 pt5 pt6 pt7
ent1 ent2 ent3 ent4)
(progn
(setq od (* od 0.5)
      rh (* dhn 0.5)
      e (* (* dhn 1.154700538) 0.5)  
      g (- thn (* e 0.125))
      h (* e 0.75)
      pt1 (polar insn (dtr 90) e)
      pt2 (polar pt1 (dtr 180) g)
      pt3 (polar insn (dtr 180) thn)
      pt4 (polar pt3 (dtr 90) h)
      pt5 (polar pt3 (dtr 90) e)
      pt6 (polar insn (dtr 90) od)
      pt7 (polar pt6 (dtr 180) thn)
);end setq
(command "pline" pt7 pt4 "a" "d" pt5 pt2 "line" pt1 pt6 "c")
(setq ent1 (entlast))
(command "revolve" ent1 "" pt3 insn "360")
(setq ent2 (entlast))
(command "ucs" "o" insn)
(command "ucs" "y" "270")
(setq insn '(0.0 0.0 0.0))
(command "polygon" 6 insn "c" (polar insn (dtr 0) rh))
(setq ent3 (entlast))
(command "extrude" ent3 "" thn "")
(setq ent4 (entlast))
(command "intersect" ent2 ent4 "")
(setq ent_list (ssget "L"))
(command "ucs" "w")
);end progn
(if (or (= w "washer_lock") (= w "washer_both")) (FAST_LOCK_3D_SOLID))
(if (or (= w "washer_flat") (= w "washer_both")) (FAST_FLAT_3D_SOLID))
(command "rotate" ent_list "" ins)
);end FAST_HEX_NUT_3D_SOLID
;--------------------------------------------------------------------;
(defun FAST_JAM_NUT_SIDE (/ dph e k g h j pt1 pt2 pt3 pt4 pt5 pt6 pt7 pt8
pt9 pt10 pt11 pt12 pt13 ln1)
(setq e (* (* djn 1.1547) 0.5)
      g2 (- tjn (* djn 0.0625))
      g1 (* djn 0.0625)
      h (* e 0.75)
      j (* tjn 0.25)         
      k (* e 0.5)
      pt1 (polar insn (dtr 180) tjn)
      pt2 (polar pt1 (dtr 90) h)
      pt3 (polar pt1 (dtr 270) h)
      pt3a (polar insn (dtr 180) g1)
      pt3b (polar insn (dtr 180) g2)
      pt4 (polar pt3b (dtr 90) k)
      pt5 (polar pt3b (dtr 90) e)
      pt6 (polar pt3a (dtr 90) e)
      pt7 (polar insn (dtr 90) h)
      pt8 (polar pt3a (dtr 90) k)
      pt9 (polar pt3a (dtr 270) k)
      pt10 (polar insn (dtr 270) h)
      pt11 (polar pt3a (dtr 270) e)
      pt12 (polar pt3b (dtr 270) e)
      pt13 (polar pt3b (dtr 270) k))
(command "pline" pt7 pt10 insn pt1 pt2 pt3 pt1 "a" "d" pt2 pt4
"l" pt4 pt8 pt4 "a" "s" pt2 pt5 "l" pt5 pt6 "a" "s" pt7 pt8 "s"
insn pt9 "l" pt9 pt13 pt9 "a" "s" pt10 pt11 "l" pt11 pt12 "a" 
"s" pt3 pt13 "s" pt1 pt4 "")
(setq ent_list (ssget "L"))
(if (or (= w "washer_lock") (= w "washer_both")) (FAST_LOCK_SIDE))
(setq ent_list (ssadd (entlast) ent_list))
(if (or (= w "washer_flat") (= w "washer_both")) (FAST_FLAT_SIDE))
(setq ent_list (ssadd (entlast) ent_list))
(command "rotate" ent_list "" ins)  
);End FAST_JAM_NUT_SIDE
;-------------------------------------------------------------------;
(defun FAST_JAM_NUT_3D_SOLID (/ rh e g h pt1 pt2 pt3p pt4 pt5 ent1
ent2 ent3 ent4 ent5 ent6 ent7 dpl idl pt6 pt7 pt8 pt9 pt10 ent8 dpf idf pt11
pt12 pt13 pt14 pt15 ent9)
(progn
(setq od (* od 0.5)
      rh (* djn 0.5)
      e (* (* djn 1.154700538) 0.5)  
      g (- tjn (* e 0.125))
      h (* e 0.75)
      pt1 (polar insn (dtr 90) h)
      pt2 (polar insn (dtr 90) e)
      pt3 (polar pt2 (dtr 180) g)
      pt4 (polar insn (dtr 180) tjn)
      pt5 (polar pt4 (dtr 90) h)
      pt6 (polar pt4 (dtr 90) e)
      pt7 (polar pt6 (dtr 0) g)
      pt8 (polar pt2 (dtr 270) (* (- e h) 0.5))
      pt9 (polar insn (dtr 90) od)
      pt10 (polar pt9 (dtr 180) tjn)
);end setq
(command "pline" pt10 pt5 "a" "d" pt6 pt3 "line" pt7 "a" "d" pt8 pt1 "line" pt9 "c")
(setq ent1 (entlast))
(command "revolve" ent1 "" pt4 insn "360")
(setq ent2 (entlast))
(command "ucs" "o" insn)
(command "ucs" "y" "270")
(setq insn '(0.0 0.0 0.0))
(command "polygon" 6 insn "c" (polar insn (dtr 0) rh))
(setq ent3 (entlast))
(command "extrude" ent3 "" tjn "")
(setq ent4 (entlast))
(command "intersect" ent2 ent4 "")
(setq ent_list (ssget "L"))
(command "ucs" "w")
);end progn
(if (or (= w "washer_lock") (= w "washer_both")) (FAST_LOCK_3D_SOLID))
(if (or (= w "washer_flat") (= w "washer_both")) (FAST_FLAT_3D_SOLID))
(command "rotate" ent_list "" ins)
);end FAST_JAM_NUT_3D_SOLID
;--------------------------------------------------------------------;
(defun FAST_PAN_HEAD_TOP (/ rad_hd dia_hd a b c d e pt1 pt2 pt3 pt4 pt5
pt6 ent1 ent2)
  (setq rad_hd (* dph 0.5)
        dia_hd dph
        b (* slw 0.5)
        a (sqrt (- (expt rad_hd 2) (expt b 2)))
        c (* rad_hd 0.33)
        d (* rad_hd 0.5)
        e (* rad_hd 1.5))
  (setq pt1 (polar ins (dtr 315) b)
        pt2 (polar ins (dtr 135) b)
        pt3 (polar pt2 (dtr 45) a)
        pt4 (polar pt2 (dtr 225) a)
        pt5 (polar pt1 (dtr 225) a)
        pt6 (polar pt1 (dtr 45) a))
  (command "circle" ins "d" dia_hd)
  (command "line" pt3 pt4 "")
  (setq ent1 (entlast))
  (command "line" pt5 pt6 "")
  (setq ent2 (entlast))
  (if (or (= w "washer_lock") (= w "washer_both")) (command "circle" ins "d" dl))
  (if (or (= w "washer_flat") (= w "washer_both")) (command "circle" ins "d" df))
  (command "rotate" ent1 ent2 "" ins)
);End FAST_PAN_HEAD_TOP
;--------------------------------------------------------------------;
(defun FAST_PAN_HEAD_SIDE (/ pt1 pt2 pt3 pt4 pt5 pt6 pt7 pt8 pt9 
pt10 pt11 pt12 pt13)
  (setq slw (* slw 0.5)
        dph (* dph 0.5))
  (setq pt1 (polar insn (dtr 180) tph)
        pt2 (polar pt1 (dtr 270) slw)
        pt3 (polar pt1 (dtr 270) dph)
        pt4 (polar pt3 (dtr 90) radph)
        pt5 (polar pt3 (dtr 0) radph)
        pt6 (polar pt3 (dtr 0) tph)
        pt7 (polar pt1 (dtr 90) slw)
        pt8 (polar pt1 (dtr 90) dph)
        pt9 (polar pt8 (dtr 270) radph)
        pt10 (polar pt8 (dtr 0) radph)
        pt11 (polar pt8 (dtr 0) tph)
        pt12 (polar pt2 (dtr 0) sdph)
        pt13 (polar pt7 (dtr 0) sdph))
  (command "pline" insn pt11 pt10 "arc" "d" pt8 pt9 "line" pt7 
   pt13 pt12 pt2 pt4 "arc" "d" pt3 pt5 "line" pt6 insn "")
  (setq ent_list (ssget "L"))
  (if (or (= w "washer_lock") (= w "washer_both")) (FAST_LOCK_SIDE))
  (setq ent_list (ssadd (entlast) ent_list))
  (if (or (= w "washer_flat") (= w "washer_both")) (FAST_FLAT_SIDE))
  (setq ent_list (ssadd (entlast) ent_list))
  (if (= shank "1") (FAST_SHANK_SIDE))
  (command "rotate" ent_list "" ins)  
  );End FAST_PAN_HEAD_SIDE
;--------------------------------------------------------------------;
(defun FAST_PAN_HEAD_3D_SOLID (/ pt1 pt2 pt3p pt4 pt5 pt6 pt7 pt8 pt9
ent1 ent2 ent3 ent4)
(progn
(setq slw (* slw 0.5)
      dph (* dph 0.5)
      pt1 (polar insn (dtr 90) dph)
      pt2 (polar pt1 (dtr 180) tph)
      pt3 (polar pt2 (dtr 0) radph)
      pt4 (polar pt2 (dtr 270) radph)
      pt5 (polar insn (dtr 180) tph)
);end setq
(command "pline" insn pt1 pt3 "a" "d" pt2 pt4 "line" pt5 "c")
(setq ent1 (entlast))
(command "revolve" ent1 "" pt5 insn "360")
(setq ent2 (entlast))
(command "ucs" "o" pt5)
(command "ucs" "y" "270")
(setq pt6 '(0.0 0.0 0.0))
(setq pt7 (polar pt6 (dtr 90) dph)
      pt8 (polar pt7 (dtr 0) slw)
      pt9 (polar pt6 (dtr 270) dph)
      pt10 (polar pt9 (dtr 180) slw))
(command "rectang" pt8 pt10 "")
(setq ent3 (entlast))
(command "extrude" ent3 "" (- 0.0 sdph) "")
(setq ent4 (entlast))
(command "subtract" ent2 "" ent4 "" "y")
(setq ent_list (ssget "L"))
(command "ucs" "w")
);end progn
(if (or (= w "washer_lock") (= w "washer_both")) (FAST_LOCK_3D_SOLID))
(if (or (= w "washer_flat") (= w "washer_both")) (FAST_FLAT_3D_SOLID))
(if (= shank "1") (FAST_SHANK_3D_SOLID))
(command "rotate" ent_list "" ins)    
);end FAST_PAN_HEAD_3D_SOLID
;--------------------------------------------------------------------;
(defun FAST_ROUND_HEAD_TOP (/ rad_hd dia_hd a b c d e pt1 pt2 pt3 pt4 pt5
pt6 ent1 ent2)
  (setq rad_hd (* drh 0.5)
        dia_hd drh
        b (* slw 0.5)
        a (sqrt (- (expt rad_hd 2) (expt b 2)))
        c (* rad_hd 0.33)
        d (* rad_hd 0.5)
        e (* rad_hd 1.5))
  (setq pt1 (polar ins (dtr 315) b)
        pt2 (polar ins (dtr 135) b)
        pt3 (polar pt2 (dtr 45) a)
        pt4 (polar pt2 (dtr 225) a)
        pt5 (polar pt1 (dtr 225) a)
        pt6 (polar pt1 (dtr 45) a))
  (command "circle" ins "d" dia_hd)
  (command "line" pt3 pt4 "")
  (setq ent1 (entlast))
  (command "line" pt5 pt6 "")
  (setq ent2 (entlast))
  (if (or (= w "washer_lock") (= w "washer_both")) (command "circle" ins "d" dl))
  (if (or (= w "washer_flat") (= w "washer_both")) (command "circle" ins "d" df))
  (command "rotate" ent1 ent2 "" ins)
);End FAST_ROUND_HEAD_TOP
;--------------------------------------------------------------------;
(defun FAST_ROUND_HEAD_SIDE (/ pt1 pt2 pt3 pt4 pt5 pt6 pt7
pt8 pt9 pt10)
  (setq slw (* slw 0.5)
        drh (* drh 0.5))
  (setq pt1 (polar insn (dtr 180) trh)
        pt2 (polar pt1 (dtr 270) slw)
        pt3 (polar pt1 (dtr 270) drh)
        pt4 (polar pt1 (dtr 90) slw)
        pt5 (polar pt1 (dtr 90) drh)
        pt6 (polar pt2 (dtr 0) sdrh)
        pt7 (polar pt4 (dtr 0) sdrh)
        pt8 (polar pt3 (dtr 0) trh)
        pt9 (polar pt5 (dtr 0) trh)
        pt10 (polar pt6 (dtr 90) slw))
  (command "pline" insn pt9 "arc" "d" pt5 pt4 "line" pt7 pt6 pt2
   "arc" "d" pt3 pt8 "line" insn "")
  (setq ent_list (ssget "L"))
  (if (or (= w "washer_lock") (= w "washer_both")) (FAST_LOCK_SIDE))
  (setq ent_list (ssadd (entlast) ent_list))
  (if (or (= w "washer_flat") (= w "washer_both")) (FAST_FLAT_SIDE))
  (setq ent_list (ssadd (entlast) ent_list))
  (if (= shank "1") (FAST_SHANK_SIDE))
  (command "rotate" ent_list "" ins)
  );End FAST_ROUND_HEAD_SIDE
;--------------------------------------------------------------------;
(defun FAST_ROUND_HEAD_3D_SOLID (/ pt1 pt2 pt3p pt4 pt5 pt6 pt7 pt8 pt9
ent1 ent2 ent3 ent4)
(progn
(setq slw (* slw 0.5)
      drh (* drh 0.5)
      pt1 (polar insn (dtr 90) drh)
      pt2 (polar pt1 (dtr 180) trh)
      pt3 (polar insn (dtr 180) trh)
      pt4 (polar pt3 (dtr 90) slw)
);end setq
(command "pline" insn pt3 pt4 "a" "d" pt2 pt1 "line" insn "")
(setq ent1 (entlast))
(command "revolve" ent1 "" pt3 insn "360")
(setq ent2 (entlast))
(command "ucs" "o" pt3)
(command "ucs" "y" "270")
(setq pt5 '(0.0 0.0 0.0))
(setq pt6 (polar pt5 (dtr 90) drh)
      pt7 (polar pt6 (dtr 0) slw)
      pt8 (polar pt5 (dtr 270) drh)
      pt9 (polar pt8 (dtr 180) slw))
(command "rectang" pt7 pt9 "")
(setq ent3 (entlast))
(command "extrude" ent3 "" (- 0.0 sdrh) "")
(setq ent4 (entlast))
(command "subtract" ent2 "" ent4 "" "y")
(setq ent_list (ssget "L"))
(command "ucs" "w")
);end progn
(if (or (= w "washer_lock") (= w "washer_both")) (FAST_LOCK_3D_SOLID))
(if (or (= w "washer_flat") (= w "washer_both")) (FAST_FLAT_3D_SOLID))
(if (= shank "1") (FAST_SHANK_3D_SOLID))
(command "rotate" ent_list "" ins)    
);end FAST_ROUND_HEAD_3D_SOLID
;--------------------------------------------------------------------;
(defun FAST_SOCKET_HEAD_TOP (); (/ dch ent1)
  (setq rhx (* rhx 0.5))
  (command "polygon" 6 ins "c" (polar ins (dtr 0) rhx))
  (setq ent1 (entlast))
  (setq dch (* dsh 0.875))
  (command "circle" ins "d" dch)
  (command "circle" ins "d" dsh)
  (if (or (= w "washer_lock") (= w "washer_both")) (command "circle" ins "d" dl))
  (if (or (= w "washer_flat") (= w "washer_both")) (command "circle" ins "d" df))
  (command "rotate" ent1 "" ins)
  );End FAST_SOCKET_HEAD_TOP
;--------------------------------------------------------------------;
(defun FAST_SOCKET_HEAD_SIDE (/ rh ch pt1 pt2 pt3 pt4 pt5 pt8 pt9 pt10)
(setq rh (* dsh 0.5)  
      ch (* tsh 0.09375)
      pt1 (polar insn (dtr 90) rh)
      pt2 (polar insn (dtr 180) (- tsh ch))
      pt3 (polar pt2 (dtr 90) rh)
      pt4 (polar pt2 (dtr 180) ch)
      pt5 (polar pt4 (dtr 90) (- rh ch))
      pt8 (polar insn (dtr 270) rh)
      pt9 (polar pt2 (dtr 270) rh)
      pt10 (polar pt4 (dtr 270) (- rh ch)))
     (command "pline" pt1 pt8 pt9 pt3 pt9 pt10 pt5 pt3 pt1 "")
(setq ent_list (ssget "L"))
(if (or (= w "washer_lock") (= w "washer_both")) (FAST_LOCK_SIDE))
(setq ent_list (ssadd (entlast) ent_list))
(if (or (= w "washer_flat") (= w "washer_both")) (FAST_FLAT_SIDE))
(setq ent_list (ssadd (entlast) ent_list))
(if (= shank "1") (FAST_SHANK_SIDE))
(command "rotate" ent_list "" ins)
);End FAST_SOCKET_HEAD_SIDE
;--------------------------------------------------------------------;
(defun FAST_SOCKET_HEAD_3D_SOLID (/ rh ch pt1 pt2 pt3p pt4 pt5 pt6 pt7 pt8 pt9
ent1 ent2 ent3 ent4)
(progn
(setq rhx (* rhx 0.5)
      rh (* dsh 0.5)  
      ch (* tsh 0.09375)
      pt1 (polar insn (dtr 90) rh)
      pt2 (polar pt1 (dtr 180) tsh)
      pt3 (polar pt2 (dtr 0) ch)
      pt4 (polar pt2 (dtr 270) ch)
      pt5 (polar insn (dtr 180) tsh)
);end setq
(command "pline" insn pt1 pt3 pt4 pt5 "c")
(setq ent1 (entlast))
(command "revolve" ent1 "" pt5 insn "360")
(setq ent2 (entlast))
(command "ucs" "o" pt5)
(command "ucs" "y" "270")
(setq pt6 '(0.0 0.0 0.0))
(command "polygon" 6 pt6 "c" (polar pt6 (dtr 0) rhx))
(setq ent3 (entlast))
(command "extrude" ent3 "" (- 0.0 (* tsh 0.5)) "")
(setq ent4 (entlast))
(command "subtract" ent2 "" ent4 "" "y")
(setq ent_list (ssget "L"))
(command "ucs" "w")
);end progn
(if (or (= w "washer_lock") (= w "washer_both")) (FAST_LOCK_3D_SOLID))
(if (or (= w "washer_flat") (= w "washer_both")) (FAST_FLAT_3D_SOLID))
(if (= shank "1") (FAST_SHANK_3D_SOLID))
(command "rotate" ent_list "" ins)    
);end FAST_SOCKET_HEAD_3D_SOLID
;--------------------------------------------------------------------;
(defun FAST_SETSCREW_TOP (); (/ dch ent1)
  (setq ssrhx (* ssrhx 0.5))
  (command "polygon" 6 ins "c" (polar ins (dtr 0) ssrhx))
  (setq ent1 (entlast))
  (command "circle" ins "d" od)
  (command "circle" ins "d" id)
  (command "rotate" ent1 "" ins)
);End FAST_SETSCREW_TOP
;--------------------------------------------------------------------;
(defun FAST_SETSCREW_CUP_SIDE (/ pt1 pt2 pt3 pt4 pt5 pt6 pt7
pt8 pt9 pt10 pt11 pt12 pt13 ent1 ent2)
(setq id (* id 0.5)
      od (* od 0.5)
      dcp (* dcp 0.5))
(setq pt1 (polar ins (dtr 180) (- od dcp))
      pt2 (polar ins (dtr 180) lg)
      pt3 (polar pt2 (dtr 0) (- od id))
      pt4 (polar ins (dtr 90) dcp)
      pt5 (polar ins (dtr 270) dcp)
      pt6 (polar pt1 (dtr 90) id)
      pt7 (polar pt1 (dtr 270) id)
      pt8 (polar pt1 (dtr 90) od)
      pt9 (polar pt1 (dtr 270) od)
      pt10 (polar pt3 (dtr 90) od)
      pt11 (polar pt3 (dtr 270) od)
      pt12 (polar pt2 (dtr 90) id)
      pt13 (polar pt2 (dtr 270) id))
(command "pline" pt9 pt5 pt4 pt8 pt9 pt11 pt13 pt12 pt10 pt11 pt10 
pt8 "")
(setq ent1 (entlast))
(command "pline" pt6 pt12 pt13 pt7 "")
(setq ent2 (entlast))
(command "chprop" ent2 "" "lt" "hidden2" "")
(command "rotate" ent1 ent2 "" ins)
);End FAST_SETSCREW_CUP_SIDE 
;--------------------------------------------------------------------;
(defun FAST_SETSCREW_CUP_3D_SOLID (/ pt1 pt2 pt3 pt4 pt5 pt6 pt7
ent1 ent2 ent3 ent4 ent5)
(if (= scale "1")
(setq lg (/ lg 25.4)))
(setq ssrhx (* ssrhx 0.5)
      id (* id 0.5)
      od (* od 0.5)
      dcp (* dcp 0.5)
      pt1 (polar ins (dtr 90) od)
      pt2 (polar pt1 (dtr 270) (- od dcp))
      pt3 (polar pt1 (dtr 180) (- od dcp))
      pt4 (polar pt1 (dtr 180) lg)
      pt5 (polar pt4 (dtr 0) (- od id))
      pt6 (polar pt4 (dtr 270) (- od id))
      pt7 (polar ins (dtr 180) lg)
);end setq
(command "pline" ins pt2 pt3 pt5 pt6 pt7 "c")
(setq ent1 (entlast))
(command "revolve" ent1 "" pt7 ins "360" "")
(setq ent2 (entlast))
(command "ucs" "o" pt7)
(command "ucs" "y" "270")
(setq pt8 '(0.0 0.0 0.0))
(command "polygon" 6 pt8 "c" (polar pt8 (dtr 0) ssrhx))
(setq ent3 (entlast))
(command "extrude" ent3 "" (- 0.0 (* od 0.5)) "")
(setq ent4 (entlast))
(command "subtract" ent2 "" ent4 "" "y")
(setq ent5 (entlast))
(command "ucs" "w")
(command "rotate" ent5 "" ins)
);End FAST_SETSCREW_CUP_3D_SOLID 
;--------------------------------------------------------------------;
(defun FAST_SETSCREW_DOG_SIDE (/ pt1 pt2 pt3 pt4 pt5 pt6 pt7
pt8 pt9 pt10 pt11 pt12 pt13 pt14 pt15 ln1 ln2 ln3)
(setq id (* id 0.5)
      od (* od 0.5)
      ddp (* ddp 0.5))
(setq pt1 (polar ins (dtr 180) (* ddp 0.125))
      pt2 (polar ins (dtr 180) ldp)
      pt3 (polar pt2 (dtr 180) (- od ddp))
      pt4 (polar ins (dtr 180) lg)
      pt5 (polar pt4 (dtr 0) (- od id))
      pt6 (polar ins (dtr 90) (* ddp 0.875))
      pt7 (polar ins (dtr 270) (* ddp 0.875))
      pt8 (polar pt1 (dtr 90) ddp)
      pt9 (polar pt1 (dtr 270) ddp)
      pt10 (polar pt2 (dtr 90) ddp)
      pt11 (polar pt2 (dtr 270) ddp)
      pt12 (polar pt3 (dtr 90) id)
      pt13 (polar pt3 (dtr 270) id)
      pt14 (polar pt3 (dtr 90) od)
      pt15 (polar pt3 (dtr 270) od)
      pt16 (polar pt5 (dtr 90) od)
      pt17 (polar pt5 (dtr 270) od)
      pt18 (polar pt4 (dtr 90) id)
      pt19 (polar pt4 (dtr 270) id))
(command "pline" pt15 pt11 pt9 pt7 pt6 pt8 pt9 pt8 pt10 pt11 pt10 
pt14 pt15 pt17 pt16 pt17 pt19 pt18 pt16 pt14 "")
(setq ent1 (entlast))
(command "pline" pt12 pt18 pt19 pt13 "")
(setq ent2 (entlast))
(command "chprop" ln2 "" "lt" "hidden2" "")
(command "rotate" ent1 ent2 "" ins)       
);End FAST_SETSCREW_DOG_SIDE 
;--------------------------------------------------------------------;
(defun FAST_SETSCREW_DOG_3D_SOLID (/ pt1 pt2 pt3 pt4 pt5 pt6 pt7
pt8 pt9 pt10 ent1 ent2 ent3 ent4 ent5)
(if (= scale "1")
(setq lg (/ lg 25.4)))
(setq ssrhx (* ssrhx 0.5)
      id (* id 0.5)
      od (* od 0.5)
      ddp (* ddp 0.5)
      pt1 (polar ins (dtr 90) ddp)
      pt2 (polar pt1 (dtr 270) (* ddp 0.125))
      pt3 (polar pt1 (dtr 180) (* ddp 0.125))
      pt4 (polar pt1 (dtr 180) ldp)
      pt5 (polar pt4 (dtr 90) (- od ddp))
      pt6 (polar pt5 (dtr 180) (- od ddp))
      pt7 (polar ins (dtr 180) lg)
      pt8 (polar pt7 (dtr 90) od)
      pt9 (polar pt8 (dtr 270) (- od id))
      pt10 (polar pt8 (dtr 0) (- od id))
);end setq
(command "pline" ins pt2 pt3 pt4 pt6 pt10 pt9 pt7 "c")
(setq ent1 (entlast))
(command "revolve" ent1 "" pt7 ins "360" "")
(setq ent2 (entlast))
(command "ucs" "o" pt7)
(command "ucs" "y" "270")
(setq pt11 '(0.0 0.0 0.0))
(command "polygon" 6 pt11 "c" (polar pt11 (dtr 0) ssrhx))
(setq ent3 (entlast))
(command "extrude" ent3 "" (- 0.0 (* od 0.5)) "")
(setq ent4 (entlast))
(command "subtract" ent2 "" ent4 "" "y")
(setq ent5 (entlast))
(command "ucs" "w")
(command "rotate" ent5 "" ins)
);End FAST_SETSCREW_DOG_3D_SOLID 
;--------------------------------------------------------------------;
(defun FAST_STUD_TOP ()
  (command "circle" ins "d" od)
  (command "circle" ins "d" id)
);End FAST_STUD_TOP
;--------------------------------------------------------------------;
(defun FAST_STUD_SIDE (/ scr_rad pt1 pt2 pt3 pt4 
pt5 pt6 pt7 pt8 pt9 pt12 pt13 pt14 pt15 pt16 pt17 
ent1 ent2)
(if (= scale "1")
(setq lg (/ lg 25.4)  
      td (/ td 25.4)))                  
(setq scr_rad (* od 0.5)
      id (* id 0.5))
(setq pt1 (polar ins (dtr 0) lg))
(if (>= td (distance ins pt1)) (setq td (distance ins pt1)))
(setq pt2 (polar pt1 (dtr 90) scr_rad)
      pt3 (polar pt1 (dtr 90) id)
      pt4 (polar pt2 (dtr 180) (- scr_rad id))
      pt5 (polar pt1 (dtr 180) (- scr_rad id))
      pt6 (polar pt1 (dtr 180) td)
      pt7 (polar pt6 (dtr 90) scr_rad)
      pt8 (polar pt6 (dtr 90) id)
      pt9 (polar ins (dtr 90) scr_rad)
      pt12 (polar pt1 (dtr 270) scr_rad)
      pt13 (polar pt1 (dtr 270) id)
      pt14 (polar pt12 (dtr 180) (- scr_rad id))
      pt15 (polar pt6 (dtr 270) scr_rad)
      pt16 (polar pt6 (dtr 270) id)
      pt17 (polar ins (dtr 270) scr_rad))
      (command "pline" pt9 pt7 pt15 pt7 pt4 pt14 pt4 pt3 pt13
       pt14 pt17 "")
      (setq ent1 (entlast))
      (command "pline" pt8 pt3 pt13 pt16 "")
      (setq ent2 (entlast))
(command "chprop" ent2 "" "lt" "hidden2" "")
(command "rotate" ent1 ent2 "" ins)
);End FAST_STUD_SIDE  
;--------------------------------------------------------------------;
(defun FAST_STUD_3D_SOLID (/ pt1 pt2 pt3 pt4 pt5 ent1 ent2 ent3 ent4
ent5)
(if (= scale "1")
(setq lg (/ lg 25.4)))
(setq id (* id 0.5)
      od (* od 0.5)
      pt1 (polar ins (dtr 90) od)
      pt2 (polar pt1 (dtr 0) lg)
      pt3 (polar pt2 (dtr 180) (- od id))
      pt4 (polar pt2 (dtr 270) (- od id))
      pt5 (polar ins (dtr 0) lg)
);end setq
(command "pline" ins pt1 pt3 pt4 pt5 "c")
(setq ent1 (entlast))
(command "revolve" ent1 "" ins pt5 "360" "")
(setq ent2 (entlast))
(command "rotate" ent2 "" ins)
);End FAST_STUD_3D_SOLID 
;--------------------------------------------------------------------;
(defun FAST_HELP ()
(if (= fast_help_list nil)
(progn
(setq line "")
(setq helpfile (open (findfile "fast_help.txt") "r"))
(while (/= line nil)
       (setq line (read-line helpfile))
       (if(/= line nil)
          (setq fast_help_list (append fast_help_list (list line)))
       );end if
);end while /= line nil
(close helpfile)
);end progn
);end = fast_help_list nil


(setq dcl_id (load_dialog (findfile "fast.dcl")))
(if (not (new_dialog "fast_help" dcl_id "" ))
(exit))

(start_list "fast_help" )
(mapcar 'add_list fast_help_list)
(end_list)                  

(start_dialog)
(unload_dialog dcl_id)
);end FAST_HELP
;-----------------------------------------------------------------------;
(defun MODE_2D_TOP ()
       (set_tile "shank" "0")
       (mode_tile "shank" 1)
       (mode_tile "shank_length" 1)
       (mode_tile "thread_length" 1)
       (mode_tile "thread_coarse" 1)
       (mode_tile "thread_fine" 1)
(progn
(if (or (= newtile "flat_head_e")
        (= newtile "flat_head_m"))
        (progn
        (mode_tile "washer_none" 1)
        (mode_tile "washer_lock" 1)
        (mode_tile "washer_flat" 1)
        (mode_tile "washer_both" 1)
        (mode_tile "shank" 1)
        (mode_tile "shank_length" 1)
        (mode_tile "thread_length" 1)
        (mode_tile "thread_coarse" 1)
        (mode_tile "thread_fine" 1)))

(if (or (= newtile "hex_head_e")
        (= newtile "pan_head_e")
        (= newtile "round_head_e")
        (= newtile "socket_head_e")
        (= newtile "hex_head_m")
        (= newtile "pan_head_m")
        (= newtile "round_head_m")
        (= newtile "socket_head_m"))
        (progn
        (mode_tile "washer_none" 0)
        (mode_tile "washer_lock" 0)
        (mode_tile "washer_flat" 0)
        (mode_tile "washer_both" 0)
        (mode_tile "shank" 1)
        (mode_tile "shank_length" 1)
        (mode_tile "thread_length" 1)
        (mode_tile "thread_coarse" 1)
        (mode_tile "thread_fine" 1)))

(if (or (= newtile "hex_nut_e")
        (= newtile "jam_nut_e")
        (= newtile "hex_nut_m")
        (= newtile "jam_nut_m"))
        (progn
        (mode_tile "washer_none" 0)
        (mode_tile "washer_lock" 0)
        (mode_tile "washer_flat" 0)
        (mode_tile "washer_both" 0)
        (mode_tile "shank" 1)
        (mode_tile "shank_length" 1)
        (mode_tile "thread_length" 1)
        (mode_tile "thread_coarse" 1)
        (mode_tile "thread_fine" 1)))

(if (or (= newtile "set_screw_e_cup")
        (= newtile "set_screw_e_dog")
        (= newtile "stud_e")
        (= newtile "set_screw_m_cup")
        (= newtile "set_screw_m_dog")
        (= newtile "stud_m"))
        (progn
        (mode_tile "washer_none" 1)
        (mode_tile "washer_lock" 1)
        (mode_tile "washer_flat" 1)
        (mode_tile "washer_both" 1)
        (mode_tile "shank" 1)
        (mode_tile "shank_length" 1)
        (mode_tile "thread_length" 1)
        (mode_tile "thread_coarse" 1)
        (mode_tile "thread_fine" 1)))

(if (or (= newtile "flat_head_m")
        (= newtile "hex_head_m")
        (= newtile "hex_nut_m")
        (= newtile "jam_nut_m")
        (= newtile "pan_head_m")
        (= newtile "round_head_m")
        (= newtile "socket_head_m")
        (= newtile "set_screw_m_cup")
        (= newtile "set_screw_m_dog")
        (= newtile "stud_m"))
        (mode_tile "met_scale" 0))

);end progn
);end MODE_2D_TOP
;--------------------------------------------------------------------;
(defun MODE_2D_SIDE ()
(set_tile "shank" "0")
(mode_tile "shank" 0)
(mode_tile "shank_length" 1)
(mode_tile "thread_length" 1)
(mode_tile "thread_coarse" 1)
(mode_tile "thread_fine" 1) 
(progn
(if (or (= newtile "flat_head_e")
        (= newtile "flat_head_m"))
        (progn
        (mode_tile "washer_none" 1)
        (mode_tile "washer_lock" 1)
        (mode_tile "washer_flat" 1)
        (mode_tile "washer_both" 1)
        (mode_tile "shank" 0)
        (mode_tile "shank_length" 1)
        (mode_tile "thread_length" 1)
        (mode_tile "thread_coarse" 1)
        (mode_tile "thread_fine" 1)))

(if (or (= newtile "hex_head_e")
        (= newtile "pan_head_e")
        (= newtile "round_head_e")
        (= newtile "socket_head_e")
        (= newtile "hex_head_m")
        (= newtile "pan_head_m")
        (= newtile "round_head_m")
        (= newtile "socket_head_m"))
        (progn
        (mode_tile "washer_none" 0)
        (mode_tile "washer_lock" 0)
        (mode_tile "washer_flat" 0)
        (mode_tile "washer_both" 0)
        (mode_tile "shank" 0)
        (mode_tile "shank_length" 1)
        (mode_tile "thread_length" 1)
        (mode_tile "thread_coarse" 1)
        (mode_tile "thread_fine" 1)))

(if (or (= newtile "hex_nut_e")
        (= newtile "jam_nut_e")
        (= newtile "hex_nut_m")
        (= newtile "jam_nut_m"))
        (progn
        (mode_tile "washer_none" 0)
        (mode_tile "washer_lock" 0)
        (mode_tile "washer_flat" 0)
        (mode_tile "washer_both" 0)
        (mode_tile "shank" 1)
        (mode_tile "shank_length" 1)
        (mode_tile "thread_length" 1)
        (mode_tile "thread_coarse" 1)
        (mode_tile "thread_fine" 1)))       

(if (or (= newtile "set_screw_e_cup")
        (= newtile "set_screw_e_dog")
        (= newtile "stud_e")
        (= newtile "set_screw_m_cup")
        (= newtile "set_screw_m_dog")
        (= newtile "stud_m"))
        (progn
        (mode_tile "washer_none" 1)
        (mode_tile "washer_lock" 1)
        (mode_tile "washer_flat" 1)
        (mode_tile "washer_both" 1)
        (mode_tile "shank" 1)
        (mode_tile "shank_length" 0)
        (mode_tile "shank_length" 2)
        (mode_tile "thread_length" 0)
        (mode_tile "thread_coarse" 0)
        (mode_tile "thread_fine" 0)))

(if (or (= newtile "flat_head_m")
        (= newtile "hex_head_m")
        (= newtile "hex_nut_m")
        (= newtile "jam_nut_m")
        (= newtile "pan_head_m")
        (= newtile "round_head_m")
        (= newtile "socket_head_m")
        (= newtile "set_screw_m_cup")
        (= newtile "set_screw_m_dog")
        (= newtile "stud_m"))
        (mode_tile "met_scale" 0))
);end progn
);end MODE_2D_SIDE
;--------------------------------------------------------------------;
(defun MODE_3D_SOLID ()
(set_tile "shank" "0")
(mode_tile "shank" 0)
(mode_tile "shank_length" 1)
(mode_tile "thread_length" 1)
(mode_tile "thread_coarse" 1)
(mode_tile "thread_fine" 1)
(progn
(if (or (= newtile "flat_head_e")
        (= newtile "flat_head_m"))
        (progn
        (mode_tile "washer_none" 1)
        (mode_tile "washer_lock" 1)
        (mode_tile "washer_flat" 1)
        (mode_tile "washer_both" 1)
        (mode_tile "shank" 0)
        (mode_tile "shank_length" 1)
        (mode_tile "thread_length" 1)
        (mode_tile "thread_coarse" 1)
        (mode_tile "thread_fine" 1)))

(if (or (= newtile "hex_head_e")
        (= newtile "pan_head_e")
        (= newtile "round_head_e")
        (= newtile "socket_head_e")
        (= newtile "hex_head_m")
        (= newtile "pan_head_m")
        (= newtile "round_head_m")
        (= newtile "socket_head_m"))
        (progn
        (mode_tile "washer_none" 0)
        (mode_tile "washer_lock" 0)
        (mode_tile "washer_flat" 0)
        (mode_tile "washer_both" 0)
        (mode_tile "shank" 0)
        (mode_tile "shank_length" 1)
        (mode_tile "thread_length" 1)
        (mode_tile "thread_coarse" 1)
        (mode_tile "thread_fine" 1)))

(if (or (= newtile "hex_nut_e")
        (= newtile "jam_nut_e")
        (= newtile "hex_nut_m")
        (= newtile "jam_nut_m"))
        (progn
        (mode_tile "washer_none" 0)
        (mode_tile "washer_lock" 0)
        (mode_tile "washer_flat" 0)
        (mode_tile "washer_both" 0)
        (mode_tile "shank" 1)
        (mode_tile "shank_length" 1)
        (mode_tile "thread_length" 1)
        (mode_tile "thread_coarse" 1)
        (mode_tile "thread_fine" 1)))

(if (or (= newtile "set_screw_e_cup")
        (= newtile "set_screw_e_dog")
        (= newtile "stud_e")
        (= newtile "set_screw_m_cup")
        (= newtile "set_screw_m_dog")
        (= newtile "stud_m"))
        (progn
        (mode_tile "washer_none" 1)
        (mode_tile "washer_lock" 1)
        (mode_tile "washer_flat" 1)
        (mode_tile "washer_both" 1)
        (mode_tile "shank" 1)
        (mode_tile "shank_length" 0)
        (mode_tile "shank_length" 2)
        (mode_tile "thread_length" 1)
        (mode_tile "thread_coarse" 1)
        (mode_tile "thread_fine" 1)))

(if (or (= newtile "flat_head_m")
        (= newtile "hex_head_m")
        (= newtile "hex_nut_m")
        (= newtile "jam_nut_m")
        (= newtile "pan_head_m")
        (= newtile "round_head_m")
        (= newtile "socket_head_m")
        (= newtile "set_screw_m_cup")
        (= newtile "set_screw_m_dog")
        (= newtile "stud_m"))
        (mode_tile "met_scale" 0))
);end progn
);end MODE_3D_SOLID
;--------------------------------------------------------------------;
(defun MODE_SHANK ()
(progn
(if (= which_view "2d_side")
(progn
(mode_tile "shank_length" (- 1 (atoi $value)))
(mode_tile "shank_length" 2)
(mode_tile "thread_length" (- 1 (atoi $value)))
(mode_tile "thread_coarse" (- 1 (atoi $value)))
(mode_tile "thread_fine" (- 1 (atoi $value)))))

(if (= which_view "3d_solid")
(progn
(mode_tile "shank_length" (- 1 (atoi $value)))
(mode_tile "shank_length" 2)
(mode_tile "thread_length" 1)
(mode_tile "thread_coarse" 1)
(mode_tile "thread_fine" 1)))
);end progn
);end MODE_SHANK
;--------------------------------------------------------------------;
(defun FAST_DEFAULTS ()
;Set defaults
(set_tile "2d_top" "1")
(set_tile "washer_none" "1")
(set_tile "shank" "0")
;(mode_tile "shank" 1)
;(mode_tile "shank_length" 1)
;(mode_tile "thread_length" 1)
;(mode_tile "3d_solid" 0)
(set_tile "met_scale" "0")
(mode_tile "met_scale" 1)
(setq scale "0"
      w "washer_none"
      thread "thread_coarse"
      lg 1
      td 1)
(if (/= fast_def_newtile nil) (setq newtile fast_def_newtile))
(if (/= fast_def_display_list nil) 
    (progn (setq display_list fast_def_display_list) 
           (start_list "get_size")
           (mapcar 'add_list display_list)
           (end_list)))
(if (/= fast_def_size nil) (setq size fast_def_size))
(if (/= fast_def_index nil) (setq index fast_def_index))
(if (/= fast_def_w nil) (setq w fast_def_w))
(if (/= fast_def_thread nil) (setq thread fast_def_thread))
(if (/= fast_def_shank nil) (setq shank fast_def_shank))
(if (/= fast_def_lg nil) (setq lg fast_def_lg))
(if (/= fast_def_td nil) (setq td fast_def_td))
(if (/= fast_def_scale nil) (setq scale fast_def_scale))
(if (/= fast_def_df nil) (setq df fast_def_df))
(if (/= fast_def_tf nil) (setq tf fast_def_tf))
(if (/= fast_def_dl nil) (setq dl fast_def_dl))
(if (/= fast_def_tl nil) (setq tl fast_def_tl))
(if (/= fast_def_dhh nil) (setq dhh fast_def_dhh))
(if (/= fast_def_thh nil) (setq thh fast_def_thh))
(if (/= fast_def_idc nil) (setq idc fast_def_idc))
(if (/= fast_def_idf nil) (setq idf fast_def_idf))
(if (/= fast_def_id nil) (setq id fast_def_id))
(if (/= fast_def_od nil) (setq od fast_def_od))
(if (/= fast_def_dsh nil) (setq dsh fast_def_dsh))
(if (/= fast_def_tsh nil) (setq tsh fast_def_tsh))
(if (/= fast_def_rhx nil) (setq rhx fast_def_rhx))
(if (/= fast_def_dfh nil) (setq dfh fast_def_dfh))
(if (/= fast_def_ho nil) (setq ho fast_def_ho))
(if (/= fast_def_tfh nil) (setq tfh fast_def_tfh))
(if (/= fast_def_slw nil) (setq slw fast_def_slw))
(if (/= fast_def_sdfh nil) (setq sdfh fast_def_sdfh))
(if (/= fast_def_drh nil) (setq drh fast_def_drh))
(if (/= fast_def_trh nil) (setq trh fast_def_trh))
(if (/= fast_def_sdrh nil) (setq sdrh fast_def_sdrh))
(if (/= fast_def_dph nil) (setq dph fast_def_dph))
(if (/= fast_def_tph nil) (setq tph fast_def_tph))
(if (/= fast_def_radph nil) (setq radph fast_def_radph))
(if (/= fast_def_sdph nil) (setq sdph fast_def_sdph))
(if (/= fast_def_dcp nil) (setq dcp fast_def_dcp))
(if (/= fast_def_ddp nil) (setq ddp fast_def_ddp))
(if (/= fast_def_ldp nil) (setq ldp fast_def_ldp))
(if (/= fast_def_ssrhx nil) (setq ssrhx fast_def_ssrhx))
(if (/= fast_def_dhn nil) (setq dhn fast_def_dhn))
(if (/= fast_def_thn nil) (setq thn fast_def_thn))
(if (/= fast_def_djn nil) (setq djn fast_def_djn))
(if (/= fast_def_tjn nil) (setq tjn fast_def_tjn))
(if (/= fast_def_check nil) (setq check fast_def_check))
(if (/= fast_def_headdia nil) (set_tile "head_dia" fast_def_headdia))
(if (/= fast_def_headthk nil) (set_tile "head_thk" fast_def_headthk))
(if (/= fast_def_flatdia nil) (set_tile "flat_dia" fast_def_flatdia))
(if (/= fast_def_flatthk nil) (set_tile "flat_thk" fast_def_flatthk))
(if (/= fast_def_lockdia nil) (set_tile "lock_dia" fast_def_lockdia))
(if (/= fast_def_lockthk nil) (set_tile "lock_thk" fast_def_lockthk))
(if (/= fast_def_rootdiac nil) (set_tile "root_dia_c" fast_def_rootdiac))
(if (/= fast_def_rootdiaf nil) (set_tile "root_dia_f" fast_def_rootdiaf))
(if (/= fast_def_nutdia nil) (set_tile "nut_dia" fast_def_nutdia))
(if (/= fast_def_nutthk nil) (set_tile "nut_thk" fast_def_nutthk))
(if (/= fast_def_jamnutdia nil) (set_tile "jam_nut_dia" fast_def_jamnutdia))
(if (/= fast_def_jamnutthk nil) (set_tile "jam_nut_thk" fast_def_jamnutthk))
(if (/= fast_def_hexkey nil) (set_tile "hex_key" fast_def_hexkey))

(if (/= fast_def_which_view nil) (setq which_view fast_def_which_view))
(if (= fast_def_which_view nil) (setq which_view "2d_top"))

(if (= fast_def_2dtop "1") (progn (set_tile "2d_top" fast_def_2dtop)
                             (mode_2d_top)))
(if (= fast_def_2dtop nil) (progn (set_tile "2d_top" "1")
                             (mode_2d_top)))
                                                   
(if (= fast_def_2dside "1") (progn (set_tile "2d_side" fast_def_2dside)
                              (mode_2d_side)))
(if (= fast_def_2dside nil) (set_tile "2d_side" "0"))

(if (= fast_def_3dsolid "1") (progn (set_tile "3d_solid" fast_def_3dsolid)
                               (mode_3d_solid)))                               
(if (= fast_def_3dsolid nil) (set_tile "3d_solid" "0"))

(if (= fast_def_washernone "1") (set_tile "washer_none" fast_def_washernone))                               
(if (= fast_def_washernone nil) (set_tile "washer_none" "1"))
(if (= fast_def_washerlock "1") (set_tile "washer_lock" fast_def_washerlock))                               
(if (= fast_def_washerlock nil) (set_tile "washer_lock" "0"))
(if (= fast_def_washerflat "1") (set_tile "washer_flat" fast_def_washerflat))                               
(if (= fast_def_washerflat nil) (set_tile "washer_flat" "0"))
(if (= fast_def_washerboth "1") (set_tile "washer_both" fast_def_washerboth))                               
(if (= fast_def_washerboth nil) (set_tile "washer_both" "0"))

(if (and (= fast_def_2dside "1")
         (= fast_def_shank "1"))
         (progn
         (set_tile "shank" fast_def_shank)
         (mode_tile "shank_length" 0)
         (mode_tile "shank_length" 2)
         (mode_tile "thread_length" 0)
         (mode_tile "thread_coarse" 0)
         (mode_tile "thread_fine" 0)))

(if (and (= fast_def_3dsolid "1")
         (= fast_def_shank "1"))
         (progn
         (set_tile "shank" fast_def_shank)
         (mode_tile "shank_length" 0)
         (mode_tile "shank_length" 2)
         (mode_tile "thread_length" 1)
         (mode_tile "thread_coarse" 1)
         (mode_tile "thread_fine" 1)))

(if (= fast_def_shank nil) (set_tile "shank" "0"))
(if (/= fast_def_shanklength nil) (set_tile "shank_length" fast_def_shanklength))                               
(if (= fast_def_shanklength nil) (set_tile "shank_length" "1"))
(if (/= fast_def_threadlength nil) (set_tile "thread_length" fast_def_threadlength))                               
(if (= fast_def_threadlength nil) (set_tile "thread_length" "1"))
(if (= fast_def_threadcoarse "1") (set_tile "thread_coarse" fast_def_threadcoarse))                               
(if (= fast_def_threadcoarse nil) (set_tile "thread_coarse" "1"))
(if (= fast_def_threadfine "1") (set_tile "thread_fine" fast_def_threadfine))                               
(if (= fast_def_threadfine nil) (set_tile "thread_fine" "0"))
(if (= fast_def_metscale "1") (set_tile "met_scale" fast_def_metscale))                               
(if (= fast_def_metscale nil) (set_tile "met_scale" "0"))


);end FAST_DEFAULTS
;--------------------------------------------------------------------;
(defun FAST_CHECK_SELECTIONS ()
;First save fast_defaults
(setq fast_def_newtile newtile
      fast_def_size size
      fast_def_which_view which_view
      fast_def_display_list display_list
      fast_def_index index
      fast_def_w w
      fast_def_thread thread
      fast_def_shank shank
      fast_def_lg lg
      fast_def_td td
      fast_def_scale scale
      fast_def_df df
      fast_def_tf tf
      fast_def_dl dl
      fast_def_tl tl
      fast_def_dhh dhh
      fast_def_thh thh
      fast_def_idc idc
      fast_def_idf idf
      fast_def_id id
      fast_def_od od
      fast_def_dsh dsh
      fast_def_tsh tsh
      fast_def_rhx rhx
      fast_def_dfh dfh
      fast_def_ho ho
      fast_def_tfh tfh
      fast_def_slw slw
      fast_def_sdfh sdfh
      fast_def_drh drh
      fast_def_trh trh
      fast_def_sdrh sdrh
      fast_def_dph dph
      fast_def_tph tph
      fast_def_radph radph
      fast_def_sdph sdph
      fast_def_dcp dcp
      fast_def_ddp ddp
      fast_def_ldp ldp
      fast_def_ssrhx ssrhx
      fast_def_dhn dhn
      fast_def_thn thn
      fast_def_djn djn
      fast_def_tjn tjn
      fast_def_check check      
      fast_def_2dtop (get_tile "2d_top")
      fast_def_2dside (get_tile "2d_side")
      fast_def_3dsolid (get_tile "3d_solid")
      fast_def_washernone (get_tile "washer_none")
      fast_def_washerlock (get_tile "washer_lock")
      fast_def_washerflat (get_tile "washer_flat")
      fast_def_washerboth (get_tile "washer_both")
      fast_def_threadcoarse (get_tile "thread_coarse")
      fast_def_threadfine (get_tile "thread_fine")
      fast_def_shank (get_tile "shank")
      fast_def_shanklength (get_tile "shank_length")
      fast_def_threadlength (get_tile "thread_length")
      fast_def_metscale (get_tile "met_scale")
      fast_def_headdia (get_tile "head_dia")
      fast_def_headthk (get_tile "head_thk")
      fast_def_flatdia (get_tile "flat_dia")
      fast_def_flatthk (get_tile "flat_thk")
      fast_def_lockdia (get_tile "lock_dia")
      fast_def_lockthk (get_tile "lock_thk")
      fast_def_rootdiac (get_tile "root_dia_c")
      fast_def_rootdiaf (get_tile "root_dia_f")
      fast_def_nutdia (get_tile "nut_dia")
      fast_def_nutthk (get_tile "nut_thk")
      fast_def_jamnutdia (get_tile "jam_nut_dia")
      fast_def_jamnutthk (get_tile "jam_nut_thk")
      fast_def_hexkey (get_tile "hex_key"))
;Then check selections
(progn (if (= newtile nil)
       (alert "OOPS! SELECT A FASTENER TYPE - TRY AGAIN!"))
       (if (and (/= newtile nil) (= size nil))
       (alert "OOPS! SELECT A FASTENER SIZE - TRY AGAIN!"))       
       (if (= check 0)
       (alert "OOPS! SIZE NOT AVAILABLE - TRY AGAIN!"))
       (if (and (/= newtile nil) (/= size nil))
       (setq save_size (get_tile "get_size")))
       (if (and (/= newtile nil) (/= size nil) (= check 1))
       (done_dialog))
);end progn
);end FAST_CHECK_SELECTIONS 
;--------------------------------------------------------------------;
(defun FAST_DIALOG ()
(setq dcl_id (load_dialog "fast.dcl"))	;load the DCL file
(if (not (new_dialog "fast" dcl_id))	;initialize the DCL file
(exit)					;exit if this doesn't work
);end if
        (fast_defaults)
	(action_tile "flat_head_e" (strcat "(setq newtile $key)"
				           "(FAST_READ_DIM_FILE)"))
	(action_tile "hex_head_e" (strcat "(setq newtile $key)"
                                          "(FAST_READ_DIM_FILE)"))
	(action_tile "hex_nut_e" (strcat "(setq newtile $key)"
                                         "(FAST_READ_DIM_FILE)"))
	(action_tile "jam_nut_e" (strcat "(setq newtile $key)"
				         "(FAST_READ_DIM_FILE)"))
	(action_tile "pan_head_e" (strcat "(setq newtile $key)"
                                          "(FAST_READ_DIM_FILE)"))
	(action_tile "round_head_e" (strcat "(setq newtile $key)"
                                            "(FAST_READ_DIM_FILE)"))
	(action_tile "socket_head_e" (strcat "(setq newtile $key)"
                                             "(FAST_READ_DIM_FILE)"))
	(action_tile "set_screw_e_cup" (strcat "(setq newtile $key)"
                                               "(FAST_READ_DIM_FILE)"))
  	(action_tile "set_screw_e_dog" (strcat "(setq newtile $key)"
                                               "(FAST_READ_DIM_FILE)"))
	(action_tile "stud_e" (strcat "(setq newtile $key)"
                                      "(FAST_READ_DIM_FILE)"))
	(action_tile "flat_head_m" (strcat "(setq newtile $key)"
                                           "(FAST_READ_DIM_FILE)"))
	(action_tile "hex_head_m" (strcat "(setq newtile $key)"
				          "(FAST_READ_DIM_FILE)"))
	(action_tile "hex_nut_m" (strcat "(setq newtile $key)"
                                         "(FAST_READ_DIM_FILE)"))
	(action_tile "jam_nut_m" (strcat "(setq newtile $key)"
				         "(FAST_READ_DIM_FILE)"))
	(action_tile "pan_head_m" (strcat "(setq newtile $key)"
                                          "(FAST_READ_DIM_FILE)"))
	(action_tile "round_head_m" (strcat "(setq newtile $key)"
                                            "(FAST_READ_DIM_FILE)"))
	(action_tile "socket_head_m" (strcat "(setq newtile $key)"
                                             "(FAST_READ_DIM_FILE)"))
	(action_tile "set_screw_m_cup" (strcat "(setq newtile $key)"
                                               "(FAST_READ_DIM_FILE)"))
  	(action_tile "set_screw_m_dog" (strcat "(setq newtile $key)"
                                               "(FAST_READ_DIM_FILE)"))
	(action_tile "stud_m" (strcat "(setq newtile $key)"
                                      "(FAST_READ_DIM_FILE)"))
	(action_tile "get_size" (strcat "(setq index (atoi $value))"
	         "(setq size (strcase (nth index display_list)))"
                 "(FAST_DIM_LIST)"))
	(action_tile "2d_top" (strcat "(setq which_view $key)"
                                      "(mode_2d_top)"))
        (action_tile "2d_side" (strcat "(setq which_view $key)"
                                       "(mode_2d_side)"))
        (action_tile "3d_solid" (strcat "(setq which_view $key)"
                                        "(mode_3d_solid)"))
	
	(action_tile "washer_none" "(setq w $key)")
	(action_tile "washer_lock" "(setq w $key)")
	(action_tile "washer_flat" "(setq w $key)")
	(action_tile "washer_both" "(setq w $key)")
	(action_tile "thread_coarse" (strcat "(setq thread $key)" "(FAST_DIM_LIST)"))
	(action_tile "thread_fine" (strcat "(setq thread $key)" "(FAST_DIM_LIST)"))
        (action_tile "shank" (strcat "(setq shank $value)"
                                     "(mode_shank)"))
        (action_tile "shank_length" "(setq lg (distof $value 2))")
	(action_tile "thread_length" "(setq td (distof $value 2))")
	(action_tile "met_scale" (strcat "(setq scale $value)"
                                "(if (/= size nil) (FAST_DIM_LIST))"))
        (action_tile "accept" "(FAST_CHECK_SELECTIONS)")
       	(action_tile "cancel" (strcat "(done_dialog)"
                                    "(setq newtile nil size nil)"
                                    "(exit)"))
	(action_tile "fast_help" "(fast_help)")
	
(start_dialog)				;display the dialog box
(unload_dialog dcl_id)			;unload the DCL file
	
);end FAST_DIALOG
;--------------------------------------------------------------------;
(defun C:CPack_Fasteners (/ newtile size which_view display_list index w thread
shank lg td scale fast_dim_file)
(setq olderr *error* 
      *error* fast_err)
(setq os (getvar "OSMODE"))
(setq plw (getvar "PLINEWID"))
(setvar "PLINEWID" 0)
(setvar "ISOLINES" 24)
(FAST_DIALOG)
(DRAW_FAST)
(setvar "ISOLINES" 0)
(setvar "PLINEWID" plw)
(setvar "OSMODE" os)
(setq *error* olderr); Restore old *error* handler
(princ)
);end FAST
;Print message once loaded.
(princ "\nStakTools Fastener Bin Loaded. Type FAST to use.")
(princ)

 
