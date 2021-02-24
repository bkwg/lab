nasm -f elf32 $1 -O0 &&\
file=$(echo $1 | cut -d "." -f 1) &&\
ld -m elf_i386 $file.o -o $file
