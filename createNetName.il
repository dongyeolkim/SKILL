procedure( createNetName()
  prog( ( wid cv objs wlists libName cellName viewName pinid labelid x y _pinwidth _pinheight)
    objs=geGetAllProbe(hiGetCurrentWindow())
    wlists=hiGetWindowList()
    foreach( wlist wlists
      if( (wlist->cellView->cellViewType == "maskLayout")
      then
        libName=wlist->cellView->libName
        cellName=wlist->cellView->cellName
        viewName=wlist->cellView->viewName
        wid=wlist
      )
    )
    cv=dbOpenCellViewByType( libName cellName viewName "maskLayout" "a")
    hiSetCurrentWindow(wid)
    hiRaiseWindow(wid)
    foreach( obj objs
      foreach( net obj->objectId->signals
        netname=sprintf(nil "%s" net->name)
        points=enterPoint( ?noInfix t ?prompts list( netname ) )
        x=car(points)
        y=car(cdr(points))
        _pinwidth=0.1
        _pinheight=0.1
        pinid=leCreatePin( geGetEditCellView() leGetEntryLayer() "rectangle" list( (x-_pinwidth/2.0):(y-_pinheight/2.0) (x+_pinwidth/2.0):(y+_pinheight/2.0) ) netname "input" list("left" "right") )
        labelid=dbCreateLabel(cv leGetEntryLayer() points netname "centerLeft" "R0" "roman" 0.1)
        leAttachFig(labelid pinid->fig)
      )
    )
    return(t)
  )
)
; load("/rnda10/home/kimdy/private/SKILL/createNetName.il")
; createNetName
