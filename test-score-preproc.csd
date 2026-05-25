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
  outall aSig
endin

</CsInstruments>
<CsScore bin="guile score-preproc.scm">

i"Bass" 0 .5 %A-1 .5
i. + . %C-2
i. + . %D-2
i. + . %E-2

</CsScore>
</CsoundSynthesizer>
