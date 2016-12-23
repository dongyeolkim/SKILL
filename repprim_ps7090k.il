procedure( RepPrim( cvid )
  let( (   i inst )
		
;    cvid=deGetCellView()
    foreach( inst cvid->instances
;      println(inst->cellName)
      case( inst->libName
        ("umc13cis" 
          case( inst->cellName
            ("P_33_SP" SubRepPrim( cvid inst) )
            ("N_33_SP" SubRepPrim( cvid inst) )
            ("N_15_SP" SubRepPrim( cvid inst) )
            ("P_15_SP" SubRepPrim( cvid inst) ) (t i=1)
          )
        )
        ("basic"  i=1)
        ("analogLib" i=1)
        ("US_8ths" i=1)
        ("1533il11sg" i=1)
        ("title" i=1)
        ( t RepPrim( dbOpenCellViewByType( inst->libName inst->cellName "schematic" nil "a") ) 
        )
      )
    )

  );let
);procedure

procedure( HierRepPrim( libName cellName  viewName )
    let( ( )
      primitives=nil
      RepPrim( dbOpenCellViewByType( libName cellName viewName nil "a") )
;      println(primitives)
    )
)

procedure( SubRepPrim(  cvid  inst )
  let( (  cellname instname orient xy cdf p mstr newinst cdfgData paramName callback)

;    cvid=deGetCellView()

;    cellname=inst->cellName
    case( inst->cellName
      ("P_15_SP" cellname="pch" )
      ("N_15_SP" cellname="nch" )
      ("P_33_SP" cellname="pch_33" )
      ("N_33_SP" cellname="nch_33" )
    )
;    println(cellname)
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
;		mstr=dbOpenCellViewByType( "1533il11sg"  cellname "symbol")
		mstr=dbOpenCellViewByType( "1533il11sg"  cellname "symbol")
;		newinst=dbCreateInst( cvid mstr nil xy orient 1)
		newinst=schCreateInst( cvid mstr nil xy orient 1)
;    geDeselectAllFig(cvid)
;    geSelectFig(newinst)
;    schHiObjectProperty()
;    schObjPropForm->w->value=width
;    schObjPropForm->l->value=length
;    schObjPropForm->m->value=multiplier
;    schObjPropForm->fingers->value=fingers
;    hiFormApply(schObjPropForm)
;    hiFormCancel(schObjPropForm)
		cdfgData=cdfGetInstCDF(newinst)
		foreach( p cdfgData->parameters
		 if( p->name == "w"
		 then
		   p->value=width
;		   p=width
;       println(p->value)

       param=cdfFindParamByName(cdfgData "w")
       callback=param->callback
		   when(callback && callback != ""
;        println("evalw")
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
;		   p=length
;       println(p->value)

       param=cdfFindParamByName(cdfgData "l") 
       callback=param->callback 
       when(callback && callback != "" 
;         println("evall")
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
;		   p=multiplier
;       println(p->value)

       param=cdfFindParamByName(cdfgData "m")
       callback=param->callback
		   when(callback && callback != ""
;         println("evalm")
        errset(evalstring(callback))
       )
;		   paramName='multiplier
;		   callback=get(cdfgData paramName)->callback
;		   when(callback && callback != ""
;		     errset(evalstring( callback ) t )
;		   )
		 )
		 if( p->name == "fingers"
		 then
		   p->value=fingers
;		   p=fingers
;       println(p->value)

       param=cdfFindParamByName(cdfgData "fingers")
       callback=param->callback
		   when(callback && callback != ""
;         println("evalf")
        errset(evalstring(callback))
       )
;		   paramName='fingers
;		   callback=get(cdfgData paramName)->callback
;		   when(callback && callback != ""
;		     errset(evalstring( callback ) t )
;		   )
		 )
;		 if( p->name == "model"
;		 then
;		   p->value=cellname
;
;       param=cdfFindParamByName(cdfgData "model")
;       callback=param->callback
;		   when(callback && callback != ""
;        errset(evalstring(callback))
;       )
;;		   paramName='model
;;		   callback=get(cdfgData paramName)->callback
;;		   when(callback && callback != ""
;;		     errset(evalstring( callback ) t )
;;		   )
;
;		 )
		);foreach
    inst->master=mstr
 )
)
; load("/rnda10/home/kimdy/private/SKILL/repprim_ps7090k.il")
; HierRepPrim( "PCA030S" "PCA030S1_TOP_S11"  "schematic" )
; HierRepPrim( "PCA030S" "amp1"  "schematic" )
;X=car(geGetSelectedSet())
;CDF=cdfGetInstCDF(X)
