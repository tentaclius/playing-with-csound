<CsoundSynthesizer>
<CsOptions>
  --daemon
  --realtime
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
0dbfs = 1
nchnls = 3

instr Au
  aSig poscil 1, 220
  outall aSig
endin

instr RestartAu
  turnoff2i "Au.111", 0, 0
  schedule "Au.111", 0, -1
endin

/*
schedule "RestartAu", 0, 1
*/

</CsInstruments>
</CsoundSynthesizer>
