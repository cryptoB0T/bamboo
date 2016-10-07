type 'imm instruction =
  | PUSH1 of 'imm
  | PUSH32 of 'imm
  | NOT
  | TIMESTAMP
  | EQ
  | ISZERO
  | LT
  | GT
  | BALANCE
  | STOP
  | ADD
  | MUL
  | SUB
  | DIV
  | SDIV
  | MOD
  | SMOD
  | ADDMOD
  | MULMOD
  | EXP
  | SIGNEXTEND
  | ADDRESS
  | ORIGIN
  | CALLER
  | CALLVALUE
  | CALLDATALOAD
  | CALLDATASIZE
  | CALLDATACOPY
  | CODESIZE
  | CODECOPY
  | GASPRICE
  | EXTCODESIZE
  | POP
  | MLOAD
  | MSTORE
  | MSTORE8
  | SLOAD
  | SSTORE
  | JUMP
  | JUMPI
  | PC
  | MSIZE
  | GAS
  | JUMPDEST of Label.label
  | LOG0
  | LOG1
  | LOG2
  | LOG3
  | LOG4
  | CREATE
  | CALL
  | CALLCODE
  | RETURN
  | DELEGATECALL
  | SUICIDE
  | SWAP1
  | SWAP2
  | SWAP3
  | SWAP4
  | SWAP5
  | SWAP6
  | DUP1
  | DUP2
  | DUP3
  | DUP4
  | DUP5
  | DUP6
  | DUP7

type 'imm program = 'imm instruction list
let program_length = List.length

let empty_program = []

(** The program is stored in the reverse order *)
let append_inst orig i = i :: orig

let to_list (p : 'imm program) =
  List.rev p

let stack_eaten = function
  | PUSH1 _ -> 0
  | PUSH32 _ -> 0
  | NOT -> 1
  | TIMESTAMP -> 0
  | EQ -> 2
  | ISZERO -> 1
  | LT -> 2
  | GT -> 2
  | BALANCE -> 1
  | STOP -> 0
  | ADD -> 2
  | MUL -> 2
  | SUB -> 2
  | DIV -> 2
  | SDIV -> 2
  | MOD -> 2
  | SMOD -> 2
  | ADDMOD -> 3
  | MULMOD -> 3
  | EXP -> 2
  | SIGNEXTEND -> 2
  | ADDRESS -> 0
  | ORIGIN -> 0
  | CALLER -> 0
  | CALLVALUE -> 0
  | CALLDATALOAD -> 1
  | CALLDATASIZE -> 0
  | CALLDATACOPY -> 3
  | CODESIZE -> 0
  | CODECOPY -> 3
  | GASPRICE -> 0
  | EXTCODESIZE -> 1
  | POP -> 1
  | MLOAD -> 1
  | MSTORE -> 2
  | MSTORE8 -> 2
  | SLOAD -> 1
  | SSTORE -> 2
  | JUMP -> 1
  | JUMPI -> 2
  | PC -> 0
  | MSIZE -> 0
  | GAS -> 0
  | JUMPDEST _ -> 0
  | SWAP1 -> 2
  | SWAP2 -> 3
  | SWAP3 -> 4
  | SWAP4 -> 5
  | SWAP5 -> 6
  | SWAP6 -> 7
  | LOG0 -> 2
  | LOG1 -> 3
  | LOG2 -> 4
  | LOG3 -> 5
  | LOG4 -> 6
  | CREATE -> 3
  | CALL -> 7
  | CALLCODE -> 7
  | RETURN -> 2
  | DELEGATECALL -> 7
  | SUICIDE -> 1
  | DUP1 -> 1
  | DUP2 -> 2
  | DUP3 -> 3
  | DUP4 -> 4
  | DUP5 -> 5
  | DUP6 -> 6
  | DUP7 -> 7


let stack_pushed = function
  | PUSH1 _ -> 1
  | PUSH32 _ -> 1
  | NOT -> 1
  | TIMESTAMP -> 1
  | EQ -> 1
  | ISZERO -> 1
  | LT -> 1
  | GT -> 1
  | BALANCE -> 1
  | STOP -> 0
  | ADD -> 1
  | MUL -> 1
  | SUB -> 1
  | DIV -> 1
  | SDIV -> 1
  | EXP -> 1
  | MOD -> 1
  | SMOD -> 1
  | ADDMOD -> 1
  | MULMOD -> 1
  | SIGNEXTEND -> 1
  | ADDRESS -> 1
  | ORIGIN -> 1
  | CALLER -> 1
  | CALLVALUE -> 1
  | CALLDATALOAD -> 1
  | CALLDATASIZE -> 1
  | CALLDATACOPY -> 0
  | CODESIZE -> 1
  | CODECOPY -> 0
  | GASPRICE -> 1
  | EXTCODESIZE -> 1
  | POP -> 0
  | MLOAD -> 1
  | MSTORE -> 0
  | MSTORE8 -> 0
  | SLOAD -> 1
  | SSTORE -> 0
  | JUMP -> 0
  | JUMPI -> 0
  | PC -> 1
  | MSIZE -> 1
  | GAS -> 1
  | JUMPDEST _ -> 0
  | SWAP1 -> 2
  | SWAP2 -> 3
  | SWAP3 -> 4
  | SWAP4 -> 5
  | SWAP5 -> 6
  | SWAP6 -> 7
  | DUP1 -> 2
  | DUP2 -> 3
  | DUP3 -> 4
  | DUP4 -> 5
  | DUP5 -> 6
  | DUP6 -> 7
  | DUP7 -> 8
  | LOG0 -> 0
  | LOG1 -> 0
  | LOG2 -> 0
  | LOG3 -> 0
  | LOG4 -> 0
  | CREATE -> 1
  | CALL -> 1
  | CALLCODE -> 1
  | RETURN -> 0
  | DELEGATECALL -> 1
  | SUICIDE -> 0

let string_of_pseudo_opcode op =
  match op with
  | PUSH1 v -> "PUSH1 "^(PseudoImm.string_of_pseudo_imm v)
  | PUSH32 v -> "PUSH32 "^(PseudoImm.string_of_pseudo_imm v)
  | NOT -> "NOT"
  | TIMESTAMP -> "TIMESTAMP"
  | EQ -> "EQ"
  | ISZERO -> "ISZERO"
  | LT -> "LT"
  | GT -> "GT"
  | BALANCE -> "BALANCE"
  | STOP -> "STOP"
  | ADD -> "ADD"
  | MUL -> "MUL"
  | SUB -> "SUB"
  | DIV -> "DIV"
  | SDIV -> "SDIV"
  | EXP -> "EXP"
  | MOD -> "MOD"
  | SMOD -> "SMOD"
  | ADDMOD -> "ADDMOD"
  | MULMOD -> "MULMOD"
  | SIGNEXTEND -> "SIGNEXTEND"
  | ADDRESS -> "ADDRESS"
  | ORIGIN -> "ORIGIN"
  | CALLER -> "CALLER"
  | CALLVALUE -> "CALLVALUE"
  | CALLDATALOAD -> "CALLDATALOAD"
  | CALLDATASIZE -> "CALLDATASIZE"
  | CALLDATACOPY -> "CALLDATACOPY"
  | CODESIZE -> "CODESIZE"
  | CODECOPY -> "CODECOPY"
  | GASPRICE -> "GASPRICE"
  | EXTCODESIZE -> "EXTCODESIZE"
  | POP -> "POP"
  | MLOAD -> "MLOAD"
  | MSTORE -> "MSTORE"
  | MSTORE8 -> "MSTORE8"
  | SLOAD -> "SLOAD"
  | SSTORE -> "SSTORE"
  | JUMP -> "JUMP"
  | JUMPI -> "JUMPI"
  | PC -> "PC"
  | MSIZE -> "MSIZE"
  | GAS -> "GAS"
  | JUMPDEST l -> "JUMPDEST (print label)"
  | SWAP1 -> "SWAP1"
  | SWAP2 -> "SWAP2"
  | SWAP3 -> "SWAP3"
  | SWAP4 -> "SWAP5"
  | SWAP5 -> "SWAP5"
  | SWAP6 -> "SWAP6"
  | DUP1 -> "DUP1"
  | DUP2 -> "DUP2"
  | DUP3 -> "DUP3"
  | DUP4 -> "DUP4"
  | DUP5 -> "DUP5"
  | DUP6 -> "DUP6"
  | DUP7 -> "DUP7"
  | LOG0 -> "LOG0"
  | LOG1 -> "LOG1"
  | LOG2 -> "LOG2"
  | LOG3 -> "LOG3"
  | LOG4 -> "LOG4"
  | CREATE -> "CREATE"
  | CALL -> "CALL"
  | CALLCODE -> "CALLCODE"
  | RETURN -> "RETURN"
  | DELEGATECALL -> "DELEGATECALL"
  | SUICIDE -> "SUICIDE"

let string_of_pseudo_program prg =
  let op_lst = to_list prg in
  String.concat "" (List.map (fun op -> string_of_pseudo_opcode op ^ "\n") op_lst)

let print_pseudo_program prg =
  Printf.printf "%s" (string_of_pseudo_program prg)

let realize_pseudo_instruction (l : PseudoImm.layout_info) (i : PseudoImm.pseudo_imm instruction)
    : Big_int.big_int instruction =
  match i with
  | PUSH1 imm -> PUSH1 (PseudoImm.realize_pseudo_imm l imm)
  | PUSH32 imm -> PUSH32 (PseudoImm.realize_pseudo_imm l imm)
  | NOT -> NOT
  | TIMESTAMP -> TIMESTAMP
  | EQ -> EQ
  | ISZERO -> ISZERO
  | LT -> LT
  | GT -> GT
  | BALANCE -> BALANCE
  | STOP -> STOP
  | ADD -> ADD
  | MUL -> MUL
  | SUB -> SUB
  | DIV -> DIV
  | SDIV -> SDIV
  | MOD -> MOD
  | SMOD -> SMOD
  | ADDMOD -> ADDMOD
  | MULMOD -> MULMOD
  | EXP -> EXP
  | SIGNEXTEND -> SIGNEXTEND
  | ADDRESS -> ADDRESS
  | ORIGIN -> ORIGIN
  | CALLER -> CALLER
  | CALLVALUE -> CALLVALUE
  | CALLDATALOAD -> CALLDATALOAD
  | CALLDATASIZE -> CALLDATASIZE
  | CALLDATACOPY -> CALLDATACOPY
  | CODESIZE -> CODESIZE
  | CODECOPY -> CODECOPY
  | GASPRICE -> GASPRICE
  | EXTCODESIZE -> EXTCODESIZE
  | POP -> POP
  | MLOAD -> MLOAD
  | MSTORE -> MSTORE
  | MSTORE8 -> MSTORE8
  | SLOAD -> SLOAD
  | SSTORE -> SSTORE
  | JUMP -> JUMP
  | JUMPI -> JUMPI
  | PC -> PC
  | MSIZE -> MSIZE
  | GAS -> GAS
  | JUMPDEST l -> JUMPDEST l
  | LOG0 -> LOG0
  | LOG1 -> LOG1
  | LOG2 -> LOG2
  | LOG3 -> LOG3
  | LOG4 -> LOG4
  | CREATE -> CREATE
  | CALL -> CALL
  | CALLCODE -> CALLCODE
  | RETURN -> RETURN
  | DELEGATECALL -> DELEGATECALL
  | SUICIDE -> SUICIDE
  | SWAP1 -> SWAP1
  | SWAP2 -> SWAP2
  | SWAP3 -> SWAP3
  | SWAP4 -> SWAP4
  | SWAP5 -> SWAP5
  | SWAP6 -> SWAP6
  | DUP1 -> DUP1
  | DUP2 -> DUP2
  | DUP3 -> DUP3
  | DUP4 -> DUP4
  | DUP5 -> DUP5
  | DUP6 -> DUP6
  | DUP7 -> DUP7


let realize_pseudo_program (l : PseudoImm.layout_info) (p : PseudoImm.pseudo_imm program)
    : Big_int.big_int program
  = List.map (realize_pseudo_instruction l) p
