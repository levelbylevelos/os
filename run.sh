# assemble bootloader
nasm -f bin boot.asm -o boot.bin

# assemble kernel
nasm -f bin kernel.asm -o kernel.bin

# create floppy image
dd if=/dev/zero of=os.img bs=512 count=2880

# write bootloader
dd if=boot.bin of=os.img conv=notrunc

# write kernel
dd if=kernel.bin of=os.img bs=512 seek=1 conv=notrunc

# run
qemu-system-i386 -drive format=raw,file=os.img