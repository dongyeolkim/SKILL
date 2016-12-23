procedure( repprim()
  let( (   i inst )
		
    cvid=deGetCellView()
    foreach( inst cvid->instances
;      println(inst->cellName)
      case( inst->libName
        ("1533il11sg" 
          case( inst->cellName
            ("pch_33" subrepprim(inst) )
            ("nch_33" subrepprim(inst) )
            ("nch" subrepprim(inst) )
            ("pch" subrepprim(inst) )
            ("pch_33_mis_cir" subrepprim(inst) )
            ("nch_33_mis_cir" subrepprim(inst) )
            ("nch_mis_cir" subrepprim(inst) )
            ("pch_mis_cir" subrepprim(inst) )
            ("nch_na33" subrepprim(inst) )
            (t i=1)
          )
        )
        ("basic"  i=1)
        ("analogLib" i=1)
        ("US_8ths" i=1)
        ( t i=1 )
      )
    )

  );let
);procedure
procedure( subrepprim( inst )
  let( (  cellname instname orient xy cdf p mstr newinst cdfgData paramName callback)

;    cvid=deGetCellView()

    cellname=inst->cellName
		instname=inst->name
		orient=inst->orient
		xy=inst->xy

		cdf=cdfGetInstCDF(inst)

		foreach( p cdf->parameters
		  if( p->name == "w"
		  then
		    width=p->value
		  )
		  if( p->name == "l"
		  then
		    length=p->value
		  )
		  if( p->name == "m"
		  then
		    multiplier=p->value
		  )
		  if( p->name == "fingers"
		  then
		    fingers=p->value
		  )
		) ; foreach
		dbDeleteObject(inst)
;    println("DDDDDDDDDDDDDDDDDDDD")
		mstr=dbOpenCellViewByType( "1533il11sg"  cellname "symbol")
		newinst=dbCreateInst( cvid mstr nil xy orient 1)
		cdfgData=cdfGetInstCDF(newinst)
		foreach( p cdfgData->parameters
;     println(p->name)
		 if( p->name == "w"
		 then
		   p->value=width

       param=cdfFindParamByName(cdfgData "w")
       callback=param->callback
		   when(callback && callback != ""
        errset(evalstring(callback))
       )

;		   paramName='w
;		   callback=get(cdfgData paramName)->callback
;		   when(callback && callback != ""
;		     errset(evalstring( callback ) t )
;		   )
		 )
		 if( p->name == "l"
		 then
		   p->value=length

       param=cdfFindParamByName(cdfgData "l")
       callback=param->callback
		   when(callback && callback != ""
        errset(evalstring(callback))
       )
;		   paramName='l
;		   callback=get(cdfgData paramName)->callback
;		   when(callback && callback != ""
;		     errset(evalstring( callback ) t )
;		   )
		 )
		 if( p->name == "m"
		 then
		   p->value=multiplier
       param=cdfFindParamByName(cdfgData "m")
       callback=param->callback
		   when(callback && callback != ""
        errset(evalstring(callback))
       )
;		   paramName='m
;		   callback=get(cdfgData paramName)->callback
;		   when(callback && callback != ""
;		     errset(evalstring( callback ) t )
;		   )
		 )
		 if( p->name == "fingers"
		 then
		   p->value=fingers
       param=cdfFindParamByName(cdfgData "fingers")
       callback=param->callback
		   when(callback && callback != ""
        errset(evalstring(callback))
       )
;		   paramName='fingers
;		   callback=get(cdfgData paramName)->callback
;		   when(callback && callback != ""
;		     errset(evalstring( callback ) t )
;		   )
		 )
		);foreach
 )
)
; load("/rnda10/home/kimdy/private/SKILL/repprim.il")
