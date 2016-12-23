x=car(geGetSelectedSet())
println(x->name)
println(x->orient)
println(x->xy)
cdf=cdfGetInstCDF(X)
foreach( p cdf->parameters
    if( p->name == "w"
    then
      println(p->value)
    )
    if( p->name == "l"
    then
      println(p->value)
    )
    if( p->name == "m"
    then
      println(p->value)
    )
    if( p->name == "fingers"
    then
      println(p->value)
    )
)
cvid=getEditRep()
mstr=dbOpenCellViewByType( "1533il11sg" "pch_33" "symbol")
x->master=mstr

x=car(geGetSelectedSet())
println(x->name)
println(x->orient)
println(x->xy)
cdf=cdfGetInstCDF(X)
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
dbDeleteObject(x)
cvid=getEditRep()
mstr=dbOpenCellViewByType( "1533il11sg" "pch_33" "symbol")
inst=dbCreateInst( cvid mstr nil 6.75:14.75 "MY" 1)
cdfgData=cdfGetInstCDF(inst)
foreach( p cdfgData->parameters
    if( p->name == "w"
    then
      p->value=width
      paramName='w
      callback=get(cdfgData paramName)->callback
      when(callback && callback != ""
        errset(evalstring( callback ) t )
      )
    )
    if( p->name == "l"
    then
      p->value=length
    )
    if( p->name == "m"
    then
      p->value=multiplier
    )
    if( p->name == "fingers"
    then
      p->value=fingers
    )
)
