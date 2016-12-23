procedure( CreateNetPin_mod( @optional (cv geGetEditCellView()) )
  let( (termList)
   termList = nil


    instList = geGetSelectedSet()
    foreach( inst instList
        foreach( instTerm inst~>instTerms
;           printf("found floating term %s of inst %s\n" instTerm~>term~>name instTerm~>inst~>name )
           termList = cons( list(nil 'name instTerm~>term~>name 'direction instTerm~>term~>direction) termList )
           SBConnectPin( inst->cellName instTerm instTerm~>term~>name )
        ) ; foreach
   ) ; foreach


   ;; create pins
   ;; SBCreatePins( cv termList )


   ;; save
   ;;; dbSave( cv )


   ;; create symbol
   ;;; schPinListToSymbol( cv~>libName cv~>cellName "symbol" schSchemToPinList(cv~>libName cv~>cellName cv~>viewName) )


   ;; check
   ;; schCheck( cv )


  ) ; let
) ; procedure


procedure( SBConnectPin( cellName instTerm netName @optional (wireLen 1.5) (textSize 0.0625) )
  let( ( instBox pinBox xa xb ya yb x1 y1 x2 y2 mywire mylabel orient (cv instTerm~>cellView))


   ;; instance and pin coordinates
   pinBox  = dbTransformBBox( car(instTerm~>term~>pins~>fig~>bBox) instTerm~>inst~>transform )
   instBox = dbTransformBBox( or(car(exists(x instTerm~>inst~>master~>shapes x~>lpp=='("instance" "drawing")))~>bBox instTerm~>inst~>bBox) instTerm~>inst~>transform )


   ;; calculate the center of instTerm
   xa = caar(pinBox)
   xb = caadr(pinBox)
   ya = cadar(pinBox)
   yb = cadadr(pinBox)
   x1 = (xa + xb)/2
   y1 = (ya + yb)/2


         
;         if( (!rexMatchp( "^CELL1_" cellName) && !rexMatchp( "^CELL2_" cellName) && !rexMatchp( "^CELL3_" cellName) && !rexMatchp("CELL4_" cellName) && !rexMatchp("^CELL5_" cellName) &&!rexMatchp("^CELL6_" cellName))
;         then
;                 if( instTerm->direction == "input"
;                 then
;                         if( rexMatchp( "^d2a_" netName)
;                        then
;                                if( rexMatchp( "<" netName)
;                                then
;                                        rexCompile("<")
;                                        netName=rexReplace(netName "_hiv<" 0)
;                                else
;                                        netName=strcat( netName "_hiv")                
;                                )
;                        )
;                 )
;        )


   ;; try to figure direction of wire from position of terminal
   cond(
    (caar(pinBox)<caar(instBox)      x2=x1-wireLen y2=y1 orient="R0"  iorient="R0"   oorient="R180" )        ;; leftwards
    (caadr(pinBox)>caadr(instBox)    x2=x1+wireLen y2=y1 orient="R0"  iorient="R180" oorient="R0"   )        ;; rightwards
    (cadar(pinBox)<cadar(instBox)    x2=x1 y2=y1-wireLen orient="R90" iorient="R90"  oorient="R270" )        ;; downwards
    (cadadr(pinBox)>cadadr(instBox)  x2=x1 y2=y1+wireLen orient="R90" iorient="R270" oorient="R90"  )        ;; upwards
    (t                               x2=x1 y2=y1+wireLen orient="R90" iorient="R270" oorient="R90"  )        ;; upwards by default
   ) ; cond


   ;(caar(pinBox)<caar(instBox)      x2=x1-wireLen y2=y1 orient="R0"  iorient="R0"   oorient="R180" )        ;; leftwards
   ;(caadr(pinBox)>caadr(instBox)    x2=x1+wireLen y2=y1 orient="R0"  iorient="R180" oorient="R0"   )        ;; rightwards
   ;(cadar(pinBox)<cadar(instBox)    x2=x1 y2=y1-wireLen orient="R90" iorient="R90"  oorient="R270" )        ;; downwards
   ;(cadadr(pinBox)>cadadr(instBox)  x2=x1 y2=y1+wireLen orient="R90" iorient="R270" oorient="R90"  )        ;; upwards


   ;; delete existing wires
   ;; mapcar( 'dbDeleteObject setof(x cv~>shapes x~>objType=="line" && member(instTerm x~>net~>instTerms) && member(list(x1 y1) x~>points)) )


   mywire = schCreateWire( cv "draw" "direct" list( list(x1 y1) list(x2 y2) ) 0.0625 0.0625 0.0)


   ;; mylabel = schCreateWireLabel( cv car(mywire) list( x2 y2 ) netName "lowerCenter" orient "stick" textSize nil)
;   mylabel = schCreateWireLabel( cv car(mywire) list( ((x1+x2)/2) ((y1+y2)/2) ) netName "lowerCenter" orient "stick" textSize nil)
   mylabel = schCreateWireLabel( cv car(mywire) list( ((x1+x2)/2) ((y1+y2)/2) ) netName "lowerLeft" orient "stick" textSize nil)


   ipin = dbOpenCellViewByType("basic" "ipin" "symbol" nil "r")
   opin = dbOpenCellViewByType("basic" "opin" "symbol" nil "r")
   iopin = dbOpenCellViewByType("basic" "iopin" "symbol" nil "r")
;   printf("Creating pin %s\n" instTerm->name)


     schCreatePin(
      cv
          case(instTerm->direction ("input" ipin) ("output" opin) ("inputOutput" iopin) (t ipin))
          netName
          instTerm->direction
          nil
          list(x2 y2)
          case(instTerm->direction ("input" iorient) ("output" oorient) ("inputOutput" iorient) (t iorient))
     )
  ) ; let
) ; procedure


procedure( SBCreatePins( cv termList )
  let( (x y ipin opin iopin)
   x = int((caar(cv~>bBox) - 4*0.0625)/0.0625)*0.0625
   y = int(cadar(cv~>bBox)/0.0625)*0.0625
   ipin = dbOpenCellViewByType("basic" "ipin" "symbol" nil "r")
   opin = dbOpenCellViewByType("basic" "opin" "symbol" nil "r")
   iopin = dbOpenCellViewByType("basic" "iopin" "symbol" nil "r")
   foreach( term termList
    unless(dbFindTermByName(cv term->name)
     printf("Creating pin %s\n" term->name)
     schCreatePin(
      cv
          case(term->direction ("input" ipin) ("output" opin) ("inputOutput" iopin) (t ipin))
          term->name
          term->direction
          nil
          list(x y)
          "R180"
     )
     y = y + 4*0.0625
    ) ; unless
   ) ; foreach
   mapcar('dbClose list(ipin opin iopin))
  ) ; let
) ; procedure

; load("/rnda10/home/kimdy/private/SKILL/autoCreatePinWire_mod.il")
