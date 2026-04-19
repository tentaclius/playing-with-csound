;; helper opcodes
opcode Tb, i, oooooooooooooooooooo
  i1,i2,i3,i4,i5,i6,i7,i8,i9,i10,i21,i22,i23,i24,i25,i26,i27,i28,i29,i30 xin
  iFt ftgentmp 0,0,10,2, i1,i2,i3,i4,i5,i6,i7,i8,i9,i10,i21,i22,i23,i24,i25,i26,i27,i28,i29,i30
  xout iFt
endop

opcode def, i, ii  ;; set a value or use the default value in case of 0
  iVal, iDflt xin
  if iVal == 0 then
    iVal = iDflt
  endif
  xout iVal
endop

opcode ignore, 0, ooooooooooooooooooooo
  i1,i2,i3,i4,i5,i6,i7,i8,i9,i10,i11,i12,i13,i14,i15,i16,i17,i18,i19,i20,i21 xin
endop

;; MIDI abstractions
#define MIDI_COLOR #0#
#define MIDI_INSTR #1#
#define MIDI_DUR #2#
#define MIDI_GAIN #3#
#define MIDI_FREQ #4#
#define MIDI_SAMPLE #5#
#define MIDI_PARAM #6#
#define MIDI_LAST #7#

giMidiMap[][] init 100, 7
opcode MidiMap, 0, iiSiiooo
  iNote, iColor, SInstr, iDur, iGain, iFreq, iSample, iParam xin
  iInstrNum = SInstr == "" ? 0 : nstrnum(SInstr)
  giMidiMap setrow fillarray(iColor, iInstrNum, iDur, iGain, iFreq, iSample, iParam), iNote
endop

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
    schedule giMidiMap[iNote][$MIDI_INSTR], 0, giMidiMap[iNote][$MIDI_DUR], iGain, iFreq, giMidiMap[iNote][$MIDI_SAMPLE], giMidiMap[iNote][$MIDI_PARAM]
  endif
endin
