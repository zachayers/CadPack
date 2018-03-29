;; ERROR HANDLER
;;
(defun *error* (msg)
  (setvar "CMDECHO" echo)
  (setvar "BLIPMODE" blip)
  (setq *error* err)
  (princ)
)


;; DEFINE ACTION TILES
;;
(defun get_actions ()

;; THIS IS THE WELD SYMBOL LIST
;;
  (setq weld_list
    (list "- None -"
          "Back or Backing"
          "Bevel"
          "Fillet"
          "Flange-Corner"
          "Flange-Edge"
          "Flare-Bevel"
          "Flare-V"
          "J"
          "Plug or Slot"
          "Seam"
          "Spot or Projection"
          "Square"
          "Surfacing"
          "U"
          "V"
    )
  )
  (start_list "weld_type_near")
  (mapcar 'add_list weld_list)
  (end_list)

  (if weld_type_near (set_tile "weld_type_near" (itoa weld_type_near)))
  (action_tile "weld_type_near" "(setq weld_type_near (atoi $value)) (gray 0)")

  (start_list "weld_type_far")
  (mapcar 'add_list weld_list)
  (end_list)

  (if weld_type_far (set_tile "weld_type_far" (itoa weld_type_far)))
  (action_tile "weld_type_far" "(setq weld_type_far (atoi $value)) (gray 0)")

;; THIS IS THE FINISH SYMBOL LIST
;;
  (setq finish_list
    (list "- None -"
          "Chipping"
          "Grinding"
          "Hammering"
          "Machining"
          "Rolling"
          "Unspecified"
    )
  )
  (start_list "finish_near")
  (mapcar 'add_list finish_list)
  (end_list)

  (if finish_near (set_tile "finish_near" (itoa finish_near)))
  (action_tile "finish_near" "(setq finish_near (atoi $value))")

  (start_list "finish_far")
  (mapcar 'add_list finish_list)
  (end_list)

  (if finish_far (set_tile "finish_far" (itoa finish_far)))
  (action_tile "finish_far" "(setq finish_far (atoi $value))")

;; THIS IS THE CONTOUR LIST
;;
  (setq contour_list
    (list "- None -"
          "Flush"
          "Concave"
          "Convex"
    )
  )
  (start_list "contour_near")
  (mapcar 'add_list contour_list)
  (end_list)

  (if contour_near (set_tile "contour_near" (itoa contour_near)))
  (action_tile "contour_near" "(setq contour_near (atoi $value)) (gray 0)")

  (start_list "contour_far")
  (mapcar 'add_list contour_list)
  (end_list)

  (if contour_far (set_tile "contour_far" (itoa contour_far)))
  (action_tile "contour_far" "(setq contour_far (atoi $value)) (gray 0)")

  (set_tile "weld_size_near" weld_size_near)
  (set_tile "weld_size_far" weld_size_far)
  (set_tile "throat_near" throat_near)
  (set_tile "throat_far" throat_far)

  (set_tile "pitch_near" pitch_near)
  (set_tile "pitch_far" pitch_far)
  (set_tile "spot_qty_near" spot_qty_near)
  (set_tile "spot_qty_far" spot_qty_far)
  (set_tile "weld_ang_near" weld_ang_near)
  (set_tile "weld_ang_far" weld_ang_far)
  (set_tile "depth_near" depth_near)
  (set_tile "depth_far" depth_far)

  (set_tile "melt_thru" (itoa melt_thru))
  (set_tile "stagger" (itoa stagger))
  (set_tile "weld_all_around" (itoa weld_all_around))
  (set_tile "field_weld" (itoa field_weld))
  (set_tile "tail" (itoa tail))

  (action_tile "melt_thru" "(setq melt_thru (atoi $value)) (gray 0)")
  (action_tile "stagger" "(setq stagger (atoi $value))")
  (action_tile "weld_all_around" "(setq weld_all_around (atoi $value))")
  (action_tile "field_weld" "(setq field_weld (atoi $value))")
  (action_tile "tail" "(setq tail (atoi $value))")
  (action_tile "weld_size_near" "(setq weld_size_near $value)")
  (action_tile "weld_size_far" "(setq weld_size_far $value)")
  (action_tile "throat_near" "(setq throat_near $value)")
  (action_tile "throat_far" "(setq throat_far $value)")
  (action_tile "pitch_near" "(setq pitch_near $value)")
  (action_tile "pitch_far" "(setq pitch_far $value)")
  (action_tile "spot_qty_near" "(setq spot_qty_near $value)")
  (action_tile "spot_qty_far" "(setq spot_qty_far $value)")
  (action_tile "weld_ang_near" "(setq weld_ang_near $value)")
  (action_tile "weld_ang_far" "(setq weld_ang_far $value)")
  (action_tile "depth_near" "(setq depth_near $value)")
  (action_tile "depth_far" "(setq depth_far $value)")

  (action_tile "accept" "(chk_input)")
  (action_tile "cancel" "(setq stop_this 0)")
  (action_tile "help" "(help_me)")
  (action_tile "info" "(tell_about)")
)


;; LOAD DIALOG, CHECK IT, AND START IT
;;
(defun do_dialog_now ()
  (setq dcl_id (load_dialog "WELD.DCL"))

  (if (not (new_dialog "weld" dcl_id)) (exit))
  (get_actions)
  (gray 0)
  (start_dialog)
  (unload_dialog dcl_id)

  (princ)
)


;; CHK_INPUT SUB-ROUTINE
;; CHECK IF EVERYTHING IS OKAY
;;
(defun chk_input ()
  (setq done_yet 0)

;; SEE IF ANYTHING TO DO
;;
  (if (= (+ weld_type_near weld_type_far) 0)
    (progn
      (alert "Error!\n\nWeldment undefined.\nPlease select weld type or Cancel.")
      (setq done_yet 1)
    )
  )

;; CLOSE DIALOG IF ALL IS WELL
;;
  (if (= done_yet 0) (done_dialog))
)


;; TELL_ABOUT SUB-ROUTINE
;;
(defun tell_about ()
  (setq dcl_id1 (load_dialog "WELD.DCL"))
  (if (not (new_dialog "weld_info" dcl_id1)) (exit))

  (setq info_list
    (list
     "WELD.LSP, Version 1.0"   
    )
  )
  (start_list "info_text")
  (mapcar 'add_list info_list)
  (end_list)

  (if info_text (set_tile "info_text" (itoa info_text)))

  (start_dialog)
  (unload_dialog dcl_id1)
)


;; HELP_ME SUB-ROUTINE
;;
(defun help_me ()
  (setq dcl_id2 (load_dialog "WELD.DCL"))
  (if (not (new_dialog "weld_help" dcl_id2)) (exit))

  (setq help_list
    (list
      "OK:"
      "  Provided sufficient parameters have been selected, this"
      "  button will close the dialog and you will be promted"
      "  for the starting point for the leader. This will be"
      "  where the arrowhead will start. You will then be"
      "  prompted for succesive points. When you are done"
      "  defining the leader, press <Enter> and the weld symbol"
      "  will be constructed, starting at the last point entered."
      ""
      "Cancel:"
      "  This button closes the dialog and terminates the program."
      ""
      "Help:"
      "  This button displays this help screen."
      ""
      "Info:"
      "  This button displays information about this program."
      "________________________________________________"
      ""
      "Weld Type:"
      "  Select from these lists, the type of weld desired."
      "  Selection can be made from either or both sides. A"
      "  message will appear if no weld is selected from"
      "  either side. The selection made here will be the"
      "  basic weld symbol created."
      ""
      "Weld Size:"
      "  Enter in these spaces, the size of the weld desired."
      "  These fields may be left blank. The values entered"
      "  here will be placed to the left of the basic weld"
      "  symbol."
      ""
      "Effective Throat:"
      "  Enter in these spaces, the effective throat dimension."
      "  The ( ) will be added automatically. These fields may be"
      "  left blank. The values entered here will placed between"
      "  the weld size and the basic weld symbol."
      ""
      "Length-Pitch:"
      "  Enter in these spaces, the length and/or pitch of the"
      "  desired weld. Be sure to seperate values with a '-' if"
      "  both length and pitch are to be specified. These fields"
      "  may be left blank. The values entered here will placed"
      "  To the right of the basic weld symbol."
      ""
      "Groove/C-Sink Angle:"
      "  Enter in these spaces, the angle for groove welds or"
      "  plug welds. The degree symbol will be added"
      "  automatically. These fields may be left blank. The"
      "  values entered here will be placed directly above or"
      "  below the basic weld symbol."
      ""
      "Spot/Projection Weld Quantity:"
      "  Enter in these spaces, the number of spot or projection"
      "  welds required. The ( ) will be added automatically."
      "  These fields may be left blank. The values entered here"
      "  will be placed directly above or below the basic weld"
      "  symbol."
      ""
      "Root Opening or Depth:"
      "  Enter in these spaces, the root opening or the depth for"
      "  groove, plug, and slot welds. These fields may be left"
      "  blank. The values entered here will be placed above"
      "  the weld size values."
      ""
      "Finish Symbol:"
      "  Select from these lists, the desired finish symbol."
      "  These symbols are related only to the contour symbols"
      "  and, therefore, will not apply if the contour is set to"
      "  NONE. The default is NONE. The selected finish symbol"
      "  will be placed directly below or above the contour"
      "  symbol."
      ""
      "Contour Symbol:"
      "  Select from these lists, the desired contour symbol."
      "  The default value is NONE. The contour symbol does not"
      "  apply to all types of welds and will be corrected"
      "  automatically. The selected contour symbol will be placed"
      "  directly below or above the basic weld symbol or the"
      "  groove angle values."
      "________________________________________________"
      ""
      "Melt Thru:"
      "  Check this box if the weld is required to melt through."
      "  This parameter has no both side significance. If a weld"
      "  type is selected for both sides, the melt through value"
      "  is not applied and will be reset. Contour symbols apply"
      "  to melt through operations, therefore, the near or far"
      "  side contour symbol may be applied to the melt through"
      "  symbol, if desired. The default value is off. The melt"
      "  through symbol will be added to the opposite side of the"
      "  basic weld symbol."
      ""
      "Stagger:"
      "  Check this box if staggering of welds is desired. This"
      "  parameter is only effective for welds on both sides and"
      "  is reset if only 1 side is selected. Also, this parameter"
      "  is useless for certain welds and is reset if this"
      "  condition is encountered. The default value is off. This"
      "  parameter causes the basic weld symbols to be offset"
      "  from each other."
      ""
      "Weld All Around:"
      "  Check this box when a weld all around operation is"
      "  required. This parameter is not effective for certain"
      "  welds and is reset if this condition is encountered. The"
      "  default value is off. This parameter places a weld all"
      "  around symbol (circle) at the end point of the reference"
      "  line."
      ""
      "Field Weld:"
      "  Check this box when field weld operations are required."
      "  The default value is off. This parameter places a field"
      "  weld symbol (flag) at the end point of the reference line."
      "  The flag will always point towards the tail."
      ""
      "Tail:"
      "  Check this box when a tail is required on the completed"
      "  weld symbol. The default value is off. The notation,"
      "  'TYP.' will be inserted as the default notation. This"
      "  text can be edited."
    )
  )
  (start_list "help_text")
  (mapcar 'add_list help_list)
  (end_list)

  (if help_text (set_tile "help_text" (itoa help_text)))

  (if (findfile "WELDS.SLB")
    (progn
      (action_tile "slide1" "(do_slide1)")
      (action_tile "slide2" "(do_slide2)")
    )
    (progn
      (mode_tile "slide1" 1)
      (mode_tile "slide2" 1)
      (alert "Error!\n\nFile not found: WELDS.SLB\nShow & Details buttons disabled.")
    )
  )

  (start_dialog)
  (unload_dialog dcl_id2)
)


;; DO_SLIDE1 SUB-ROUTINE
;;
(defun do_slide1 ()
  (setq dcl_id3 (load_dialog "WELD.DCL"))
  (if (not (new_dialog "viewslide" dcl_id3)) (exit))

  (setq x (dimx_tile "welds"))
  (setq y (dimy_tile "welds"))
  (start_image "welds")
  (slide_image 0 0 x y "WELDS(WELD1)")
  (end_image)

  (start_dialog)
  (unload_dialog dcl_id3)
)


;; DO_SLIDE2 SUB-ROUTINE
;;
(defun do_slide2 ()
  (setq dcl_id3 (load_dialog "WELD.DCL"))
  (if (not (new_dialog "viewslide" dcl_id3)) (exit))

  (setq x (dimx_tile "welds"))
  (setq y (dimy_tile "welds"))
  (start_image "welds")
  (slide_image 0 0 x y "WELDS(WELD2)")
  (end_image)

  (start_dialog)
  (unload_dialog dcl_id3)
)


;; CHECK_WELD SUB-ROUTINE
;;
(defun check_weld ()
  (cond
    ((= 0  weld_type_near) (setq weld_symbol "")) ;; None
    ((= 1  weld_type_near) (back_near))           ;; Back or Backing
    ((= 2  weld_type_near) (bevel_near))          ;; Bevel
    ((= 3  weld_type_near) (fillet_near))         ;; Fillet
    ((= 4  weld_type_near) (corn_near))           ;; Flange-Corner
    ((= 5  weld_type_near) (edge_near))           ;; Flange-Edge
    ((= 6  weld_type_near) (bflare_near))         ;; Flare-Bevel
    ((= 7  weld_type_near) (vflare_near))         ;; Flare-V
    ((= 8  weld_type_near) (j_near))              ;; J
    ((= 9  weld_type_near) (plug_near))           ;; Plug or Slot
    ((= 10 weld_type_near) (seam_near))           ;; Seam
    ((= 11 weld_type_near) (spot_near))           ;; Spot or Projection
    ((= 12 weld_type_near) (square_near))         ;; Square
    ((= 13 weld_type_near) (surf_near))           ;; Surfacing
    ((= 14 weld_type_near) (u_near))              ;; U
    ((= 15 weld_type_near) (vee_near))            ;; V
  )
  (cond
    ((= 0  weld_type_far) (setq weld_symbol "")) ;; None
    ((= 1  weld_type_far) (back_far))            ;; Back or Backing
    ((= 2  weld_type_far) (bevel_far))           ;; Bevel
    ((= 3  weld_type_far) (fillet_far))          ;; Fillet
    ((= 4  weld_type_far) (corn_far))            ;; Flange-Corner
    ((= 5  weld_type_far) (edge_far))            ;; Flange-Edge
    ((= 6  weld_type_far) (bflare_far))          ;; Flare-Bevel
    ((= 7  weld_type_far) (vflare_far))          ;; Flare-V
    ((= 8  weld_type_far) (j_far))               ;; J
    ((= 9  weld_type_far) (plug_far))            ;; Plug or Slot
    ((= 10 weld_type_far) (seam_far))            ;; Seam
    ((= 11 weld_type_far) (spot_far))            ;; Spot or Projection
    ((= 12 weld_type_far) (square_far))          ;; Square
    ((= 13 weld_type_far) (surf_far))            ;; Surfacing
    ((= 14 weld_type_far) (u_far))               ;; U
    ((= 15 weld_type_far) (vee_far))             ;; V
  )
)


;; GET_POINTS SUB-ROUTINE
;; This function draws the leader
;;
(defun get_points ()
  (setq pt1 (getpoint "\nStart point: "))
  (setvar "OSMODE" 16384)
  (setq pt2 (getpoint pt1 "\nTo point: "))

  (command "LEADER" pt1 pt2 "" "" "N")

;; CONTINUE GETTING SUCCESIVE POINTS UNTIL STOP
;;
  (while (setq temp_pt (getpoint pt2 "\nTo point: "))
    (command "LINE" pt2 temp_pt "")
    (setq pt1 pt2 pt2 temp_pt)
  )

;; GET CURRENT TEXT WIDTH TO MAKE APPROXIMATE ADJUSTMENTS
;;
  (setq text_width (cdr (assoc 41 (tblsearch "STYLE" (getvar "DIMTXSTY")))))

;; SET POINT 3
;;
  (if (= (strlen throat_near) 0)
    (setq weld_throat_near weld_size_near)
    (setq weld_throat_near (strcat weld_size_near "(" throat_near ")"))
  )
  (if (= (strlen throat_far) 0)
    (setq weld_throat_far weld_size_far)
    (setq weld_throat_far (strcat weld_size_far "(" throat_far ")"))
  )
  (setq weld_len (max (strlen weld_throat_near) (strlen weld_throat_far)))
  (if (> weld_len 5) (setq add_len (* (- weld_len 5) text_width)) (setq add_len 0))

  (setq pitch_len (max (strlen pitch_near) (strlen pitch_far)))
  (if (= pitch_len 0) (setq pitch_len text_width) (setq pitch_len (+ (* pitch_len text_width) 0.75)))

  (if (or (<= (angle pt1 pt2) (/ pi 2)) (> (angle pt1 pt2) (+ (/ pi 2) pi)))
    (progn
      (if (or (/= weld_type_near 0) (/= weld_type_far 0))
        (setq pt3 (list (+ (car pt2) (* dim_scale (+ 10.0 pitch_len add_len))) (cadr pt2)))
      )
      (setq ref_pt pt2)
    )
    (progn
      (if (or (/= weld_type_near 0) (/= weld_type_far 0))
        (setq pt3 (list (- (car pt2) (* dim_scale (+ 10.0 pitch_len add_len))) (cadr pt2)))
      )
      (setq ref_pt pt3)
    )
  )
  (command "LINE" pt2 pt3 "")
  (if (= stagger 1) (setq offset 0.25) (setq offset 0))
)


;; MAKE_SYMBOL SUB-ROUTINE
;;
(defun make_symbol ()

;; MAKE WELD ALL AROUND CIRCLE 
;;
  (if (= weld_all_around 1)
    (command "CIRCLE" pt2 (* dim_scale 0.75))
  )

;; MAKE FIELD WELD FLAG
;;
  (if (= field_weld 1)
    (progn
      (command "LINE" pt2 (list (car pt2) (+ (cadr pt2) (* dim_scale 3.125))) "")
      (if (= (angle pt2 pt3) 0)
        (command "SOLID" 
          (list (car pt2) (+ (cadr pt2) (* dim_scale 3.125)))
          (list (car pt2) (+ (cadr pt2) (* dim_scale 2.175)))
          (list
            (+ (car pt2) (* dim_scale 1.6))
            (+ (cadr pt2) (* dim_scale 2.65))
          ) "" ""
        )
        (command "SOLID" 
          (list (car pt2) (+ (cadr pt2) (* dim_scale 3.125)))
          (list (car pt2) (+ (cadr pt2) (* dim_scale 2.175)))
          (list
            (- (car pt2) (* dim_scale 1.6))
            (+ (cadr pt2) (* dim_scale 2.65))
          ) "" ""
        )
      )
    )
  )

;; MAKE REFERENCE TAIL
;;
  (if (= tail 1)
    (if (= (angle pt2 pt3) 0)
      (progn
        (command "LINE" pt3
          (list
            (+ (car pt3) (* dim_scale 1.4))
            (+ (cadr pt3) (* dim_scale 1.4))
          ) ""
        )
        (command "LINE" pt3
          (list
            (+ (car pt3) (* dim_scale 1.4))
            (- (cadr pt3) (* dim_scale 1.4))
          ) ""
        )
        (command "TEXT" "ML" (list (+ (car pt3) (* dim_scale 1.25)) (cadr pt3))
          dim_scale "0" "TYP."
        )
      )
      (progn
        (command "LINE" pt3
          (list
            (- (car pt3) (* dim_scale 1.4))
            (+ (cadr pt3) (* dim_scale 1.4))
          ) ""
        )
        (command "LINE" pt3
          (list
            (- (car pt3) (* dim_scale 1.4))
            (- (cadr pt3) (* dim_scale 1.4))
          ) ""
        )
        (command "TEXT" "S" (getvar "DIMTXSTY") "MR"
          (list (- (car pt3) (* dim_scale 1.25)) (cadr pt3))
           dim_scale "0" "TYP."
        )
      )
    )
  )
)


;; MAKE_REFS SUB-ROUTINE
;;
(defun make_refs ()

;; INSERT WELD SIZE, EFFECTIVE THROAT, PITCH-LENGTH, AND ROOT-DEPTH
;;
  (if (/= weld_type_near 0)
    (progn
      (command "TEXT" "S" (getvar "DIMTXSTY") "TC"
        (list (+ (car ref_pt) (* dim_scale (+ 3.0 (/ add_len 2.0)))) (- (cadr ref_pt) (* dim_scale 0.5)))
        dim_scale "0" weld_throat_near
      )
      (command "TEXT" "S" (getvar "DIMTXSTY") "TL"
        (list (+ (car ref_pt) (* dim_scale (+ 9.5 add_len))) (- (cadr ref_pt) (* dim_scale 0.5)))
         dim_scale "0" pitch_near
      )
      (command "TEXT" "S" (getvar "DIMTXSTY") "TR"
        (list (+ (car ref_pt) (* dim_scale (+ 4.5 (/ add_len 2.0)))) (- (cadr ref_pt) (* dim_scale 2.0)))
        dim_scale "0" depth_near
      )
    )
  )
  (if (/= weld_type_far 0)
    (progn
      (command "TEXT" "S" (getvar "DIMTXSTY") "C"
        (list (+ (car ref_pt) (* dim_scale (+ 3.0 (/ add_len 2.0)))) (+ (cadr ref_pt) (* dim_scale 0.5)))
         dim_scale "0" weld_throat_far
      )
      (command "TEXT" "S" (getvar "DIMTXSTY")
        (list (+ (car ref_pt) (* dim_scale (+ 9.5 add_len))) (+ (cadr ref_pt) (* dim_scale 0.5)))
         dim_scale "0" pitch_far
      )
      (command "TEXT" "S" (getvar "DIMTXSTY") "R"
        (list (+ (car ref_pt) (* dim_scale (+ 4.5 (/ add_len 2.0)))) (+ (cadr ref_pt) (* dim_scale 2.0)))
        dim_scale "0" depth_far
      )
    )
  )
)


;; ADD_CONTOUR SUB-ROUTINE
;;
(defun add_contour ()

;; GET FINISH SYMBOL
;;
  (cond
    ((= finish_near 0) (setq finish_sym_near nil))
    ((= finish_near 1) (setq finish_sym_near "C"))
    ((= finish_near 2) (setq finish_sym_near "G"))
    ((= finish_near 3) (setq finish_sym_near "H"))
    ((= finish_near 4) (setq finish_sym_near "M"))
    ((= finish_near 5) (setq finish_sym_near "R"))
    ((= finish_near 6) (setq finish_sym_near "U"))
  )
  (cond
    ((= finish_far 0) (setq finish_sym_far nil))
    ((= finish_far 1) (setq finish_sym_far "C"))
    ((= finish_far 2) (setq finish_sym_far "G"))
    ((= finish_far 3) (setq finish_sym_far "H"))
    ((= finish_far 4) (setq finish_sym_far "M"))
    ((= finish_far 5) (setq finish_sym_far "R"))
    ((= finish_far 6) (setq finish_sym_far "U"))
  )


;; PLACE CONTOUR SYMBOL
;;
  (if
    (or
      (= (member weld_type_near '(0 3 10 11)) nil)
      (and
        (= melt_thru 1)
        (= weld_type_near 0)
        (= (member weld_type_far '(0 1 3 4 5 9 10 11 13)) nil)
      )
    )
    (progn
      (cond
        ((= contour_near 1)
          (command "LINE"
            (list (+ (car ref_pt) (* dim_scale (- (+ 5.8 add_len) offset))) (- (cadr ref_pt) (* dim_scale y_near)))
            (list (+ (car ref_pt) (* dim_scale (- (+ 8.2 add_len) offset))) (- (cadr ref_pt) (* dim_scale y_near))) ""
          )
        )
        ((= contour_near 2)
          (command "ARC"
            (list (+ (car ref_pt) (* dim_scale (- (+ 5.8 add_len) offset))) (- (cadr ref_pt) (* dim_scale (+ y_near 0.2))))
            (list (+ (car ref_pt) (* dim_scale (- (+ 7.0 add_len) offset))) (- (cadr ref_pt) (* dim_scale (- y_near 0.12))))
            (list (+ (car ref_pt) (* dim_scale (- (+ 8.2 add_len) offset))) (- (cadr ref_pt) (* dim_scale (+ y_near 0.2))))
          )
        )
        ((= contour_near 3)
          (command "ARC"
            (list (+ (car ref_pt) (* dim_scale (- (+ 5.8 add_len) offset))) (- (cadr ref_pt) (* dim_scale y_near)))
            (list (+ (car ref_pt) (* dim_scale (- (+ 7.0 add_len) offset))) (- (cadr ref_pt) (* dim_scale (+ y_near 0.32))))
            (list (+ (car ref_pt) (* dim_scale (- (+ 8.2 add_len) offset))) (- (cadr ref_pt) (* dim_scale y_near)))
          )
        )
      )
      (if (/= contour_near 0)
        (command "TEXT" "S" (getvar "DIMTXSTY") "TC"
          (list (+ (car ref_pt) (* dim_scale (- (+ 7.0 add_len) offset))) (- (cadr ref_pt) (* dim_scale (+ y_near 0.5))))
          dim_scale "0" finish_sym_near
        )
      )
    )
  )
  (if
    (or
      (= (member weld_type_far '(0 3 10 11)) nil)
      (and
        (= melt_thru 1)
        (= weld_type_far 0)
        (= (member weld_type_near '(0 1 3 4 5 9 10 11 13)) nil)
      )
    )
    (progn
      (cond
        ((= contour_far 1)
          (command "LINE"
            (list (+ (car ref_pt) (* dim_scale (+ (+ 5.8 add_len) offset))) (+ (cadr ref_pt) (* dim_scale y_far)))
            (list (+ (car ref_pt) (* dim_scale (+ (+ 8.2 add_len) offset))) (+ (cadr ref_pt) (* dim_scale y_far))) ""
          )
        )
        ((= contour_far 2)
          (command "ARC"
            (list (+ (car ref_pt) (* dim_scale (+ (+ 5.8 add_len) offset))) (+ (cadr ref_pt) (* dim_scale (+ y_far 0.2))))
            (list (+ (car ref_pt) (* dim_scale (+ (+ 7.0 add_len) offset))) (+ (cadr ref_pt) (* dim_scale (- y_far 0.12))))
            (list (+ (car ref_pt) (* dim_scale (+ (+ 8.2 add_len) offset))) (+ (cadr ref_pt) (* dim_scale (+ y_far 0.2))))
          )
        )
        ((= contour_far 3)
          (command "ARC"
            (list (+ (car ref_pt) (* dim_scale (+ (+ 5.8 add_len) offset))) (+ (cadr ref_pt) (* dim_scale y_far)))
            (list (+ (car ref_pt) (* dim_scale (+ (+ 7.0 add_len) offset))) (+ (cadr ref_pt) (* dim_scale (+ y_far 0.32))))
            (list (+ (car ref_pt) (* dim_scale (+ (+ 8.2 add_len) offset))) (+ (cadr ref_pt) (* dim_scale y_far)))
          )
        )
      )
      (if (/= contour_far 0)
        (command "TEXT" "S" (getvar "DIMTXSTY") "C"
          (list (+ (car ref_pt) (* dim_scale (+ (+ 7.0 add_len) offset))) (+ (cadr ref_pt) (* dim_scale (+ y_far 0.5))))
          dim_scale "0" finish_sym_far
        )
      )
    )
  )

;; IF IT IS A FILLET, ADJUST THE CONTOUR SYMBOL
;;
  (if (= weld_type_near 3)
    (progn
      (cond
        ((= contour_near 1)
          (command "LINE"
            (list (+ (car ref_pt) (* dim_scale (- (+ 8.45 add_len) offset))) (- (cadr ref_pt) (* dim_scale 0.35)))
            (list (+ (car ref_pt) (* dim_scale (- (+ 6.85 add_len) offset))) (- (cadr ref_pt) (* dim_scale 1.95))) ""
          )
        )
        ((= contour_near 2)
          (command "ARC"
            (list (+ (car ref_pt) (* dim_scale (- (+ 8.56 add_len) offset))) (- (cadr ref_pt) (* dim_scale 0.46)))
            (list (+ (car ref_pt) (* dim_scale (- (+ 7.54 add_len) offset))) (- (cadr ref_pt) (* dim_scale 1.04)))
            (list (+ (car ref_pt) (* dim_scale (- (+ 6.96 add_len) offset))) (- (cadr ref_pt) (* dim_scale 2.06)))
          )
        )
        ((= contour_near 3)
          (command "ARC"
            (list (+ (car ref_pt) (* dim_scale (- (+ 8.34 add_len) offset))) (- (cadr ref_pt) (* dim_scale 0.24)))
            (list (+ (car ref_pt) (* dim_scale (- (+ 7.76 add_len) offset))) (- (cadr ref_pt) (* dim_scale 1.26)))
            (list (+ (car ref_pt) (* dim_scale (- (+ 6.74 add_len) offset))) (- (cadr ref_pt) (* dim_scale 1.84)))
          )
        )
      )
      (command "TEXT" "S" (getvar "DIMTXSTY") "TC"
        (list (+ (car ref_pt) (* dim_scale (+ (+ 7.8 add_len) offset))) (- (cadr ref_pt) (* dim_scale 2.0)))
        dim_scale "0" finish_sym_near
      )
    )
  )
  (if (= weld_type_far 3)
    (progn
      (cond
        ((= contour_far 1)
          (command "LINE"
            (list (+ (car ref_pt) (* dim_scale (+ (+ 8.45 add_len) offset))) (+ (cadr ref_pt) (* dim_scale 0.35)))
            (list (+ (car ref_pt) (* dim_scale (+ (+ 6.85 add_len) offset))) (+ (cadr ref_pt) (* dim_scale 1.95))) ""
          )
        )
        ((= contour_far 2)
          (command "ARC"
            (list (+ (car ref_pt) (* dim_scale (+ (+ 8.56 add_len) offset))) (+ (cadr ref_pt) (* dim_scale 0.46)))
            (list (+ (car ref_pt) (* dim_scale (+ (+ 7.54 add_len) offset))) (+ (cadr ref_pt) (* dim_scale 1.04)))
            (list (+ (car ref_pt) (* dim_scale (+ (+ 6.96 add_len) offset))) (+ (cadr ref_pt) (* dim_scale 2.06)))
          )
        )
        ((= contour_far 3)
          (command "ARC"
            (list (+ (car ref_pt) (* dim_scale (+ (+ 8.34 add_len) offset))) (+ (cadr ref_pt) (* dim_scale 0.24)))
            (list (+ (car ref_pt) (* dim_scale (+ (+ 7.76 add_len) offset))) (+ (cadr ref_pt) (* dim_scale 1.26)))
            (list (+ (car ref_pt) (* dim_scale (+ (+ 6.74 add_len) offset))) (+ (cadr ref_pt) (* dim_scale 1.84)))
          )
        )
      )
      (command "TEXT" "S" (getvar "DIMTXSTY") "C"
        (list (+ (car ref_pt) (* dim_scale (+ (+ 7.8 add_len) offset))) (+ (cadr ref_pt) (* dim_scale 2.0)))
        dim_scale "0" finish_sym_far
      )
    )
  )
)


;; SEAM_NEAR SUB-ROUTINE
;;
(defun seam_near ()
  (command "CIRCLE"
    (list (+ (car ref_pt) (* dim_scale (+ 7.0 add_len))) (- (cadr ref_pt) dim_scale))
    dim_scale
  )
  (command "LINE" 
    (list (+ (car ref_pt) (* dim_scale (+ 5.5 add_len))) (- (cadr ref_pt) (* dim_scale 0.5)))
    (list (+ (car ref_pt) (* dim_scale (+ 8.5 add_len))) (- (cadr ref_pt) (* dim_scale 0.5))) ""
  )
  (command "LINE" 
    (list (+ (car ref_pt) (* dim_scale (+ 5.5 add_len))) (- (cadr ref_pt) (* dim_scale 1.5)))
    (list (+ (car ref_pt) (* dim_scale (+ 8.5 add_len))) (- (cadr ref_pt) (* dim_scale 1.5))) ""
  )
)


;; SEAM_FAR SUB-ROUTINE
;;
(defun seam_far ()
  (if (= 10 weld_type_near)
    (progn
      (command "ERASE" "L" "" "ERASE" "L" "" "ERASE" "L" "")
      (command "CIRCLE"
        (list (+ (car ref_pt) (* dim_scale (+ 7.0 add_len))) (cadr ref_pt))
        dim_scale
      )
      (command "LINE" 
        (list (+ (car ref_pt) (* dim_scale (+ 5.5 add_len))) (- (cadr ref_pt) (* dim_scale 0.5)))
        (list (+ (car ref_pt) (* dim_scale (+ 8.5 add_len))) (- (cadr ref_pt) (* dim_scale 0.5))) ""
      )
      (command "LINE" 
        (list (+ (car ref_pt) (* dim_scale (+ 5.5 add_len))) (+ (cadr ref_pt) (* dim_scale 0.5)))
        (list (+ (car ref_pt) (* dim_scale (+ 8.5 add_len))) (+ (cadr ref_pt) (* dim_scale 0.5))) ""
      )
    )
    (progn
      (command "CIRCLE"
        (list (+ (car ref_pt) (* dim_scale (+ 7.0 add_len))) (+ (cadr ref_pt) dim_scale))
        dim_scale
      )
      (command "LINE" 
        (list (+ (car ref_pt) (* dim_scale (+ 5.5 add_len))) (+ (cadr ref_pt) (* dim_scale 0.5)))
        (list (+ (car ref_pt) (* dim_scale (+ 8.5 add_len))) (+ (cadr ref_pt) (* dim_scale 0.5))) ""
      )
      (command "LINE" 
        (list (+ (car ref_pt) (* dim_scale (+ 5.5 add_len))) (+ (cadr ref_pt) (* dim_scale 1.5)))
        (list (+ (car ref_pt) (* dim_scale (+ 8.5 add_len))) (+ (cadr ref_pt) (* dim_scale 1.5))) ""
      )
    )
  )
)


;; SURF_NEAR SUB-ROUTINE
;;
(defun surf_near ()
  (command "ARC" "C"
    (list (+ (car ref_pt) (* dim_scale (+ 6.0 add_len))) (cadr ref_pt))
    (list (+ (car ref_pt) (* dim_scale (+ 5.0 add_len))) (cadr ref_pt))
    (list (+ (car ref_pt) (* dim_scale (+ 7.0 add_len))) (cadr ref_pt))
  )
  (command "ARC" "C"
    (list (+ (car ref_pt) (* dim_scale (+ 8.0 add_len))) (cadr ref_pt))
    (list (+ (car ref_pt) (* dim_scale (+ 7.0 add_len))) (cadr ref_pt))
    (list (+ (car ref_pt) (* dim_scale (+ 9.0 add_len))) (cadr ref_pt))
  )
  (setq y_near 1.75)
)


;; SURF_FAR SUB-ROUTINE
;;
(defun surf_far ()
  (command "ARC" "C"
    (list (+ (car ref_pt) (* dim_scale (+ 6.0 add_len))) (cadr ref_pt))
    (list (+ (car ref_pt) (* dim_scale (+ 7.0 add_len))) (cadr ref_pt))
    (list (+ (car ref_pt) (* dim_scale (+ 5.0 add_len))) (cadr ref_pt))
  )
  (command "ARC" "C"
    (list (+ (car ref_pt) (* dim_scale (+ 8.0 add_len))) (cadr ref_pt))
    (list (+ (car ref_pt) (* dim_scale (+ 9.0 add_len))) (cadr ref_pt))
    (list (+ (car ref_pt) (* dim_scale (+ 7.0 add_len))) (cadr ref_pt))
  )
  (setq y_far 1.75)
)


;; BACK_NEAR SUB-ROUTINE
;;
(defun back_near ()
  (command "ARC" "C"
    (list (+ (car ref_pt) (* dim_scale (+ 7.0 add_len))) (cadr ref_pt))
    (list (+ (car ref_pt) (* dim_scale (+ 6.0 add_len))) (cadr ref_pt))
    (list (+ (car ref_pt) (* dim_scale (+ 8.0 add_len))) (cadr ref_pt))
  )
  (setq y_near 1.75)
)


;; BACK_FAR SUB-ROUTINE
;;
(defun back_far ()
  (command "ARC" "C"
    (list (+ (car ref_pt) (* dim_scale (+ 7.0 add_len))) (cadr ref_pt))
    (list (+ (car ref_pt) (* dim_scale (+ 8.0 add_len))) (cadr ref_pt))
    (list (+ (car ref_pt) (* dim_scale (+ 6.0 add_len))) (cadr ref_pt))
  )
  (setq y_far 1.75)
)


;; SPOT_NEAR SUB-ROUTINE
;;
(defun spot_near ()
  (command "CIRCLE"
    (list (+ (car ref_pt) (* dim_scale (+ 7.0 add_len))) (- (cadr ref_pt) dim_scale))
    dim_scale
  )
  (if (> (strlen spot_qty_near) 0)
    (command "TEXT" "S" (getvar "DIMTXSTY") "TC"
      (list (+ (car ref_pt) (* dim_scale (+ 7.0 add_len))) (- (cadr ref_pt) (* dim_scale 2.5)))
       dim_scale "0" (strcat "(" spot_qty_near ")")
    )
  )
)


;; SPOT_FAR SUB-ROUTINE
;;
(defun spot_far ()
  (if (= 11 weld_type_near)
    (progn
      (if (> (strlen spot_qty_near) 0) (command "ERASE" "L" ""))
      (command "MOVE" "L" ""
        (list (+ (car ref_pt) (* dim_scale (+ 7.0 add_len))) (- (cadr ref_pt) dim_scale))
        (list (+ (car ref_pt) (* dim_scale (+ 7.0 add_len))) (cadr ref_pt))
      )
      (if (> (strlen spot_qty_near) 0)
        (command "TEXT" "S" (getvar "DIMTXSTY") "TC"
          (list (+ (car ref_pt) (* dim_scale (+ 7.0 add_len))) (- (cadr ref_pt) (* dim_scale 1.5)))
           dim_scale "0" (strcat "(" spot_qty_near ")")
        )
      )
    )
    (progn
      (command "CIRCLE"
        (list (+ (car ref_pt) (* dim_scale (+ 7.0 add_len))) (+ (cadr ref_pt) dim_scale))
        dim_scale
      )
      (if (> (strlen spot_qty_far) 0)
        (command "TEXT" "S" (getvar "DIMTXSTY") "C"
          (list (+ (car ref_pt) (* dim_scale (+ 7.0 add_len))) (+ (cadr ref_pt) (* dim_scale 2.5)))
           dim_scale "0" (strcat "(" spot_qty_far ")")
        )
      )
    )
  )
)


;; FILLET_NEAR SUB-ROUTINE
;;
(defun fillet_near ()
  (command "LINE"
    (list (+ (car ref_pt) (* dim_scale (- (+ 6.5 add_len) offset))) (cadr ref_pt))
    (list (+ (car ref_pt) (* dim_scale (- (+ 6.5 add_len) offset))) (- (cadr ref_pt) (* dim_scale 1.6)))
    (list (+ (car ref_pt) (* dim_scale (- (+ 8.1 add_len) offset))) (cadr ref_pt)) ""
  )
)


;; FILLET_FAR SUB-ROUTINE
;;
(defun fillet_far ()
  (command "LINE"
    (list (+ (car ref_pt) (* dim_scale (+ (+ 6.5 add_len) offset))) (cadr ref_pt))
    (list (+ (car ref_pt) (* dim_scale (+ (+ 6.5 add_len) offset))) (+ (cadr ref_pt) (* dim_scale 1.6)))
    (list (+ (car ref_pt) (* dim_scale (+ (+ 8.1 add_len) offset))) (cadr ref_pt)) ""
  )
)


;; BEVEL_NEAR SUB-ROUTINE
;;
(defun bevel_near ()
  (command "LINE"
    (list (+ (car ref_pt) (* dim_scale (- (+ 6.5 add_len) offset))) (cadr ref_pt))
    (list (+ (car ref_pt) (* dim_scale (- (+ 6.5 add_len) offset))) (- (cadr ref_pt) (* dim_scale 1.6))) ""
  )
  (command "LINE"
    (list (+ (car ref_pt) (* dim_scale (- (+ 6.5 add_len) offset))) (cadr ref_pt))
    (list (+ (car ref_pt) (* dim_scale (- (+ 8.1 add_len) offset))) (- (cadr ref_pt) (* dim_scale 1.6))) ""
  )
  (if (= (strlen weld_ang_near) 0) (setq y_near 2.5) (setq y_near 3.5))
  (if (> (strlen weld_ang_near) 0)
    (command "TEXT" "S" (getvar "DIMTXSTY") "TC"
      (list (+ (car ref_pt) (* dim_scale (- (+ 7.0 add_len) offset))) (- (cadr ref_pt) (* dim_scale 2.0)))
       dim_scale "0" (strcat weld_ang_near "%%d")
    )
  )
)


;; BEVEL_FAR SUB-ROUTINE
;;
(defun bevel_far ()
  (command "LINE"
    (list (+ (car ref_pt) (* dim_scale (+ (+ 6.5 add_len) offset))) (cadr ref_pt))
    (list (+ (car ref_pt) (* dim_scale (+ (+ 6.5 add_len) offset))) (+ (cadr ref_pt) (* dim_scale 1.6))) ""
  )
  (command "LINE"
    (list (+ (car ref_pt) (* dim_scale (+ (+ 6.5 add_len) offset))) (cadr ref_pt))
    (list (+ (car ref_pt) (* dim_scale (+ (+ 8.1 add_len) offset))) (+ (cadr ref_pt) (* dim_scale 1.6))) ""
  )
  (if (= (strlen weld_ang_far) 0) (setq y_far 2.5) (setq y_far 3.5))
  (if (> (strlen weld_ang_far) 0)
    (command "TEXT" "S" (getvar "DIMTXSTY") "C"
      (list (+ (car ref_pt) (* dim_scale (+ (+ 7.0 add_len) offset))) (+ (cadr ref_pt) (* dim_scale 2.0)))
       dim_scale "0" (strcat weld_ang_far "%%d")
    )
  )
)


;; PLUG_NEAR SUB-ROUTINE
;;
(defun plug_near ()
  (command "LINE"
    (list (+ (car ref_pt) (* dim_scale (- (+ 5.25 add_len) offset))) (cadr ref_pt))
    (list (+ (car ref_pt) (* dim_scale (- (+ 5.25 add_len) offset))) (- (cadr ref_pt) (* dim_scale 2.0))) ""
  )
  (command "LINE"
    (list (+ (car ref_pt) (* dim_scale (- (+ 8.75 add_len) offset))) (cadr ref_pt))
    (list (+ (car ref_pt) (* dim_scale (- (+ 8.75 add_len) offset))) (- (cadr ref_pt) (* dim_scale 2.0))) ""
  )
  (command "LINE"
    (list (+ (car ref_pt) (* dim_scale (- (+ 5.25 add_len) offset))) (- (cadr ref_pt) (* dim_scale 2.0)))
    (list (+ (car ref_pt) (* dim_scale (- (+ 8.75 add_len) offset))) (- (cadr ref_pt) (* dim_scale 2.0))) ""
  )
  (if (= (strlen weld_ang_near) 0) (setq y_near 2.5) (setq y_near 4.0))
  (if (> (strlen weld_ang_near) 0)
    (command "TEXT" "S" (getvar "DIMTXSTY") "TC"
      (list (+ (car ref_pt) (* dim_scale (- (+ 7.0 add_len) offset))) (- (cadr ref_pt) (* dim_scale 2.5)))
       dim_scale "0" (strcat weld_ang_near "%%d")
    )
  )
)


;; PLUG_FAR SUB-ROUTINE
;;
(defun plug_far ()
  (command "LINE"
    (list (+ (car ref_pt) (* dim_scale (+ (+ 5.25 add_len) offset))) (cadr ref_pt))
    (list (+ (car ref_pt) (* dim_scale (+ (+ 5.25 add_len) offset))) (+ (cadr ref_pt) (* dim_scale 2.0))) ""
  )
  (command "LINE"
    (list (+ (car ref_pt) (* dim_scale (+ (+ 8.75 add_len) offset))) (cadr ref_pt))
    (list (+ (car ref_pt) (* dim_scale (+ (+ 8.75 add_len) offset))) (+ (cadr ref_pt) (* dim_scale 2.0))) ""
  )
  (command "LINE"
    (list (+ (car ref_pt) (* dim_scale (+ (+ 5.25 add_len) offset))) (+ (cadr ref_pt) (* dim_scale 2.0)))
    (list (+ (car ref_pt) (* dim_scale (+ (+ 8.75 add_len) offset))) (+ (cadr ref_pt) (* dim_scale 2.0))) ""
  )
  (if (= (strlen weld_ang_far) 0) (setq y_far 2.5) (setq y_far 4.0))
  (if (> (strlen weld_ang_far) 0)
    (command "TEXT" "S" (getvar "DIMTXSTY") "C"
      (list (+ (car ref_pt) (* dim_scale (+ (+ 7.0 add_len) offset))) (+ (cadr ref_pt) (* dim_scale 2.5)))
       dim_scale "0" (strcat weld_ang_far "%%d")
    )
  )
)


;; BFLARE_NEAR SUB-ROUTINE
;;
(defun bflare_near ()
  (command "LINE"
    (list (+ (car ref_pt) (* dim_scale (- (+ 6.5 add_len) offset))) (cadr ref_pt))
    (list (+ (car ref_pt) (* dim_scale (- (+ 6.5 add_len) offset))) (- (cadr ref_pt) dim_scale)) ""
  )
  (command "ARC" "C"
    (list (+ (car ref_pt) (* dim_scale (- (+ 8.5 add_len) offset))) (cadr ref_pt))
    (list (+ (car ref_pt) (* dim_scale (- (+ 7.5 add_len) offset))) (cadr ref_pt))
    (list (+ (car ref_pt) (* dim_scale (- (+ 8.5 add_len) offset))) (- (cadr ref_pt) dim_scale))
  )
  (setq y_near 1.75)
)


;; BFLARE_FAR SUB-ROUTINE
;;
(defun bflare_far ()
  (command "LINE"
    (list (+ (car ref_pt) (* dim_scale (+ (+ 6.5 add_len) offset))) (cadr ref_pt))
    (list (+ (car ref_pt) (* dim_scale (+ (+ 6.5 add_len) offset))) (+ (cadr ref_pt) dim_scale)) ""
  )
  (command "ARC" "C"
    (list (+ (car ref_pt) (* dim_scale (+ (+ 8.5 add_len) offset))) (cadr ref_pt))
    (list (+ (car ref_pt) (* dim_scale (+ (+ 8.5 add_len) offset))) (+ (cadr ref_pt) dim_scale))
    (list (+ (car ref_pt) (* dim_scale (+ (+ 6.5 add_len) offset))) (cadr ref_pt))
  )
  (setq y_far 1.75)
)


;; VFLARE_NEAR SUB-ROUTINE
;;
(defun vflare_near ()
  (command "ARC" "C"
    (list (+ (car ref_pt) (* dim_scale (- (+ 8.5 add_len) offset))) (cadr ref_pt))
    (list (+ (car ref_pt) (* dim_scale (- (+ 7.5 add_len) offset))) (cadr ref_pt))
    (list (+ (car ref_pt) (* dim_scale (- (+ 8.5 add_len) offset))) (- (cadr ref_pt) dim_scale))
  )
  (command "ARC" "C"
    (list (+ (car ref_pt) (* dim_scale (- (+ 5.5 add_len) offset))) (cadr ref_pt))
    (list (+ (car ref_pt) (* dim_scale (- (+ 5.5 add_len) offset))) (- (cadr ref_pt) dim_scale))
    (list (+ (car ref_pt) (* dim_scale (- (+ 6.5 add_len) offset))) (cadr ref_pt))
  )
  (setq y_near 1.75)
)


;; VFLARE_FAR SUB-ROUTINE
;;
(defun vflare_far ()
  (command "ARC" "C"
    (list (+ (car ref_pt) (* dim_scale (+ (+ 8.5 add_len) offset))) (cadr ref_pt))
    (list (+ (car ref_pt) (* dim_scale (+ (+ 8.5 add_len) offset))) (+ (cadr ref_pt) dim_scale))
    (list (+ (car ref_pt) (* dim_scale (+ (+ 6.5 add_len) offset))) (cadr ref_pt))
  )
  (command "ARC" "C"
    (list (+ (car ref_pt) (* dim_scale (+ (+ 5.5 add_len) offset))) (cadr ref_pt))
    (list (+ (car ref_pt) (* dim_scale (+ (+ 6.5 add_len) offset))) (cadr ref_pt))
    (list (+ (car ref_pt) (* dim_scale (+ (+ 5.5 add_len) offset))) (+ (cadr ref_pt) dim_scale))
  )
  (setq y_far 1.75)
)


;; EDGE_NEAR SUB-ROUTINE
;;
(defun edge_near ()
  (command "LINE"
    (list (+ (car ref_pt) (* dim_scale (+ 6.5 add_len))) (- (cadr ref_pt) dim_scale))
    (list (+ (car ref_pt) (* dim_scale (+ 6.5 add_len))) (- (cadr ref_pt) (* dim_scale 2.0))) ""
  )
  (command "LINE"
    (list (+ (car ref_pt) (* dim_scale (+ 7.5 add_len))) (- (cadr ref_pt) dim_scale))
    (list (+ (car ref_pt) (* dim_scale (+ 7.5 add_len))) (- (cadr ref_pt) (* dim_scale 2.0))) ""
  )
  (command "ARC" "C"
    (list (+ (car ref_pt) (* dim_scale (+ 8.5 add_len))) (- (cadr ref_pt) dim_scale))
    (list (+ (car ref_pt) (* dim_scale (+ 8.5 add_len))) (cadr ref_pt))
    (list (+ (car ref_pt) (* dim_scale (+ 6.5 add_len))) (- (cadr ref_pt) dim_scale))
  )
  (command "ARC" "C"
    (list (+ (car ref_pt) (* dim_scale (+ 5.5 add_len))) (- (cadr ref_pt) dim_scale))
    (list (+ (car ref_pt) (* dim_scale (+ 6.5 add_len))) (- (cadr ref_pt) dim_scale))
    (list (+ (car ref_pt) (* dim_scale (+ 5.5 add_len))) (cadr ref_pt))
  )
  (setq y_near 2.5)
)


;; EDGE_FAR SUB-ROUTINE
;;
(defun edge_far ()
  (command "LINE"
    (list (+ (car ref_pt) (* dim_scale (+ 6.5 add_len))) (+ (cadr ref_pt) dim_scale))
    (list (+ (car ref_pt) (* dim_scale (+ 6.5 add_len))) (+ (cadr ref_pt) (* dim_scale 2.0))) ""
  )
  (command "LINE"
    (list (+ (car ref_pt) (* dim_scale (+ 7.5 add_len))) (+ (cadr ref_pt) dim_scale))
    (list (+ (car ref_pt) (* dim_scale (+ 7.5 add_len))) (+ (cadr ref_pt) (* dim_scale 2.0))) ""
  )
  (command "ARC" "C"
    (list (+ (car ref_pt) (* dim_scale (+ 8.5 add_len))) (+ (cadr ref_pt) dim_scale))
    (list (+ (car ref_pt) (* dim_scale (+ 7.5 add_len))) (+ (cadr ref_pt) dim_scale))
    (list (+ (car ref_pt) (* dim_scale (+ 8.5 add_len))) (cadr ref_pt))
  )
  (command "ARC" "C"
    (list (+ (car ref_pt) (* dim_scale (+ 5.5 add_len))) (+ (cadr ref_pt) dim_scale))
    (list (+ (car ref_pt) (* dim_scale (+ 5.5 add_len))) (cadr ref_pt))
    (list (+ (car ref_pt) (* dim_scale (+ 6.5 add_len))) (+ (cadr ref_pt) dim_scale))
  )
  (setq y_far 2.5)
)


;; U_NEAR SUB-ROUTINE
;;
(defun u_near ()
  (command "LINE"
    (list (+ (car ref_pt) (* dim_scale (- (+ 7.0 add_len) offset))) (cadr ref_pt))
    (list (+ (car ref_pt) (* dim_scale (- (+ 7.0 add_len) offset))) (- (cadr ref_pt) dim_scale)) ""
  )
  (command "ARC" "C"
    (list (+ (car ref_pt) (* dim_scale (- (+ 7.0 add_len) offset))) (- (cadr ref_pt) (* dim_scale 2.0)))
    (list (+ (car ref_pt) (* dim_scale (- (+ 8.0 add_len) offset))) (- (cadr ref_pt) (* dim_scale 2.0)))
    (list (+ (car ref_pt) (* dim_scale (- (+ 6.0 add_len) offset))) (- (cadr ref_pt) (* dim_scale 2.0)))
  )
  (if (= (strlen weld_ang_near) 0) (setq y_near 2.5) (setq y_near 3.5))
  (if (> (strlen weld_ang_near) 0)
    (command "TEXT" "S" (getvar "DIMTXSTY") "TC"
      (list (+ (car ref_pt) (* dim_scale (- (+ 7.0 add_len) offset))) (- (cadr ref_pt) (* dim_scale 2.0)))
       dim_scale "0" (strcat weld_ang_near "%%d")
    )
  )
)


;; U_FAR SUB-ROUTINE
;;
(defun u_far ()
  (command "LINE"
    (list (+ (car ref_pt) (* dim_scale (+ (+ 7.0 add_len) offset))) (cadr ref_pt))
    (list (+ (car ref_pt) (* dim_scale (+ (+ 7.0 add_len) offset))) (+ (cadr ref_pt) dim_scale)) ""
  )
  (command "ARC" "C"
    (list (+ (car ref_pt) (* dim_scale (+ (+ 7.0 add_len) offset))) (+ (cadr ref_pt) (* dim_scale 2.0)))
    (list (+ (car ref_pt) (* dim_scale (+ (+ 6.0 add_len) offset))) (+ (cadr ref_pt) (* dim_scale 2.0)))
    (list (+ (car ref_pt) (* dim_scale (+ (+ 8.0 add_len) offset))) (+ (cadr ref_pt) (* dim_scale 2.0)))
  )
  (if (= (strlen weld_ang_far) 0) (setq y_far 2.5) (setq y_far 3.5))
  (if (> (strlen weld_ang_far) 0)
    (command "TEXT" "S" (getvar "DIMTXSTY") "C"
      (list (+ (car ref_pt) (* dim_scale (+ (+ 7.0 add_len) offset))) (+ (cadr ref_pt) (* dim_scale 2.0)))
       dim_scale "0" (strcat weld_ang_far "%%d")
    )
  )
)


;; J_NEAR SUB-ROUTINE
;;
(defun j_near ()
  (command "LINE"
    (list (+ (car ref_pt) (* dim_scale (- (+ 6.5 add_len) offset))) (cadr ref_pt))
    (list (+ (car ref_pt) (* dim_scale (- (+ 6.5 add_len) offset))) (- (cadr ref_pt) (* dim_scale 2.0))) ""
  )
  (command "ARC" "C"
    (list (+ (car ref_pt) (* dim_scale (- (+ 6.5 add_len) offset))) (- (cadr ref_pt) (* dim_scale 2.0)))
    (list (+ (car ref_pt) (* dim_scale (- (+ 7.5 add_len) offset))) (- (cadr ref_pt) (* dim_scale 2.0)))
    (list (+ (car ref_pt) (* dim_scale (- (+ 6.5 add_len) offset))) (- (cadr ref_pt) dim_scale))
  )
  (if (= (strlen weld_ang_near) 0) (setq y_near 2.5) (setq y_near 3.5))
  (if (> (strlen weld_ang_near) 0)
    (command "TEXT" "S" (getvar "DIMTXSTY") "TC"
      (list (+ (car ref_pt) (* dim_scale (- (+ 7.0 add_len) offset))) (- (cadr ref_pt) (* dim_scale 2.2)))
       dim_scale "0" (strcat weld_ang_near "%%d")
    )
  )
)


;; J_FAR SUB-ROUTINE
;;
(defun j_far ()
  (command "LINE"
    (list (+ (car ref_pt) (* dim_scale (+ (+ 6.5 add_len) offset))) (cadr ref_pt))
    (list (+ (car ref_pt) (* dim_scale (+ (+ 6.5 add_len) offset))) (+ (cadr ref_pt) (* dim_scale 2.0))) ""
  )
  (command "ARC" "C"
    (list (+ (car ref_pt) (* dim_scale (+ (+ 6.5 add_len) offset))) (+ (cadr ref_pt) (* dim_scale 2.0)))
    (list (+ (car ref_pt) (* dim_scale (+ (+ 6.5 add_len) offset))) (+ (cadr ref_pt) dim_scale))
    (list (+ (car ref_pt) (* dim_scale (+ (+ 7.5 add_len) offset))) (+ (cadr ref_pt) (* dim_scale 2.0)))
  )
  (if (= (strlen weld_ang_far) 0) (setq y_far 2.5) (setq y_far 3.5))
  (if (> (strlen weld_ang_far) 0)
    (command "TEXT" "S" (getvar "DIMTXSTY") "C"
      (list (+ (car ref_pt) (* dim_scale (+ (+ 7.0 add_len) offset))) (+ (cadr ref_pt) (* dim_scale 2.2)))
       dim_scale "0" (strcat weld_ang_far "%%d")
    )
  )
)


;; CORN_NEAR SUB-ROUTINE
;;
(defun corn_near ()
  (command "LINE"
    (list (+ (car ref_pt) (* dim_scale (+ 6.5 add_len))) (cadr ref_pt))
    (list (+ (car ref_pt) (* dim_scale (+ 6.5 add_len))) (- (cadr ref_pt) (* dim_scale 2.0))) ""
  )
  (command "LINE"
    (list (+ (car ref_pt) (* dim_scale (+ 7.5 add_len))) (- (cadr ref_pt) dim_scale))
    (list (+ (car ref_pt) (* dim_scale (+ 7.5 add_len))) (- (cadr ref_pt) (* dim_scale 2.0))) ""
  )
  (command "ARC" "C"
    (list (+ (car ref_pt) (* dim_scale (+ 8.5 add_len))) (- (cadr ref_pt) dim_scale))
    (list (+ (car ref_pt) (* dim_scale (+ 8.5 add_len))) (cadr ref_pt))
    (list (+ (car ref_pt) (* dim_scale (+ 6.5 add_len))) (- (cadr ref_pt) dim_scale))
  )
  (setq y_near 2.5)
)


;; CORN_FAR SUB-ROUTINE
;;
(defun corn_far ()
  (command "LINE"
    (list (+ (car ref_pt) (* dim_scale (+ 6.5 add_len))) (cadr ref_pt))
    (list (+ (car ref_pt) (* dim_scale (+ 6.5 add_len))) (+ (cadr ref_pt) (* dim_scale 2.0))) ""
  )
  (command "LINE"
    (list (+ (car ref_pt) (* dim_scale (+ 7.5 add_len))) (+ (cadr ref_pt) dim_scale))
    (list (+ (car ref_pt) (* dim_scale (+ 7.5 add_len))) (+ (cadr ref_pt) (* dim_scale 2.0))) ""
  )
  (command "ARC" "C"
    (list (+ (car ref_pt) (* dim_scale (+ 8.5 add_len))) (+ (cadr ref_pt) dim_scale))
    (list (+ (car ref_pt) (* dim_scale (+ 7.5 add_len))) (+ (cadr ref_pt) dim_scale))
    (list (+ (car ref_pt) (* dim_scale (+ 8.5 add_len))) (cadr ref_pt))
  )
  (setq y_far 2.5)
)


;; SQUARE_NEAR SUB-ROUTINE
;;
(defun square_near ()
  (command "LINE"
    (list (+ (car ref_pt) (* dim_scale (- (+ 6.5 add_len) offset))) (cadr ref_pt))
    (list (+ (car ref_pt) (* dim_scale (- (+ 6.5 add_len) offset))) (- (cadr ref_pt) (* dim_scale 2.0))) ""
  )
  (command "LINE"
    (list (+ (car ref_pt) (* dim_scale (- (+ 7.5 add_len) offset))) (cadr ref_pt))
    (list (+ (car ref_pt) (* dim_scale (- (+ 7.5 add_len) offset))) (- (cadr ref_pt) (* dim_scale 2.0))) ""
  )
  (setq y_near 2.5)
)


;; SQUARE_FAR SUB-ROUTINE
;;
(defun square_far ()
  (command "LINE"
    (list (+ (car ref_pt) (* dim_scale (+ (+ 6.5 add_len) offset))) (cadr ref_pt))
    (list (+ (car ref_pt) (* dim_scale (+ (+ 6.5 add_len) offset))) (+ (cadr ref_pt) (* dim_scale 2.0))) ""
  )
  (command "LINE"
    (list (+ (car ref_pt) (* dim_scale (+ (+ 7.5 add_len) offset))) (cadr ref_pt))
    (list (+ (car ref_pt) (* dim_scale (+ (+ 7.5 add_len) offset))) (+ (cadr ref_pt) (* dim_scale 2.0))) ""
  )
  (setq y_far 2.5)
)


;; VEE_NEAR SUB-ROUTINE
;;
(defun vee_near ()
  (command "LINE"
    (list (+ (car ref_pt) (* dim_scale (- (+ 7.0 add_len) offset))) (cadr ref_pt))
    (list (+ (car ref_pt) (* dim_scale (- (+ 8.6 add_len) offset))) (- (cadr ref_pt) (* dim_scale 1.6))) ""
  )
  (command "LINE"
    (list (+ (car ref_pt) (* dim_scale (- (+ 7.0 add_len) offset))) (cadr ref_pt))
    (list (+ (car ref_pt) (* dim_scale (- (+ 5.4 add_len) offset))) (- (cadr ref_pt) (* dim_scale 1.6))) ""
  )
  (if (= (strlen weld_ang_near) 0) (setq y_near 2.5) (setq y_near 3.2))
  (if (> (strlen weld_ang_near) 0)
    (command "TEXT" "S" (getvar "DIMTXSTY") "TC"
      (list (+ (car ref_pt) (* dim_scale (- (+ 7.0 add_len) offset))) (- (cadr ref_pt) (* dim_scale 1.5)))
       dim_scale "0" (strcat weld_ang_near "%%d")
    )
  )
)


;; VEE_FAR SUB-ROUTINE
;;
(defun vee_far ()
  (command "LINE"
    (list (+ (car ref_pt) (* dim_scale (+ (+ 7.0 add_len) offset))) (cadr ref_pt))
    (list (+ (car ref_pt) (* dim_scale (+ (+ 8.6 add_len) offset))) (+ (cadr ref_pt) (* dim_scale 1.6))) ""
  )
  (command "LINE"
    (list (+ (car ref_pt) (* dim_scale (+ (+ 7.0 add_len) offset))) (cadr ref_pt))
    (list (+ (car ref_pt) (* dim_scale (+ (+ 5.4 add_len) offset))) (+ (cadr ref_pt) (* dim_scale 1.6))) ""
  )
  (if (= (strlen weld_ang_far) 0) (setq y_far 2.5) (setq y_far 3.2))
  (if (> (strlen weld_ang_far) 0)
    (command "TEXT" "S" (getvar "DIMTXSTY") "C"
      (list (+ (car ref_pt) (* dim_scale (+ (+ 7.0 add_len) offset))) (+ (cadr ref_pt) (* dim_scale 1.5)))
       dim_scale "0" (strcat weld_ang_far "%%d")
    )
  )
)


;; LETS_MELT SUB-ROUTINE
;;
(defun lets_melt ()
  (if
    (and
      (= melt_thru 1)
      (= weld_type_near 0)
      (= (member weld_type_far '(0 1 3 4 5 9 10 11 13)) nil)
    )
    (progn
      (command "ARC"
        (list (+ (car ref_pt) (* dim_scale (+ 5.8 add_len))) (cadr ref_pt))
        (list (+ (car ref_pt) (* dim_scale (+ 7.0 add_len))) (- (cadr ref_pt) (* dim_scale 0.8)))
        (list (+ (car ref_pt) (* dim_scale (+ 8.2 add_len))) (cadr ref_pt))
      )
      (command "HATCH" "LINE" (* dim_scale 0.25) "0" "" "N"
        (list (+ (car ref_pt) (* dim_scale (+ 5.8 add_len))) (cadr ref_pt)) "A" "S"
        (list (+ (car ref_pt) (* dim_scale (+ 7.0 add_len))) (- (cadr ref_pt) (* dim_scale 0.8)))
        (list (+ (car ref_pt) (* dim_scale (+ 8.2 add_len))) (cadr ref_pt)) "" ""
      )
      (setq y_near 1.5)
    )
  )
  (if
    (and
      (= melt_thru 1)
      (= weld_type_far 0)
      (= (member weld_type_near '(0 1 3 4 5 9 10 11 13)) nil)
    )
    (progn
      (command "ARC"
        (list (+ (car ref_pt) (* dim_scale (+ 5.8 add_len))) (cadr ref_pt))
        (list (+ (car ref_pt) (* dim_scale (+ 7.0 add_len))) (+ (cadr ref_pt) (* dim_scale 0.8)))
        (list (+ (car ref_pt) (* dim_scale (+ 8.2 add_len))) (cadr ref_pt))
      )
      (command "HATCH" "LINE" (* dim_scale 0.25) "0" "" "N"
        (list (+ (car ref_pt) (* dim_scale (+ 5.8 add_len))) (cadr ref_pt)) "A" "S"
        (list (+ (car ref_pt) (* dim_scale (+ 7.0 add_len))) (+ (cadr ref_pt) (* dim_scale 0.8)))
        (list (+ (car ref_pt) (* dim_scale (+ 8.2 add_len))) (cadr ref_pt)) "" ""
      )
      (setq y_far 1.5)
    )
  )
  (if
    (or
      (and (= melt_thru 1) (/= weld_type_near 0) (/= weld_type_far 0))
      (/= (member weld_type_near '(1 3 4 5 9 10 11 13)) nil)
      (/= (member weld_type_far '(1 3 4 5 9 10 11 13)) nil)
    )
    (setq melt_thru 0)
  )
)


;; GRAY SUB-ROUTINE
;; Grays out non-applicable tiles within dialog.
;;
(defun gray (clear)
  (if (= clear 0) (setq clear nil))

;; CHECK IF FLANGE WELD SIGNIFICANT
;;
  (if (or (= weld_type_near 4) (= weld_type_near 5))
    (progn
      (if clear (setq weld_type_far 0))
      (mode_tile "weld_type_far" 1)
      (setq gray_far 1)
    )
    (progn
      (mode_tile "weld_type_far" 0)
      (setq gray_far 0)
    )
  )
  (if (or (= weld_type_far 4) (= weld_type_far 5))
    (progn
      (if clear (setq weld_type_near 0))
      (mode_tile "weld_type_near" 1)
      (setq gray_near 1)
    )
    (progn
      (mode_tile "weld_type_near" 0)
      (setq gray_near 0)
    )
  )

;; RESET MELT_THRU IF NECESSARY
;;
  (if
    (or
      (= (+ weld_type_near weld_type_far) 0)
      (/= (member weld_type_near '(1 3 4 5 9 10 11 13)) nil)
      (/= (member weld_type_far '(1 3 4 5 9 10 11 13)) nil)
      (and (> weld_type_near 0) (> weld_type_far 0))
    )
    (progn
      (if clear (setq melt_thru 0))
      (mode_tile "melt_thru" 1)
    )
    (mode_tile "melt_thru" 0)
  )

;; RESET STAGGER IF NECESSARY
;;
  (if
    (or
      (/= (member weld_type_near '(0 1 4 5 10 11 13)) nil)
      (/= (member weld_type_far '(0 1 4 5 10 11 13)) nil)
    )
    (progn
      (if clear (setq stagger 0))
      (mode_tile "stagger" 1)
    )
    (mode_tile "stagger" 0)
  )

;; RESET WELD_ALL_AROUND IF NECESSARY
;;
  (if
    (or
      (= (+ weld_type_near weld_type_far) 0)
      (/= (member weld_type_near '(9 10 11)) nil)
      (/= (member weld_type_far '(9 10 11)) nil)
    )
    (progn
      (if clear (setq weld_all_around 0))
      (mode_tile "weld_all_around" 1)
    )
    (mode_tile "weld_all_around" 0)
  )

;; CLEAR THROAT_NEAR & THROAT_FAR IF NOT USED
;;
  (if
    (or
      (= (member weld_type_near '(2 6 7 8 12 14 15)) nil)
      (= gray_near 1)
    )
    (progn
      (if clear (setq throat_near ""))
      (mode_tile "throat_near" 1)
    )
    (mode_tile "throat_near" 0)
  )
  (if (= (member weld_type_far '(2 6 7 8 12 14 15)) nil)
    (progn
      (if clear (setq throat_far ""))
      (mode_tile "throat_far" 1)
    )
    (mode_tile "throat_far" 0)
  )

;; CLEAR FIELD_WELD AND TAIL
;;
  (if (= (+ weld_type_near weld_type_far) 0)
    (progn
      (if clear (setq field_weld 0 tail 0))
      (mode_tile "field_weld" 1)
      (mode_tile "tail" 1)
    )
    (progn
      (mode_tile "field_weld" 0)
      (mode_tile "tail" 0)
    )
  )

;; CLEAR EVERYTHING ELSE ON NEAR SIDE IF NOT NEEDED
;;
  (if (or (= weld_type_near 0) (= gray_near 1))
    (progn
      (if clear (setq weld_size_near ""))
      (mode_tile "weld_size_near" 1)
      (if clear (setq pitch_near ""))
      (mode_tile "pitch_near" 1)
    )
    (progn
      (mode_tile "weld_size_near" 0)
      (mode_tile "pitch_near" 0)
    )
  )
  (if (or (= (member weld_type_near '(2 8 9 14 15)) nil) (= gray_near 1))
    (progn
      (if clear (setq weld_ang_near ""))
      (mode_tile "weld_ang_near" 1)
    )
    (mode_tile "weld_ang_near" 0)
  )
  (if (or (/= weld_type_near 11) (= gray_near 1))
    (progn
      (if clear (setq spot_qty_near ""))
      (mode_tile "spot_qty_near" 1)
    )
    (mode_tile "spot_qty_near" 0)
  )
  (if (or (/= (member weld_type_near '(0 1 10 11 13)) nil) (= gray_near 1))
    (progn
      (if clear (setq depth_near ""))
      (mode_tile "depth_near" 1)
    )
    (mode_tile "depth_near" 0)
  )

;; RESET CONTOUR_NEAR IF NOT APPLICABLE
;;
  (if
    (or
      (and
        (= weld_type_near 0)
        (/= (member weld_type_far '(0 1 3 4 5 9 10 11 13)) nil)
      )
      (and
        (= melt_thru 0)
        (/= (member weld_type_near '(0 10 11)) nil)
      )
      (= gray_near 1)
    )
    (progn
      (if clear (setq contour_near 0))
      (mode_tile "contour_near" 1)
      (if clear (setq finish_near 0))
      (mode_tile "finish_near" 1)
    )
    (progn
      (mode_tile "contour_near" 0)
      (if (= contour_near 0)
        (progn
          (if clear (setq finish_near 0))
          (mode_tile "finish_near" 1)
        )
        (mode_tile "finish_near" 0)
      )
    )
  )

;; CLEAR EVERYTHING ELSE ON FAR SIDE IF NOT NEEDED
;;
  (if (or (= weld_type_far 0) (= gray_far 1))
    (progn
      (if clear (setq weld_size_far ""))
      (mode_tile "weld_size_far" 1)
      (if clear (setq pitch_far ""))
      (mode_tile "pitch_far" 1)
    )
    (progn
      (mode_tile "weld_size_far" 0)
      (mode_tile "pitch_far" 0)
    )
  )
  (if (or (= (member weld_type_far '(2 8 9 14 15)) nil) (= gray_far 1))
    (progn
      (if clear (setq weld_ang_far ""))
      (mode_tile "weld_ang_far" 1)
    )
    (mode_tile "weld_ang_far" 0)
  )
  (if (or (/= weld_type_far 11) (= gray_far 1))
    (progn
      (if clear (setq spot_qty_far ""))
      (mode_tile "spot_qty_far" 1)
    )
    (mode_tile "spot_qty_far" 0)
  )
  (if (or (/= (member weld_type_far '(0 1 10 11 13)) nil) (= gray_far 1))
    (progn
      (if clear (setq depth_far ""))
      (mode_tile "depth_far" 1)
    )
    (mode_tile "depth_far" 0)
  )

;; RESET CONTOUR_FAR IF NOT APPLICABLE
;;
  (if
    (or
      (and
        (= weld_type_far 0)
        (/= (member weld_type_near '(0 1 3 4 5 9 10 11 13)) nil)
      )
      (and
        (= melt_thru 0)
        (/= (member weld_type_far '(0 10 11)) nil)
      )
      (= gray_far 1)
    )
    (progn
      (if clear (setq contour_far 0))
      (mode_tile "contour_far" 1)
      (if clear (setq finish_far 0))
      (mode_tile "finish_far" 1)
    )
    (progn
      (mode_tile "contour_far" 0)
      (if (= contour_far 0)
        (progn
          (if clear (setq finish_far 0))
          (mode_tile "finish_far" 1)
        )
        (mode_tile "finish_far" 0)
      )
    )
  )
)


;; MAIN FUNCTION
;;
(defun C:CPack_WELD (/ blip echo err pt1 pt2 pt3 add_len contour_list done_yet
                 finish_list offset omode pitch_len ref_pt stop_this temp_pt
                 text_width weld_len weld_list y_near weld_throat_far
                 weld_throat_near 
              )

;; SET VARIABLES
;;
  (setq err *error*)
  (setq blip (getvar "BLIPMODE"))
  (setq echo (getvar "CMDECHO"))
  (setq omode (getvar "OSMODE"))
  (setvar "BLIPMODE" 0)
  (setvar "CMDECHO" 0)

;; INITIALIZE VARIABLES
;;
  (setq dim_scale (* (getvar "DIMSCALE") (getvar "DIMTXT")))
  (setq stop_this 1)

  (if (= melt_thru nil) (setq melt_thru 0))
  (if (= stagger nil) (setq stagger 0))
  (if (= weld_all_around nil) (setq weld_all_around 0))
  (if (= field_weld nil) (setq field_weld 0))
  (if (= tail nil) (setq tail 0))

  (if (= weld_type_near nil) (setq weld_type_near 0))
  (if (= weld_type_far nil) (setq weld_type_far 0))

  (if (= weld_size_near nil) (setq weld_size_near ""))
  (if (= weld_size_far nil) (setq weld_size_far ""))

  (if (= throat_near nil) (setq throat_near ""))
  (if (= throat_far nil) (setq throat_far ""))

  (if (= pitch_near nil) (setq pitch_near ""))
  (if (= pitch_far nil) (setq pitch_far ""))

  (if (= spot_qty_near nil) (setq spot_qty_near ""))
  (if (= spot_qty_far nil) (setq spot_qty_far ""))

  (if (= weld_ang_near nil) (setq weld_ang_near ""))
  (if (= weld_ang_far nil) (setq weld_ang_far ""))

  (if (= depth_near nil) (setq depth_near ""))
  (if (= depth_far nil) (setq depth_far ""))

;; DO DIALOG
;;
  (if (findfile "WELD.DCL")
    (do_dialog_now)
    (progn
      (alert "Error!\n\nFile not found: WELD.DCL")
      (setq stop_this 0)
    )
  )

;; RUN SUBS
;;
  (gray 1)
  (if (= stop_this 1)
    (progn
      (get_points)
      (make_refs)
      (check_weld)
      (make_symbol)
      (lets_melt)
      (add_contour)
    )
  )

;; RESET VARIABLES
;;
  (setq *error* err)
  (setvar "BLIPMODE" blip)
  (setvar "CMDECHO" echo)
  (setvar "OSMODE" omode)

  (princ)
)

(princ " WELD loaded.  ")
