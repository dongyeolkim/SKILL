;look4pads_form_id = nil
procedure(look4pads()
     prog((rep replib)

         if(! (rep = geGetEditRep()) then
             return()
         )
         replib = rep~>lib
         if(! boundp('look4pads_form_id) then
             if(! (look4pads_form_id = CreateLook4PadsForm()) then
                 return()
             else
                 printf("look4pads_form_id created.\n")
             )
         else
             if(! look4pads_form_id then
                 if(! (look4pads_form_id = CreateLook4PadsForm()) then
                     return()
                 else
                     printf("look4pads_form_id created.\n")
                 )
             )
         )
         hiDisplayForm(look4pads_form_id)
     )
)

procedure(CreateLook4PadsForm()
     prog((def_pad_name def_lab_name def_out pad_name_id lab_name_id out_file_id look4pads_form_id)

         def_pad_name = ""
         def_lab_name = ""
         def_out = strcat(rep~>cellName ".pads")

         pad_name_id = hiCreateStringField(
                 ?name 'pad_name
                 ?prompt "Enter pad layer name."
                 ?value def_pad_name
                 ?defValue def_pad_name
         )
         lab_name_id = hiCreateStringField(
                 ?name 'lab_name
                 ?prompt "Enter label layer name."
                 ?value def_lab_name
                 ?defValue def_lab_name
         )
         out_file_id = hiCreateStringField(
                 ?name 'out_file
                 ?prompt "Enter output filename"
                 ?value def_out
                 ?defValue def_out
         )
         look4pads_form_id = hiCreateForm(
                 'look4pads_form
                 "Find pad centers and names."
                 list("findpads()" "")
                 list(pad_name_id lab_name_id out_file_id)
                 nil nil
         )
         return(look4pads_form_id)
     )
)

procedure(findpads()
     prog((lay_str lay_name lay_purp text_str text_name text_purp out_file_name
             out_port pad_paths num_pads pad_inst pshape pad_name pad_trans
             pad_box pad_coord pad_label label_list path_depth current_level
             current_cell c_x c_y lab_paths lab_str mag_fact pad_list min_x max_x min_y max_y)

         min_x=100000.0
         max_x=-100000.0
         min_y=100000.0
         max_y=-100000.0
         lay_str = parseString(look4pads_form->pad_name->value)
         lay_name = nth(0 lay_str)
         if(! (lay_purp = nth(1 lay_str)) then
             lay_purp = "drawing"
         )
;         if(! dbGetLayer(replib list(lay_name lay_purp)) then
;             printf("Pad layer does not exist in library.\n")
;             return()
;         )
         text_str = parseString(look4pads_form->lab_name->value)
         text_name = nth(0 text_str)
         if(! (text_purp = nth(1 text_str)) then
             text_purp = "TEXT"
         )
;         if(! dbGetLayer(replib list(text_name text_purp)) then
;             printf("Label layer does not exist in library.\n")
;             return()
;         )
         out_file_name = look4pads_form->out_file->value
;         if(! (out_port = outfile(out_file_name)) then
;             printf("Output file creation error\n")
;             return()
;         )
         pad_paths = dbGetTrueOverlaps(rep rep~>bBox list(lay_name lay_purp) 32)
         if(! pad_paths then
             printf("No pads were found on layer \"%s %s\" in this hierarchy\n" lay_name lay_purp)
             return()
         else
             num_pads = length(pad_paths)
             ;fprintf(out_port "%d pads were found on layer" num_pads)
             ;fprintf(out_port " \"%s %s\" in this hierarchy\n" lay_name lay_purp)
             ;    fprintf(out_port "\n\n\nAT49FW080 32-PIN PLCC FWH ")
             ;    fprintf(out_port "\n\n(391f6)")
             ;    fprintf(out_port "\n\n(Chip size = 3606um X 8498um)")
             ;    fprintf(out_port "\n\n\nPin                   Function Center of Pad")
             ;    fprintf(out_port "\n---------            ---------- ------------------------------------\n")

         )
         foreach(ppath pad_paths
             ;printf(" \n")
             ;printf(" \n")
             ;printf("ppath = ") println(ppath)
             pad_box = nil
             current_level = ppath
             if(! listp(current_level) then
                 pshape = current_level
                 pad_trans = list(0:0 "R0" 1.0)
                 ;printf("pshape = ") println(pshape)
                 pad_box = pshape~>bBox
             else
                 current_cell = nth(0 current_level)
                 pad_trans = current_cell~>transform
                 ;printf("current_cell = ") println(current_cell)
                 ;printf("pad_trans = ") println(pad_trans)
                 while(listp(nth(1 current_level))
                     current_level = nth(1 current_level)
                     current_cell = nth(0 current_level)
                     ;printf("current_cell = ") println(current_cell)
                     pad_trans = dbConcatTransform( current_cell~>transform pad_trans)
                     ;printf("pad_trans = ") println(pad_trans)
                 )
                 pad_name = current_cell~>name
                 ;printf("pad_name = ") println(pad_name)
                 pshape = nth(1 current_level)
                 ;printf("pshape = ") println(pshape)
                 pad_box = geTransformUserBBox(pshape~>bBox list(nth(0 pad_trans) nth(1 pad_trans) nth(2 pad_trans)))
             )
             ;printf("pad_trans = ") println(pad_trans)
             ;mag_fact = nth(2 pad_trans)
             if(pad_box then
                 p_llx = nth(0 nth(0 pad_box))
                 p_lly = nth(1 nth(0 pad_box))
                 p_urx = nth(0 nth(1 pad_box))
                 p_ury = nth(1 nth(1 pad_box))

                 ;p_llx = nth(0 nth(0 pad_box)) * mag_fact
                 ;p_lly = nth(1 nth(0 pad_box)) * mag_fact
                 ;p_urx = nth(0 nth(1 pad_box)) * mag_fact
                 ;p_ury = nth(1 nth(1 pad_box)) * mag_fact
                 c_x = p_llx+(p_urx-p_llx)*.5
                 c_y = p_lly+(p_ury-p_lly)*.5
                 pad_coord = c_x:c_y
                 ; Look for label.
;                 println( list(text_name text_purp) )
                 lab_paths = dbGetTrueOverlaps(rep pad_box list(text_name text_purp) 32)
                 label_list = nil
                 foreach(labpath lab_paths
                     current_level = labpath
                     if(! listp(current_level) then
                         lab = labpath
                     else
                         current_cell = nth(0 current_level)
                         while(listp(nth(1 current_level))
                             current_level = nth(1 current_level)
                         )
                         lab = nth(1 current_level)
                     )
                     ;printf("lab = ") println(lab)
                     if(lab~>shape == "label" then
                         lab_str = lab~>theLabel
                         if(!member(lab_str label_list) then
                             label_list = append1(label_list lab_str)
                         )
                     )
                 )
                 lab_str = nth(0 label_list)
                 if(! lab_str then
;                     fprintf(out_port "No label found in pad area at at %f:%f\n" c_x c_y)
                 else
                 ;    if(length(label_list) > 1 then
                 ;        fprintf(out_port "More than one label at %f:%f\n"
                 ;           c_x c_y)
                 ;        fprintf(out_port "\nUsing label %s.\n" lab_str)
                 ;    )

                     elem=list( lab_str 1*c_x 1*c_y)
;                     println(elem)
                     if( pad_list == nil then
                        pad_list=list( elem )
                     else
                        pad_list=cons( elem pad_list )
                     )
                     if( min_x > c_x then min_x=c_x)
                     if( min_y > c_y then min_y=c_y)
                     if( max_x < c_x then max_x=c_x)
                     if( max_y < c_y then max_y=c_y)

;                     fprintf(out_port "%10s         %10s          X = %10.2f      Y = %10.2f           \n" "" lab_str (1*c_x) (1*c_y) text_name)
                 )
             );if pad_box
         );foreach pad_path
;                 fprintf(out_port "\n\n\n Coordinates are in um (micron) with")
;                 fprintf(out_port "\n reference to center of chip \n")

;         close(out_port)
         pad_sort( pad_list min_x min_y max_x max_y out_file_name)
;         hiEdgeViewFile(out_file_name)
         
         return(label_list)
     )
)

procedure( pad_sort(pad_list min_x min_y max_x max_y out_file_name)
  prog( (pad leftlist rightlist toplist bottomlist line_num )
;    println( min_x )
;    println( min_y )
;    println( max_x )
;    println( max_y )

    foreach( pad pad_list 
      if( nth( 1 pad) == min_x then
        if( leftlist == nil then
          leftlist=list(pad)
        else
          leftlist=cons( pad leftlist )
        )
      );if
      if( nth( 1 pad) == max_x then
        if( rightlist == nil then
          rightlist=list(pad)
        else
          rightlist=cons( pad rightlist )
        )
      );if
      if( nth( 2 pad) == min_y then
        if( bottomlist == nil then
          bottomlist=list(pad)
        else
          bottomlist=cons( pad bottomlist )
        )
      );if
      if( nth( 2 pad) == max_y then
        if( toplist == nil then
          toplist=list(pad)
        else
          toplist=cons( pad toplist )
        )
      );if
    );foreach

    if(! (out_port = outfile(out_file_name)) then
      printf("Output file creation error\n")
      return()
    )

    line_num=0
    leftlist=sort(leftlist lambda( (a b) greaterp( nth( 2 a)  nth(2 b))))
    foreach( left leftlist
        fprintf(out_port "%3d) %10s         %10s          X = %10.2f      Y = %10.2f           \n" line_num "" nth( 0 left) nth(1 left) nth(2 left))
        line_num++
    )

    bottomlist=sort(bottomlist lambda( (a b) lessp( nth( 1 a)  nth(1 b))))
    foreach( left bottomlist
        fprintf(out_port "%3d) %10s         %10s          X = %10.2f      Y = %10.2f           \n" line_num "" nth( 0 left) nth(1 left) nth(2 left))
        line_num++
    )

    rightlist=sort(rightlist lambda( (a b) lessp( nth( 2 a)  nth(2 b))))
    foreach( left rightlist
        fprintf(out_port "%3d) %10s         %10s          X = %10.2f      Y = %10.2f           \n" line_num "" nth( 0 left) nth(1 left) nth(2 left))
        line_num++
    )
    toplist=sort(toplist lambda( (a b) greaterp( nth( 1 a)  nth(1 b))))
    foreach( left toplist
        fprintf(out_port "%3d) %10s         %10s          X = %10.2f      Y = %10.2f           \n" line_num "" nth( 0 left) nth(1 left) nth(2 left))
        line_num++
    )
    close(out_port)

    printf(" Reported Pad Coords with [%s]. \n", out_file_name)
  );prog
);procudeur
;load("/rnda6/home/kimdy/work/PI4008K_AIP/look4pad.il")

