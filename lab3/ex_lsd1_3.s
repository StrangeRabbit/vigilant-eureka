# Programa L3.as

# ZONA I: Definicao de variaveis
.data
	x: .word 2
	y: .word 17

# ZONA II: Codigo
.text

# Programa principal: programa que recebe dois numeros inteiros positivos, x e y, e retorna o valor de x^y
	lw a0, x
	lw a1, y
	li a2, 0
	addi sp, sp, -12
	sw a0, 8(sp)
	sw a1, 4(sp)
	sw a2, 0(sp)
	jal Pow

	lw a0, 4(sp)

	li a7, 1
	ecall

	lw a0, 0(sp)

	addi sp, sp, 8

	li a7, 1
	ecall

	li a7, 10
	ecall

# Pow: Rotina que efectua o calculo de x^y, sendo x e y dois numeros inteiros positivos
# 	Entradas: 	8(sp) - x
#			  			4(sp) - y
#						0(sp) - n
#	Saidas:   	4(sp) - resultado
#						0(sp) - numero de vezes chamada
# 	Efeitos:  	---

Pow:
	addi sp, sp, -28
	sw ra, 24(sp)
	sw s1, 20(sp)
	sw s2, 16(sp)
	sw a0, 12(sp)
	sw a1, 8(sp)
	sw a2, 4(sp)
	sw a3, 0(sp)
	
	lw a0, 32(sp) # a0 = y
	beq a0, zero, return1 # y = 0 => return1

	lw s2, 28(sp)
	addi s2, s2, 1

	srai a1, a0, 1 # a1 = h

	li a2, 1
	ble a0, a2, else # y < 1 ou y = 1 => else

	andi a2, a0, 1
	bne a2, zero, else # y % 2 = 1 => else

	lw a3, 36(sp) # a3 = x

	addi sp, sp, -12
	sw a3, 8(sp) # 8(sp) = x
	sw a1, 4(sp) # 4(sp) = h
	sw s2, 0(sp) # 0(sp) = n
	jal	Pow

	lw s2, 0(sp)
	lw a0, 4(sp) # a0 = pow(x,h,n)
	sw a0, 0(sp)
	jal Mult # Mult(pow(x,h), pow(x,h))
	lw s1, 0(sp)
	addi sp, sp, 4
	j end

else:

	lw a0, 36(sp) # a0 = x
	
	addi sp, sp, -12
	sw a0, 8(sp) # 8(sp) = x
	sw a1, 4(sp) # 4(sp) = h
	sw s2, 0(sp) # 0(sp) = n
	jal Pow
	
	lw s2, 0(sp)
	lw a0, 4(sp) # a0 = pow(x,h)
	sw a0, 0(sp)
	jal Mult
	lw a0, 40(sp) # a0 = x
	addi sp, sp, -4
	sw a0, 0(sp)
	jal Mult
	lw s1, 0(sp)
	addi sp, sp, 4
	j end

return1:
	li s1, 1

end:
	sw s1, 36(sp)
	sw s2, 32(sp)

	lw ra, 24(sp)
	lw s1, 20(sp)
	lw s2, 16(sp)
	lw a0, 12(sp)
	lw a1, 8(sp)
	lw a2, 4(sp)
	lw a3, 0(sp)
	addi sp, sp, 32
	ret

# Mult: Rotina que efectua o calculo de a*b, sendo a e b numeros inteiros positivos
# 	Entradas:	0(sp), 4(sp) - numeros a multiplicar
#	Saidas:		0(sp) - resultado
#	Efeitos:	---

Mult:
	addi sp, sp, -12
	sw s1, 8(sp)
	sw s2, 4(sp)
	sw s3, 0(sp)

	lw s2, 16(sp)
	lw s1, 12(sp)

	li s3, 0
	beq s2, zero, OutMul
	beq s1, zero, OutMul

MulLoop:
	add s3, s3, s1
	addi, s2, s2, -1
	bne s2, zero, MulLoop

OutMul:
	sw s3, 16(sp)

	lw s3, 0(sp)
	lw s2, 4(sp)
	lw s1, 8(sp)
	addi sp, sp, 16
	ret
