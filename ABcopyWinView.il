/* ABcopyWinView.il

Author     A.D.Beckett
Group      Structured Custom, Cadence Design Systems Ltd
Machine    SUN
Modified   
By        

Copies a window view from one window to another,
not necessarily of the same cellView

Here's some code I wrote a while ago to do something similar. I then defined a
bindkey:
    hiSetBindKey("Layout" "<Key>w"        "(ABcopyWinView)")
Then you'd hit w in your source window, and then click in the destination
window, and it would copy the view settings across. I primarily used this for 
debugging in an extracted view, and then zooming to the layout view to
actually fix it.

Regards,

Andrew.

***************************************************

SCCS Info: @(#) ABcopyWinView.il 08/07/01.15:30:32 1.1

*/

(procedure (ABcopyWinViewCB win done points)
  (let (bbox)
       (setq win (hiGetCurrentWindow))
       (when (and done (windowp win) (windowp ABcopyWinViewFrom))
             (setq bbox (hiGetViewBBox ABcopyWinViewFrom))
             (hiZoomIn win bbox))))

/***************************************************************
*                                                              *
*             (ABcopyWinView @optional (win nil))              *
*                                                              *
*     Procedure to copy a view from one window to another      *
*                                                              *
***************************************************************/

(procedure (ABcopyWinView @optional (win nil))
  (unless win (setq win (hiGetCurrentWindow)))
  (setq ABcopyWinViewFrom win)
  (hiSetCurrentWindow win)
  (when (windowp win)
        (enterMultiRep ?prompts '("Point to the source window" "Point to the destination window")
                       ?points '((0 0))
                       ?doneProc "ABcopyWinViewCB"
                       ?dontDraw t
                       ))
t)

; load("/rnda10/home/kimdy/private/SKILL/ABcopyWinView.il")
