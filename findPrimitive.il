procedure( findPrimitive( cv )
  let( ( inst  i)
    if( cv 
    then
		  foreach( inst cv->instances 
	      if( inst->cellView
	      then
			    case( inst->libName 
			      ("1533il11sg"  if( match( inst->cellName primitives) then primitives=cons( inst->cellName primitives ) ) )
			      ("basic"  i=1)
			      ("analogLib" i=1)
			      ("US_8ths" i=1)
		        ( t findPrimitive( dbOpenCellViewByType( inst->libName inst->cellName   "schematic"  nil "r") ) )
			    )
	      )
		  )
    )
  )
)
procedure( HierFind( libName cellName  viewName )
    let( ( )
      primitives=nil
      findPrimitive( dbOpenCellViewByType( libName cellName viewName "schematic" "r") )
      println(primitives)
    )
)

procedure( match( cellName primitives )
prog( ()
  foreach( item primitives
      if( cellName == item 
      then 
        return( nil )
      )
  )
  return( t )
)
  
)
; load("/rnda10/home/kimdy/work/PS7100K/findPrimitive.il")
; HierFind( "PS7100K" "pll_pxpl_top_v4_PS7100K"  "schematic" )
; HierFind( "PS7100K" "COL_TOP_PS7100K"  "schematic" )
; HierFind( "PS7100K" "col_latch_top_1ch_dnw_ps7100k"  "schematic" )
; HierFind( "PS7100K" "col_2column_top_56_ps7100k"  "schematic" )
; HierFind( "PS7100K" "col_sa_4column_array_ps3210k"  "schematic" )
; HierFind( "PS7100K" "ANALOG_CORE_PS7100K"  "schematic" )
