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

#include "lib.orc"

;; load samples
giSnare1 ftgen 0,0,0,1,"s/snare1.wav",0,0,0
giChordAm7 ftgen 0,0,0,1,"s/Am7.wav",0,0,0
giChordDm ftgen 0,0,0,1,"s/Dm.wav",0,0,0
giChordDm7 ftgen 0,0,0,1,"s/Dm7.wav",0,0,0
giChordG ftgen 0,0,0,1,"s/G.wav",0,0,0

;; 64 65 66 67 96 97 98 99
;; 60 61 62 63 92 93 94 95
;; 56 57 58 59 88 89 90 91
;; 52 53 54 55 84 85 86 87
;; 48 49 50 51 80 81 82 83
;; 44 45 46 47 76 77 78 79
;; 40 41 42 43 72 73 74 75
;; 36 37 38 39 68 69 70 71

;; colors we are going to use
#define COLOR_BLANK #0#
#define PAD_L #22#
#define PAD_R #27#
#define INSTR #80#
#define COLOR_SYS #5#

; looper colors
#define LOOPER_RECORD #5#
#define LOOPER_SELECT #40#
#define LOOPER_SELECTED #45#
#define LOOPER_OVER #6#
#define LOOPER_UNDO #19#
#define LOOPER_MUTE #12#

;; looper
MidiMap 64, $LOOPER_RECORD, "", 1, 1, 1, 0 ; record
MidiMap 65, $LOOPER_OVER, "", 1, 1, 1, 0 ; overdub
MidiMap 66, $LOOPER_UNDO, "", 1, 1, 1, 0 ; undo
MidiMap 67, $LOOPER_UNDO, "", 1, 1, 1, 0 ; redo
MidiMap 96, $LOOPER_MUTE, "", 1, 1, 1, 0 ; mute
MidiMap 97, $LOOPER_MUTE, "", 1, 1, 1, 0 ; solo
MidiMap 98, $LOOPER_MUTE, "", 1, 1, 1, 0 ; once
MidiMap 60, $LOOPER_SELECT, "SelectSLTrack", 0.1, 60, 0, 0 ; select track 1
MidiMap 61, $LOOPER_SELECT, "SelectSLTrack", 0.1, 61, 1, 0 ; select track 2
MidiMap 62, $LOOPER_SELECT, "SelectSLTrack", 0.1, 62, 1, 0 ; select track 3
MidiMap 63, $LOOPER_SELECT, "SelectSLTrack", 0.1, 63, 1, 0 ; select track 4
MidiMap 92, $LOOPER_SELECT, "SelectSLTrack", 0.1, 92, 1, 0 ; select track 5
MidiMap 93, $LOOPER_SELECT, "SelectSLTrack", 0.1, 93, 1, 0 ; select track 6
MidiMap 95, $LOOPER_MUTE, "SelectSLTrack", 0.1, 0, 1, 0 ; select all tracks
;; system
MidiMap 71, $COLOR_SYS, "RefreshColors", 0.1, 1, 1, 0

;; samples/synths
MidiMap 39, $PAD_L, "Bd", 1, 0, 110
MidiMap 68, $PAD_R, "Bd", 1, 0, 110
MidiMap 42, $PAD_L, "Hh", 1, 1, 5000, 0.05
MidiMap 73, $PAD_R, "Hh", 1, 1, 5000, 0.05
MidiMap 38, $PAD_L, "Hh", 1, 1, 5000, 0.3
MidiMap 69, $PAD_R, "Hh", 1, 1, 5000, 0.3
MidiMap 43, $PAD_L, "Sample", 1, -1, 60, giSnare1
MidiMap 72, $PAD_R, "Sample", 1, -1, 60, giSnare1
MidiMap 46, $INSTR, "SoloTrigger", 4, 0, 60, nstrnum("PlayChords"), giChordAm7
MidiMap 47, $INSTR, "SoloTrigger", 4, 0, 60, nstrnum("PlayChords"), giChordDm
MidiMap 76, $INSTR, "SoloTrigger", 4, 0, 60, nstrnum("PlayChords"), giChordG
MidiMap 77, $INSTR, "SoloTrigger", 4, 0, 60, nstrnum("PlayChords"), giChordDm7
MidiMap 50, $INSTR, "SoloTrigger", 2, 0, 40, nstrnum("Square")
MidiMap 51, $INSTR, "SoloTrigger", 2, 0, 42, nstrnum("Square")
MidiMap 80, $INSTR, "SoloTrigger", 2, 0, 43, nstrnum("Square")
MidiMap 54, $INSTR, "SoloTrigger", 4, 0, 52, nstrnum("Airy")

;; light up Launchpad keys
instr RefreshColors
  ignore = p8
  for iColor, iIndex in getcol(giMidiMap, 0) do
    noteon 1, iIndex, iColor
  od
  turnoff
endin

;; play a sample
instr Sample
  iGain = p4
  iFreq mtof p5
  iTable = p6
  ignore = p8
  ;
  xtratim ftlen(iTable) * 261.626/iFreq / sr
  aSig,aSig2 loscil3 iGain, iFreq, iTable, 261.626, 0
  ;
  out aSig, aSig
endin

instr SampleMono
  iGain = p4
  iFreq = p5
  iTable = p6
  ignore = p8
  ;
  xtratim ftlen(iTable) * 261.626/iFreq / sr
  aSig loscil3 iGain, iFreq, iTable, 261.626, 0
  ;
  out aSig, aSig
endin

giChoosenSLTrack = 0
instr SelectSLTrack
  ignore = p8
  noteon 1, giChoosenSLTrack, $LOOPER_SELECT
  giChoosenSLTrack = p4
  if giChoosenSLTrack != 0 then
    noteon 1, giChoosenSLTrack, $LOOPER_SELECTED
  endif
endin

;; voice stealing stuff
#define SOLO_MAX_INST #32#

instr SoloInstrWrapper
  iGain = p4
  iNote = p5
  iInstr = p6
  iInstance = p7
  iSample = p8
  ;
  SStopChn sprintf "solo.stop.%d.%d", iInstr, iInstance
  chnset 0, SStopChn
  kStopFlag init 0
  kEnv = 1
  if kStopFlag == 0 then
    kStopFlag chnget SStopChn
  endif
  if kStopFlag == 1 then
    kEnv line 1, 0.1, 0
    if kEnv < 0.01 then
      turnoff
    endif
  endif
  ;
  aSig subinstr iInstr, iGain, iNote, iSample
  aSig *= kEnv
  out aSig, aSig
endin

instr SoloTrigger  ;; a wrapper stopping the previous instance
  iDur = p3
  iGain = p4
  iNote = p5
  iInstr = p6
  iArg = p7
  ignore = p8
  ;
  SLastInstChn sprintf "solo.inst.%d", iInstr
  iInstance chnget SLastInstChn
  SStopChn sprintf "solo.stop.%d.%d", iInstr, iInstance
  chnset 1, SStopChn
  iNextInstance = (iInstance + 1) % $SOLO_MAX_INST
  chnset iNextInstance, SLastInstChn
  schedule "SoloInstrWrapper", 0.001, iDur, iGain, iNote, iInstr, iNextInstance, iArg
  turnoff
endin

;; Instruments
;; =================================================================================

;; a wrapper stopping the previous instance
instr PlayChords
  iDur = p3
  iGain = p4
  iFreq = p5
  iSample def p6, 0
  ignore = p8
  ;
  aSig subinstr "SampleMono", iGain, mtof:i(60), iSample
  kEnv madsr 0.01, 0.1, 0.9, 0.1
  out aSig*kEnv, aSig*kEnv
endin

instr Bd
  iGain def p4, 1
  iFreq def p5, 330
  iDur def p6, 0.1
  ignore = p8
  ;
  kEnv linseg iGain, iDur*3, 0
  kFreq linseg iFreq, iDur, 10
  aSig poscil 1, kFreq
  ;
  aBass poscil iGain, 60
  ;
  aSig = (aSig + aBass) * kEnv / 2
  out aSig, aSig
endin

instr Hh
  iGain def p4, 1
  iFreq def p5, 3000
  iDur def p6, 0.1
  ignore = p8
  ;
  kEnv linseg iGain, iDur, 0
  aSig noise kEnv, 0
  aSig mvchpf aSig, iFreq, 0.9
  ;
  out aSig, aSig
endin

instr Airy
  iGain = p4
  iFreq mtof p5
  ;
  kEnv xadsr 0.1, 0.1, 0.7, 2
  aSig noise 1, 0
  aSig vclpf aSig, iFreq, 0.99
  aSin poscil 1/2, iFreq/2 
  aSin += poscil(1/3, iFreq)
  ;
  aOut = (aSig + aSin) / 2 * iGain * kEnv
  out aOut, aOut
endin

instr Square
  iGain = p4
  iFreq mtof p5
  ignore = p8
  ;
  kEnv madsr 0.02, 0.07, 0.7, 0.1
  kLfo lfo 1, 1/2
  kLfo scale kLfo, 0.8, 0.2, 1, -1
  aSqr vco2 1, iFreq, 2, kLfo
  ;
  aOut = aSqr * kEnv * iGain * 0.1
  out aOut, aOut
endin

</CsInstruments>
<CsScore>
i "RefreshColors" 0 1
</CsScore>
</CsoundSynthesizer>
