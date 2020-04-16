C_FILE=progc
ASM_FILE=proga
FINAL=prog

all : nasm_compile c_compile final_compile
nasm_compile : 
	nasm -f elf64 -o $(ASM_FILE).o -l $(ASM_FILE).lst $(ASM_FILE).asm
c_compile:
	gcc -m64 -c -g -O0 $(C_FILE).c
final_compile :
	gcc -m64 -o $(FINAL) $(C_FILE).o $(ASM_FILE).o
	
clean :
	rm *.o
	rm $(FINAL)
	rm $(ASM_FILE).lst
