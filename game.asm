#####################################################################
#
# CSCB58 Winter 2024 Assembly Final Project
# University of Toronto, Scarborough
#
# Student: Xinge Wang, 1008837822, wang3607, single.wang@mail.utoronto.ca
#
# Bitmap Display Configuration:
# - Unit width in pixels: 4 (update this as needed)
# - Unit height in pixels: 4 (update this as needed)
# - Display width in pixels: 256 (update this as needed)
# - Display height in pixels: 256 (update this as needed)
# - Base Address for Display: 0x10008000 ($gp)
#
# Which milestoneshave been reached in this submission?
# (See the assignment handout for descriptions of the milestones)
# - Milestone 4 (choose the one the applies)
#
# Which approved features have been implemented for milestone 4?
# (See the assignment handout for the list of additional features)
# 1. Different levels (2 marks)
# 2. Disappearing platform (1 mark)
# 3. Moving objects (2 marks)
# ... (add more if necessary)
#
# Link to video demonstration for final submission:
# - https://github.com/Verusins/Jerry-dodge- (github)
# - https://youtu.be/ayTEwwVGEBY (YouTube)
#
# Are you OK with us sharing the video with people outside course staff?
# - yes, and please share this project github link as well!
#
# Any additional information that the TA needs to know:
# N/A
#
#####################################################################

.eqv BASE_ADDRESS 0x10008000
.data
color_black: .word 0x000000     # Black color
color_platform: .word 0x666666  # Plaform Gray
color_gray: .word 0xC3C3C3      # Gray color
color_white: .word 0xFFFFFF     # White color
color_red: .word 0xFF0000       # Red color
# color_yellow: .word 0xEBF527    # Yellow color
color_green: .word 0x33DE72     # Green color
color_blue: .word 0x42B4FF      # Blue color (main)
color_lightblue: .word 0x99E7EE # Blue for water body
color_water: .word 0x4F47ED     # Water Dark Blue / Quicksand
# A: .word 4 8 12 256 272 512 516 520 524 528 -1

# make the whole page white
.macro ClearPage
    li $t3, 0 # counter
    li $t4, 4096 # ending condition
    lw $t5, color_white # color
    addi $t6, $t0, 0 # counter (for paint)
    
background:
    sw $t5, ($t6) # paint the pixel
    addi $t3, $t3, 1 # Increment loop counter
    addi $t6, $t6, 4 # Compare loop counter with loop limit
    bne $t3, $t4, background  # Branch to loop if not equal
.end_macro

.macro MakeGround
    li $t3, 0 # counter 256*92 = 23552
    li $t4, 1024 # ending condition
    lw $t5, color_black # color
    addi $t6, $t0, 12288 # counter starting at 256*92*4 = 94208
ground:
    sw $t5, ($t6) # paint the pixel
    addi $t3, $t3, 1 # Increment loop counter
    addi $t6, $t6, 4 # Compare loop counter with loop limit
    bne $t3, $t4, ground  # Branch to loop if not equal
.end_macro

.macro MakeWater
    li $t3, 0 # counter 256*92 = 23552
    li $t4, 960 # ending condition
    lw $t5, color_lightblue # color
    addi $t6, $t0, 8448 # counter starting at 256*92*4 = 94208
water:
    sw $t5, ($t6) # paint the pixel
    addi $t3, $t3, 1 # Increment loop counter
    addi $t6, $t6, 4 # Compare loop counter with loop limit
    bne $t3, $t4, water  # Branch to loop if not equal
.end_macro

.macro DrawPowerUp (%xindex) (%yindex)
    addi $t6, $t0, %yindex
    addi $t6, $t6, %xindex
    addi $t6, $t6, %xindex
    addi $t6, $t6, %xindex
    addi $t6, $t6, %xindex
    lw $t5, color_red # color
    sw $t5, ($t6) # paint the pixel
    lw $t5, color_yellow # color
    sw $t5, 4($t6) # paint the pixel
    lw $t5, color_blue # color
    sw $t5, 256($t6) # paint the pixel
    lw $t5, color_green # color
    sw $t5, 260($t6) # paint the pixel
.end_macro 

.macro DrawWaterPlatformAt (%xindex) (%yindex)
    li $t3, 0 # counter
    li $t4, 16 # ending condition
    lw $t5, color_water # color
    addi $t6, $t0, %yindex
    addi $t6, $t6, %xindex
    addi $t6, $t6, %xindex
    addi $t6, $t6, %xindex
    addi $t6, $t6, %xindex
ground:
    sw $t5, ($t6) # paint the pixel
    addi $t3, $t3, 1 # Increment loop counter
    addi $t6, $t6, 4 # Compare loop counter with loop limit
    bne $t3, $t4, ground  # Branch to loop if not equal
.end_macro

.macro DrawTempPlatformAt (%xindex) (%yindex)
    li $t3, 0 # counter
    li $t4, 16 # ending condition
    lw $t5, color_gray # color
    addi $t6, $t0, %yindex
    addi $t6, $t6, %xindex
    addi $t6, $t6, %xindex
    addi $t6, $t6, %xindex
    addi $t6, $t6, %xindex
ground:
    sw $t5, ($t6) # paint the pixel
    addi $t3, $t3, 1 # Increment loop counter
    addi $t6, $t6, 4 # Compare loop counter with loop limit
    bne $t3, $t4, ground  # Branch to loop if not equal
.end_macro

.macro DrawPlatformAt (%xindex) (%yindex)
    li $t3, 0 # counter
    li $t4, 16 # ending condition
    lw $t5, color_black # color
    addi $t6, $t0, %yindex
    addi $t6, $t6, %xindex
    addi $t6, $t6, %xindex
    addi $t6, $t6, %xindex
    addi $t6, $t6, %xindex
ground:
    sw $t5, ($t6) # paint the pixel
    addi $t3, $t3, 1 # Increment loop counter
    addi $t6, $t6, 4 # Compare loop counter with loop limit
    bne $t3, $t4, ground  # Branch to loop if not equal
.end_macro

.macro MakeLevel2Pf
    DrawWaterPlatformAt 0 8192
    DrawWaterPlatformAt 16 8192
    DrawWaterPlatformAt 32 8192
    DrawWaterPlatformAt 48 8192
.end_macro

.macro MakeLevel3Pf
    DrawWaterPlatformAt 8 8192
    DrawWaterPlatformAt 40 8192
.end_macro

.macro DetectPfLevel2 (%xindex)
    # reference: blt $t1, 11520, above_ground
    # $t3 = 0 means in air, $t3 = 1 means on ground/platform
    la $t3, 0
    bge $t1, 11520, on_platform3
    bge $t1, 7168, on_platform0_half2
    j not_on3
on_platform0_half2:
    ble $t1, 7408, not_on3
on_platform3:
    la $t3, 1
not_on3:
.end_macro

.macro DetectPfLevel3 (%xindex)
    la $t3, 0
    bge $t1, 11520, on_platform2
    # 7168 - 7920
    bgt $t1, 7920, not_on2
    blt $t1, 7168, not_on2
    add $t4, $zero, 256
    div $t1, $t4
    mfhi $t5
    bgt $t5, 220, not_on2
    blt $t5, 150, branch1
    j onPlatform
branch1:
    bgt $t5, 100, not_on2
    blt $t5, 20, not_on2
onPlatform:
    la $t5, 2
    div $t9, $t5
    mfhi $t4
    beq $t4, 0, not_on2
    sub $t9, $t9, 1
    j not_on2
on_platform2:
    la $t3, 1
not_on2:
.end_macro

.macro InitialBulletLv1
    add $s4, $zero, 11516
    add $t4, $t0, $s4
    lw $t3, color_red
    sw $t3, ($t4)
.end_macro

.macro InitialBulletLv2
    add $s4, $zero, 11516
    add $s5, $zero, 7292
    add $s6, $zero, 11388
    add $t4, $t0, $s4
    add $t5, $t0, $s5
    add $t6, $t0, $s6
    lw $t3, color_red
    sw $t3, ($t4)
    sw $t3, ($t5)
    sw $t3, ($t6)
.end_macro

.macro UpdateNDrawBulletLv1
    add $t4, $s4, $t0
    lw $t3, color_white
    sw $t3, ($t4)
    lw $t3, color_red
    sub $s4, $s4, 4
    add $t4, $s4, $t0
    sw $t3, ($t4)

    li $t0, BASE_ADDRESS
    add $t0, $t0, 11260
    bgt $t4, $t0, loopB11
    lw $t3, color_white
    sw $t3, ($t4)
    lw $t3, color_red
    add $s4, $s4, 256 # 11516
loopB11:
.end_macro

.macro UpdateDrawBulletLv2
    add $t4, $s4, $t0
    add $t5, $s5, $t0
    add $t6, $s6, $t0
    
    lw $t3, color_lightblue
    sw $t3, ($t4)
    sw $t3, ($t6)
    lw $t3, color_white
    sw $t3, ($t5)
    lw $t3, color_red
    sub $s4, $s4, 4
    sub $s5, $s5, 4
    add $s6, $s6, 4
    add $t4, $s4, $t0
    add $t5, $s5, $t0
    add $t6, $s6, $t0
    sw $t3, ($t4)
    sw $t3, ($t5)
    sw $t3, ($t6)

    li $t0, BASE_ADDRESS
    add $t0, $t0, 11260
    bgt $t4, $t0, loopB11
    lw $t3, color_lightblue
    sw $t3, ($t4)
    lw $t3, color_red
    add $s4, $s4, 256 # 11516
loopB11:
    li $t0, BASE_ADDRESS
    add $t0, $t0, 7164
    bgt $t5, $t0, loopB12
    lw $t3, color_white
    sw $t3, ($t5)
    lw $t3, color_red
    add $s5, $s5, 256 # 7168
loopB12:
    li $t0, BASE_ADDRESS
    add $t0, $t0, 11516
    blt $t6, $t0, loopB21
    lw $t3, color_lightblue
    sw $t3, ($t6)
    lw $t3, color_red
    add $s6, $s6, -256 # 7168
loopB21:
.end_macro

.macro UpdateDrawBulletLv3
    add $t4, $s4, $t0
    add $t5, $s5, $t0
    add $t6, $s6, $t0
    
    lw $t3, color_white
    sw $t3, ($t4)
    sw $t3, ($t6)
    sw $t3, ($t5)
    lw $t3, color_red
    sub $s4, $s4, 4
    sub $s5, $s5, 4
    add $s6, $s6, 4
    add $t4, $s4, $t0
    add $t5, $s5, $t0
    add $t6, $s6, $t0
    sw $t3, ($t4)
    sw $t3, ($t5)
    sw $t3, ($t6)

    li $t0, BASE_ADDRESS
    add $t0, $t0, 11260
    bgt $t4, $t0, loopB11
    lw $t3, color_white
    sw $t3, ($t4)
    lw $t3, color_red
    add $s4, $s4, 256 # 11516
loopB11:
    li $t0, BASE_ADDRESS
    add $t0, $t0, 7164
    bgt $t5, $t0, loopB12
    lw $t3, color_white
    sw $t3, ($t5)
    lw $t3, color_red
    add $s5, $s5, 256 # 7168
loopB12:
    li $t0, BASE_ADDRESS
    add $t0, $t0, 11516
    blt $t6, $t0, loopB21
    lw $t3, color_white
    sw $t3, ($t6)
    lw $t3, color_red
    add $s6, $s6, -256 # 7168
loopB21:
.end_macro

.macro BulletCollision (%character) (%bullet)
    la $t0, 256
    bgt $s1, 0, collisionEnd
    # $t3 character x, $t4 character y
    # $t5 bullet    x, $t6 bullet    y
    add $t3, $zero, %character
    div $t3, $t0
    mfhi $t3
    mflo $t4
    add $t5, $zero, %bullet
    div $t5, $t0
    mfhi $t5
    mflo $t6
    blt $t5, $t3, collisionEnd
    add $t3, $t3, 16
    bgt $t5, $t3, collisionEnd
    blt $t6, $t4, collisionEnd
    add $t4, $t4, 4
    bgt $t6, $t4, collisionEnd
    la $s1, 10
collisionEnd:
.end_macro

.macro MakeEnemy (%xindex)
    li $t3, 0 # counter
    li $t4, 4 # ending condition
    lw $t5, color_red # color
    addi $t6, $t0, 11264
    addi $t6, $t6, %xindex
    addi $t6, $t6, %xindex
    addi $t6, $t6, %xindex
    addi $t6, $t6, %xindex
ground:
    sw $t5, ($t6) # paint the pixel
    sw $t5, 4($t6) # paint the pixel
    sw $t5, 8($t6) # paint the pixel
    sw $t5, 12($t6) # paint the pixel
    addi $t3, $t3, 1 # Increment loop counter
    addi $t6, $t6, 256 # Compare loop counter with loop limit
    bne $t3, $t4, ground  # Branch to loop if not equal
.end_macro

.macro MakeCharacter (%index)
    li $t3, 0 # counter
    li $t4, 4 # ending condition
    lw $t5, color_blue # color
    add $t6, %index, 0
    add $t6, $t6, $t0
ground:
    sw $t5, ($t6) # paint the pixel
    sw $t5, 4($t6) # paint the pixel
    sw $t5, 8($t6) # paint the pixel
    sw $t5, 12($t6) # paint the pixel
    addi $t3, $t3, 1 # Increment loop counter
    addi $t6, $t6, 256 # Compare loop counter with loop limit
    bne $t3, $t4, ground  # Branch to loop if not equal
.end_macro

.macro MakeCharacterHurt (%index)
    li $t3, 0 # counter
    li $t4, 4 # ending condition
    lw $t5, color_gray # color
    add $t6, %index, 0
    add $t6, $t6, $t0
ground:
    sw $t5, ($t6) # paint the pixel
    sw $t5, 4($t6) # paint the pixel
    sw $t5, 8($t6) # paint the pixel
    sw $t5, 12($t6) # paint the pixel
    addi $t3, $t3, 1 # Increment loop counter
    addi $t6, $t6, 256 # Compare loop counter with loop limit
    bne $t3, $t4, ground  # Branch to loop if not equal
.end_macro

.macro MakeEyes
    add $t3, $t1, 256
    add $t3, $t3, $t0
    lw $t5, color_black # color
    blt $t1, $t7, left
    add $t3, $t3, 4
left:
    sw $t5, ($t3)
    sw $t5, 8($t3)
.end_macro

.macro CleanCharacter (%index)
    li $t0, BASE_ADDRESS
    li $t3, 0 # counter
    li $t4, 4 # ending condition
    lw $t5, color_white # color
    add $t6, %index, 0
    add $t6, $t6, $t0
    add $t0, $t0, 8192
ground:
    bne $s2, 2, aboveWater
    blt $t6, $t0, aboveWater
    lw $t5, color_lightblue # color
aboveWater:
    
    sw $t5, ($t6) # paint the pixel
    sw $t5, 4($t6) # paint the pixel
    sw $t5, 8($t6) # paint the pixel
    sw $t5, 12($t6) # paint the pixel
    addi $t3, $t3, 1 # Increment loop counter
    addi $t6, $t6, 256 # Compare loop counter with loop limit
    bne $t3, $t4, ground  # Branch to loop if not equal
.end_macro

.macro DrawHealth (%hearts)
    li $t0, BASE_ADDRESS
    add $t3, %hearts, 0
    lw $t4, color_red
    
    bne $t3, 0, moreThan0Health
    lw $t4, color_gray

moreThan0Health:
    addi $t6, $t0, 260
    sw $t4, 0($t6)
    sw $t4, 8($t6)
    sw $t4, 256($t6)
    sw $t4, 260($t6)
    sw $t4, 264($t6)
    sw $t4, 516($t6)
    
    bne $t3, 1, moreThan1Health
    lw $t4, color_gray

moreThan1Health:
    addi $t6, $t6, 16
    sw $t4, 0($t6)
    sw $t4, 8($t6)
    sw $t4, 256($t6)
    sw $t4, 260($t6)
    sw $t4, 264($t6)
    sw $t4, 516($t6)
    
    bne $t3, 2, moreThan2Health
    lw $t4, color_gray

moreThan2Health:    
    addi $t6, $t6, 16
    sw $t4, 0($t6)
    sw $t4, 8($t6)
    sw $t4, 256($t6)
    sw $t4, 260($t6)
    sw $t4, 264($t6)
    sw $t4, 516($t6)
.end_macro

.macro DrawProgress (%time)
    li $t0, BASE_ADDRESS
    add $t3, %time, 0
    addi $t6, $t0, 484
    lw $t4, color_green
    bge $t3, 100, percent10
    lw $t4, color_gray
percent10:
    addi $t6, $t6, 4
    sw $t4, 0($t6)
    sw $t4, 256($t6)
    bge $t3, 200, percent20
    lw $t4, color_gray
percent20:
    addi $t6, $t6, 4
    sw $t4, 0($t6)
    sw $t4, 256($t6)
    bge $t3, 300, percent30
    lw $t4, color_gray
percent30:
    addi $t6, $t6, 4
    sw $t4, 0($t6)
    sw $t4, 256($t6)
    bge $t3, 400, percent40
    lw $t4, color_gray
percent40:
    addi $t6, $t6, 4
    sw $t4, 0($t6)
    sw $t4, 256($t6)
    bge $t3, 500, percent50
    lw $t4, color_gray
percent50:
    addi $t6, $t6, 4
    sw $t4, 0($t6)
    sw $t4, 256($t6)
    
.end_macro

.macro DrawSuccessScreen
    li $t3, 0 # counter
    li $t4, 4096 # ending condition
    lw $t5, color_green # color
    addi $t6, $t0, 0 # counter (for paint)
background:
    sw $t5, ($t6) # paint the pixel
    addi $t3, $t3, 1 # Increment loop counter
    addi $t6, $t6, 4 # Compare loop counter with loop limit
    bne $t3, $t4, background  # Branch to loop if not equal
    
    lw $t5, color_white

    addi $t6, $t0, 6748
    sw $t5, 4($t6)
    sw $t5, 8($t6)
    sw $t5, 12($t6)
    sw $t5, 16($t6)
    sw $t5, 28($t6)
    sw $t5, 32($t6)
    sw $t5, 48($t6)
    sw $t5, 52($t6)
    sw $t5, 56($t6)
    sw $t5, 68($t6)
    sw $t5, 72($t6)
    sw $t5, 76($t6)
    
    addi $t6, $t6, 260
    sw $t5, 0($t6)
    sw $t5, 12($t6)
    sw $t5, 20($t6)
    sw $t5, 32($t6)
    sw $t5, 40($t6)
    sw $t5, 60($t6)
    
    addi $t6, $t6, 256
    sw $t5, 0($t6)
    sw $t5, 4($t6)
    sw $t5, 8($t6)
    sw $t5, 12($t6)
    sw $t5, 20($t6)
    sw $t5, 24($t6)
    sw $t5, 28($t6)
    sw $t5, 32($t6)
    sw $t5, 40($t6)
    sw $t5, 44($t6)
    sw $t5, 48($t6)
    sw $t5, 52($t6)
    sw $t5, 60($t6)
    sw $t5, 64($t6)
    sw $t5, 68($t6)
    sw $t5, 72($t6)
    
    addi $t6, $t6, 256
    sw $t5, 0($t6)
    sw $t5, 20($t6)
    sw $t5, 32($t6)
    sw $t5, 52($t6)
    sw $t5, 72($t6)
    
    addi $t6, $t6, 256
    sw $t5, 0($t6)
    sw $t5, 20($t6)
    sw $t5, 32($t6)
    sw $t5, 40($t6)
    sw $t5, 44($t6)
    sw $t5, 48($t6)
    sw $t5, 60($t6)
    sw $t5, 64($t6)
    sw $t5, 68($t6)
.end_macro

.macro DrawFailScreen
    li $t3, 0 # counter
    li $t4, 4096 # ending condition
    lw $t5, color_black # color
    addi $t6, $t0, 0 # counter (for paint)
background:
    sw $t5, ($t6) # paint the pixel
    addi $t3, $t3, 1 # Increment loop counter
    addi $t6, $t6, 4 # Compare loop counter with loop limit
    bne $t3, $t4, background  # Branch to loop if not equal
    
    lw $t5, color_white

    addi $t6, $t0, 5744
    
    sw $t5, 8($t6)
    sw $t5, 12($t6)
    sw $t5, 16($t6)
    sw $t5, 20($t6)
    
    sw $t5, 260($t6)
    sw $t5, 264($t6)
    sw $t5, 268($t6)
    sw $t5, 272($t6)
    sw $t5, 276($t6)
    sw $t5, 280($t6)
    
    sw $t5, 512($t6)
    sw $t5, 524($t6)
    sw $t5, 528($t6)
    sw $t5, 540($t6)
    
    sw $t5, 768($t6)
    sw $t5, 780($t6)
    sw $t5, 784($t6)
    sw $t5, 796($t6)
    
    sw $t5, 1024($t6)
    sw $t5, 1028($t6)
    sw $t5, 1032($t6)
    sw $t5, 1044($t6)
    sw $t5, 1048($t6)
    sw $t5, 1052($t6)
    
    sw $t5, 1284($t6)
    sw $t5, 1288($t6)
    sw $t5, 1292($t6)
    sw $t5, 1296($t6)
    sw $t5, 1300($t6)
    sw $t5, 1304($t6)
    
    sw $t5, 1544($t6)
    sw $t5, 1556($t6)
    
    add $t6, $t6, 2300
    sw $t5, 4($t6)
    sw $t5, 8($t6)
    sw $t5, 12($t6)
    sw $t5, 28($t6)
    sw $t5, 32($t6)
    sw $t5, 36($t6)
    add $t6, $t6, 256
    sw $t5, ($t6)
    sw $t5, 24($t6)
    add $t6, $t6, 256
    sw $t5, ($t6)
    sw $t5, 8($t6)
    sw $t5, 12($t6)
    sw $t5, 24($t6)
    sw $t5, 32($t6)
    sw $t5, 36($t6)
    add $t6, $t6, 256
    sw $t5, ($t6)
    sw $t5, 12($t6)
    sw $t5, 24($t6)
    sw $t5, 36($t6)
    add $t6, $t6, 256
    sw $t5, 4($t6)
    sw $t5, 8($t6)
    sw $t5, 28($t6)
    sw $t5, 32($t6)
.end_macro











.text
    li $t0, BASE_ADDRESS # $t0 stores the base address for display
    # $t1 - $t2 fixed. $t0 for base, $t1 for character position, $t2 for jump force
    # $t9 for storing health etc. 0x00000000, last digit for on jump or not, remaining for frame count
    # 2644 - 2716 # l 824 
    la $t2, 0
    la $s0, 3 # store health
    # s1 for smallest interval between damage
    # s4-s7 store bullet location
    la $s2, 0
    # s2 to store for levels

next_level:
    la $t1, 11280 # 11520
    add $s2, $s2, 1
    ClearPage
    MakeGround
    bne $s2, 2, noWater
    MakeWater
noWater:
    bne $s2, 1, drawBulletLv2
    InitialBulletLv1
    j main_loop
drawBulletLv2:
    InitialBulletLv2 # Bullet Lv2 and Lv3 share the same :)
        
main_loop:

# the start of input detection
    # $t7 for erasing former location
    add $t7, $t1, 0
    li $t5, 0xffff0000
    lw $t4, 0($t5)
    bne $t4, 1, validate_height
    lw $t0, 4($t5) # this assumes $t5 is set to 0xfff0000 from before
    beq $t0, 0x61, respond_left # ASCII code of 'a' is 0x61 or 97 in decimal
    beq $t0, 0x64, respond_right # d is 64
    beq $t0, 0x77, jump # w is 77
    beq $t0, 0x73, sink # s is 73
    j validate_height
respond_left:
    # detect if its at the left most
    la $t0, 256
    div $t1, $t0
    mfhi $t0
    beq $t0, 0, no_key
    sub $t1, $t1, 8
    j validate_height
respond_right:
    # detect if its at the right most
    la $t0, 256
    div $t1, $t0
    mfhi $t0
    bge $t0, 240, no_key
    add $t1, $t1, 8
    j validate_height
jump:
    # setting the speed_up (t2) to 7
    # extract jump digit
    la $t5, 2
    div $t9, $t5
    mfhi $t4
    # if its on jump, it cannot jump anymore
    bne $t4, 0, validate_height
    # set starting speed
    la $t2, 7
    # update t9 to jump
    addi $t9, $t9, 1
    j validate_height
sink:
    add $t1, $t1, 768
    j validate_height
# the end of input detection



# the start of calculation and rendering
validate_height:
    # update jump force
    # if not on ground, add gravity acceleration
    # 2644 - 2716
    bgt $t1, 11264, update_y_true
    blt $s2, 3, level2ifs
    j level3ifs
level3ifs:
    bge $t1, 7572, on_platform2_half
    bge $t1, 7444, on_platform1_half
    bge $t1, 7316, on_platform2_half2
    bge $t1, 7188, on_platform1_half2
    j breakpoint
level2ifs:
    bge $t1, 6656, on_platform0_half
breakpoint:
    ble $t1, 3328, on_platform3_half
    j not_on
on_platform0_half:
    bgt $t1, 7152, update_y_true
    j not_on
on_platform2_half:
    bgt $t1, 7644, not_on
    sub $t1, $t1, 256
on_platform2_half2:
    ble $t1, 7388, update_y_true
    j not_on
on_platform1_half:
    bgt $t1, 7516, not_on
    sub $t1, $t1, 256
on_platform1_half2:
    ble $t1, 7260, update_y_true
    j not_on
on_platform3_half:
    la $t0, 256
    div $t1, $t0
    mfhi $t0
    blt $t0, 84, not_on
    bgt $t0, 156, not_on
    j update_y
not_on:
    # DetectPfLevel3 ($t1)
    sub $t2, $t2, 2
    j update_y_true

update_y:
    # bgt $t2, 3, update_y_true
    la $t2, 0

update_y_true:   
    # jump force * line, update y coordinate
    la $t0, 256
    mult $t2, $t0
    mflo $t0
    sub $t1, $t1, $t0
    li $t0, BASE_ADDRESS
    
on_platform:
    # not sinking to the ground, store $t3 as if on ground
    # blt $t1, 11520, above_ground # 11520
    # $t3 = 0 means in air, $t3 = 1 means on ground/platform
    bne $s2, 2, notLv2
    DetectPfLevel2 ($t1)
notLv2:
    bne $s2, 3, notLv3
    DetectPfLevel3 ($t1)
notLv3:
    beq $t3, 0, above_ground

on_ground:
    beq $s2, 2, NoLv2Water
    # ble $t1, 11520, above_ground
NoLv2Water:
    beq $s2, 1, weirdGravityLv1
    sub $t1, $t1, 256
weirdGravityLv1:
    ble $t1, 11520, above_ground
    bne $s2, 1, weirdGravity
    sub $t1, $t1, 256
weirdGravity:
    la $t2, 0 # reset jump force
    # reset $t9 0 if its jumping
    la $t5, 2
    div $t9, $t5
    mfhi $t4
    beq $t4, 0, on_ground
    sub $t9, $t9, 1
    
    j on_ground
above_ground:
    # not overflowing to the sky
    bgez $t1, no_key
    add $t1, $t1, 1024
    la $t2, 0 # reset jump force
    j validate_height


no_key:
    li $t0, BASE_ADDRESS
    # MakeEnemy 40
    
    # add time/frame counter
    add $t9, $t9, 2
    bge $t9, 600, level_success
    
    # detect collision and add health
    BulletCollision $t1 $s4
    BulletCollision $t1 $s5
    BulletCollision $t1 $s6
    # BulletCollision $t1 11300
    li $t0, BASE_ADDRESS
    blt $s1, 10, cooldown
    sub $s0, $s0, 1
    # if failed, return fail screen, end program
    bltz $s0, failed
cooldown:
    beq $s1, 0, readyForDamage
    sub $s1, $s1, 1
readyForDamage:
    
    # temp platform counter calc
    beq $s2, 1, disPfEnd
    add $t3, $zero, 250
    div $t9, $t3
    mfhi $t3
    bge $t3, 170, disPfOff
disPfOn:
    DrawPlatformAt 24 4096
    j disPfEnd
disPfOff:
    DrawTempPlatformAt 24 4096
    bge $t1, 3328, disPfEnd
    la $t0, 256
    div $t1, $t0
    mfhi $t0
    blt $t0, 84, disPfEnd
    bgt $t0, 156, disPfEnd
    add $t1, $t1, 512 # on the plaform, you cannot stand here!
    j disPfEnd

disPfEnd:
    # Draw Character according to damaged or not
    CleanCharacter ($t7)
    li $t0, BASE_ADDRESS
    la $t3, 2
    div $s1, $t3
    mfhi $t3
    beq $t3, 1, characterNormalHurt
    j characterNormal
characterNormal:    
    MakeCharacter ($t1)
    j characterFinished
characterNormalHurt:
    MakeCharacterHurt ($t1)
    j characterFinished
characterFinished:
    MakeEyes
    bne $s2, 2, notLv2pf
    MakeLevel2Pf # renew platforms
notLv2pf:
    bne $s2, 3, notLv3pf
    MakeLevel3Pf
notLv3pf:

    bne $s2, 1, notLv1Bullet
    UpdateNDrawBulletLv1 # update bullet
notLv1Bullet:
    bne $s2, 2, notLv2Bullet
    UpdateDrawBulletLv2 # update bullet
notLv2Bullet:
    bne $s2, 3, notLv3Bullet
    UpdateDrawBulletLv3 # update bullet
notLv3Bullet:
    DrawHealth ($s0) # draw health bar
    DrawProgress ($t9) # draw progress

    li $v0, 32
    li $a0, 100
    syscall
    j main_loop
    
level_success:
    DrawSuccessScreen
    li $v0, 32
    li $a0, 1000
    syscall
    add $t9, $zero, 0
    beq $s2, 3, succeed
    j next_level


failed:
    DrawFailScreen
succeed:
    li $v0, 10 # terminate the program gracefully
    syscall
    
