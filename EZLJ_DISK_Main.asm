//Zelda Expansion Disk
//By LuigiBlood

//Uses ARM9 bass

arch n64.cpu
endian msb
output "EZLJ_new.ndd", create

include "N64_CPUREGS.asm"

macro seek(n) {
  origin {n}
}

//FILL
seek(0x0)
fill 0x3DEC800

//System Area
seek(0x0)
//System Data
define x(0)
while {x} < 14 {
  define y(0)
  while {y} < 86 { //232 * 85
  
    dw 0xE848D316	//Disk Region
    db 0x10
    db 0x11		//Disk Type
    dh 0x0001		//Boot Blocks Load
    db 0x0C, 0x18, 0x24, 0x30, 0x3C, 0x48, 0x54, 0x60, 0x6C, 0x78, 0x84, 0x90, 0x9C, 0xA8, 0xB4, 0xC0
    dw 0xFFFFFFFF
    dw 0x80000400
    db 0x10, 0x16, 0x1C, 0x22, 0x28, 0x2E, 0x34, 0x36, 0x37, 0x40, 0x46, 0x4C
    db 0x04, 0x0C, 0x14, 0x1C, 0x24, 0x2C, 0x34, 0x3C, 0x44, 0x4C, 0x54, 0x5C
    db 0x04, 0x0C, 0x14, 0x1C, 0x24, 0x2C, 0x34, 0x3C, 0x44, 0x4C, 0x54, 0x5C
    db 0x04, 0x0C, 0x14, 0x1C, 0x24, 0x2C, 0x34, 0x3C, 0x44, 0x4C, 0x54, 0x73
    db 0x04, 0x0C, 0x14, 0x1C, 0x24, 0x2C, 0x34, 0x3C, 0x44, 0x4C, 0x54, 0x5C
    db 0x04, 0x0C, 0x14, 0x1C, 0x24, 0x2C, 0x34, 0x3C, 0x44, 0x4C, 0x54, 0x5C
    db 0x04, 0x0C, 0x14, 0x1C, 0x24, 0x2C, 0x34, 0x3C, 0x44, 0x4C, 0x54, 0x92
    db 0x04, 0x0C, 0x14, 0x1C, 0x24, 0x2C, 0x34, 0x3C, 0x44, 0x4C, 0x54, 0x6F
    db 0x56, 0x5C, 0x62, 0x68, 0x6E, 0x74, 0x7A, 0x7F, 0x86, 0x8C, 0x92, 0x98
    db 0x04, 0x0C, 0x14, 0x1C, 0x24, 0x2C, 0x34, 0x3C, 0x44, 0x4C, 0x54, 0x88
    db 0x04, 0x0C, 0x14, 0x1C, 0x24, 0x2C, 0x34, 0x3C, 0x44, 0x4C, 0x54, 0x5C
    db 0x04, 0x0C, 0x14, 0x1C, 0x24, 0x2C, 0x34, 0x3C, 0x44, 0x4C, 0x54, 0x5C
    db 0x04, 0x0C, 0x14, 0x1C, 0x24, 0x2C, 0x34, 0x3C, 0x44, 0x4C, 0x54, 0x5C
    db 0x04, 0x0C, 0x14, 0x1C, 0x24, 0x2C, 0x34, 0x3C, 0x44, 0x4C, 0x54, 0x69
    db 0x04, 0x0C, 0x14, 0x1C, 0x24, 0x2C, 0x34, 0x3C, 0x44, 0x4C, 0x54, 0x93
    db 0x04, 0x0C, 0x14, 0x1C, 0x24, 0x2C, 0x34, 0x3C, 0x44, 0x4C, 0x54, 0x5C
    dh 0x061E, 0x07AE, 0x10C3, 0xFFFF
    
    evaluate y({y} + 1)
  }
  evaluate x({x} + 1)
}

//Disk ID
define x(14)
while {x} < 24 {
  define y(0)
  while {y} < 86 { //232 * 85
  
    db "EZLJ"	//Game ID code
    db 0	//Version 0
    db 0	//Disk Number 0
    db 0	//Does not use MFS
    db 0	//Disk Use
    db "URAZELDA"
    db "ITISREAL"
    db "01"
    db "WOAHHH"
    
    fill 200
    
    evaluate y({y} + 1)
  }
  evaluate x({x} + 1)
}

//LBA 25
seek(0x785C8)

constant DDHOOK_RAM(0x80410000)
constant DDHOOK_GPRAM(0x80400000)
constant DDHOOK_NESTEST(0x80440000)

base DDHOOK_RAM

ddhook_start:
db "URAZELDA"
ddhook_list_start:
dw (ddhook_setup)		//00: 64DD Hook
dw 0x00000000			//04: 64DD Unhook
dw 0x00000000			//08: Room Loading Hook
dw 0x00000000			//0C: Scene Loading (???)
dw 0x00000000			//10: "game_play" game state entrypoint
dw 0x00000000			//14: Collision related
dw 0x00000000			//18: ???
dw 0x00000000			//1C: 
dw 0x00000000			//20: 
dw 0x00000000			//24: 
dw 0x00000000			//28: map_grand_static & map_i_static Hook
dw 0x00000000			//2C: 
dw 0x00000000			//30: 
dw 0x00000000			//34: (Unused)
dw 0x00000000			//38: (Unused)
dw 0x00000000			//3C: ???
dw 0x00000000			//40: 
dw 0x00000000			//44: (Unused)
dw (ddhook_scenedetect_real)	//48: Scene Entry Hook
dw 0x00000000			//4C: (Unused)
dw 0x00000000			//50: (Unused)
dw 0x00000000			//54: "game_play" game state entrypoint (Cutscenes?)
dw (ddhook_text_table)		//58: Message Table Replacement Setup Hook
dw 0x00000000			//5C: (Unused)
dw 0x00000000			//60: staff_message_data_static Load Hook
dw 0x00000000			//64: jpn_message_data_static Load Hook
dw (ddhook_textUSload)		//68: nes_message_data_static Load Hook
dw 0x00000000			//6C: ???
dw 0x00000000			//70: DMA ROM to RAM Hook
dw 0x00000000			//74: ???
dw 0x00000000			//78: Set Cutscene Pointer (Intro Cutscenes)
ddhook_list_end:

//64DD Hook Initialization Code
ddhook_setup:
	//A0=p->p->n64dd_Func_801C7C1C (USEFUL! Disk read function)
	//800FEE70 - Address Table
	//	+0x0 = 801C7C1C
	//	+0x50 = osSendMesg
	//	+0x88 = Save Context
	//8011A5D0 - Save Context
	//	+0x1409 = Language (8011B9D9)
	
	//n64dd_Func_801C7C1C(destination, source, size)
	
	addiu sp,sp,-0x10
	sw ra,4(sp)
	
	//Change language to English
	lw a1,0x88(a0)		//Get Save Context Address
	addiu a1,a1,0x1409	//Language Byte
	ori a2,0,1
	sb a2,0(a1)		//Set the game into English (1)
	
	//save pointer to 801C7C1C
	li a3,(DDHOOK_GPRAM)
	lw a2,0x50(a0)		//Store osSendMesg callback address
	sw a2,4(a3)
	lw a0,0(a0)		//Store n64dd_Func_801C7C1C callback address (Disk Load function)
	sw a0,0(a3)
	
	or a3,0,a0
	
	//Load text data into RAM (avoid music stop)
	li a1,0x00966000	//A1=00966000 (Offset)
	li a2,0x00039000	//A2=00039000 (Size)
	li a0,DDHOOK_NESTEST	//A0=DDHOOK_NESTEST (Dest)
	jalr a3			//read from disk
				//n64dd_Func_801C7C1C(DDHOOK_NESTEST, 0x966000, 0x39000)
	nop
	
	lw ra,4(sp)
	addiu sp,sp,0x10
	jr ra
	nop

//nes_message_data_static Load Hook
ddhook_textUSload:
	//A0=p->Text Heap
	//	+0 = Offset
	//	+4 = Size
	//	+DC88 = Destination
	addiu sp,sp,-0x10
	sw ra,4(sp)
	
	lw a2,4(a0) 		//A2 = Size
	lw a1,0(a0)		//A1 = Offset
	li a3,DDHOOK_NESTEST	//A3 = DDHOOK_NESTEST
	addu a1,a1,a3		//A1 = A3 + Offset
	ori a3,0,0xDC88
	addu a0,a0,a3		//A0 = RAM Dest
	
	//Copy Text Data from RAM to where it wants
	//Avoid hang from loading from disk directly and stop the music
ddhook_textUSloop:
	lb a3,0(a1)
	sb a3,0(a0)
	addiu a0,a0,1
	addiu a1,a1,1
	subi a2,a2,1
	bnez a2,ddhook_textUSloop
	
	lw ra,4(sp)
	addiu sp,sp,0x10
	jr ra
	nop

//Message Table Replacement Setup Hook
constant DDHOOK_MESSAGETABLENES(0x80420000)
ddhook_text_table:
	//A0=p->p->jpn_message_data_static table
	//A1=p->p->nes_message_data_static table
	//A2=p->p->staff_message_data_static table
	//You can change the pointers.
	addiu sp,sp,-0x10
	sw ra,4(sp)
	
	li a0,DDHOOK_MESSAGETABLENES
	sw a0,0(a1)		//Change nes_message_data_static pointer (A0 = Destination)
	li a1,0x00008004	//A1=Source
	li a2,0x421C		//A2=Size
	
	li a3,(DDHOOK_GPRAM)
	lw a3,0(a3)
	jalr a3			//read from disk
	nop
	
	lw ra,4(sp)
	addiu sp,sp,0x10
	jr ra
	nop	

//Scene Entry Hook
ddhook_scenedetect_real:
	//A0=Scene ID
	//A1=p->Scene Table
	addiu sp,sp,-0x10
	addiu a3,0,0x14
	multu a0,a3
	mflo a0
	addu v0,a0,a1
	bnez a0,ddhook_scenedetect_real_notdeku	//Scene 0 is Deku Tree, so enable the Room Loading Hook ONLY if that scene is being loaded
	nop
	li a0,ddhook_list_start	
	li a1,ddhook_roomload
	sw a1,8(a0)
	b ddhook_scenedetect_real_return
	nop
ddhook_scenedetect_real_notdeku:
	li a0,ddhook_list_start
	sw 0,8(a0)
	
ddhook_scenedetect_real_return:
	addiu sp,sp,0x10
	jr ra
	nop

//Room Loading Hook
ddhook_roomload:
	//A0=p->Global Context
	//A1=p->Room Context
	//A2=Room ID
	
	addiu sp,sp,-0x20
	sw ra,0x10(sp) //4
	sw a1,0x14(sp) //8
	
	lw a0,0x0134(a1)	//load Room List Pointer
	sll a3,a2,3		//Room ID * 8
	addu a2,a0,a3		//calculate offset from Room ID
	lw a0,0x34(a1)		//A0=RAM Address
	lw a3,0x8(a2)		//RoomEnd
	lw a1,0x0(a2)		//RoomStart (A1=VROM Address)
	subu a2,a3,a1		//A2=Size
	
	lw a3,0x14(sp)
	sw a1,0x38(a3)		//Store VROM Address
	sw a0,0x3C(a3)		//Store RAM Address
	sw a2,0x40(a3)		//Store Size 
	
	li a3,(DDHOOK_GPRAM)
	lw a3,0(a3)
	jalr a3			//read from disk
	nop
	
	lw a0,0x14(sp)
	addiu a0,a0,0x50
	lw a0,0(a0)		//OsMesgQueue pointer (osSendMesg A0)
	li a1,0			//OSMesg (osSendMesg A1)
	li a2,0			//DON'T BLOCK until response
	
	li a3,(DDHOOK_GPRAM)
	lw a3,4(a3)
	jalr a3			//osSendMesg, to let know to the engine that the data is loaded
	nop
	
	lw ra,0x10(sp)
	addiu sp,sp,0x20
	jr ra
	nop

ddhook_end:

//Initial loading from OoT File Start
seek(0x79628)
dw (ddhook_start - ddhook_start)	//Source Start
dw (ddhook_end - ddhook_start)		//Source End
dw (ddhook_start)			//Dest Start
dw (ddhook_end)				//Dest End
dw (ddhook_list_start)


//Those files are taken from US 1.0 version
seek(0x785C8 + 0x8000)
insert "ezlj_nes_message_table.bin"

seek(0x785C8 + 0x00966000)
insert "ezlj_nes_message_data_static.bin"

//parody message shit
seek(0x9ED325)
db 0x57, 0x6F, 0x77, 0x21, 0x20, 0x41, 0x20, 0x36, 0x34, 0x44, 0x44, 0x21, 0x21, 0x21, 0x04, 0x1A, 0x49, 0x74, 0x27, 0x73, 0x20, 0x61, 0x62, 0x6F, 0x75, 0x74, 0x20, 0x74, 0x69, 0x6D, 0x65, 0x20, 0x79, 0x6F, 0x75, 0x20, 0x75, 0x73, 0x65, 0x64, 0x20, 0x6F, 0x6E, 0x65

seek(0x9ED39E)
db 0x4C, 0x65, 0x74, 0x20, 0x6D, 0x65, 0x20, 0x68, 0x75, 0x6D, 0x70, 0x20, 0x6D, 0x79, 0x20, 0x72, 0x6F, 0x63, 0x6B, 0x20, 0x69, 0x6E, 0x20, 0x70, 0x65, 0x61, 0x63, 0x65, 0x21, 0x01, 0x53, 0x65, 0x72, 0x69, 0x6F, 0x75, 0x73, 0x6C, 0x79, 0x2C, 0x20, 0x6C, 0x6F, 0x73, 0x65, 0x72, 0x2C, 0x20, 0x79, 0x6F, 0x75, 0x27, 0x72, 0x65, 0x20, 0x72, 0x75, 0x69, 0x6E, 0x69, 0x6E, 0x67, 0x20, 0x69, 0x74, 0x21, 0x02

//Those files are taken from PAL Master Quest ROM
seek(0x785C8 + 0x02499000)
//insert "ezlj_ydan_all_ntsc1.0.bin"
insert "ezlj_ydan_scene_palmq.bin"

seek(0x785C8 + 0x01F61000)
insert "ezlj_ydan_rooms_palmq.bin"