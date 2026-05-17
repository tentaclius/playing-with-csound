opcode def, i, ii  ;; set a value or use the default value in case of 0
  iVal, iDflt xin
  if iVal == 0 then
    iVal = iDflt
  endif
  xout iVal
endop

opcode def, k, kk  ;; set a value or use the default value in case of 0
  kVal, kDflt xin
  if kVal == 0 then
    kVal = kDflt
  endif
  xout kVal
endop

opcode param_or_chn, k, iS
  iParam, SChName xin
  kValue = iParam
  if kValue == 0 then
    kValue chnget SChName
  endif
  xout kValue
endop

opcode param_or_chn, i, iS
  iParam, SChName xin
  iValue = iParam
  if iValue == 0 then
    iValue chnget SChName
  endif
  xout iValue
endop
  
giTempo = 60
instr Tempo
  ;; needs -t60 option enabled to work
  giTempo = 60/p4
  tempo p4, 60
  turnoff
endin

instr ChnLine
  iDur = p3
  SName = p4
  iStart = p5
  iFinish = p6
  kVal linseg iStart, iDur, iFinish
  chnset kVal, SName
endin

instr ChnSet
  SName = p3
  iValue = p4
  chnset iValue, SName
endin
