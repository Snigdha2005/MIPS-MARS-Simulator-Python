.data	
	next_line: .asciiz "\n"
	inp_statement: .asciiz "Enter No. of integers to be taken as input: "
	inp_int_statement: .asciiz "Enter starting address of inputs(in decimal format): "
	out_int_statement: .asciiz "Enter starting address of outputs (in decimal format): "
	enter_int: .asciiz "Enter the integer: "
	#.align 2
	#array: .space 12
	
.text

#input: N= how many numbers to sort should be entered from terminal. 
#It is stored in $t1
jal print_inp_statement	
jal input_int 
move $t1,$t4			

#input: X=The Starting address of input numbers (each 32bits) should be entered from
# terminal in decimal format. It is stored in $t2
jal print_inp_int_statement
jal input_int
move $t2,$t4

#input:Y= The Starting address of output numbers(each 32bits) should be entered
# from terminal in decimal. It is stored in $t3
jal print_out_int_statement
jal input_int
move $t3,$t4 

#input: The numbers to be sorted are now entered from terminal.
# They are stored in memory array whose starting address is given by $t2
move $t8,$t2
move $s7,$zero	#i = 0
loop1:  beq $s7,$t1,loop1end
	jal print_enter_int
	jal input_int
	sw $t4,0($t2)
	addi $t2,$t2,4
      	addi $s7,$s7,1
        j loop1      
loop1end: move $t2,$t8       
#############################################################
#Do not change any code above this line
#Occupied registers $t1,$t2,$t3. Don't use them in your sort function.
#############################################################
#function: should be written by students(sorting function)
#The below function adds 10 to the numbers. You have to replace this with
#your code
#t1 -> n; t2 -> input address; t3 -> output address
addi $s1,$t1,0#s1 is assigned n
addi $t5,$t2,0#t5 is assigned in input address
addi $t7,$t3,0#t7 is given the output address
addi $t0,$0,0#t0=i is assigned 0
copy:
	slt $t9,$t0,$s1#if0<n t9=1 else t9=0
	beq $t9,$0,initial#when t9=0 initial
	lw $t9,0($t5)#storing the 1st element into t9
	sw $t9,0($t7)#giving that element to 0th address of t7
	addi $t5,$t5,4#incrementing input address
	addi $t7,$t7,4#incrementing the output address
	addi $t0,$t0,1#i++
	j copy
	
initial:
	addi $at,$0,1#at=1
    	sub $s1,$s1,$at#n=n-1
	addi $t0,$0,0# making i=0
	addi $t4,$0,0#t4=0=j
	addi $t7,$t3,0#t7=t3
	j loop3

loop3:
	slt $t9,$t0,$s1#if i<n-1 t9=1 else t9=0
	beq $t9,$0,exit#if t9=0 directly stop
	sub $t8,$s1,$t0#t8=n-1-i
	slt $t9,$t4,$t8#if j<n-i-1 the t9=1 else t9=0
	bne $t9,$0,loop2#if t9!=0 go to loop2
	addi $t4,$0,0#when the above conditon satisfy make jback to 0
	addi $t0,$t0,1#i++
	addi $t7,$t3,0
	j loop3
	
loop2:
	lw $t9,0($t7)#t9=A[j]
	lw $t5,4($t7)#t5=A[j+1]
	slt $s2,$t9,$t5#if A[j]<A[j+1] s2=1 else s2=0
	beq $s2,$0,swap #if s2=0 the do swap
	addi $t4,$t4,1#j++
	addi $t7,$t7,4#go to next output address
	j loop3
	
swap:
	sw $t5,0($t7)#t5 has A[j] and it is shifted to 1st address of the output address
	sw $t9,4($t7)#t9 has A[j+1] and that is shifted to 2nd address of the outpput address
	addi $t4,$t4,1#j++
	addi $t7,$t7,4#increment output address
	j loop3

exit:

################################################################
move $s7,$zero	#i = 0
loop: beq $s7,$t1,end
      lw $t4,0($t3)
      jal print_int
      jal print_line
      addi $t3,$t3,4
      addi $s7,$s7,1
      j loop 
#end
end:  li $v0,10
      syscall
#input from command line(takes input and stores it in $t6)
input_int: li $v0,5
	   syscall
	   move $t4,$v0
	   jr $ra
#print integer(prints the value of $t6 )
print_int: li $v0,1	
	   move $a0,$t4
	   syscall
	   jr $ra
#print nextline
print_line:li $v0,4
	   la $a0,next_line
	   syscall
	   jr $ra

#print number of inputs statement
print_inp_statement: li $v0,4
		la $a0,inp_statement
		syscall 
		jr $ra
#print input address statement
print_inp_int_statement: li $v0,4
		la $a0,inp_int_statement
		syscall 
		jr $ra
#print output address statement
print_out_int_statement: li $v0,4
		la $a0,out_int_statement
		syscall 
		jr $ra
#print enter integer statement
print_enter_int: li $v0,4
		la $a0,enter_int
		syscall 
		jr $ra
