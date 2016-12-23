procedure( vdc( netname level )
    prog( (volt ll points ll mywire mylabel gg)
      ll=dbOpenCellViewByType("analogLib" "vdc" "symbol" "schematicSymbol" "r")
      points=enterPoint( ?noInfix t ?prompts list( "Please click" ) )
      ll=dbCreateInst( geGetEditCellView() ll "" points "0" 1)
      ll->vdc=pwr
      mywire = schCreateWire( geGetEditCellView() "draw" "direct" list( points list( car(points)+18*0.0625 car(cdr(points))) ) 0.0625 0.0625 0.0)
      mylabel = schCreateWireLabel( geGetEditCellView()  car(mywire) list( car(points)+0.0625 car(cdr(points))) netname "lowerLeft" "R0" "stick" 0.0625 nil)
      gg=dbOpenCellViewByType("analogLib" "gnd" "symbol" "schematicSymbol" "r")
      dbCreateInst( geGetEditCellView() gg "" list(car(points) car(cdr(points))-0.375) "0" 1)
      t
    )
)
procedure( vpwl( netname delay level @rest timings)
    prog( (freq period rftime volt frameclock rows frame ll points i gg mywire mylabel)

      freq=27000000
      period=1.0/freq*1E+6
      rftime=0.1
      volt=1.5
      frameclock=857

      rows=488
      frame=60

      ll=dbOpenCellViewByType("analogLib" "vpwl" "symbol" "schematicSymbol" "r")

      points=enterPoint( ?noInfix t ?prompts list( "Please click" ) )
      ll=dbCreateInst( geGetEditCellView() ll "" points "0" 1)
      ll->tvpairs=length(timings)*2+1
      ll->delay=delay
      ll->rpt=0
      i=0
      case( level
          ("vdda" level="vdda")
          ("vddd" level="vddd")
          ("gnda" level="gnda")
          ("gndd" level="gndd")
          (t println("Error : Incorrect Power Ground Name") )
      )
      foreach( timing timings
        i=i+1
        time=sprintf( nil "ll->t%d=%fu" i timing*period)
        volt=sprintf( nil "ll->v%d=\"%s\"" i level)
        evalstring(time)
        evalstring(volt)
        case( level
            ("vdda" level="gnda" )
            ("vddd" level="gndd" )
            ("gnda" level="vdda" )
            ("gndd" level="vddd" )
            (t println("Error : Incorrect Power Ground Name") )
        )
        i=i+1
        time=sprintf( nil "ll->t%d=%fu+%fn" i timing*period rftime)
        volt=sprintf( nil "ll->v%d=\"%s\"" i level)
        evalstring(time)
        evalstring(volt)
      )
      i=i+1
      time=sprintf( nil "ll->t%d=%fu" i frameclock*period)
      volt=sprintf( nil "ll->v%d=\"%s\"" i level)
      evalstring(time)
      evalstring(volt)
      mywire = schCreateWire( geGetEditCellView() "draw" "direct" list( points list( car(points)+18*0.0625 car(cdr(points))) ) 0.0625 0.0625 0.0)
      mylabel = schCreateWireLabel( geGetEditCellView()  car(mywire) list( car(points)+0.0625 car(cdr(points))) netname "lowerLeft" "R0" "stick" 0.0625 nil)
      gg=dbOpenCellViewByType("analogLib" "gnd" "symbol" "schematicSymbol" "r")
      dbCreateInst( geGetEditCellView() gg "" list(car(points) car(cdr(points))-0.375) "0" 1)
      return t
    )
)
;tvpairs
;t1 t2 t3 t4 t5 t6 t7
;v1 v2 v3 v4 v5 v6 v7
;rpt
;delay

; load("/rndb2/home/kimdy/private_SKILL/vpwl.il")
; vpwl( "d2a_cds_blacksun_vgg1_sample" "0n" "gndd" 846)
; vpwl( "d2a_cds_blacksun_vgg2_sample" "0n" "gndd" 846)
; vpwl( "d2a_cds_global_vgg1_sample"   "0n" "gndd" 846)
; vdc( "d2a_cds_vgg1_pullup" "gndd")
; vdc( "a2a_bgr_cds_pd" "gndd")
; vdc( "d2a_cds_amp_consti" "gndd")
; vpwl( "d2a_cds_store"   "0n" "gndd" 0 55)
; vpwl( "d2a_cds_sample"   "0n" "gndd" 0 837)
; vpwl( "d2a_cds_local_vgg1_sample" "0n" "gndd" 846)
; vpwl( "d2a_cds_local_vgg2_sample" "0n" "gndd" 846)
; vpwl( "d2a_cds_limiter_en"   "0n" "gndd" 1 856)
; vpwl( "d2a_cds_blacksun_en"   "0n" "vddd" 60 837)
; vpwl( "d2a_cds_latch_en"   "0n" "gndd" 87 833 854 855)
; vpwl( "d2a_cds_load_en"   "0n" "gndd" 86 834 )
; vpwl( "d2a_cds_inv_en"   "0n" "gndd" 86 834 )
