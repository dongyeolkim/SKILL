procedure( selectedNetName()
  prog( ( wid cv objs wlists libName cellName viewName)
    netlist='()
    nets=geGetSelectedSet()
    foreach( net nets
      if( net->objType == "inst"
      then
        netlist=cons( net->baseName netlist)
      else
        netlist=cons( car(net->net->sigNames) netlist)
      )
    )
    println(netlist)

    wid=""
    wlists=hiGetWindowList()
    foreach( wlist wlists
      if( (wlist->cellView->cellViewType == "maskLayout")
      then
        if( wid == ""
        then
          libName=wlist->cellView->libName
          cellName=wlist->cellView->cellName
          viewName=wlist->cellView->viewName
          wid=wlist
        )
      )
    )
    hiSetCurrentWindow(wid)
    hiRaiseWindow( wid )
    foreach( netname netlist
	    points=enterPoint( ?noInfix t ?prompts list( netname ) )
	    d_cellView=geGetEditCellView()
;	    l_lpp = list( "TEXT" "drawing")
	    l_lpp = leGetEntryLayer()
	    t_just ="centerCenter"
	    t_orient = "R0"
	    t_font="stick"
	    x_height=0.0625
	
	    dbCreateLabel(
	      d_cellView   ;; your db item of cv
	      l_lpp  ;; list of layer and purpose pair
	      points   ;; location of the label
	      netname      ;; your text of the label
	      t_just       ;; your value for justification
	      t_orient     ;; your value for orientation
	      t_font       ;; your value for font
	      x_height     ;; your value for font size or hight
	    )
    )

    return(t)
  )
)
; load("/rnda10/home/kimdy/private/SKILL/selectedNetName.il")
; selectedNetName
