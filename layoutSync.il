
procedure( layoutSync()
  prog( (points coord x y)
    wid=""
    points=enterPoint( ?noInfix t ?prompts list( "Please click" ) )
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
    x=nth(0 points)
    y=nth(1 points)
    hiSetCurrentWindow(wid)
    hiRaiseWindow( wid )
    hiZoomIn( hiGetCurrentWindow() list( x-5:y-5 x+5:y+5) )
    return(t)
   )
)
; load("/rnda10/home/kimdy/private/SKILL/layoutSync.il")

