
procedure( layoutSync1()
;  prog( (points coord x y)
  prog( ( coord x y)
    wid=""
    point=enterPoint( ?noInfix t ?prompts list( "Please  Click Original Window" ) )
    points=geGetWindowBox( hiGetCurrentWindow())
    println(hiGetCurrentWindow())
    point=enterPoint( ?noInfix t ?prompts list( "Please Click Target Window" ) )
    println(hiGetCurrentWindow())
    wlists=hiGetWindowList()
    print(points)
;    foreach( wlist wlists
;      if( (wlist->cellView->cellViewType == "maskLayout")
;      then
;        if( wid == ""
;        then
;          libName=wlist->cellView->libName
;          cellName=wlist->cellView->cellName
;          viewName=wlist->cellView->viewName
;          wid=wlist
;        )
;      )
;    )
;    x=nth(0 points)
;   y=nth(1 points)
;    hiSetCurrentWindow(wid)
;    hiRaiseWindow( wid )
    hiZoomIn( hiGetCurrentWindow() points )
    return(t)
   )
)
; load("/rnda10/home/kimdy/private/SKILL/layoutSync1.il")

