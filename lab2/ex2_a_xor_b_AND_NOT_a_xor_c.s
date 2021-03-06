.data

.text

main:
### a = 0 e b = 0 e c = 0
li x10, 0
li x11, 0
li x12, 0
jal y

li x17, 1
ecall

### a = 0 e b = 0 e c = 1
li x10, 0
li x11, 0
li x12, 1
jal y

li x17, 1
ecall

### a = 0 e b = 1 e c = 0
li x10, 0
li x11, 1
li x12, 0
jal y

li x17, 1
ecall

### a = 0 e b = 1 e c = 1
li x10, 0
li x11, 1
li x12, 1
jal y

li x17, 1
ecall

### a = 1 e b = 0 e c = 0
li x10, 1
li x11, 0
li x12, 0
jal y

li x17, 1
ecall

### a = 1 e b = 0 e c = 1
li x10, 1
li x11, 0
li x12, 1
jal y

li x17, 1
ecall

### a = 1 e b = 1 e c = 0
li x10, 1
li x11, 1
li x12, 0
jal y

li x17, 1
ecall

### a = 1 e b = 1 e c = 1
li x10, 1
li x11, 1
li x12, 1
jal y

li x17, 1
ecall


li x17, 10
ecall

#################################################################

y:
mv x21, x1
addi sp, sp, -4
sw x10, 0(sp)

jal rede_neuronal_xor
mv x11, x12 # move c to x11
mv x12, x10 # save a xor b in x12
lw x10, 0(sp) # load a to x10

jal rede_neuronal_xor
mv x11, x10
mv x10, x12
jal x_and_not_y
mv x1, x21
addi sp, sp, 4
ret

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
#input
# x10 = x1
# x11 = x2
# x12 = w1
# x13 = w2
# x14 = b
# output 
# x10 = output neuronio


neuronio:
mv x18, x1

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
# input
# x10 = x
# x11 = y
# output
# x10 = x xor y

rede_neuronal_xor:

# save jal
mv x19, x1
# x10 = a
# x11 = b
# x15 = c
# x16 = d

addi sp, sp, -20
sw x10, 0(sp)
sw x11, 4(sp)
sw x12, 8(sp)
sw x13, 12(sp)
sw x14, 16(sp)

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

lw x12, 8(sp)
lw x13, 12(sp)
lw x14, 16(sp)
addi sp, sp, 20

# repo jal
mv x1, x19
ret

#################################################################
# input
# x10 = x
# x11 = y
# output
# x10 = x and not(y)
x_and_not_y:

# save jal
mv x20, x1


addi sp, sp, -12
sw x12, 0(sp)
sw x13, 4(sp)
sw x14, 8(sp)

# return = neuronio(c, a, 3, -2, -2)
li x12, 3
li x13, -2
li x14, -2
jal neuronio

lw x12, 0(sp)
lw x13, 4(sp)
lw x14, 8(sp)
addi sp, sp, 12

# repo jal
mv x1, x20
ret
