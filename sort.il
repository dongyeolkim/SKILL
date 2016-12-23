procedure( RKsortList(listToSort sortCriteria)
  let(((newList nil) returnList)
    rexCompile("^\\(.+\\)\\.\\(.+\\)\\.\\(.+\\) - \\(.+\\)")
    foreach(x listToSort
      rexExecute(x)
      newList=cons(list(rexSubstitute("\\1") rexSubstitute("\\2") rexSubstitute("\\3") rexSubstitute("\\4")) newList)
    )
    case(sortCriteria
      ("instance"
        returnList=sort(newList lambda( (a b) alphalessp((car a) (car b))))
      )
      ("cellname"
        returnList=sort(newList lambda( (a b) alphalessp((cadr a) (cadr b))))
      )
      ("pin"
        returnList=sort(newList lambda( (a b) alphalessp((caddr a) (caddr b))))
      )
      ("net"
        returnList=sort(newList lambda( (a b) alphalessp((cadddr a) (cadddr b))))
      )
      (t
        returnList=listToSort
      )
    )
    returnList
  )
)
;

Example of execution :
myList= list("|I10.buff_01.in - ckin"


"|I10.buff_01.out - net032"
"|I10.buff_01.sub - vss"
"|I10.buff_01.vdd - vbat"
"|I11.buff_01.in - ckin_b"
"|I11.buff_01.out - net16"
"|I11.buff_01.sub - vss"
"|I11.buff_01.vdd - vbat"
"|I14.RC_delay.in - p2"
"|I14.RC_delay.out - net021"
)
RKsortList(myList "pin")
==>
(("|I10" "buff_01" "in" "ckin")
    ("|I11" "buff_01" "in" "ckin_b")
    ("|I14" "RC_delay" "in" "p2")
    ("|I10" "buff_01" "out" "net032")
    ("|I11" "buff_01" "out" "net16")
    ("|I14" "RC_delay" "out" "net021")
    ("|I10" "buff_01" "sub" "vss")
    ("|I11" "buff_01" "sub" "vss")
    ("|I10" "buff_01" "vdd" "vbat")
    ("|I11" "buff_01" "vdd" "vbat")
)

RKsortList(myList "instance")
==>
(("|I10" "buff_01" "in" "ckin")
    ("|I10" "buff_01" "out" "net032")
    ("|I10" "buff_01" "sub" "vss")
    ("|I10" "buff_01" "vdd" "vbat")
    ("|I11" "buff_01" "in" "ckin_b")
    ("|I11" "buff_01" "out" "net16")
    ("|I11" "buff_01" "sub" "vss")
    ("|I11" "buff_01" "vdd" "vbat")
    ("|I14" "RC_delay" "in" "p2")
    ("|I14" "RC_delay" "out" "net021")
)

RKsortList(myList "cellname")
==>
(("|I14" "RC_delay" "in" "p2")
    ("|I14" "RC_delay" "out" "net021")
    ("|I10" "buff_01" "in" "ckin")
    ("|I10" "buff_01" "out" "net032")
    ("|I10" "buff_01" "sub" "vss")
    ("|I10" "buff_01" "vdd" "vbat")
    ("|I11" "buff_01" "in" "ckin_b")
    ("|I11" "buff_01" "out" "net16")
    ("|I11" "buff_01" "sub" "vss")
    ("|I11" "buff_01" "vdd" "vbat")
)

RKsortList(myList "net")
==>
(("|I10" "buff_01" "in" "ckin")
    ("|I11" "buff_01" "in" "ckin_b")
    ("|I14" "RC_delay" "out" "net021")
    ("|I10" "buff_01" "out" "net032")
    ("|I11" "buff_01" "out" "net16")
    ("|I14" "RC_delay" "in" "p2")
    ("|I10" "buff_01" "vdd" "vbat")
    ("|I11" "buff_01" "vdd" "vbat")
    ("|I10" "buff_01" "sub" "vss")
    ("|I11" "buff_01" "sub" "vss")
)
