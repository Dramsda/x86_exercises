.686
.model flat
public _podciag

.data 
licznik dd ?
licznikMaks dd ?	;	maksymalna dlugosc podciagu
wskMaks dd ?		;	wskaznik na maksymalny podciag

.code

_podciag PROC
	push ebp ; zapisanie zawartoœci EBP na stosie
	mov ebp, esp ; kopiowanie zawartoœci ESP do EBP

	mov esi, [ebp+8]	; wskaznik do t1
	mov edi, [ebp+12]	; wskaznik do t2

	mov eax,0 ; indeks do t1
	mov ebx,0 ; indeks do t2
	mov licznikMaks, 0

ptl1:
	mov licznik,0
	push eax
	push ebx

ptl2:
	cmp [esi+eax],dword ptr 0
	je znakiNiezgodne
	cmp [edi+ebx],dword ptr 0
	je znakiNiezgodne
	mov edx,[esi+eax]
	cmp edx,[edi+ebx]
	jne znakiNiezgodne

	inc licznik
	add eax,4
	add ebx,4
	jmp ptl2
znakiNiezgodne:
	pop ebx				; przywrocenie wskaznika na poczatek stringu
	pop eax
	mov ecx,licznik
	cmp licznikMaks, ecx
	ja nieAktualizuj

	mov licznikMaks,ecx
	mov wskMaks,esi
	add wskMaks,eax

nieAktualizuj:
	add ebx,4
	cmp [edi+ebx], dword ptr 0
	jne ptl1

	mov ebx,0
	add eax,4
	cmp [esi+eax], dword ptr 0
	jne ptl1
	
koniec:

	mov eax,wskMaks
	pop ebp
	ret

_podciag ENDP
END

