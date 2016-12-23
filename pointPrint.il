
procedure( pointPrint()
  prog( (points coord)
     points=enterPoint( ?noInfix t ?prompts list( "Please click" ) )
     coord=sprintf( nil "z%L" points)
     println( printf("%s\n" coord) )
     return(t)
   )
)
; load("/rnda10/home/kimdy/private/SKILL/pointPrint.il")

