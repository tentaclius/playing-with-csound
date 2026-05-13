<CsoundSynthesizer>
<CsOptions>
-o dac
-+skip_seconds=0
-m 4
;-t60
</CsOptions>
<CsInstruments>

sr = 48000
ksmps = 4
nchnls = 2
0dbfs = 1

#include "lib.orc"

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
  iDecay def p6, 0.7
  iAttack = 0.01
  ;
  kEnv transeg 0, iAttack, 6, iGain, iDecay, -6, 0
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

instr Bd
  iGain def p4, 1
  iFreq def p5, 330
  iDur def p6, 0.06
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
instr FmBass
  kFreq mtof param_or_chn(p4, "FmBass.note")
  kGain param_or_chn p5, "FmBass.gain"
  kDepth param_or_chn p6, "FmBass.depth"
  kQ param_or_chn p7, "FmBass.Q"
  ;
  kEnv adsr 0.1, 0.1, 0.7, 0.2
  aMod poscil kDepth, kFreq * kQ
  aSig poscil kGain * kEnv, kFreq + aMod
  outall aSig
endin

</CsInstruments>
<CsScore>
#define BAR_SIZE #4#  ;; bar is 4 beats
#define BAR #B $BAR_SIZE#

t0 [60*$BAR_SIZE]

i"Ding" 0 1 60 .3
i"Ding" 1 . 63
i"Ding" 2 . 65
i"Ding" 3 . 67

$BAR
i"Ding" 0 1 60 .3
i"Ding" 1 . 65
i"Ding" 2 . 67
i"Ding" 3 . 72

$BAR
i"Ding" 0 1 60 .3
i"Ding" 1 . 63
i"Ding" 2 . 65
i"Ding" 3 . 67

$BAR
i"Ding" 1 1 65 .3
i"Ding" 2 . 67
i"Ding" 3 . 72

;;;; 4

$BAR
i"ChnLine" 0 7 "FmBass.depth" 50 500
i"ChnLine" 0 2 "FmBass.gain" 0 0.5
i"FmBass" 0.01 9 36 0.1

i"Ding" 0 1 60 .3
i"Ding" 1 . 63
i"Ding" 2 . 65
i"Ding" 3 . 67

i"Ding" 1 1 [65+5] .3
i"Ding" 2 . [67+5]
i"Ding" 3 . [72+5]

$BAR
i"ChnLine" 2 4 "FmBass.Q" 3 8
i"Ding" 0 1 60 .3
i"Ding" 1 . 65
i"Ding" 2 . 67
i"Ding" 3 . 72

$BAR
i"FmBass" 0 9 41 0.2 300 2
i"Ding" 0 1 60 .3
i"Ding" 1 . 63
i"Ding" 2 . 65
i"Ding" 3 . 67

i"Ding" 1 1 [65+5] .3
i"Ding" 2 . [67+5]
i"Ding" 3 . [72+5]

$BAR
i"Ding" 1 1 65 .3
i"Ding" 2 . 67
i"Ding" 3 . 72

;;;; 8

$BAR
i"FmBass" 0 8 39 0.2 300 2
i"Ding" 0 1 60 .3
i"Ding" 1 . 63
i"Ding" 2 . 65
i"Ding" 3 . 67

i"Ding" 1 1 [65+5] .3
i"Ding" 2 . [67+5]
i"Ding" 3 . [72+7]

$BAR
i"Ding" 1 1 65 .3
i"Ding" 2 . 67
i"Ding" 3 . 72

$BAR
i"Ding" 0 1 60 .3
i"Ding" 1 . 63
i"Ding" 2 . 65
i"Ding" 3 . 67

i"Ding" 1 1 [67+5] .3
i"Ding" 2 . [65+5]
i"Ding" 3 . [72+2]

$BAR
i"Ding" 1 1 65 .3
i"Ding" 2 . 67
i"Ding" 3 . 72

;;;; 12

</CsScore>
</CsoundSynthesizer>
