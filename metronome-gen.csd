<CsoundSynthesizer>
<CsOptions>
  -o dac
</CsOptions>
<CsInstruments>

sr = 48000
ksmps = 4
0dbfs = 1
nchnls = 3

instr MetronomeSnd
  iFq = p4
  ;
  kEnv linseg 1, 0.051, 0
  aSig noise kEnv/2, 0.5
  aSig mvchpf aSig, iFq, 0.9
  aSig *= kEnv
  ;
  aSin poscil kEnv/2, iFq
  aSig += aSin
  ;
  outall aSig
endin

instr MetronomeStart
  schedule "MetronomeSnd", 0, 1, 1000
  schedule "MetronomeSnd", 1/2, 1, 500
  schedule "MetronomeSnd", 2/2, 1, 500
  schedule "MetronomeSnd", 3/2, 1, 500
  schedule "Metronome", 2, 1
endin

</CsInstruments>
<CsScore>
r1024
i "MetronomeSnd" 0 0.5 1000
i . + . 500
i . +
i . +
s
</CsScore>
</CsoundSynthesizer>
