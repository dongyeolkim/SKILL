procedure(xAlign()

let((objects obj somepoints refObject shift overallbbox)

objects = geGetSelSet() ; selects objects to be moved to align 

somepoints = enterPoint(                   ; prompts the user to enter a point which will be used to select the reference object
  ?prompts list("enter the ref object")
  ?doneProc "adhGetSelSet"
  ?initProc "setSelectionMode"
      )
geAddSelectPoint(hiGetCurrentWindow() nil somepoints) ; selecting the reference object
refObject = car(last(geGetSelSet()))
overallbbox = makeInstance('overallbbox ?bBox trBBoxUnion(objects~>bBox))
println(overallbbox~>bBox)
shift = getXshift(overallbbox refObject)

foreach(obj objects
dbMoveFig(obj geGetEditCellView() list(shift:0 "R0")))
geDeselectAll()
 
 ))

procedure(setSelectionMode(win)
geSetEnterFunctionSelectionMode(win 4)
)  

procedure(trBBoxUnion( bBoxList )
let((llxList llyList urxList uryList minllx minlly maxurx maxury)
llxList = foreach(mapcar bBox bBoxList xCoord(lowerLeft(bBox)))
llyList = foreach(mapcar bBox bBoxList yCoord(lowerLeft(bBox)))
urxList = foreach(mapcar bBox bBoxList xCoord(upperRight(bBox)))
uryList = foreach(mapcar bBox bBoxList yCoord(upperRight(bBox)))
minllx = apply('min llxList)
minlly = apply('min llyList)
maxurx = apply('max urxList)
maxury = apply('max uryList)
list(minllx:minlly maxurx:maxury)
   )
)

defclass( overallbbox ()
(
 (bBox @initarg bBox)
 )
)

procedure(getXshift(object ref)
let((shift objectMidx refMidx)

 objectMidx = (xCoord(lowerLeft(object~>bBox))+xCoord(upperRight(object~>bBox)))/2
        refMidx    = (xCoord(lowerLeft(ref~>bBox))+xCoord(upperRight(ref~>bBox)))/2
shift = refMidx - objectMidx
shift  
)  )

hiSetBindKey("Layout" "Super<Key>x" "xAlign()")

how can i tell xAlign() to use enterpoint() (shown in Bold)  when i "click" or use enterBox() when i "click and drag". 
