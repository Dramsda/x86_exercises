;Podprogram dodaj_dwa - zwiêksza argument funkcji o 2 i zwraca go jako rezultat
;Podprogram w asemblerze 32-bitowym przystosowany do wywo³ywania z poziomu jêzyka C

.686
.model flat
public _dodaj_dwa
.data
.code

_dodaj_dwa PROC
	push ebp
	mov ebp, esp
	sub esp,24 ; zmienne - 3 liczby double
	push esi
	push edi
	push ebx
		
	;[ebp-24]	pierwsza liczba (mniejszy operand)
	;[ebp-16]   druga liczba (wiekszy operand)
	;[ebp-8]    trzecia liczba (wynik)

	;wpisz pierwsza liczbe 2.0
	mov [ebp-24], dword ptr 0h
	mov [ebp-20], dword ptr 40180000h

	;wpisz druga liczbe
	mov eax,[ebp+8]
	mov [ebp-16],eax
	mov eax,[ebp+12]
	mov [ebp-12],eax

	;obliczam roznice wykladnikow i wpisuje do EAX (moze byc ujemna)
	mov eax,[ebp-20]
	mov ebx,[ebp-12]
	shr eax,20
	shr ebx,20
	sub eax,ebx

	;sprawdzam, czy roznica ujemna
	test eax, eax
	js ujemna
	;mniejsza liczba w [ebp-16]
	;esi adres mniejszej liczby, edi wiekszej
	lea esi, [ebp-16]
	lea edi, [ebp-24]
	jmp dalej1
ujemna:
	lea esi, [ebp-24]
	lea edi, [ebp-16]
	neg eax
dalej1:
	;eax- roznica wykladnikow, juz dodatnia

	;w ecx:ebx zwraca mantyse z ukryta jedynka z pamieci [ESI]
	mov edx,esi
	call daj_wykladnik

	;przesuwam mantyse ECX:EBX w prawo o roznice wykladnikow (EAX)

przesun:
	test eax,eax
	jz koniec_przesuwania
	shr ecx,1
	rcr ebx,1
	dec eax
	jmp przesun
koniec_przesuwania:

	push ecx
	push ebx

	mov edx,edi
	call daj_wykladnik

	;dodaje do poprzednio obliczonej/przesunietej mantysy
	pop eax
	add ebx,eax

	pop eax
	adc ecx,eax

	;w ecx:ebx suma dwoch mantys
	;do eax wpisuje nowy wykladnik (z wiekszej liczby)

	mov eax,[edi+4]
	shr eax,20

	;sprawdzenie czy nowa mantysa nie wymaga znormalizowania
	bt ecx,21
	jnc mantysa_dobra
	;dziele nowa mantyse przez dwa i dodaje jeden do wykladnika
	shr ecx,1
	rcr ebx,1
	inc eax
mantysa_dobra:
	;usuniecie niejawnego bitu 1 w mantysie
	btr ecx,20

	;przesuniecie wykladnika o 20 bitow w lewo, zeby polaczyc go z mantysa
	shl eax,20
	;dodaje wykladnik
	or ecx,eax

	mov [ebp-8],ebx
	mov [ebp-4],ecx

	fld qword ptr [ebp-8]
	pop esi
	pop edi
	pop edi
	add esp,24
	pop ebp
	ret
_dodaj_dwa ENDP

;zwraca mantyse w ECX:EBX dla liczby w pamieci wskazywanej w edx
;dodaje ukryta jedynke
daj_wykladnik:
	mov ebx,[edx]
	mov ecx,[edx+4]

	;zeruje wykladnik
	and ecx,0FFFFFh
	;ustawia niejawna jedynke
	bts ecx,20
	ret	

END
