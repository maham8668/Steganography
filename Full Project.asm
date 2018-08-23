.386
.model flat, stdcall
ExitProcess proto , dwExitCode:dword
.Stack 4096

.data
choice byte "What would you like to do ?" , 0dh , 0ah
encypt byte "Press 1 to hide" , 0dh , 0ah
decrypt byte "Press 2 to recover" , 0dh , 0ah
sayBye byte "Press 3 to exit" , 0dh , 0ah
selection byte "Enter your selection" , 0dh , 0ah
source byte "Please specify the source PPM filename E-g boxes_1.ppm" , 0dh , 0ah
output byte "Please specify output PPM filename E-g boxes.ppm" , 0dh , 0ah
secretWord byte "Please enter a phrase to hide" , 0dh , 0ah
messageHasHidden byte "Your meassage '"
messageHasHidden1 byte "'has been hidden in "" " , 0dh , 0ah
source1 byte "Please specify the source PPM filename E-g boxes.ppm" , 0dh , 0ah
messageHasrecovered byte "Following message '"
messageHasrecovered1 byte "'has been recovered from file hidden-1.ppm "" " , 0dh , 0ah

filepath2 byte "G:\Image\"

a dword ?
b dword ?
d dword ?

buffer byte 12000 DUP(?)
handle dword ?
array byte 12000 DUP(?)
m dword ?
message byte 30 DUP(?)
select byte 30 DUP(?)
phrase byte 50 DUP(?)
filename byte 20  DUP(?)
filename2 byte 20 DUP(?)

GetStdHandle proto , nStdHandle:dword
WriteConsoleA proto , handle:dword , lpBuffer:PTR byte , P1: dword , P2:ptr dword , P3: ptr dword
ReadConsoleA proto , handle:dword , lpBuffer:PTR byte , P1: dword , P2:ptr dword , P3: ptr dword
ExitProcess proto , asd:dword

filepath1 byte "G:\Image\"

CloseHandle proto , p1:dword
ExitProcess proto , p1:dword
CreateFileA proto , p1: ptr byte , p2:dword, p3:dword , p4:dword , p5:dword , p6:dword , p7:dword
ReadFile proto , p1: dword , p2:ptr byte , p3:dword , p4:ptr dword , p5:ptr dword
WriteFile proto , p1: dword , p2:ptr byte , p3:dword , p4:ptr dword , p5:ptr dword

.code

encryption proc

push eax

invoke GetStdHandle , -11
mov a , eax
mov esi , offset b
mov ebx , offset source
invoke WriteConsoleA , a , ebx , lengthof source  , esi , 0

invoke GetStdHandle , -10
mov d , eax
mov esi , offset b
mov ebx , offset filename
invoke ReadConsoleA , eax , offset filename , lengthof filename , esi , 0

invoke GetStdHandle , -11
mov a , eax
mov esi , offset b
mov ebx , offset output
invoke WriteConsoleA , a , ebx , lengthof output , esi , 0

invoke GetStdHandle , -10
mov d , eax
mov esi , offset b
mov ebx , offset filename2
invoke ReadConsoleA , d , ebx , lengthof filename2 , esi , 0

push eax
push ecx
push ebx
mov ebx,0
LoopStart:
mov al,filename[ebx]
cmp al,0
je Start1
inc ebx
jmp LoopStart
Start1:
dec ebx
dec ebx
mov eax,offset filepath1
mov ecx,ebx
mov ebx,0
mov esi, lengthof filepath1
L1:
mov al,filename[ebx]
mov filepath1[esi],al	
inc esi
inc ebx
Loop L1
pop ebx
pop ecx
pop eax


push eax
push ecx
push ebx
mov ebx,0
LoopStart1A:
mov al,filename2[ebx]
cmp al,0
je Start1A
inc ebx
jmp LoopStart1A
Start1A:
dec ebx
dec ebx
mov eax,offset filepath2
mov ecx,ebx
mov ebx,0
mov esi, lengthof filepath2
L1A:
mov al,filename2[ebx]
mov filepath2[esi],al	
inc esi
inc ebx
Loop L1A
pop ebx
pop esi
pop eax


invoke CreateFileA , offset filepath1 , 10020000h , 1 , 0 , 3 , 128 , 0
mov handle, eax
invoke ReadFile , eax , offset buffer , 12000 , offset m , 0
invoke CloseHandle , handle
invoke CreateFileA , offset filepath2 , 101F0000h , 2 , 0 , 3 , 128 , 0
mov handle, eax
invoke WriteFile , eax , offset buffer , 12000 , offset m , 0
invoke CloseHandle , handle
invoke CreateFileA , offset filepath2 , 101F0000h , 2 , 0 , 3 , 128 , 0
mov handle , eax
invoke ReadFile, eax , offset array , 12000 , offset m , 0
invoke CloseHandle , handle

mov edi , offset array

invoke GetStdHandle , -11
mov a , eax
mov esi , offset b
mov ebx , offset secretWord
invoke WriteConsoleA , a , ebx , lengthof secretWord , esi , 0

invoke GetStdHandle , -10
mov d , eax
mov esi,offset b
mov ebx , offset phrase
invoke ReadConsoleA , d , ebx , lengthof phrase , esi , 0


mov eax , 0
mov ecx , 0
LM :
cmp phrase[eax] , 00000000b
je skipA
inc ecx
inc eax
jmp LM


skipA :
dec ecx 
dec ecx


mov esi , 0
mov edi , 0 
L111 :
mov al, phrase[esi]
mov dx , 9

L2 :
dec dx
cmp dx , 0 
je BB	
SHL al , 1
jnc L3
or array[edi] , 00000001b  
inc edi
jmp L2 

L3 :
and array[edi] , 11111110b  
inc edi
jmp L2
Loop L2

BB :

inc esi
Loop L111



or array[edi] , 11111111b
   
 mov esi , offset array

invoke GetStdHandle , -11
mov a , eax
mov esi , offset b
mov ebx , offset messageHasHidden
invoke WriteConsoleA , a , ebx , lengthof messageHasHidden , esi , 0

invoke GetStdHandle , -11
mov a , eax
mov esi , offset b
mov ebx , offset phrase
invoke WriteConsoleA , a , ebx , lengthof phrase , esi , 0

invoke GetStdHandle , -11
mov a , eax
mov esi , offset b
mov ebx , offset messageHasHidden1
invoke WriteConsoleA , a , ebx , lengthof messageHasHidden1 , esi , 0

invoke GetStdHandle , -11
mov a , eax
mov esi , offset b
mov ebx , offset filename
invoke WriteConsoleA , a , ebx , lengthof filename , esi , 0

pop eax
ret
encryption endp

decrpytion proc

push eax
LB :

invoke GetStdHandle , -11
mov a , eax
mov esi , offset b
mov ebx , offset source1
invoke WriteConsoleA , a , ebx , lengthof source1 , esi , 0

invoke GetStdHandle , -10
mov d , eax
mov esi , offset b
mov ebx , offset filepath2
invoke ReadConsoleA , d , ebx , lengthof filepath2 , esi , 0

invoke CreateFileA, offset filepath2, 101F0000h, 2, 0, 3, 128, 0
mov handle, eax
invoke ReadFile, eax, offset array, 12000, offset d,0
invoke CloseHandle, handle

mov edi , offset array


mov ebx , 0
mov edx , 0
mov eax , 8
L11 :
shr array[ebx] , 1
rcl message[edx] , 1
dec eax
cmp eax , 0
jne skip
add edx , 1
mov eax , 8
skip :
inc ebx
cmp array[ebx] , 11111111b
je exit
jmp L11
exit :

mov ebx , offset message


invoke GetStdHandle , -11
mov a , eax
mov ebx , offset messageHasrecovered
invoke WriteConsoleA , a , ebx , lengthof messageHasrecovered , esi , 0


invoke GetStdHandle , -11
mov a , eax
mov ebx , offset message
invoke WriteConsoleA , a , ebx , lengthof message , esi , 0

invoke GetStdHandle , -11
mov a , eax
mov ebx , offset messageHasrecovered1
invoke WriteConsoleA , a , ebx , lengthof messageHasrecovered1 , esi , 0

pop eax
ret 
decrpytion endp


main proc

Start :

invoke GetStdHandle , -11
mov a , eax
mov esi , offset b
mov ebx , offset choice
invoke WriteConsoleA , a , ebx , lengthof choice , esi , 0

invoke GetStdHandle , -11
mov a , eax
mov esi , offset b
mov ebx , offset encypt
invoke WriteConsoleA , a , ebx , lengthof encypt , esi , 0

invoke GetStdHandle , -11
mov a , eax
mov esi , offset b
mov ebx , offset decrypt
invoke WriteConsoleA , a , ebx , lengthof decrypt , esi , 0

invoke GetStdHandle , -11
mov a , eax
mov esi , offset b
mov ebx , offset sayBye
invoke WriteConsoleA , a , ebx , lengthof sayBye , esi , 0


invoke GetStdHandle , -11
mov a , eax
mov esi , offset b
mov ebx , offset selection
invoke WriteConsoleA , a , ebx , lengthof selection , esi , 0

invoke GetStdHandle , -10
mov d , eax
mov esi , offset b
mov ebx , offset select
invoke ReadConsoleA , d , ebx , lengthof select , esi , 0

mov al , select
cmp al , '1'
je Follow
cmp al , '2'
je Equal

jmp Bye

Follow :
call encryption
jmp start

Equal :
call decrpytion
jmp start

Bye :

invoke ExitProcess , 0
main endp
end main
 