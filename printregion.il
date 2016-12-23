
procedure( pr()
  let( (region prt)
    cv=hiGetCurrentWindow()
    windowId=geGetCellViewWindow(geGetEditCellView())
    moslist=geGetSelectedSet()
    geDeselectAll()
    geDeleteAllProbe(windowId)
    probe_LPP=list("y0" "drawing")
    ; geAddInstProbe( wnd Probe_Lpp inst)
    foreach( mos moslist
      if( mos->cellName == "pch_33" || mos->cellName == "nch_33"
      then
        region=OP( strcat( "/" mos->name ) "region")
        if( region 
        then
          if( region != 2.0 
          then
            geAddInstProbe(windowId probe_LPP strcat( "/" mos->name ) )
          )
          prt=sprintf( nil "%s %f" mos->name region)
          println(prt)
        )
      )
    )
    t
  )
)
;load("/rnda10/home/kimdy/private/SKILL/printregion.il")
