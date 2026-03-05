;Podprogram wczytuje ³añcuch w formacie szesnastkowym, a
;nastêpnie wyœwietla na ekranie liczbê podanym formacie
;format liczby wejsciowej - 32-bitowa liczba mieszana w kodzie U2, najmniej znacz¹cy bit ma wagê 2-8

;edycja programu dodanie 2 liczb - zadanie dodatkowe
.686
.model flat
public _wczytaj_wyswietl
extern __read : PROC
extern __write : PROC
.data
buf db 128 dup(0)
.code
iloscPoPrzecinku equ 8

; zapisuje do bufora jako ciag znakow ascii liczbe calkowita z rejestru EAX
; parametry:
;ebx- minimalna ilsoc znakow w liczbie, jezeli liczba ma mniej nzakow to z przodu sa zera
;eax- liczba do skonwertowania
;edi- wsk na bufor gdzie ma zapisana byc liczba
zapisz_liczbe_bufor PROC
	push ebp
	mov ebp, esp
	push ebx
	push esi

	xor ecx, ecx; ecx licznik wpisanej liczby
ptl1:
	xor edx, edx ; zerowanie do dzielenia
	mov esi,10
	div esi
	add dl, '0'
	push edx
	inc ecx
	dec ebx
	cmp eax, 0
	jne ptl1

	cmp ebx, 0
	jg ptl1

ptl2:
	pop edx
	mov [edi],dl
	dec ebx
	inc edi
loop ptl2
	pop esi
	pop ebx
	pop ebp
	ret
zapisz_liczbe_bufor ENDP


; w eax jest liczba do wyswietlenia
wyswietl PROC
	push ebp
	mov ebp, esp
	sub esp, 20 ;miejse na liczbe do wypisania
	push esi
	push edi
	lea edi, [ebp-20]; wsk na poczatek bufora wyjsciowego

	;sprawdzenie znaku liczby i wpisanie do b_wyjsciowego, jesli ujemna neguje liczbe
	bt  eax,31
	jc ujemna
	mov [edi], byte ptr '+'
	jmp dalej
ujemna:
	mov [edi], byte ptr '-'
	neg eax
dalej:
	push eax ; przechowuje liczbe na stosie, zeby pozniej wyswietlic czesc ulamkowa
	inc edi

	mov ebx, 1 ; param, mowi ile min znakow ma miec liczba(chodzi o zeraz znaczace)
	shr eax, iloscPoPrzecinku ; uzyskuje liczbe calkowita
	call zapisz_liczbe_bufor

	mov [edi], byte ptr '.'
	inc edi

	pop eax
	mov ecx, iloscPoPrzecinku
	xor ebx, ebx
ptlMAska:
	stc
	rcl ebx,1
	loop ptlMaska

	and eax, ebx ; usuniecie czesci calkowitej

	;w eax czesc ulamkowa od 0-1
	;*100 czesc calkowita od 0-100
	;/2^iloscPoPrzecinku usuwanie czesci ulamkowej,interesuje nas tylko czesc calkowita
	mov ebx, 100
	mul ebx
	shr eax,iloscPoPrzecinku ; tu 8 bitow bo interesuje mnie czesc calkowita tylko

	mov ebx, 2; 2 bo w czesci ulamkowej musza byc 2 znaki
	call zapisz_liczbe_bufor
	mov [edi],byte ptr 0

	lea edx, [ebp-20] ; adres poczatku bufora

	mov eax, edi
	sub eax, edx
	push eax ; dlugosc ciagu znakow do wyseiwtlenia
	push edx ; pocztek bufora
	push 1 ; stdout
	call __write
	add esp,12

	add esp,20
	pop edi
	pop esi
	pop ebp
	ret
wyswietl ENDP

;na wejsciu w bl znak ascii hex
;na wyjsciu w bl liczba 0-15
ascii_do_hex:
	cmp bl, '9'
	ja literka
	sub bl, '0'
	jmp koniec_a2h
literka:
	cmp bl, 'F'
	ja mala_literka
	add bl, 10 - 'A'
	jmp koniec_a2h
mala_literka:
	add bl, 10 - 'a'
koniec_a2h:
	ret

;zwraca liczbe w rejestrze EAX
dekoduj_znaki_hex PROC
	push ebp
	mov ebp, esp
	push esi
	push ebx

	mov esi, offset buf
	xor eax, eax
ptl1:
	mov bl,byte ptr [esi]
	cmp bl, 0Ah 
	je koniec
	call ascii_do_hex
	shl eax,4
	add al,bl ; To jest ok ( nie przepelni sie), bo bl jest zero
	inc esi
	jmp ptl1
koniec:
	pop ebx
	pop esi
	pop ebp
	ret
dekoduj_znaki_hex ENDP

wczytaj_znaki PROC
	push ebp
	mov ebp, esp

	push 128
    push OFFSET buf
    push 0
    call __read
    add  esp, 12
	pop ebp
	ret
wczytaj_znaki ENDP

_wczytaj_wyswietl PROC
	push ebp
	mov ebp, esp
	push esi
	push edi
	push ebx

	call wczytaj_znaki

	call dekoduj_znaki_hex

	;mov ebx, eax
	;edycja dodanie 2 liczb
	;call wczytaj_znaki
	;call dekoduj_znaki_hex
	;add eax, ebx

	;mov eax,7fffff80h
	;mov eax,0fffffE00h
	call wyswietl



	pop ebx
	pop edi
	pop esi
	pop ebp
	ret
_wczytaj_wyswietl ENDP


END

