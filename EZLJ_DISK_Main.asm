//Zelda Expansion Disk
//By LuigiBlood

//Uses ARM9 bass

//Main Disk Assembly

print "Assembling Custom Zelda Disk Expansion...\n"

if {defined DEV} {
  print "Development Version - "
} else {
  print "Retail Version - "
}

if {defined USA} {
  print "USA Region\n"
} else {
  print "JPN Region\n"
}

arch n64.cpu
endian msb
output "EZLJ_new.ndd", create

include "N64_CPUREGS.asm"

include "EZLJ_DISK_RAM.asm"
include "EZLJ_DISK_Macros.asm"
include "EZLJ_DISK_System.asm"
include "EZLJ_DISK_FileSystem.asm"

//LBA 25
print "- Assemble Main Disk Code...\n"

seek(0x785C8)

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
dw 0x00000000			//28: map_i_static Replacement
dw 0x00000000			//2C: 
dw 0x00000000			//30: 
dw 0x00000000			//34:
dw 0x00000000			//38:
dw 0x00000000			//3C:
dw 0x00000000			//40: 
dw 0x00000000			//44: map_48x85_static Replacement
dw (ddhook_scenedetect_real)	//48: Scene Entry Replacement
dw 0x00000000			//4C:
dw 0x00000000			//50:
dw (ddhook_removecutscene)	//54: Entrance Cutscene Replacement?
dw (ddhook_text_table)		//58: Message Table Replacement Setup
dw 0x00000000			//5C:
dw 0x00000000			//60: staff_message_data_static Load
dw 0x00000000			//64: jpn_message_data_static Load
dw (ddhook_textUSload)		//68: nes_message_data_static Load
dw 0x00000000			//6C: ???
dw 0x00000000			//70: DMA ROM to RAM Hook
dw 0x00000000			//74: ???
dw 0x00000000			//78: Set Cutscene Pointer (Intro Cutscenes)
ddhook_list_end:

//64DD Hook Initialization Code
ddhook_setup: {
	//Arguments:
	//A0=p->Address Table
	//800FEE70 (NTSC 1.0) - Address Table
	//	+0x0 = n64dd_Func_801C7C1C (USEFUL! Disk read function)
	//	+0x50 = osSendMesg
	//	+0x88 = Save Context
	//8011A5D0 (NTSC 1.0) - Save Context
	//	+0x1409 = Language (8011B9D9)
	
	addiu sp,sp,-0x10
	sw ra,4(sp)
	
	//Save Zelda Disk Address Table's Address for later usage
	li a3,(DDHOOK_ADDRTABLE)
	sw a0,0(a3)
	
	//Save Context Change
	n64dd_LoadAddress(a1, {CZLJ_SaveContext})
	ori a2,0,1
	sb a2,0x1409(a1)	//Set the game into English (1)
	
	addiu a2,0,0
	sw a2,0(a1)		//Scene ID = 0
	sw a2,4(a1)		//Adult
	sw a2,8(a1)		//No Cutscene
	nop
	
	//Load text data into RAM (avoid music stop)
	n64dd_DiskLoad(DDHOOK_TEXTDATA, 0x966000, 0x39000)
	
	lw ra,4(sp)
	addiu sp,sp,0x10
	jr ra
	nop
}

//nes_message_data_static Load Hook
ddhook_textUSload: {
	//Arguments:
	//A0=p->Message Context
	//	+0 = Offset
	//	+4 = Size
	//	+DC88 = Destination
	addiu sp,sp,-0x10
	sw ra,4(sp)
	
	lw a2,4(a0) 		//A2 = Size
	lw a1,0(a0)		//A1 = Offset
	li a3,DDHOOK_TEXTDATA	//A3 = DDHOOK_TEXTDATA
	addu a1,a1,a3		//A1 = A3 + Offset
	ori a3,0,0xDC88
	addu a0,a0,a3		//A0 = RAM Dest
	
	//Copy Text Data from RAM to where it wants
	//Avoid hang from loading from disk directly and stop the music
     -; lb a3,0(a1)
	sb a3,0(a0)
	addiu a0,a0,1
	addiu a1,a1,1
	subi a2,a2,1
	bnez a2,-
	
	lw ra,4(sp)
	addiu sp,sp,0x10
	jr ra
	nop
}

//Message Table Replacement Setup Hook
ddhook_text_table: {
	//Arguments:
	//A0=p->p->jpn_message_data_static table
	//A1=p->p->nes_message_data_static table
	//A2=p->p->staff_message_data_static table
	//You can change the pointers.
	addiu sp,sp,-0x10
	sw ra,4(sp)
	
	li a0,DDHOOK_TEXTTABLE
	sw a0,0(a1)		//Change nes_message_data_static pointer
	
	n64dd_DiskLoad(DDHOOK_TEXTTABLE, 0x8004, 0x421C)
	
	lw ra,4(sp)
	addiu sp,sp,0x10
	jr ra
	nop	
}

//Scene Entry Hook
ddhook_scenedetect_real: {
	//Arguments:
	//A0=Scene ID
	//A1=p->Scene Table
	//
	//Return:
	//V0=p->Scene Entry
	
	addiu sp,sp,-0x10
	addiu a3,0,0x14
	multu a0,a3
	mflo a0
	addu v0,a0,a1
	bnez a0,+	//Scene 0 is Deku Tree, so enable the Room Loading Hook ONLY if that scene is being loaded
	nop
	li a0,ddhook_list_start	
	li a1,ddhook_roomload
	sw a1,8(a0)
	
	li v0, ddhook_sceneentry_data
	nop
	
	b ++
	nop
     +; li a0,ddhook_list_start
	sw 0,8(a0)
	
     +; addiu sp,sp,0x10
	jr ra
	nop
}

//Room Loading Hook
ddhook_roomload: {
	//Arguments:
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
	lw a3,0x4(a2)		//RoomEnd
	lw a1,0x0(a2)		//RoomStart (A1=VROM Address)
	subu a2,a3,a1		//A2=Size
	
	lw a3,0x14(sp)
	sw a1,0x38(a3)		//Store VROM Address
	sw a0,0x3C(a3)		//Store RAM Address
	sw a2,0x40(a3)		//Store Size 
	
	n64dd_LoadAddress(a3, 0)
	jalr a3			//read from disk
	nop
	
	lw a0,0x14(sp)
	addiu a0,a0,0x50
	lw a0,0(a0)		//OsMesgQueue pointer (osSendMesg A0)
	li a1,0			//OSMesg (osSendMesg A1)
	li a2,0			//DON'T BLOCK until response
	
	n64dd_LoadAddress(a3, {CZLJ_osSendMesg})
	jalr a3			//osSendMesg, to let the engine know that the data is loaded and continue the game
	nop
	
	lw ra,0x10(sp)
	addiu sp,sp,0x20
	jr ra
	nop
}

//Remove Intro Cutscene (avoid softlock)
ddhook_removecutscene: {
	//Arguments:
	//A0=p->Global Context
	//
	//Return:
	//V0=Is Loaded?
	addiu v0,0,1
	jr ra
	nop
}

//Scene Entries
ddhook_sceneentry_data: {
	n64dd_SceneEntry("TEST SCENE", 0x02000000, 0x02000390, 0x00000000, 0x00000000, 0x01, 0x13, 0x02)
}

ddhook_end:

if (origin() >= 0x79628) {
  error "\n\nFATAL ERROR: MAIN DISK CODE IS TOO LARGE.\nPlease reduce it and load the rest during 64DD Hook Initialization Code.\n"
}

//Initial loading from OoT File Start
seek(0x79628)
dw (ddhook_start - ddhook_start)	//Source Start
dw (ddhook_end - ddhook_start)		//Source End
dw (ddhook_start)			//Dest Start
dw (ddhook_end)				//Dest End
dw (ddhook_list_start)			//Hook Table Address

print "- Done!\n"
