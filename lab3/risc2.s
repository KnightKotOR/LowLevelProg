.text
__start:
.global __start
  call main
finish:
  li a0, 10 
  ecall
  
# main.s
# Загрузка адреса первого элемента массива в a0, длины массива в a1
# Вызов подпрогаммы

.text
main:
.globl main

  la a0, array # загружаем адрес 0-го элемента массива
  lw a1, array_length # загружаем длину массива

  addi sp, sp, -16 # выделение памяти в стеке
  sw ra, 12(sp) # сохранение ra
  
  call swap_pairs #вызов подпрограммы
  
  lw ra, 12(sp) # загрузка ra
  addi sp, sp, 16 # освобождение памяти в стеке
  
  ret
  
.rodata
array_length:
  .word 8
.data
array:
  .word 3, 6, 2, 2, 5, 4, 21, 16


# swap_pairs.s
# Попарная перестановка, если x1 > x2, x3 > x4 и тд
# Резултат в ячейках с 0x0001007c по 0x00010098

.text
swap_pairs:
.globl swap_pairs
# в a0 – адрес 0-го элемента массива чисел
# в a1 – длина массива
  srli a2, a1, 1 # смещаем на 1 разряд влево и тем самым отбрасываем последний разряд
  slli a2, a2, 3 # смещаем на 3 разряда влево (восстанавливаем последний и умножаем на 4)
  add a2, a0, a2 # прибавляем к адресу массива длину и получаем адрес последнего элемента
  beq a0, a2, loop_exit # если достигли конца массива, заканчиваем работу
  
loop:
  lw t0, 0(a0) # загружаем t[0]
  lw t1, 4(a0) # загружаем t[1]
  bge t1, t0, next_loop # если t[1] >= t[0], то пропускаем перестановку и переходим к следующей итерации
  sw t0, 4(a0) # \
  sw t1, 0(a0) # / меняем местами t[0] и t[1] в исходном массиве
  
next_loop:  
  addi a0, a0, 8 # переход к следующей паре элементов
  bne a0, a2, loop # если достигли конца массива, заканчиваем работу
  
loop_exit:
  ret
