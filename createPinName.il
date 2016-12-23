procedure( createPinName()
  prog( (cv name bBox n_x n_y l_lpp d_cellView d_selSet t_label t_just t_orient t_font x_height)
    cv=hiGetCurrentWindow()
    foreach(  shape cv->cellView->shapes
      if( (shape->pin)
      then
        name=shape->pin->name   
        bBox=shape->bBox
;        println( name )
;        println(bBox)
        case( shape->layerName
          ("ME1"   layer="M1_CAD" )
          ("ME2"   layer="M2_CAD" )
          ("ME3"   layer="M3_CAD" )
          ("ME4"   layer="M4_CAD" )
          ("ME5"   layer="M5_CAD" )
        )
        d_cellView=geGetEditCellView()
        d_selSet = car( geGetSelSet( ) )
        l_lpp = list( layer "TEXT")
        n_x = xCoord( lowerLeft( bBox ) ) + (xCoord( upperRight( bBox ) ) - xCoord( lowerLeft( bBox ) ))*0.5 
        n_y = yCoord( lowerLeft( bBox ) ) + (yCoord( upperRight( bBox ) ) - yCoord( lowerLeft( bBox ) ))*0.5
;        println(xCoord( upperRight( bBox ) ))
;        println(xCoord( lowerLeft( bBox ) ))
        t_label=name
        t_just ="centerCenter"
        t_orient = "R0"
        t_font="stick"
        x_height=0.0625

        dbCreateLabel(
          d_cellView   ;; your db item of cv
          l_lpp  ;; list of layer and purpose pair
          n_x:n_y   ;; location of the label
          t_label      ;; your text of the label
          t_just       ;; your value for justification
          t_orient     ;; your value for orientation
          t_font       ;; your value for font
          x_height     ;; your value for font size or hight
        )
      )
    );foreach 
    return t
  );let
);procedure
;load("/rnda10/home/kimdy/private/SKILL/createPinName.il")
