%include "./src/io.mac"

.DATA
	msgRow db "Enter the number of rows : ",0
	msgCol db "Enter the number of cols : ",0
	msgMat1 db "Matrix 1 : ",0xA,0xD,0
	msgMat2 db "Matrix 2 : ",0xA,0xD,0
	msgEle db "Enter the elements : ",0xA,0xD,0
	msgWrong db "Wrong size of matrices",0xA,0xD,"Columns in 1st should be equal to Rows in 2nd",0
	space db " ",0
	answer db "Resultant Matrix : ",0xA,0xD,0
	com db ",",0

.UDATA
	n resw 1
	m resw 1
	p resw 1
	q resw 1
	matA resw 100
	sizeA resw 1
	matB resw 100
	sizeB resw 1
	matC resw 100

.CODE
	.STARTUP

	PutStr msgMat1 
	PutStr msgRow
	GetInt [n]
	PutStr msgCol
	GetInt [m]
	mov eax,[n]
	imul eax,[m]
	mov [sizeA],eax

	push word[sizeA]
	push matA
	call readMatrix 

	PutStr msgMat2
	PutStr msgRow
	GetInt [p]
	PutStr msgCol
	GetInt [q]
	mov eax,[p]
	imul eax,[q]
	mov [sizeB],eax

	push word[sizeB]
	push matB
	call readMatrix 

	mov ax,word[m]
	mov bx,word[p]
	cmp ax,bx
	jne wrong

	PutStr msgMat1
	push word[m]
	push word[n]
	push matA
	call printMatrix

	PutStr msgMat2
	push word[q]
	push word[p]
	push matB
	call printMatrix


	push word[q]
	push word[m]
	push word[n]
	push matA
	push matB
	push matC	
	call mulMatrix

	PutStr answer
	push word[q]
	push word[n]
	push matC
	call printMatrix

	jmp done

wrong:
	PutStr msgWrong
	nwln

done:
	.EXIT

readMatrix:
	enter 0,0
	;ebp+8 : address of mat,+12 : size of matrix

	PutStr msgEle
	xor ax,ax
	mov ebx,[ebp+8]
	readLoop:
		GetInt cx
		mov [ebx],cx
		add ebx,2
		inc ax
		cmp ax,[ebp+12]
	jne readLoop
	readLoop_end:
		leave
		ret 6

printMatrix:
	enter 0,0
	;ebp+8 : address of mat,+12 : number of rows
	;ebp+14 : number of cols

	xor bx,bx
	mov ecx,[ebp+8]
	printLoop:
		xor ax,ax
		printRow:
			PutInt word[ecx]
			PutStr space
			add ecx,2
			inc ax
			cmp ax,[ebp+14]
		jne printRow
		nwln
		inc bx
		cmp bx,[ebp+12]
	jne printLoop
	printLoop_end:
		leave
		ret 8

mulMatrix:
	enter 0,0
	;+8: address of c,+12: address of b
	;+16: address of a,+20:	rows in 1
	;+22: cols/rows in 1/2,+24: cols in 2
	;+26: size of a,+28: size of b

segment .data
	i dw 0
	j dw 0
	k dw 0
	sum dw 0
	ind1 dd 0
	ind2 dd 0

segment .text
	
	mov eax,[ebp+16]
	mov ebx,[ebp+12]
	mov ecx,[ebp+8]
	mulLoop:
		xor dx,dx
		mov word[j],dx
		
		mulLoopRow:
			xor dx,dx
			mov word[k],dx
			mov word[sum],dx
			mulLoopAdd:
				mov dx,word[i]
				imul dx,[ebp+22]
				add dx,word[k]
				mov [ind1],dx

				mov dx,word[k]
				imul dx,[ebp+24]
				add dx,word[j]
				mov [ind2],dx

				add eax,[ind1]
				add eax,[ind1]
				add ebx,[ind2]
				add ebx,[ind2]

				mov dx,[eax]
				imul dx,[ebx]
				add [sum],dx

				sub eax,[ind1]
				sub ebx,[ind2]
				sub eax,[ind1]
				sub ebx,[ind2]

				inc word[k]
				mov dx,word[k]
				cmp dx,[ebp+22]
			jne mulLoopAdd

			mov dx,word[sum]
			mov word[ecx],dx
			add ecx,2
			inc word[j]
			mov dx,word[j]
			cmp dx,[ebp+24]
		jne mulLoopRow
		inc word[i]
		mov dx,word[i]
		cmp dx,[ebp+20]
	jne mulLoop
	mulLoop_end:
		leave
		ret 18