ciwMenuInit()
trStreamOut = hiCreateMenuItem(   
  ?name 'trStreamOut   
  ?itemText "Verification"   
  ?callback "ipc(\"/rnda10/home/kimdy/private/Python/PwrExtractLibBrowser6/pypwr.py\")"
)
gvimcdsinit = hiCreateMenuItem(   
        ?name 'gvimcdsinit   
        ?itemText "gvim .cdsinit"   
;        ?callback "system(gvim(\".cdsinit\"))"   
        ?callback "system(\"gvim .cdsinit\")"   
)
gvimcdslib = hiCreateMenuItem(   
        ?name 'gvimcdslib   
        ?itemText "gvim cds.lib"   
;        ?callback "system(gvim(\".cdsinit\"))"   
        ?callback "system(\"gvim cds.lib\")"   
)
Terminal = hiCreateMenuItem(   
        ?name 'Terminal   
        ?itemText "Terminal"   
;        ?callback "system(gvim(\".cdsinit\"))"   
        ?callback "system(\"gnome-terminal&\")"   
)
;trDelHilit = hiCreateMenuItem(   
;        ?name 'trDelHilit   
;        ?itemText "DelHilit"   
;        ?callback "delhilit()"   
;)
trPulldownMenu=hiCreatePulldownMenu(            
        'trPulldownMenu            "SkillMenu"            
        list( trStreamOut Terminal gvimcdsinit gvimcdslib)            
)
hiInsertBannerMenu(window( 1 ) trPulldownMenu 4)
procedure( delhilit()
  if( boundp( 'set1 )
  then
                        if( geIsValidHilightSet( set1 ) 
                        then
                                geDeleteHilightSet( set1 )
                        )
        )
        hiRedraw( hiGetCurrentWindow() )
        hiRaiseWindow( hiGetCurrentWindow() )
)
procedure( ipc(symCommand )    
;                if( ipcIsAliveProcess( tclpid )
;                then
;                        ipcKillProcess(tclpid)
                        tclpid=ipcBeginProcess(symCommand ""  "dataH" "simErr" "simTerm")
;                        println("DD")
;                else
;                        tclpid=ipcBeginProcess(symCommand ""  "dataH" "simErr" "simTerm")
;                        println("CC")
;                )
;        ipcWriteProcess( tclpid "data" )
;ipcKillProcess(tclpid)
;ipcKillAllProcesses()
)
procedure( dataH(cid data)    
prog( (cv l len v a  cv cd s flag fun bBox)
        println(data)
        datalist=parseString(data "\n");
        foreach( each datalist
                evalstring(each)
        )
);prog
);procedure data
procedure( simErr( cid err)    
println( err )
)
procedure( simTerm( cid exit)    
println("exit")
)

;;
;; This file contains a command that takes library, cell, view, and
;; mode values and performs an open using deOpen. The associated form
;; also contains a 'Browse' button to exercise the custom library
;; browser integration although it will also work with DFII's default
;; browser as well.
;;
;procedure(LaySchBrowser( cellViewType )
procedure(LaySchBrowser()
  if( boundp('myOpenForm) && hiIsForm(myOpenForm) then
      hiSetCurrentField(myOpenForm 'libName)
  else
    let((itemL)
      itemL = tconc(itemL list(hiCreateStringField(
          ?name                 'libName
          ?prompt               "Library"
          ?value                ""
          ?callback             "myOpenLibCB()"
      ) 5:0 200:30 60))
      itemL = tconc(itemL list(hiCreateStringField(
          ?name                'cellName
          ?prompt               "Cell"
          ?value                ""
          ?callback             "myOpenCellCB()"
      ) 5:30 200:30 60))
      itemL = tconc(itemL list(hiCreateStringField(
          ?name                'viewName
          ?prompt              "View"
          ?value               ""
          ?callback            "myOpenViewCB()"
      ) 5:60 200:30 60))
      itemL = tconc(itemL list(hiCreateRadioField(
          ?name                'mode
          ?prompt              "Mode"
          ?choices             '("edit" "read")
          ?value               "read"
      ) 5:90 200:30 60))
      itemL = tconc(itemL list(hiCreateFormButton(
          ?name                'browse
          ?buttonText          "Browse"
          ?callback            "myOpenBrowseCB()"
      ) 5:120 60:25))

      hiCreateAppForm(
          ?name                    'myOpenForm
          ?formTitle               "Open Cellview"
          ?fields                  car(itemL)
          ?help                    ""
          ?buttonLayout            'OKCancelApply
          ?formType                'nonOptions
          ?callback                '("myOpenCB('ok)" "myOpenCB('cancel)")
          ?unmapAfterCB            t
      )
     )
  );if
;  ddsSyncWithForm(myOpenForm 'open 'libName 'cellName 'viewName)
  ddsSyncWithForm(myOpenForm 'browse 'libName 'cellName 'viewName)
  hiDisplayForm(myOpenForm)
)

procedure( myOpenBrowseCB()
  ddsSyncWithForm(myOpenForm 'browse 'libName 'cellName 'viewName)
)

procedure( myOpenLibCB()
  let( (form libN)
    form = myOpenForm
    libN = form->libName->value

    hiHighlightField(form 'cellName hicBackground)
    hiHighlightField(form 'viewName hicBackground)
    when( libN != "" && ddGetObj(libN)
      hiHighlightField(form 'libName hicBackground)
    )
    ddsUpdateSyncWithForm()
  )
)

procedure( myOpenCellCB()
  let( (form libN cellN)
    form = myOpenForm
    libN = form->libName->value
    cellN = form->cellName->value

    hiHighlightField(form 'libName hicBackground)
    hiHighlightField(form 'viewName hicBackground)
    when( libN != "" && cellN != "" && ddGetObj(libN cellN)
      hiHighlightField(form 'cellName hicBackground)
    )
    ddsUpdateSyncWithForm()
  )
)

procedure( myOpenViewCB()
  let( (form libN cellN viewN)
    form = myOpenForm
    libN = form->libName->value
    cellN = form->cellName->value
    viewN = form->viewName->value

    hiHighlightField(form 'libName hicBackground)
    hiHighlightField(form 'cellName hicBackground)
    when( libN != "" && cellN != "" && viewN != "" &&
      ddGetObj(libN cellN viewN)
      hiHighlightField(form 'viewName hicBackground)
    )
    ddsUpdateSyncWithForm()
  )
)

procedure( myOpenCB(okOrCan "s")
  prog( (form fspec libN cellN viewN id vType)

    when(eq(okOrCan 'cancel)
      ddsEndSyncWithForm()
      return()
    )
    form = myOpenForm
    libN = form->libName->value
    cellN = form->cellName->value
    viewN = form->viewName->value
    cond(
      (libN == ""
        hiSetCallbackStatus(form nil)
        hiSetCurrentField(form 'libName)
        hiHighlightField(form 'libName hicError)
        myOpenDBox("Need Library Name" "Please enter a library name.")
        return()
      )
      (cellN == ""
        hiSetCallbackStatus(form nil)
        hiSetCurrentField(form 'cellName)
        hiHighlightField(form 'cellName hicError)
        myOpenDBox("Need Cell Name" "Please enter a cell name.")
        return()
      )
      (viewN == ""
        hiSetCallbackStatus(form nil)
        hiSetCurrentField(form 'viewName)
        hiHighlightField(form 'viewName hicError)
        myOpenDBox("Need View Name" "Please enter a view name.")
        return()
      )
      (!ddGetObj(libN cellN viewN)
        hiSetCallbackStatus(form nil)
        hiSetCurrentField(form 'viewName)
        hiHighlightField(form 'viewName hicError)
        myOpenDBox("Not Found"
        sprintf(nil strcat("Cellview '%s/%s/%s' does not exist.\n"
        "Please check your entries.")
        libN cellN viewN))
        return()
      )
    )
    hiSetCallbackStatus(form t)
    hiFormUnmap(form)
    ddsEndSyncWithForm()
  
    fspec = list(nil
      'libName	 libN
      'cellName	 cellN
      'viewName	 viewN
      'viewType	 nil
      'accessMode	 form->mode->value
    )
  
    cellProp=strcat( "LaySet" " " libN " " cellN " " viewN " " cellN ".gds" "\n")
    ipcWriteProcess( tclpid cellProp )
    println(cellProp)

    return( fspec  )
  )
)

procedure( myOpenDBox(banner msg "tt")
  hiDisplayAppDBox(
    ?name	 'myDBox
    ?dboxBanner	 banner
    ?dboxText	 msg
    ?dialogType	 hicErrorDialog
    ?buttonLayout	 'Close
  )
)

;load("/rnda6/home/kimdy/work/PI4008K/ddsWithSyncForm.il")
procedure( boxDone( w done pts )
  if( done 
        then
                bstartx1=nth( 0 car(pts))
                bstarty1=nth( 1 car(pts))
                bstartx2=nth( 0 car(cdr(pts)))
                bstarty2=nth( 1 car(cdr(pts)))
  else
     println("Box entry aborted.")
  )
)
procedure(        LaySchList( cellViewType)
        let( (lcv oneCell cellList)
        cellList=nil
        foreach( win hiGetWindowList()
                when( win->cellView
                        if( (win->cellView->cellViewType == cellViewType)
                        then
                                cv=win->cellView
                                oneCell=sprintf( nil "%s %s %s" cv->libName cv->cellName cv->viewName )
                                cellList=append( cellList list(oneCell))
                        );if
                );when
        );foreach
        if( cellList
        then
                cellShowListBox( cellList cellViewType )
        else
                println("%s is not opened!!!!" cellViewType)
        )
        );let
);procedure
procedure( cellShowListBox( cellList cellViewType )
        prog( ( listBoxSymbol )
                listBoxSymbol=gensym( 'trCellListBox )
                hiShowListBox(
                        ?name listBoxSymbol
                        ?choices cellList
                        ?callback 'trCellListBoxCB
                        ?title        sprintf( nil "%s" cellViewType )
                        ?multipleSelect nil
                        ?applyButton nil
                        )
        );let
);procedure
procedure( trCellListBoxCB( ok theListBox )
        prog( (libN cellN viewN libcellview)
                println("trCellListBoxCB")
        if( ok
        then
                libcellview=parseString( car(theListBox->value) )
                libN=nth( 0  libcellview )
                cellN=nth( 1  libcellview )
                viewN=nth( 2  libcellview )
;                "The callback routine"
                if( libN != "" && cellN != "" && viewN != ""
                then
                if( theListBox->title == "maskLayout"
                then
                        cellProp=strcat( "LaySet" " " libN " " cellN " " viewN " " cellN ".gds" "\n")
                        ipcWriteProcess( tclpid cellProp )
												println(cellProp)
                )
                if( theListBox->title == "schematic"
                then
;                        cellProp=strcat( "SchSet" " " libN " " cellN " " viewN " " cellN ".net" "\n")
                        cellProp=strcat( "SchSet" " " libN " " cellN " " viewN " " cellN ".cdl" "\n")
                        ipcWriteProcess( tclpid cellProp )
												println(cellProp)
                )
                )
        )
        )
);procedure
procedure( drc_zoom( num libName cellName viewName @rest coord)
prog( (exist) 
        exist=0
        if( num == 0
        then
                foreach( win hiGetWindowList()
                when( win->cellView
                        if( (win->cellView->libName == libName)
                         then
                                if( (win->cellView->cellName == cellName)
                                then
                                        if( (win->cellView->viewName == viewName)
                                        then
                                                exist=1
                                                hiSetCurrentWindow( win )
                                                hiRaiseWindow( win )
                                        )
                                )
                        )
                );when
                );foreach
                if( exist == 0
                then
                        geOpen( ?window hiGetCurrentWindow( ) ?lib libName ?cell cellName ?view viewName ?viewType "maskLayout" ?mode "r" )
                )
        )
  cv=hiGetCurrentWindow()
        len=length(coord)        
        for( i 0 len-1
                if( (i == 0)
                then
                        a=nth(i coord)
                  a=float(a)
                  a=a/1000
                  sprintf( s "list( %f:" a )        
          else
                        if( evenp(i)
                        then
                                a=nth(i coord) 
                                a=float(a)
                                a=a/1000
                           sprintf( s "%s%f:" s a )        
                        else
                                a=nth(i coord)
                                a=float(a)
                                a=a/1000
                          sprintf( s "%s%f " s a )        
                        )
          )
        )
        sprintf( s "%s)" s);
        if( boundp( 'set1 )
        then
                if( geIsValidHilightSet( set1 ) 
                then
                        if( num == 0
                        then
                                geDeleteHilightSet( set1 )
                        )
                )
        )
        ;hiSetCurrentWindow( cv ) ;hiDisplayWindow( cv ) ;geRefreshWindow( cv) ;hiRaiseWindow( cv )
        if( num == 0
        then
                set1=geCreateHilightSet( geGetEditCellView( hiGetCurrentWindow() )  list("hilite" "drawing1") nil )
        )
        if( len == 4 
        then
                geAddHilightRectangle( set1 evalstring(s) )
        else
                geAddHilightPolygon( set1 evalstring(s) )
        )
        set1->enable=t
        bBox=Zoom_bBox( s )
        hiZoomIn( cv evalstring(bBox) )
        ;hiZoomOut( cv )
        hiZoomRelativeScale(hiGetCurrentWindow() 0.5)
        hiRedraw( cv )
);prog
);procedure
procedure( Zoom_bBoxs(  @rest coord) 
  cv=hiGetCurrentWindow()
        len=length(coord)        
        for( i 0 len-1
                if( (i == 0)
                then
                        a=nth(i coord)
                  a=float(a)
                  a=a/1000
                  sprintf( s "list( %f:" a )        
          else
                        if( evenp(i)
                        then
                                a=nth(i coord) 
                                a=float(a)
                                a=a/1000
                           sprintf( s "%s%f:" s a )        
                        else
                                a=nth(i coord)
                                a=float(a)
                                a=a/1000
                          sprintf( s "%s%f " s a )        
                        )
          )
        )
        sprintf( s "%s)" s)
        bBox=Zoom_bBox( s )
        hiZoomIn( cv evalstring(bBox) )
        hiZoomRelativeScale(hiGetCurrentWindow() 0.5)
        hiRedraw( cv )
)
procedure( Zoom_bBox( zoom_list)
prog( (zoomlist zoomvec len xy xx yy xmin xmax ymin ymax bBox)
        zoomlist=parseString( zoom_list )
  zoomvec=listToVector( zoomlist )
  len=length( zoomlist )
        for( i 1 len-2
                xy=parseString( zoomvec[i] ":" )
                xx=evalstring( nth( 0 xy) )
                yy=evalstring( nth( 1 xy) )
                if( (i == 1) 
                then
                        xmin=xx
                        xmax=xx
                        ymin=yy
                        ymax=yy
                else
                        if( (xmin > xx)
                        then
                                xmin=xx
                        )
                        if( (xmax < xx)
                        then
                                xmax=xx
                        )
                        if( (ymin > yy)
                        then
                                ymin=yy
                        )
                        if( (ymax < yy)
                        then
                                ymax=yy
                        )
                )
        )
        sprintf( bBox "list( %f:%f %f:%f )" xmin ymin xmax ymax )
        return( bBox )
)
)
procedure( probe()
prog( (probeList p a data out_port)
        probeList=geGetAllProbe( hiGetCurrentWindow() )
        i=1
        if(! (out_port = outfile(".probe")) then 
                printf("Output file creation error\n")
    return()
  )
        foreach(p probeList 
                if( p->probeType == "net"
                then
                        if( p->objectId->numBits == 1
                        then
                                hierList=parseString( p->pathList "/" )
                                l=length( hierList )
                                if( (l==0) 
                                then
                                        a=strcat( "v(" p->pathObjectName ") " )
                                else
                                        hier=buildString(hierList ".X")
                                        hier=strcat( "X" hier)
                                        a=strcat( "v(" hier "." p->pathObjectName ") " )
                                )
                                data=strcat( ".probe " a )
                                data=strcat( data "\n" )
                                fprintf( out_port data)
                                i=i+1
                        else
                                hierList=parseString( p->pathList "/" )
                                l=length( hierList )
                                if( (l==0) 
                                then
                                        foreach( sigName p->objectId->sigNames
                                                a=strcat( "v(" sigName ") " )
                                                data=strcat( ".probe " a )
                                                data=strcat( data "\n" )
                                                fprintf( out_port data)
                                        )
                                else
                                        hier=buildString(hierList ".X")
                                        hier=strcat( "X" hier)
                                        foreach( sigName p->objectId->sigNames
                                                a=strcat( "v(" hier "." sigName ") " )
                                                data=strcat( ".probe " a )
                                                data=strcat( data "\n" )
                                                fprintf( out_port data)
                                        )
                                )
                                i=i+1
                        )
                else
                        hierList=parseString( p->pathList "/" )
                        l=length( hierList )
                        if( (l==0) 
                        then
                                a=strcat( "i(" p->pathObjectName ") " )
                        else
                                hier=buildString(hierList ".X")
                                hier=strcat( "X" hier)
                                a=strcat( "i(" hier "." p->pathObjectName ") " )
                        )
                        data=strcat( ".probe " a )
                        data=strcat( data "\n" )
                        fprintf( out_port data)
                        i=i+1
                )
        )
        close(out_port)
        system("gvim -geom 100x100 .probe")
        return t
)
)
procedure( z( x y )
  cv=hiGetCurrentWindow()
        if( (cv->cellView->viewName != "layout")
        then
                foreach( win hiGetWindowList()
                        when( win->cellView
                          if( (win->cellView->viewName == "layout")
                          then
                                        cv=win->cellView
                                        hiSetCurrentWindow( win )
                                        hiRaiseWindow( win )
                                        ;hiSetCursor(win)
                                )
                        )
          )
        else
        hiRaiseWindow( cv )
        )
;        hiZoomIn( hiGetCurrentWindow() list( x-0.1:y-0.1 x+0.1:y+0.1) )
        hiZoomIn( hiGetCurrentWindow() list( x-1:y-1 x+1:y+1) )
)
