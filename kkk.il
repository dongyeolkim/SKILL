procedure( kkk()
    prog( (currentlib currentcell currentview currentcell_1 )
         currentlib=hiGetCurrentWindow()->cellView->libName
        currentcell=hiGetCurrentWindow()->cellView->cellName
        currentview=hiGetCurrentWindow()->cellView->viewName
        currentcell_1=sprintf( nil "%s_1" currentcell)
        geSaveAs( hiGetCurrentWindow() currentlib currentcell_1 currentview )
      )
    )
