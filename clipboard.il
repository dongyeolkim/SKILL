procedure(MyReplaceLabels( libName viewName "tt" ) 
let( ( d_libId d_cvId l_cellList l_labelList ) 
d_libId = ddGetObj( libName ) 
l_cellList = setof( 
                d_cell d_libId~>cells 
                member( viewName d_cell~>views~>name ) 
                ) 
foreach( d_cell l_cellList 
     d_cvId = dbOpenCellViewByType( libName d_cell~>name viewName nil "a" )         
     l_labelList = setof( d_shape d_cvId~>shapes  d_shape~>objType == "label" ) 
     foreach( d_label l_labelList 
        case( d_label~>theLabel 
                        ( "VDD" 
                                d_label~>theLabel = "vdd!" 
                        ) 
                        ( "VSS" 
                                d_label~>theLabel = "gnd!" 
                        ) 
                ) ;; close case 
     ) 
   dbSave( d_cvId ) 
   dbClose( d_cvId ) 
) 
) 
) 
;; End of MyReplaceLabels.il

