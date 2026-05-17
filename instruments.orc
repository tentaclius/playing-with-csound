;; Instruments
instr Airy
  iGain = p4
  iFreq mtof p5
  ;
  kEnv xadsr 1, 0.3, 0.7, 2
  aSig noise 1/2, 0.4
  aSig vclpf aSig, iFreq, 0.989
  aSin1 poscil 1/8, iFreq/2 
  aSin2 poscil 1/4, iFreq
  aSin3 poscil 1/12, iFreq*2
  aSin = aSin1 + aSin2 + aSin3
  ;
  aOut = (aSig + aSin) * iGain * kEnv
  outall aOut
endin

instr Ding
  iFreq mtof p4
  iGain def p5, 0.5
  iDecay def p6, 0.8
  xtratim 1
  ;
  kEnv transeg 0, 0.02, 6, iGain, iDecay, -6, 0
  if trigger(kEnv, 0, 1) == 1 then
    turnoff
  endif
  aSig poscil kEnv, iFreq
  outall aSig
endin
  
instr Square
  iGain = p4
  iFreq mtof p5
  ;
  kEnv adsr 0.02, 0.07, 0.7, 0.3
  kLfo lfo 1, 1/2
  kLfo scale kLfo, 0.8, 0.2, 1, -1
  aSqr vco2 1, iFreq, 2, kLfo
  ;
  aOut = aSqr * kEnv * iGain * 0.1
  out aOut, aOut
endin

chnset 0.06, "Bd.dur"
chnset 300, "Bd.freq"
chnset 0.9, "Bd.gain"
instr Bd
  iGain param_or_chn p4, "Bd.gain"
  iFreq param_or_chn p5, "Bd.freq"
  iDur param_or_chn p6, "Bd.dur"
  ;
  kEnv linseg iGain, iDur*3, 0
  kFreq linseg iFreq, iDur, 10
  aSig poscil 1, kFreq
  aBass poscil iGain, 60
  ;
  aSig = (aSig + aBass) * kEnv / 2
  out aSig, aSig
endin

instr Hh
  iGain def p4, 0.5
  iFreq def p5, 3000
  iDur def p6, 0.07
  ;
  kEnv linseg iGain, iDur, 0
  aSig noise kEnv, 0
  aSig mvchpf aSig, iFreq, 0.9
  ;
  out aSig, aSig
endin
  
chnset 300, "FmBass.depth"
chnset 3, "FmBass.Q"
chnset 0.5, "FmBass.gain"
chnset 60, "FmBass.note"
chnset 0.2, "FmBass.env.attack"
chnset 0.5, "FmBass.env.release"
instr FmBass
  kFreq mtof param_or_chn(p4, "FmBass.note")
  kGain param_or_chn p5, "FmBass.gain"
  kDepth param_or_chn p6, "FmBass.depth"
  kQ param_or_chn p7, "FmBass.Q"
  iAttack param_or_chn p8, "FmBass.env.attack"
  iRelease param_or_chn p9, "FmBass.env.release"
  ;
  kEnv adsr iAttack, 0.01, 0.7, iRelease
  aMod poscil kDepth, kFreq * kQ
  aSig poscil kGain * kEnv, kFreq + aMod
  outall aSig
endin
