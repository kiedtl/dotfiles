" we need the conceal feature (vim ≥ 7.3)
if !has('conceal')
    finish
endif

" [[ ]]
syn match li_LeftDBracket        /\[\[/     contains=li_LeftDBracket1,li_LeftDBracket2
syn match li_LeftDBracket1       /\[/       contained conceal cchar=
syn match li_LeftDBracket2       /\[\@<=\[/ contained conceal cchar=
syn match li_RightDBracket       /\]\]/     contains=li_RightDBracket1,li_RightDBracket2
syn match li_RightDBracket1      /\]/       contained conceal cchar=
syn match li_RightDBracket2      /\]\@<=\]/ contained conceal cchar=

" #[
syn match li_HashBracket         /#\[/      contains=li_HashBracketTail
syn match li_HashBracketTail     /#\@<=\[/  contained conceal cchar=

" [| |]
syn match li_LBracketPipe        /\[|/      contains=li_LBracketPipePipe
syn match li_LBracketPipePipe    /\[\@<=|/  contained containedin=LBracketPipe conceal cchar=
syn match li_RBracketPipe        /|\]/      contains=li_RBracketPipePipe
syn match li_RBracketPipePipe    /|/        contained containedin=RBracketPipe conceal cchar=

" 0x
syn match li_Hex                 /\<0x\d/   contains=li_HexZero,li_HexMult
syn match li_HexZero             /0/        contained containedin=li_Hex conceal cchar=0
syn match li_HexMult             /0\@<=x/   contained containedin=li_Hex conceal cchar=×

" :=
syn match li_ColonEqual          /:=/       contains=li_ColonEqualHead,li_ColonEqualTail
syn match li_ColonEqualHead      /:/        contained containedin=li_ColonEqual conceal cchar=
syn match li_ColonEqualTail      /:\@<==/   contained containedin=li_ColonEqual conceal cchar=

" ||
syn match li_DivideEqual         /||/       contains=li_DivideEqualHead,li_DivideEqualTail
syn match li_DivideEqualHead     /|/        contained containedin=li_DivideEqual conceal cchar=
syn match li_DivideEqualTail     /|\@<=|/   contained containedin=li_DivideEqual conceal cchar=

" /=
syn match li_DivideEqual         /\/=/      contains=li_DivideEqualHead,li_DivideEqualTail
syn match li_DivideEqualHead     /\//       contained containedin=li_DivideEqual conceal cchar=
syn match li_DivideEqualTail     /\/\@<==/  contained containedin=li_DivideEqual conceal cchar=

syn match li_NotEqual            "!="       conceal cchar=≠

" ->, <-
syn match li_Pointer             /->/       contains=li_PointerTail,li_PointerHead1
syn match li_PointerTail         /-/        contained containedin=li_Pointer conceal cchar=
syn match li_PointerHead1        /-\@<=>/   contained containedin=li_Pointer conceal cchar=→
syn match li_Pointer             /<-/       contains=li_PointerHead2,li_PointerTail
syn match li_PointerHead2        /</        contained containedin=li_Pointer conceal cchar=←

" =>
syn match li_DoublePointer       /=>/       contains=li_DoublePointerHead,li_DoublePointerTail
syn match li_DoublePointerHead   /=/        contained containedin=li_DoublePointer conceal cchar=
syn match li_DoublePointerTail   /=\@<=>/   contained containedin=li_DoublePointer conceal cchar=⇒

" ==
syn match li_IsEqual             /==/       contains=li_FirstEqual,li_SecondEqual
syn match li_FirstEqual          /=/        contained containedin=li_IsEqual conceal cchar=
syn match li_SecondEqual         /=\@<==/   contained containedin=li_IsEqual conceal cchar=

" disabled
" >=, <=
"syn match li_LessThan            /<=/       contains=li_LessThanHead,li_LessThanTail
"syn match li_LessThanHead        /</        contained containedin=li_LessThan conceal cchar=
"syn match li_LessThanTail        /<\@<==/   contained containedin=li_LessThan conceal cchar=
"syn match li_GreaterThan         />=/       contains=li_GreaterThanHead,li_GreaterThanTail
"syn match li_GreaterThanHead     />/        contained containedin=li_GreaterThan conceal cchar=
"syn match li_GreaterThanTail     />\@<==/   contained containedin=li_GreaterThan conceal cchar=
