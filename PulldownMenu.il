procedure(PPSchematicBanner(args)

list(
   hiCreatePulldownMenu(
    'ciwCustomMenu
    "PPUtils"
      list(


        hiCreateMenuItem(
          ?name 'createNetName
          ?itemText "createNetName"
          ?callback "createNetName()"
        )
;        hiCreateMenuItem(
;          ?name 'createLabel
;          ?itemText "createLabel"
;          ?callback "createLabel()"
;        )
   ) ; hiCreatePulldownMenu
) ; list
)
)

procedure(PPLayoutBanner(args)

list(
   hiCreatePulldownMenu(
    'ciwCustomMenu
    "PPUtils"
      list(


;        hiCreateMenuItem(
;          ?name 'createNetName
;          ?itemText "createNetName"
;          ?callback "createNetName()"
;        )
        hiCreateMenuItem(
          ?name 'createLabel
          ?itemText "autoCreateBUSLabel"
          ?callback "pylabel()"
        )
   ) ; hiCreatePulldownMenu
) ; list
)
)

deRegUserTriggers("schematic" nil 'PPSchematicBanner )
deRegUserTriggers("maskLayout" nil 'PPLayoutBanner )
deRegUserTriggers("maskLayoutXL" nil 'PPLayoutBanner )
; load("/rnda10/home/kimdy/private/SKILL/schPulldownMenu.il")
; 
