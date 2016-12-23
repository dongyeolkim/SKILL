procedure( ExampleCreateLayoutPulldownMenu1( )
        
        /* creating menu items, if not exists */
        unless( boundp( 'ExampleMenuItem1 )
                ExampleMenuItem1 = hiCreateMenuItem(
                        ?name 'ExampleMenuItem1
                        ?itemText "Example Item 1"
                        ?callback "println( \"Example Item 1\" )"
                        )
                ) /* unless */
        
        /* creat pulldow menu, if not exists */        
        if( boundp( 'ExampleLayoutPulldownMenu1 ) then
                ExampleLayoutPulldownMenu1
        else
                hiCreatePulldownMenu(
                        'ExampleLayoutPulldownMenu1
                        "Example Pulldown Menu 1"
                        list(
                                ExampleMenuItem1
                                ) /* list */
                        ) /* hiCreatePulldownMenu */
        ) /* if */
        
) /*  ExampleCreateLayoutPulldownMenu1 */


procedure( ExamplePostInstallTrigger( args )
        
        /* inset pulldown menu */
        hiInsertBannerMenu(
                args->window
                ExampleCreateLayoutPulldownMenu1( )
                length( hiGetBannerMenus( args->window ) )
                )
) /* ExamplePostInstallTrigger */


deRegUserTriggers( 
        "maskLayout"                        /* view type */
        nil                                /* user application trigger */
        nil                                /* user menu trigger */
        'ExamplePostInstallTrigger        /* user postInstall trigger */
        ) /* deRegUserTriggers */        
; load("/rnda10/home/kimdy/private/SKILL/schPulldownMenu1.il")
