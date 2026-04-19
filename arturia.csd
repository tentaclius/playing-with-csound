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
0dbfs = 1
nchnls = 3

;; some decent instruments from livecode's lib by Steven Yi
#include "lib.orc"

;; load samples
giSnare1 ftgen 0,0,0,1,"s/snare1.wav",0,0,0
giChordAm7 ftgen 0,0,0,1,"s/Am7.wav",0,0,0
giChordDm ftgen 0,0,0,1,"s/Dm.wav",0,0,0
giChordDm7 ftgen 0,0,0,1,"s/Dm7.wav",0,0,0
giChordG ftgen 0,0,0,1,"s/G.wav",0,0,0

;; midi mapping structure
#define MIDI_INSTR #0#
#define MIDI_DUR #1#
#define MIDI_GAIN #2#
#define MIDI_FREQ #3#
#define MIDI_SAMPLE #4#
#define MIDI_LAST #5#

giMidiMap[][] init 100, $MIDI_LAST
opcode MidiMap, 0, iSiiii
  iNote, SInstr, iDur, iGain, iFreq, iSample xin
  iInstrNum = SInstr == "" ? 0 : nstrnum(SInstr)
  giMidiMap setrow fillarray(iInstrNum, iDur, iGain, iFreq, iSample), iNote
endop

MidiMap 36, "Bd", 1, 0, 110, 0.1
MidiMap 37, "Hh", 1, 1, 5000, 0.1
MidiMap 38, "Sample", 1, -1, mtof:i(60), giSnare1
MidiMap 39, "ChordsWrap", 4, 0, mtof:i(60), giChordAm7
MidiMap 40, "ChordsWrap", 4, 0, mtof:i(60), giChordDm
MidiMap 41, "ChordsWrap", 4, 0, mtof:i(60), giChordG
MidiMap 42, "ChordsWrap", 4, 0, mtof:i(60), giChordDm7

massign 1, "MidiHandler"

instr MidiHandler
  iNote notnum
  iVelo veloc
  ;
  if giMidiMap[iNote][$MIDI_INSTR] > 0 then
    iGain = giMidiMap[iNote][$MIDI_GAIN]
    if iGain <= 0 then
      iGain = sqrt(iVelo/127) * ampdb(iGain)
    endif
    iFreq def giMidiMap[iNote][$MIDI_FREQ], mtof:i(iNote)
    schedule giMidiMap[iNote][$MIDI_INSTR], 0, giMidiMap[iNote][$MIDI_DUR], iGain, iFreq, giMidiMap[iNote][$MIDI_SAMPLE]
  endif
endin

;; play a sample
instr Sample
  iGain = p4
  iFreq = p5
  iTable = p6
  ;
  xtratim ftlen(iTable) * 261.626/iFreq / sr
  aSig,aSig2 loscil3 iGain, iFreq, iTable, 261.626, 0
  ;
  out aSig, aSig2
endin

instr SampleMono
  iGain = p4
  iFreq = p5
  iTable = p6
  ;
  xtratim ftlen(iTable) * 261.626/iFreq / sr
  aSig loscil3 iGain, iFreq, iTable, 261.626, 0
  ;
  out aSig, aSig
endin

;; a wrapper stopping the previous instance
instr PlayChords
  iDur = p3
  iGain = p4
  iNote = p5
  iSample def p6, 0
  ;
  aSig subinstr "SampleMono", iGain, mtof:i(60), iSample
  kEnv madsr 0.01, 0.1, 0.9, 0.1
  out aSig*kEnv, aSig*kEnv
endin

instr ChordsWrap
  iInstr = nstrnum("PlayChords")
  iDur = p3
  iGain def p4, 1/2
  iNote def p5, 60
  iSample def p6, 0
  ;
  turnoff2 iInstr, 0, 1
  schedule iInstr, 0.001, iDur, iGain, iNote, iSample
  turnoff
endin

;; Synthesized Instruments
instr Bd
  iGain def p4, 1
  iFreq def p5, 330
  iDur def p6, 0.1
  ;
  kEnv linseg iGain, iDur*3, 0
  kFreq linseg iFreq, iDur, 10
  aSig poscil 1, kFreq
  ;
  aBass poscil 0.7 * iGain, 60
  ;
  aSig = (aSig + aBass) * kEnv
  out aSig, aSig
endin

instr Hh
  iGain def p4, 1
  iFreq def p5, 3000
  iDur def p6, 0.1
  ;
  kEnv linseg iGain, iDur, 0
  aSig noise kEnv, 0
  aSig mvchpf aSig, iFreq, 0.9
  ;
  out aSig, aSig
endin

</CsInstruments>
<CsScore>
</CsScore>
</CsoundSynthesizer>
