
procedure( SBCreateSymbol( @optional (cv geGetEditCellView()) )
  let( (termList)
   termList = nil
   foreach( inst cv~>instances
     foreach( instTerm inst~>instTerms
       when( length( instTerm~>net~>instTerms ) == 1 && null(instTerm~>net~>pins)

         printf("found floating term %s of inst %s\n" instTerm~>term~>name instTerm~>inst~>name )
         termList = cons( list(nil 'name instTerm~>term~>name 'direction instTerm~>term~>direction) termList )
         SBConnectPin( instTerm instTerm~>term~>name )
       ) ;when
     ) ; foreach
   ) ; foreach
   ;; create pins
   SBCreatePins( cv termList )
   ;; save
   dbSave( cv )
   ;; create symbol
   schPinListToSymbol( cv~>libName cv~>cellName "symbol" schSchemToPinList(cv~>libName cv~>cellName cv~>viewName) )
   ;; check
   schCheck( cv )
  ) ; let
) ; procedure


procedure( SBCreatePins( cv termList )
  let( (x y ipin opin iopin)
   x = int((caar(cv~>bBox) - 4*0.0625)/0.0625)*0.0625
   y = int(cadar(cv~>bBox)/0.0625)*0.0625
   ipin = dbOpenCellViewByType("basic" "ipin" "symbol" nil "r")
   opin = dbOpenCellViewByType("basic" "opin" "symbol" nil "r")
   iopin = dbOpenCellViewByType("basic" "iopin" "symboll" nil "r")
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

procedure( SBConnectPin( instTerm netName @optional (wireLen 0.0625*10) (textSize 0.0625) )
  let( (instBox pinBox xa xb ya yb x1 y1 x2 y2 mywire mylabel orient (cv instTerm~>cellView))

   ;; instance and pin coordinates
   pinBox = dbTransformBBox( car(instTerm~>term~>pins~>fig~>bBox) instTerm~>inst~>transform )
   instBox = dbTransformBBox( or(car(exists(x instTerm~>inst~>master~>shapes x~>lpp=='("instance" "drawing")))~>bBox instTerm~>inst~>bBox) instTerm~>inst~>transform )

   ;; calculate the center of instTerm
   xa = caar(pinBox)
   xb = caadr(pinBox)
   ya = cadar(pinBox)
   yb = cadadr(pinBox)
   x1 = (xa + xb)/2
   y1 = (ya + yb)/2

   ;; try to figure direction of wire from position of terminal
   cond(
    (caar(pinBox)<caar(instBox)      x2=x1-wireLen y2=y1 orient="R0" )        ;; leftwards
    (caadr(pinBox)>caadr(instBox)    x2=x1+wireLen y2=y1 orient="R0" )        ;; rightwards
    (cadar(pinBox)<cadar(instBox)    x2=x1 y2=y1-wireLen orient="R90")        ;; downwards
    (cadadr(pinBox)>cadadr(instBox)  x2=x1 y2=y1+wireLen orient="R90")        ;; upwards
    (t                               x2=x1 y2=y1+wireLen orient="R90")        ;; upwards by default
   ) ; cond
   ;; delete existing wires
   ;; mapcar( 'dbDeleteObject setof(x cv~>shapes x~>objType=="line" && member(instTerm x~>net~>instTerms) && member(list(x1 y1) x~>points)) )

   mywire = schCreateWire( cv "draw" "direct" list( list(x1 y1) list(x2 y2) ) 0.0625 0.0625 0.0)
   mylabel = schCreateWireLabel( cv car(mywire) list( x2 y2 ) netName "lowerCenter" orient "stick" textSize nil)
  ) ; let
) ; procedure
;load( "/rnda10/home/kimdy/private/SKILL/SBCreatePin.il")
