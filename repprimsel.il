procedure( repprimsel()
  prog( ( i )
	  foreach( item geGetSelectedSet()
	    if( item->objType == "inst"
	    then
	      case( item->libName
	        ("1533il11sg" 
	          case( item->cellName
	            ("pch_33" subrepprimsel(item) )
	            ("nch_33" subrepprimsel(item) )
	            ("nch" subrepprimsel(item) )
	            ("pch" subrepprimsel(item) )
	            ("pch_33_mis_cir" subrepprimsel(item) )
	            ("nch_33_mis_cir" subrepprimsel(item) )
	            ("nch_mis_cir" subrepprimsel(item) )
	            ("pch_mis_cir" subrepprimsel(item) )
	            ("nch_na33" subrepprimsel(item) )
	            (t i=1)
	          )
	        )
	        ("basic"  i=1)
	        ("analogLib" i=1)
	        ("US_8ths" i=1)
	        ( t i=1 )
	      )
      )
    )
	return t	
  );let
)
; load("/rnda10/home/kimdy/private/SKILL/repprimsel.il")
procedure( subrepprimsel( item )
  prog( ( cvid  cellname instname orient xy cdf p mstr inst cdfgData paramName callback)
        cvid=deGetCellView()
	      cellname=item->cellName
				instname=item->name
				orient=item->orient
				xy=item->xy
	
				cdf=cdfGetInstCDF(item)
	
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
				)
				dbDeleteObject(item)
	
				mstr=dbOpenCellViewByType( "1533il11sg"  cellname "symbol")
				inst=dbCreateInst( cvid mstr nil xy orient 1)
				cdfgData=cdfGetInstCDF(inst)
				foreach( p cdfgData->parameters
				    if( p->name == "w"
				    then
				      p->value=width

              param=cdfFindParamByName(cdfgData "w")
              callback=param->callback
		          when(callback && callback != ""
                errset(evalstring(callback))
              )
;				      paramName='w
;				      callback=get(cdfgData paramName)->callback
;				      when(callback && callback != ""
;				        errset(evalstring( callback ) t )
;				      )
				    )
				    if( p->name == "l"
				    then
				      p->value=length

              param=cdfFindParamByName(cdfgData "l")
              callback=param->callback
		          when(callback && callback != ""
                errset(evalstring(callback))
              )
;				      paramName='l
;				      callback=get(cdfgData paramName)->callback
;				      when(callback && callback != ""
;				        errset(evalstring( callback ) t )
;				      )
				    )
				    if( p->name == "m"
				    then
				      p->value=multiplier

              param=cdfFindParamByName(cdfgData "m")
              callback=param->callback
		          when(callback && callback != ""
                errset(evalstring(callback))
              )
;				      paramName='m
;				      callback=get(cdfgData paramName)->callback
;				      when(callback && callback != ""
;				        errset(evalstring( callback ) t )
;				      )
				    )
				    if( p->name == "fingers"
				    then
				      p->value=fingers

              param=cdfFindParamByName(cdfgData "fingers")
              callback=param->callback
		          when(callback && callback != ""
                errset(evalstring(callback))
              )
;				      paramName='fingers
;				      callback=get(cdfgData paramName)->callback
;				      when(callback && callback != ""
;				        errset(evalstring( callback ) t )
;				      )
				    )
				)
        return t
		  )
  )
; load("/rnda10/home/kimdy/private/SKILL/repprimsel.il")
