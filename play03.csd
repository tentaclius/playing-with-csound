<CsoundSynthesizer>
<CsOptions>
  -o dac
  -+skip_seconds=0
  ;-m4
  ;-t60
</CsOptions>
<CsInstruments>

sr = 48000
ksmps = 4
nchnls = 2
0dbfs = 1

instr Bass
  pset 0, 0, 1, 60, 0.7
  iFreq mtof p4
  iDur, iGain = p3, p5
  p3 += 0.4
  xtratim 1
  ;
  kEnv adsr 0.01, 0.1, 0.5, 0.4
  kEnv *= iGain
  aSig vco2 kEnv, iFreq
  kFq scale kEnv, 700, 100
  aSig moogladder aSig, kFq, .6
  ;
  chnmix aSig, "Echo"
endin

instr BassN
  SNote = p4
  iGain = p5
  iNote ntom SNote
  aOutL, aOutR subinstr "Bass", iNote, iGain
  out aOutL, aOutR
endin

instr Bd
  pset 0, 0, 1, .9, 300, .08
  iGain, iFreq, iDur = p4, p5, p6
  ;
  kEnv linseg iGain, iDur, 0
  kFreq linseg iFreq, iDur, 10
  aSig poscil kEnv, kFreq
  kBassEnv linseg iGain, iDur-0.01, 0
  aBass poscil kBassEnv, 60
  ;
  aSig = (aSig + aBass) / 2
  out aSig, aSig
endin

instr Hh
  pset 0, 0, 1, .2, 3000, .02
  iGain, iFreq, iDur = p4, p5, p6
  ;
  kEnv linseg iGain, iDur, 0
  aSig noise kEnv, 0
  aSig mvchpf aSig, iFreq, 0.9
  ;
  out aSig, aSig
endin

instr Sn
  iAmp  = p4
  ;
  kEnv expon 1, 0.25, 0.001
  kPitch expon 280, 0.06, 140
  aBody oscil kEnv, kPitch
  aNoise rand 1
  aNoise butterbp aNoise, 4000, 3500
  aNoise *= kEnv * 2.5
  kTEnv expon 1, 0.008, 0.001
  aTrans rand 1
  aTrans butterhp aTrans, 6000
  aTrans *= kTEnv
  ;
  aOut = (aBody * 0.5 + aNoise * 0.5 + aTrans * 0.3) * iAmp
  outall aOut
endin
  
instr Rattle
  SInstrName init p4
  iInstr nstrnum SInstrName
  iDur, iNumber, ip4, ip5, ip6 = p3, p5, p6, p7, p8
  ii init 0
  while ii < iNumber do
    schedule iInstr, ii/iNumber*iDur, iDur/iNumber, ip4, ip5, ip6
    ii += 1
  od
  turnoff
endin

instr +Echo
  aSig chnget "Echo"
  chnclear "Echo"
  aSigL, aSigR freeverb aSig, aSig, .9, .9
  aSig = aSig/2 + aSigL/3 + aSigR/3
  out aSig, aSig
endin

</CsInstruments>
<CsScore>

;; start
t0 [60*4]

i"Echo" 0 -1

i"BassN" 0 1 "1A" .5
i. + . . .4
i.
i. + . "1A#"

B4
i"BassN" 0 1 "1A"
i. + . . .3
i. + . . .4
i"BassN" + 1 "2C"

i"Sn" 0 1

B4
i"BassN" 0 1 "1A"
i. + . . .4
i.
i.

B4
i"BassN" 0 1 "1A"
i. + . . .4
i.
i"BassN" + 1 "1A#"

</CsScore>
</CsoundSynthesizer>
