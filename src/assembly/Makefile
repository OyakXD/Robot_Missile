
TARGET = program


SRC = program.asm


OBJ = program.o


NASMFLAGS = -f elf64


all: $(TARGET)


$(TARGET): $(OBJ)
	ld -o $@ $^


$(OBJ): $(SRC)
	nasm $(NASMFLAGS) -o $@ $<


clean:
	rm -f $(OBJ) $(TARGET)
