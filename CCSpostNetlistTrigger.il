procedure(CCSpostNetlistTrigger(session)
	let((simulator existingPostFunc analysis inPort outPort nextLine parsedLine current waveform expression mosPort)
	  simulator=asiGetSimName(session)
	  printf("TRIGGER: netlist Directory is %L\n" asiGetNetlistDir(session))
	  printf("TRIGGER: psf Directory is %L\n" asiGetPsfDir(session))
	  existingPostFunc=concat('CCSpostNetlistTrigger_ simulator)


;    ss=asiGetSession(hiGetCurrentWindow())
;    ss=asiGetCurrentSession()
;    outs=asiGetOutputList(ss)
;    outs->signal
;    ss=sevSession(hiGetCurrentWindow())
;    sevPlotAllOutputs(ss)
    
    analysis=asiGetAnalysis( session 'tran)

    when( asiIsAnalysisEnabled( analysis )

	    inputckt=strcat( asiGetNetlistDir(session) "/input.ckt")
	    outputckt=strcat( asiGetNetlistDir(session) "/input.org")
	
	    inPort=infile( inputckt  )
	    outPort=outfile( outputckt )
	
	    when( inPort
	      while( gets( nextLine inPort )
	
	        if( rexMatchp( "I[1-4](" nextLine )
	        then
            if( rexMatchp( "I1(" nextLine )
            then
              mosPort="i1"
            else
              if( rexMatchp( "I2(" nextLine)
              then
                mosPort="i2"
              else
                if( rexMatchp( "I3(" nextLine)
                then
                  mosPort="i3"
                else
                  if( rexMatchp( "I4(" nextLine)
                    mosPort="i4"
                  )
                )
              )
            )
            

	          rexCompile( ")" )
	          nextLine=rexReplace( nextLine ".m1)" 0 )

	
	          parsedLine=parseString( nextLine "()")
	          current=nth(1 parsedLine)
            exprname=strcat(current "." mosPort )
	;          current="xi3.xm1.m1"
	          rexCompile( "\\." )
	          waveform=rexReplace( current "^" 0 )
	          expression=strcat( "i(\"" mosPort "(" waveform ")\" ?result \"timeSweep\")")

;            println(mosPort)
;            println(nextLine)
;            println(exprname)
;            println(expression)
	          _vvExportTestExpression(sevSession(hiGetCurrentWindow())  "SendToADE-L" exprname expression  ) 
	        )
	        fprintf(outPort nextLine)
	      )
	      close(inPort)
	      close(outPort)
	    );when
	
	    inPort=infile( outputckt  )
	    outPort=outfile( inputckt )
	
	    when( inPort
	      while( gets( nextLine inPort )
	        fprintf(outPort nextLine)
	      )
	      close(inPort)
	      close(outPort)
	    );when
    );when

	  if(getd(existingPostFunc) then
	    funcall(existingPostFunc session)
	  else
	    t
	  ) ; if
	) ; let
) ; procedure CCSpostNetlistTrigger

procedure(CCSdefinePostNetlistTrigger(simulator)
  let((flow postFunc step)
	  flow=asiGetFlowchart(asiGetTool(simulator))
	  step=asiGetFlowchartStep(flow 'asiComposeSimInput)
	  postFunc=step->postFunc
		;--------------------------------------------------------------------
		; Doesn't seem to be a postFunc for this step, but just in case,
		; future proof it...
		;--------------------------------------------------------------------
	
	  when(postFunc && neq(postFunc 'CCSpostNetlistTrigger)
	    putd(concat('CCSpostNetlistTrigger_ simulator) getd(postFunc))
	  ) ; when
	
	  asiChangeFlowchartStep(flow ?name 'asiComposeSimInput ?postFunc 'CCSpostNetlistTrigger )
  ) ; let

) ; procedure CCSdefinePostNetlistTrigger
