<CsoundSynthesizer>
<CsOptions>
-o dac
</CsOptions>
<CsInstruments>

sr = 48000
ksmps = 4
nchnls = 2
0dbfs = 1

#include "lib.orc"

#define LFO(tb'pos'fq) #tabw (lfo(tabi($pos, $tb)/3, $fq) + 2*tabi($pos, $tb)/3), $pos, $tb#

opcode Sines, a, iiki
  iNst, iSize, kFreq, iGainFt xin
  aRec init 0
  kGain tab iNst-1, iGainFt
  aSig poscil 1, kFreq*iNst
  aSig = aSig/iSize * kGain
  if iNst < iSize then
    aRec Sines iNst+1, iSize, kFreq, iGainFt
  endif
  xout aSig+aRec
endop

instr Sins
  iGain = p4
  iFreq = p5
 
  xtratim 1
  kEnv adsr 0.01, 0.1, 0.5, 0.5

  iGainsFt Tb 1, 1/2, 1/3, 1/4, 1/5, 1/6, 1/7, 1/8, 1/9, 1/10, 1/11
  $LFO(iGainsFt' 1' iFreq/400)
  $LFO(iGainsFt' 2' iFreq/300)
  $LFO(iGainsFt' 3' iFreq/200)
  $LFO(iGainsFt' 4' iFreq/100)

  aSig Sines 1, 3, iFreq, iGainsFt
  outall aSig * kEnv * iGain
endin

instr SinsN
  iFreq mtof p4
  iGain def p5, 1/2
  iLen def p6, p3
  print p6
  schedule "Sins", 0, iLen, iGain, iFreq
endin

instr HfNoise
  iGain = p4
  iFreq mtof p5

  kEnv adsr 1, 1, 0.65, 2

  aNoise noise 1, -0.3
  aNoise vclpf aNoise, iFreq, 0.99

  aSin poscil 1/2, iFreq/2

  aSig0 vco2 1, iFreq, 0, 0, 0
  aSig1 vco2 1/2, iFreq, 0, 0, 0.12 
  aSig2 vco2 1/3, iFreq+1, 0, 0, 0.3
  aSaw = (aSig0 + aSig1 + aSig2) / 3
  kLfo lfo 1, 1/2, 1
  kLfo scale kLfo, 10, 7, 1, -1
  aSaw vclpf aSaw, iFreq*kLfo, 0.3
  aSaw =0

  aOut = (aSin + aNoise + aSaw/3)/3 * kEnv * iGain
  outall aOut
endin

instr SSaw
  iGain = p4
  iFreq mtof p5

  kEnv xadsr 0.016, 0.1, 0.6, 1

  aSig0 vco2 1, iFreq, 0, 0, 0
  aSig1 vco2 1/2, iFreq, 0, 0, 0.12 
  aSig2 vco2 1/3, iFreq+1, 0, 0, 0.3
  aSaw = (aSig0 + aSig1 + aSig2) / 3

  kLfo lfo 1, 1/2, 1
  kLfo scale kLfo, 10, 7, 1, -1
  aSaw vclpf aSaw, iFreq*kLfo, 0.3

  outall aSaw * kEnv * iGain
endin

</CsInstruments>
<CsScore>
i "SSaw" 0 2 1 60
i "SSaw" 1 2 0.5 63
i "SSaw" 2 2 0.5 67
</CsScore>
</CsoundSynthesizer>
