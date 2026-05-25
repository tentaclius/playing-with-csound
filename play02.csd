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
  
</CsInstruments>
<CsScore>

#define AND #
#

;; defaults
i"Bd" 0 0 .9 300 .08
i"Hh" 0 0 .2 3000 .02
i"Sn" 0 0 .8 500 .1
i"Rattle" 0 0 "Hh" 4 .2 3000 .02

;; start
t0 [110*4]

i"Bd" 0 1

B4
i"Sn" 0 2
i"Bd" 3 . .3

B4
i"Bd" 1 . >
i"Bd" 2 . .9

B4
i"Sn" 0

;; 4

B4
i"Bd" 0

B4
i"Sn" 0
i"Bd" 2 . .1
i"Bd" 3 . .8

B4
i"Bd" 1
i"Bd" 2

B4
i"Sn" 0

;; 8

B4
i"Bd" 0  $AND  i"Hh" 0 1 .1
i"Rattle" 1 1 "Hh" 2
i"Hh" 2
i"Hh" 3

B4
i"Sn" 0
i"Hh" 1
i"Rattle" 2 1 "Hh" 3
i"Bd" 3  $AND  i"Hh" 3

B4
i"Bd" 1
i"Bd" 2

i"Rattle" 0 4 "Hh" 4

B4
i"Sn" 0
i"Rattle" 0 4 "Hh" 4

;; 12

B4
i"Bd" 0  $AND  i"Rattle" 0 1 "Hh" 3
i"Rattle" 1 3 "Hh" 3

B4
i"Sn" 0
i"Hh" 1
i"Bd" 2  $AND  i"Rattle" 2 1 "Hh" 3
i"Bd" 3

B4
i"Bd" 1
i"Bd" 2
i"Rattle" 0 4 "Hh" 4

B4
i"Sn" 0
i"Rattle" 0 4 "Hh" 4

;; 16

</CsScore>
</CsoundSynthesizer>
