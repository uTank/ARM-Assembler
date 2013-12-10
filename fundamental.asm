
mov r0, r2, LSR #24
orr r3, r0, r3, LSL #8

mov r0, r0, LSL #n      ; r0 = r0 << n; r0 = r0 * (2**n)
add r0, r0, r0, LSL #n  ; r0 = r0 + r0 * (2**n) = r0 * (2**n + 1)
rsb r0, r0, r0, LSL #n  ; r0 = r0 * (2**n) - r0 = r0 * (2**n - 1)
add r0, r0, r0, LSL #2  ; r0 = r0 * (2**2 + 1) = r0 * 5
add r0, r1, r0, LSL #1  ; r0 = r1 + r0 * (2**1)

adds r0, r0, r2
adc r1, r1, r3

subs r0, r0, r2
sbc r1, r1, r3

cmp r1, r3
cmpeq r0, r2

; little endian --> big endian
; r0 = A,B,C,D --> r0 = D,C,B,A
eor r1, r0, r0, ROR #16 ; r1 = r0 ^ (r0 >>> 16) = [A,B,C,D] ^ [C,D,A,B] = A^C,B^D,C^A,D^B
bic r1, r1, #0xff0000   ; r1 = A^C, 0 ,C^A,D^B
mov r0, r0, ROR #8      ; r0 = D, A, B, C
eor r0, r0, r1, LSR #8  ; r0 = r0 ^ (r1 >> 8) = [D,A,B,C] ^ [0,A^C,0,C^A] = D,C,B,A

; r0 = A,B,C,D --> r0 = D,C,B,A
mov r2, #0xff           ; r2 = 0xff
orr r2, r2, #0xff0000   ; r2 = 0x00ff00ff
and r1, r2, r0          ; r1 = 0,B,0,D
and r0, r2, r0, ROR #24 ; r0 = r2 & (r0 >>> 24) = 0x00ff00ff & [B,C,D,A] = 0,C,0,A
orr r0, r0, r1, ROR #8  ; r0 = r0 | (r1 >>> 8) = [0,B,0,D] | [A,0,C,0] = A,B,C,D

; routine
...
BL function
...
...
function
...
...
MOV PC, LR

; conditional execution
int gcd(int a, int b)
{
    while (a != b)
        if (a > b)
            a = a - b;
        else
            b = b - a;
    return a;
}

gcd:
    cmp r0, r1
    subgt r0, r0, r1
    sublt r1, r1, r0
    bne gcd
    mov pc, lr

;
if (a == 0 || b == 1)
    c = d + e

; r0 = a; r1 = b; r2 = c, r3 = d; r4 = e
cmp r0, #0
cmpne r1, #1
addeq r2, r3, r4

;
MOV R0, #LoopCount
Loop:
...
SUBS R0, R0, #1
BNE Loop
...



;
llsearch:
    CMP R0, #0
    LDRNEB R2, [R0]
    CMPNE R1, R2
    LDRNE R0, [R0, #4]
    BNE llsearch
    MOV PC, LR

;字符串比较操作
StrCmp:
    LDRB R2, [R0], #1
    LDRB R3, [R1], #1
    CMP R2, #0
    CMPNE R3, #0
    BEQ Return
    CMP R2, R3
    BEQ StrCmp
Return:
    SUB R0, R2, R3
    MOV PC, LR

