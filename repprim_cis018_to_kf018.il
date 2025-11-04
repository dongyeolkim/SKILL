procedure( HierFind()
    let( ( )
    cvid=deGetCellView()
      primitives=nil
      println( cvid->libName )
      println( cvid->cellName )
      println( cvid->viewName )
      repprim( dbOpenCellViewByType( cvid->libName cvid->cellName cvid->viewName "schematic" "a") )
    )
)
procedure( repprim(cvid)
  let( (   i inst )
  if( cvid
  then
    println("************************************")
    printf("****%s %s %s****\n" cvid->libName cvid->cellName cvid->viewName)
    println("************************************")
    foreach( inst cvid->instances
      case( inst->libName
        ("1833is18sh"
          case( inst->cellName
            ("pch3"           println(inst->cellName) subrepprim(inst "xpch_tk50") )
            ("nch3"           println(inst->cellName) subrepprim(inst "xnch_tk50") )


            ("rhighr"         println(inst->cellName) rsubrepprim(inst "rdhpo_ns1k") )

            ("mimcap_2p0"     println(inst->cellName) ccsubrepprim(inst "cmim2") )


            ("pnph2"             println(inst->cellName) qsubrepprim(inst "xvp2h") )


            ("dn"             println(inst->cellName) dsubrepprim(inst "dn") )
            ("dp"             println(inst->cellName) dsubrepprim(inst "dp") )



            ("basic"     i=1)
            ("analogLib" i=1)
            ("US_8ths"   i=1)
            ( t          i=1 )
          )
        )
        ("PRIMLIB"            
          case( inst->cellName
            ("vdd3i"             println(inst->cellName) psubrepprim(inst "vdd3i") )
            ("gnd3i"             println(inst->cellName) gsubrepprim(inst "gnd3i") )
            ( t          i=1 )
          )
        )
        ("SO6214_R0_V1"           repprim( dbOpenCellViewByType( inst->libName inst->cellName   list( "schematic"  "cmos_sch") nil "a") ) )
        ("SO6204"                 repprim( dbOpenCellViewByType( inst->libName inst->cellName   list( "schematic"  "cmos_sch") nil "a") ) )
        ("SO6204_TEST"            repprim( dbOpenCellViewByType( inst->libName inst->cellName   list( "schematic"  "cmos_sch") nil "a") ) )
        ("D_CELL_CIS018_3V"       repprim( dbOpenCellViewByType( inst->libName inst->cellName   list( "schematic"  "cmos_sch") nil "a") ) )
        ("SO6214_R0_V1_LOGIC"     repprim( dbOpenCellViewByType( inst->libName inst->cellName   list( "schematic"  "cmos_sch") nil "a") ) )
        ("DB_DCELL"               repprim( dbOpenCellViewByType( inst->libName inst->cellName   list( "schematic"  "cmos_sch") nil "a") ) )
        ("TEST_DCELL"             repprim( dbOpenCellViewByType( inst->libName inst->cellName   list( "schematic"  "cmos_sch") nil "a") ) )
        ("basic"  i=1)
        ("analogLib" i=1)
        ("US_8ths" i=1)
        ( t i=1 )
      )
    )
  );if
  );let
);procedure
;SO6214_R0_V1
;SO6204
;D_CELL_CIS018_3V
;TEST_DCELL

;SO6204_TEST
procedure( gsubrepprim( inst hcellname)
  let( (  cellname instname orient xy cdf p mstr newinst cdfgData paramName callback)
        cellname=inst->cellName
        instname=inst->name
        orient=inst->orient
        xy=inst->xy


        dbDeleteObject(inst)
        mstr=dbOpenCellViewByType( "SO6204"  hcellname "symbol")
        newinst=dbCreateInst( cvid mstr nil xy orient 1)
        cdfgData=cdfGetInstCDF(newinst)
 );let
);procedure
procedure( psubrepprim( inst hcellname)
  let( (  cellname instname orient xy cdf p mstr newinst cdfgData paramName callback)
        cellname=inst->cellName
        instname=inst->name
        orient=inst->orient
        xy=inst->xy


        dbDeleteObject(inst)
        mstr=dbOpenCellViewByType( "SO6204"  hcellname "symbol")
        newinst=dbCreateInst( cvid mstr nil xy orient 1)
        cdfgData=cdfGetInstCDF(newinst)
 );let
);procedure
procedure( qsubrepprim( inst hcellname)
  let( (  cellname instname orient xy cdf p mstr newinst cdfgData paramName callback)
        cellname=inst->cellName
        instname=inst->name
        orient=inst->orient
        xy=inst->xy


        dbDeleteObject(inst)
        mstr=dbOpenCellViewByType( "MPDK_HP18E40GEN3"  hcellname "symbol")
        newinst=dbCreateInst( cvid mstr nil xy orient 1)
        cdfgData=cdfGetInstCDF(newinst)
 );let
);procedure

procedure( ccsubrepprim( inst hcellname)
  let( (  cellname instname orient xy cdf p mstr newinst cdfgData paramName callback)
        multiplier="1"
        fingers="1"
        cellname=inst->cellName
        instname=inst->name
        orient=inst->orient
        xy=inst->xy
        width="4u"
        length="4u"


        dbDeleteObject(inst)
        mstr=dbOpenCellViewByType( "MPDK_HP18E40GEN3"  hcellname "symbol")
        newinst=dbCreateInst( cvid mstr nil xy orient 1)
        cdfgData=cdfGetInstCDF(newinst)
 )
)

procedure( rsubrepprim( inst hcellname)
  let( (  cellname instname orient xy cdf p mstr newinst cdfgData paramName callback)
        multiplier="1"
        fingers="1"
        cellname=inst->cellName
        instname=inst->name
        orient=inst->orient
        xy=inst->xy
        ssegs="1"
        psegs="1"

	    width="2u"
	    length="10u"

        foreach( p inst->prop
          if( p->name == "segW"
          then
            width=p->value
          )
          if( p->name == "segL"
          then
            length=p->value
          )
          if( p->name == "m"
          then
            multiplier=p->value
          )
        ) ; foreach

        printf("%s %s %s" width length multiplier )

        dbDeleteObject(inst)
        mstr=dbOpenCellViewByType( "MPDK_HP18E40GEN3"  hcellname "symbol")
        newinst=dbCreateInst( cvid mstr nil xy orient 1)
        cdfgData=cdfGetInstCDF(newinst)
        foreach( p cdfgData->parameters
         if( p->name == "segL"
         then
           p->value=length

           param=cdfFindParamByName(cdfgData "segL")
           callback=param->callback
           when(callback && callback != ""
               errset(evalstring(callback))
           )
         )
        );foreach
        foreach( p cdfgData->parameters
         if( p->name == "segW"
         then
           p->value=width

           param=cdfFindParamByName(cdfgData "segW")
           callback=param->callback
           when(callback && callback != ""
               errset(evalstring(callback))
           )

         )
         if( p->name == "m"
         then
           p->value=multiplier
           param=cdfFindParamByName(cdfgData "m")
           callback=param->callback
           when(callback && callback != ""
               errset(evalstring(callback))
           )
         )
        );foreach
 )
)

procedure( subrepprim( inst hcellname)
  let( (  cellname instname orient xy cdf p mstr newinst cdfgData paramName callback)
        multiplier="1"
        fingers="1"
	    width="0.22u"
        length="0.3u"
        if( inst->cellName == "nch3"
        then
            length="0.35u"
        )

        cellname=inst->cellName
        instname=inst->name
        orient=inst->orient
        xy=inst->xy


        foreach( p inst->prop
          if( p->name == "fw"
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

        printf("%s %s %s %s" width length multiplier fingers)

        dbDeleteObject(inst)
        mstr=dbOpenCellViewByType( "MPDK_HP18E40GEN3"  hcellname "symbol")
        newinst=dbCreateInst( cvid mstr nil xy orient 1)
        cdfgData=cdfGetInstCDF(newinst)
        foreach( p cdfgData->parameters
         if( p->name == "fw"
         then
           p->value=width

           param=cdfFindParamByName(cdfgData "fw")
           callback=param->callback
           when(callback && callback != ""
               errset(evalstring(callback))
           )

         )
         if( p->name == "l"
         then
           p->value=length

           param=cdfFindParamByName(cdfgData "l")
           callback=param->callback
           when(callback && callback != ""
               errset(evalstring(callback))
           )
         )
         if( p->name == "m"
         then
           p->value=multiplier
           param=cdfFindParamByName(cdfgData "m")
           callback=param->callback
           when(callback && callback != ""
               errset(evalstring(callback))
           )
         )
         if( p->name == "fingers"
         then
           p->value=fingers
           param=cdfFindParamByName(cdfgData "fingers")
           callback=param->callback
           when(callback && callback != ""
               errset(evalstring(callback))
           )
         )
        );foreach
 );let
);procedure



procedure( dsubrepprim( inst hcellname)
  let( (  cellname instname orient xy cdf p mstr newinst cdfgData paramName callback)
        multiplier="1"
        fingers="1"
	    width="3u"
	    length="3u"
        cellname=inst->cellName
        instname=inst->name
        orient=inst->orient
        xy=inst->xy


        foreach( p inst->prop
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
          if( p->name == "nf"
          then
            fingers=p->value
          )
        ) ; foreach
        dbDeleteObject(inst)
        mstr=dbOpenCellViewByType( "ntc1121"  hcellname "symbol")
        newinst=dbCreateInst( cvid mstr nil xy orient 1)
        cdfgData=cdfGetInstCDF(newinst)
        foreach( p cdfgData->parameters
         if( p->name == "w"
         then
           p->value=width

           param=cdfFindParamByName(cdfgData "w")
           callback=param->callback
           when(callback && callback != ""
               errset(evalstring(callback))
           )

         )
         if( p->name == "l"
         then
           p->value=length

           param=cdfFindParamByName(cdfgData "l")
           callback=param->callback
           when(callback && callback != ""
               errset(evalstring(callback))
           )
         )
         if( p->name == "m"
         then
           p->value=multiplier
           param=cdfFindParamByName(cdfgData "m")
           callback=param->callback
           when(callback && callback != ""
               errset(evalstring(callback))
           )
         )
         if( p->name == "fingers"
         then
           p->value=fingers
           param=cdfFindParamByName(cdfgData "fingers")
           callback=param->callback
           when(callback && callback != ""
               errset(evalstring(callback))
           )
         )
        );foreach
 );let
);procedure
procedure( qqsubrepprim( inst hcellname)
  let( (  cellname instname orient xy cdf p mstr newinst cdfgData paramName callback)
        multiplier="1"
        fingers="1"
	    width="2u"
	    length="0.5u"
        cellname=inst->cellName
        instname=inst->name
        orient=inst->orient
        xy=inst->xy


        foreach( p inst->prop
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
          if( p->name == "nf"
          then
            fingers=p->value
          )
        ) ; foreach
        dbDeleteObject(inst)
        mstr=dbOpenCellViewByType( "ntc1121"  hcellname "symbol")
        newinst=dbCreateInst( cvid mstr nil xy orient 1)
        cdfgData=cdfGetInstCDF(newinst)
        foreach( p cdfgData->parameters
         if( p->name == "w"
         then
           p->value=width

           param=cdfFindParamByName(cdfgData "w")
           callback=param->callback
           when(callback && callback != ""
               errset(evalstring(callback))
           )

         )
         if( p->name == "l"
         then
           p->value=length

           param=cdfFindParamByName(cdfgData "l")
           callback=param->callback
           when(callback && callback != ""
               errset(evalstring(callback))
           )
         )
         if( p->name == "m"
         then
           p->value=multiplier
           param=cdfFindParamByName(cdfgData "m")
           callback=param->callback
           when(callback && callback != ""
               errset(evalstring(callback))
           )
         )
;         if( p->name == "fingers"
;         then
;           p->value=fingers
;           param=cdfFindParamByName(cdfgData "fingers")
;           callback=param->callback
;           when(callback && callback != ""
;               errset(evalstring(callback))
;           )
;         )
        );foreach
 );let
);procedure
procedure( dsubrepprim( inst hcellname)
  let( (  cellname instname orient xy cdf p mstr newinst cdfgData paramName callback)
        multiplier="1"
        fingers="1"
	    width="3u"
	    length="3u"
        cellname=inst->cellName
        instname=inst->name
        orient=inst->orient
        xy=inst->xy


        foreach( p inst->prop
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
;          if( p->name == "nf"
;          then
;            fingers=p->value
;          )
        ) ; foreach
        dbDeleteObject(inst)
        mstr=dbOpenCellViewByType( "ntc1121"  hcellname "symbol")
        newinst=dbCreateInst( cvid mstr nil xy orient 1)
        cdfgData=cdfGetInstCDF(newinst)
        foreach( p cdfgData->parameters
         if( p->name == "w"
         then
           p->value=width

           param=cdfFindParamByName(cdfgData "w")
           callback=param->callback
           when(callback && callback != ""
               errset(evalstring(callback))
           )

         )
         if( p->name == "l"
         then
           p->value=length

           param=cdfFindParamByName(cdfgData "l")
           callback=param->callback
           when(callback && callback != ""
               errset(evalstring(callback))
           )
         )
         if( p->name == "m"
         then
           p->value=multiplier
           param=cdfFindParamByName(cdfgData "m")
           callback=param->callback
           when(callback && callback != ""
               errset(evalstring(callback))
           )
         )
;         if( p->name == "fingers"
;         then
;           p->value=fingers
;           param=cdfFindParamByName(cdfgData "fingers")
;           callback=param->callback
;           when(callback && callback != ""
;               errset(evalstring(callback))
;           )
;         )
        );foreach
 );let
);procedure
procedure( subrepprim_mv( inst hcellname)
  let( (  cellname instname orient xy cdf p mstr newinst cdfgData paramName callback)
        multiplier="1"
        fingers="1"
	    width="4u"
	    length="1u"
        cellname=inst->cellName
        instname=inst->name
        orient=inst->orient
        xy=inst->xy


        foreach( p inst->prop
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
          if( p->name == "NGate"
          then
            fingers=p->value
          )
        ) ; foreach
        dbDeleteObject(inst)
        mstr=dbOpenCellViewByType( "ntc1121"  hcellname "symbol")
        newinst=dbCreateInst( cvid mstr nil xy orient 1)
        cdfgData=cdfGetInstCDF(newinst)
        foreach( p cdfgData->parameters
         if( p->name == "fw"
         then
           p->value=width

           param=cdfFindParamByName(cdfgData "fw")
           callback=param->callback
           when(callback && callback != ""
               errset(evalstring(callback))
           )

         )
         if( p->name == "l"
         then
           p->value=length

           param=cdfFindParamByName(cdfgData "l")
           callback=param->callback
           when(callback && callback != ""
               errset(evalstring(callback))
           )
         )
         if( p->name == "m"
         then
           p->value=multiplier
           param=cdfFindParamByName(cdfgData "m")
           callback=param->callback
           when(callback && callback != ""
               errset(evalstring(callback))
           )
         )
         if( p->name == "fingers"
         then
           p->value=fingers
           param=cdfFindParamByName(cdfgData "fingers")
           callback=param->callback
           when(callback && callback != ""
               errset(evalstring(callback))
           )
         )
        );foreach
 );let
);procedure
procedure( invsubrepprim( inst hcellname)
  let( (  cellname instname orient xy cdf p mstr newinst cdfgData paramName callback)
        mp=1
        mn=1
        cellname=inst->cellName
        instname=inst->name
        orient=inst->orient
        xy=inst->xy


        foreach( p inst->prop
          if( p->name == "wn"
          then
            wn=p->value
          )
          if( p->name == "ln"
          then
            ln=p->value
          )
          if( p->name == "mn"
          then
            mn=p->value
          )
          if( p->name == "wp"
          then
            wp=p->value
          )
          if( p->name == "lp"
          then
            lp=p->value
          )
          if( p->name == "mp"
          then
            mp=p->value
          )
        ) ; foreach
        dbDeleteObject(inst)
        mstr=dbOpenCellViewByType( "ntc1121"  hcellname "symbol")
        newinst=dbCreateInst( cvid mstr nil xy orient 1)
        cdfgData=cdfGetInstCDF(newinst)
        foreach( p cdfgData->parameters
         if( p->name == "wn"
         then
           p->value=wn

           param=cdfFindParamByName(cdfgData "wn")
           callback=param->callback
           when(callback && callback != ""
               errset(evalstring(callback))
           )

         )
         if( p->name == "ln"
         then
           p->value=ln

           param=cdfFindParamByName(cdfgData "ln")
           callback=param->callback
           when(callback && callback != ""
               errset(evalstring(callback))
           )

         )
         if( p->name == "mn"
         then
           p->value=mn

           param=cdfFindParamByName(cdfgData "mn")
           callback=param->callback
           when(callback && callback != ""
               errset(evalstring(callback))
           )

         )
         if( p->name == "wp"
         then
           p->value=wp

           param=cdfFindParamByName(cdfgData "wp")
           callback=param->callback
           when(callback && callback != ""
               errset(evalstring(callback))
           )

         )
         if( p->name == "lp"
         then
           p->value=lp

           param=cdfFindParamByName(cdfgData "lp")
           callback=param->callback
           when(callback && callback != ""
               errset(evalstring(callback))
           )

         )
         if( p->name == "mp"
         then
           p->value=mp

           param=cdfFindParamByName(cdfgData "mp")
           callback=param->callback
           when(callback && callback != ""
               errset(evalstring(callback))
           )

         )
        );foreach
 )
)
procedure( csubrepprim( inst hcellname)
  let( (  cellname instname orient xy cdf p mstr newinst cdfgData paramName callback)
        multiplier="1"
        fingers="1"
        cellname=inst->cellName
        instname=inst->name
        orient=inst->orient
        xy=inst->xy


        foreach( p inst->prop
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
        ) ; foreach
        dbDeleteObject(inst)
        mstr=dbOpenCellViewByType( "ntc1121"  hcellname "symbol")
        newinst=dbCreateInst( cvid mstr nil xy orient 1)
        cdfgData=cdfGetInstCDF(newinst)
        foreach( p cdfgData->parameters
         if( p->name == "fw"
         then
           p->value=width

           param=cdfFindParamByName(cdfgData "fw")
           callback=param->callback
           when(callback && callback != ""
               errset(evalstring(callback))
           )

         )
         if( p->name == "l"
         then
           p->value=length

       param=cdfFindParamByName(cdfgData "l")
       callback=param->callback
       when(callback && callback != ""
           errset(evalstring(callback))
       )
         )
         if( p->name == "m"
         then
           p->value=multiplier
       param=cdfFindParamByName(cdfgData "m")
       callback=param->callback
           when(callback && callback != ""
        errset(evalstring(callback))
       )
         )
        );foreach
 )
)

; HierFind()
; load("/home/kf018/kimdy/SKILL/kkk.il")

