.data
x: .word 1
y: .word 1
z: .word 1

#################################################################

.text
main:
# load do x, y e z para os registos
lw x10, x
lw x11, y
lw x12, z

# store dos valores para a pilha
addi sp, sp, -12
sw x12, 0(sp)
sw x11, 4(sp)
sw x10, 8(sp)

# chamada da funçao
jal not(x_xor_y_xor_z)

# load do output da funçao
lw x10, 0(sp)
addi sp, sp, 4

li x17, 10
ecall

#################################################################

multiplica:
# salvaguarda de contexto
addi sp, sp, -12
sw x10, 8(sp)
sw x11, 4(sp)
sw x12, 0(sp)

li x10, 0

lw x11, 16(sp)
lw x12, 12(sp)

# modulo do numero
bge x12, x0, loop
not x12, x12
addi x12, x12, 1

loop:
ble x12, x0, check
add x10, x10, x11
addi x12, x12, -1
j loop

# modulo do numero
check:
bge x12, x0, end
addi x10, x10, -1
not x10, x10

end:
sw x10, 16(sp)

lw x10, 8(sp)
lw x11, 4(sp)
lw x12, 0(sp)
addi sp, sp, 16
ret

#################################################################

neuronio:
mv x18, x1
# x10 = x1
# x11 = x2
# x12 = w1
# x13 = w2
# x14 = b

# x1 * w1
addi sp, sp, -8
sw x10, 0(sp)
sw x12, 4(sp)
jal multiplica
lw x10, 0(sp)
addi sp, sp, 4

# x2 * w2
addi sp, sp, -8
sw x11, 0(sp)
sw x13, 4(sp)
jal multiplica
lw x11, 0(sp)
addi sp, sp, 4

# x1 * w1 + x2 * w2 + b
add x10, x10, x11
add x10, x10, x14

mv x1, x18
bge x10, x0, return1
return0:
li x10, 0
ret
return1:
li x10, 1
ret

#################################################################

rede_neuronal_xor:

# save jal
mv x19, x1
# x10 = a
# x11 = b
# x15 = c
# x16 = d

addi sp, sp, -8
sw x10, 0(sp)
sw x11, 4(sp)

# c = neuronio(a, b, 2, -2, -1)
lw x10, 0(sp)
lw x11, 4(sp)
li x12, 2
li x13, -2
li x14, -1
jal neuronio
mv x15, x10

# d = neuronio(a, b, -2, 2, -1)
lw x10, 0(sp)
lw x11, 4(sp)
li x12, -2
li x13, 2
li x14, -1
jal neuronio
mv x16, x10

# y = neuronio(c, d, -2, 2, -1)
mv x10, x15
mv x11, x16
li x12, 2
li x13, 2
li x14, -1
jal neuronio

addi sp, sp, 8

# repo jal
mv x1, x19
ret

#################################################################
# input
# x10 = x
# x11 = y
# output
# x10 = x nand y
x_nand_y:

mv x20, x1

addi sp, sp, -12
sw x12, 0(sp)
sw x13, 4(sp)
sw x14, 8(sp)

li x12, 2
li x13, 2
li x14, -1
jal neuronio

lw x12, 0(sp)
lw x13, 4(sp)
lw x14, 8(sp)
addi sp, sp, 12

mv x1, x20

ret

#################################################################

not(x_xor_y_xor_z):
# input by stack 0(sp) -- 4(sp) -- 8(sp)
# output by stack 0(sp)

# save register
mv x21, x1

# salvaguarda de contexto
addi sp, sp, -8
sw x10, 4(sp)
sw x11, 0(sp)

# x10 = xor(sp1, sp2)
lw x10, 16(sp)
lw x11, 12(sp)
jal rede_neuronal_xor

# x10 = xor(x10, sp3)
lw x11, 8(sp)
jal rede_neuronal_xor

# not(x10)
xori x10, x10, 1

# guardar o output na pilha
sw x10, 16(sp)

# reposiçao de contexto
lw x10, 4(sp)
lw x11, 0(sp)
addi sp, sp, 16

# repo register
mv x1, x21
ret