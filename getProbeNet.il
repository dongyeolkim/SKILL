procedure( getProbeNet()
    let( (list elem outport modhier hier)
      list=geGetAllProbe()
      if(! (outport = outfile("sig.net")) then
        return()
      )
      foreach( elem list
        if( elem->probeType == "net"
        then
          pathList=elem->pathList
          pathObjectName = elem->pathObjectName
          if( pathList == ""
          then
            modhier=pathObjectName
          else
            hier=parseString(pathList "/")
            modhier=""
            foreach( item hier
              modhier=strcat(modhier "X" item ".")
            )
            modhier=strcat(modhier  pathObjectName)
          )
          
          fprintf(outport modhier)
          fprintf(outport "\n")
        )
      )
      close(outport)
      system("gvim sig.net")   
      t
    )
)
;load("/rnda10/home/kimdy/private/SKILL/getProbeNet.il")
