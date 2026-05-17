<CsoundSynthesizer>
<CsOptions>
  -o dac
  -+rtaudio=jack
  -+rtmidi=alsaseq
  -Ma -Qa
  --port=1234
  -L stdin
  -b 16
  -B 272
</CsOptions>
<CsInstruments>

sr = 48000
ksmps = 4
nchnls = 2
0dbfs = 1

#include "lib.orc"
#include "instruments.orc"

massign 0, "MidiWrap"

instr MidiWrap
  #define CTL_CHAN #1#
  iNote notnum
  iVelo veloc
  kDepth chanctrl $CTL_CHAN, 74, 0, 800
  kQ = int(chanctrl:k($CTL_CHAN, 18) / 127 * 12)
  iAttack chanctrl $CTL_CHAN, 71, 0.01, 0.1
  iRelease chanctrl $CTL_CHAN, 19, 0.1, 1
  printk 0.1, kDepth
  chnset kDepth, "FmBass.depth"
  chnset kQ, "FmBass.Q"
  ;
  xtratim 1
  kEnv madsr iAttack, 0.1, 0.7, iRelease
  aSig subinstr "FmBass", iNote, iVelo/127/3
  outall aSig*kEnv
endin

</CsInstruments>
<CsScore>
</CsScore>
</CsoundSynthesizer>
