#----------enunciado----------
# Determinar a maior potencia
# de 2 menor que u(7)
# u(7) e o 7º elemento
# da sequencia de fibonacci

.data
x: .word 1


.text
la x15, x
lw x10, x
li x12, 13

for:
slli x10, x10, 1
blt x10, x12, for

srli x10, x10, 1

sw x10, 0(x15) 

li x17,1
ecall

li x17,10
ecall