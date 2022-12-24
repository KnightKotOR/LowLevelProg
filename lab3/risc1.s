# Попарная перестановка, если x1 > x2, x3 > x4 и тд
# Резултат в ячейках с 0x00010050 по 0x0001006c
# t0 - первый элемент пары
# t1 - второй элемент пары
# a4 - длина массива
# a2 - адрес элемента x1 рассматриваемой пары
# a3 - адрес конца массива

.text
__start:
.globl __start
  la a2, array # загружаем адрес 0-го элемента массива
  lw a4, array_length # загружаем длину массива
  srli a3, a4, 1 # смещаем на 1 разряд влево и тем самым отбрасываем последний разряд
  slli a3, a3, 3 # смещаем на 3 разряда влево (восстанавливаем последний и умножаем на 4)
  add a3, a2, a3 # прибавляем к адресу массива длину и получаем адрес последнего элемента
  beq a2, a3, loop_exit # если достигли конца массива, заканчиваем работу

loop:

  lw t0, 0(a2) # загружаем t[0]
  lw t1, 4(a2) # загружаем t[1]
  bge t1, t0, next_loop # если t[1] >= t[0], то пропускаем перестановку и переходим к следующей итерации
  sw t0, 4(a2) # \
  sw t1, 0(a2) # / меняем местами t[0] и t[1] в исходном массиве
  
next_loop:
  
  addi a2, a2, 8 # переход к следующей паре элементов
  bne a2, a3, loop # если достигли конца массива, заканчиваем работу

loop_exit:

finish:

  li a0, 10
  ecall
  
.rodata
array_length:
  .word 9
.data
array:
  .word 3, 6, 2, 2, 5, 4, 21, 16, 10