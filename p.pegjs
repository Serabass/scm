// https://gtamods.com/wiki/III/VC_SCM

{
  function extractList(list, index) {
    return list.map(function(element) { return element[index]; });
  }

  function optionalList(value) {
    return value !== null ? value : [];
  }
}

Start
  = program:Program { return program; }

Program
  = head: Head
    body:SourceElements? {
      return {
        type: "Program",
        body: optionalList(body)
      };
    }

SourceElements
  = head:OPCODE tail:(OPCODE)* {
      return [head, ...tail];
    }

Head
  = header1: Header1
    header2: Header2
    someTitle: (........................)
    header3: Header3?
    ms: HeaderMainScript {
      return {
        header1,
        header2,
        someTitle,
        header3,
        ms
      };
    }

Header1 "header 1"
  = chunk: GOTO_CHUNK
    game: TargetGame {
    return {
      type: "Header 1",
      chunk,
      game,
    }
  }

Header2 "header 2"
  = chunk: GOTO_CHUNK
    alignment: Alignment
    usedObjectsCount: (....) {
    return {
      type: "Header 2",
      chunk,
      alignment,
      usedObjectsCount
    }
  }
Header3 "header 3"
  = chunk: GOTO_CHUNK
    alignment: "0x00"
    usedObjectsCount: (....) {
    return {
      type: "Header 3",
      chunk,
      alignment,
      usedObjectsCount
    }
  }

HeaderMainScript "header main script"
 = chunk: GOTO_CHUNK
   alignment: Alignment
   mainScriptSize: (....)
   largestMissionSize: (....)
   missionScriptsCount: (..)
   exclusiveMissionScriptsCount: (..)
    {
   return {
     chunk,
     alignment,
     mainScriptSize,
     largestMissionSize,
     missionScriptsCount,
     exclusiveMissionScriptsCount,
   };
 }

Alignment "alignment"
 = "\x00" / "\x01"

TargetGame = "l" / "m"


GOTO_CHUNK "goto chunk"
  = "\x02\x00\x01" offset: (....) {
    return {
      type: "GOTO_CHUNK",
      offset
    };
  }

OPCODE "opcode"
 = NAME_THREAD
 / CREATE_FIRE
 / END_THREAD
 / FADE
 / SET_TOTAL_MISSIONS
 / JUMP
 / CREATE_PLAYER
 / TEXT_STYLED
 / PUT_HIDDEN_PACKAGE
 / GET_RAMPAGE_STATUS
 / SET_GANG_MODELS

SET_GANG_MODELS "set gang models"
 = "\x35\x02" gangIndex: VAL model1: VAL model2: VAL {
   return {
     OPCODE: "GET_RAMPAGE_STATUS",
     gangIndex, model1, model2
   };
 }

GET_RAMPAGE_STATUS "get rampage status"
 = "\xFA\x01" result: VAR2 {
   return {
     OPCODE: "GET_RAMPAGE_STATUS",
     result
   };
 }

PUT_HIDDEN_PACKAGE "put hidden package at"
 = "\xEC\x02" x: VAL y: VAL z: VAL {
   return {
     OPCODE: "PUT_HIDDEN_PACKAGE",
     x, y, z
   };
 }

CREATE_FIRE "create fire at"
 = "\xCF\x02" x: VAL y: VAL z: VAL v: VAR2 {
   return {
     OPCODE: "CREATE_FIRE",
     x, y, z, v
   };
 }

JUMP
  = "\x02\x00" addr: LABEL_ADDR {
    return {
      OPCODE: "JUMP",
      addr
    };
  }

NOP "nop"
  = "\x00\x00" {
    return {
      OPCODE: "NOP"
    };
  }

NAME_THREAD "set thread name"
  = "\xA4\x03" name: STR {
    return {
      OPCODE: "NAME_THREAD",
      name
    };
  }

END_THREAD "end thread with specified name"
  = "\x59\x04" name: (.......) n: "\x00" {
    return {
      OPCODE: "END_THREAD",
      name
    };
  }

FADE "fade screen"
  = "\x6A\x01" v1: BYTE v2: BYTE {
    return {
      OPCODE: "FADE",
      v1, v2
    };
  }

SET_TOTAL_MISSIONS "set total missions"
  = "\x2C\x04" val: BYTE {
    return {
      OPCODE: "SET_TOTAL_MISSIONS",
      val
    };
  }

CREATE_PLAYER "create player at position"
  = "\x53\x00"
      v: BYTE
      x: FLOAT
      y: FLOAT
      z: FLOAT
      m: "\x02\x18\x00" {
    return {
      OPCODE: "CREATE_PLAYER",
      v, x, y, z, m
    };
  }

TEXT_STYLED
 = "\xBA\x00" str: (........) time: FLOAT style: BYTE {
   return {
      OPCODE: "TEXT_STYLED",
      str, time, style
    };
 }

EOF "end of file"
 = !.

VAL
  = BYTE
  / VAR3
  / FLOAT
  / LABEL_ADDR

LABEL_ADDR
 = "\x01" val: (....) {
   return {
     type: "LABEL_ADDR",
     val: val
   };
 }

BYTE
 = "\x04" val: (.) {
   return {
     type: "BYTE_VAL",
     val
   };
 }

FLOAT
 = "\x06" val: (....) {
   return {
     type: "FLOAT",
     val
   };
 }

VAR2
 = "\x02" val: (..) {
   return {
     type: "VAR2",
     val
   };
 }

VAR3 "@ prefixed var"
 = "\x03" val: (..) {
   return {
     type: "VAR3",
     val
   };
 }

STR7
 = "\x0E" "\x07" val: (.......) {
   return {
     type: "STR7",
     val: val.join('')
   };
 }

STR8
 = "\x0E" "\x08" val: (........) {
   return {
     type: "STR7",
     val: val.join('')
   };
 }

STR9
 = "\x0E" "\x09" val: (.........) {
   return {
     type: "STR9",
     val: val.join('')
   };
 }

 STR
   = STR7
   / STR8
   / STR9