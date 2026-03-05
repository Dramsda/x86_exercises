# x86_exercises

Repozytorium zawiera zadania z programowania w asemblerze 32-bitowym (x86).

---

## Struktura repozytorium

```
.
├── dodaj_liczby_zmiennoprzecinek/   # Zadanie 1 – dodaj_dwa (double)
├── liczby_mieszane/                 # Zadanie 2 – wyświetlanie liczb mieszanych U2
└── najdluzszy_podciag/              # Zadanie 3 – najdłuższy wspólny podciąg
```

---

## Zadania

### 1. `dodaj_liczby_zmiennoprzecinek` – Funkcja `dodaj_dwa`

Podprogram w asemblerze 32-bitowym przystosowany do wywołania z poziomu języka C.

**Prototyp funkcji:**

```c
double dodaj_dwa(double);
```

Funkcja zwiększa argument zmiennoprzecinkowy o `2` i zwraca wynik. Funkcja przystosowana do dodawania różnych wartości do liczb, nie tylko 2.

---

### 2. `liczby_mieszane` – Wyświetlanie liczb w formacie U2

Podprogram w asemblerze 32-bitowym wczytujący liczbę w formacie szesnastkowym i wyświetlający ją jako **32-bitową liczbę mieszaną w kodzie U2**, gdzie najmniej znaczący bit ma wagę `2⁻⁸`.

**Prototyp funkcji**

```c
void wczytaj_wyswietl();
```

Wynik wyświetlany jest w postaci dziesiętnej z dokładnością zgodną z wrtością zmiennej **iloscPoPrzecinku**.

---

### 3. `najdluzszy_podciag` – Najdłuższy wspólny podciąg

Funkcja w asemblerze 32-bitowym przystosowana do wywołania z poziomu języka C.

**Prototyp funkcji:**

```c
int *podciag(int *t1, int *t2);
```

Funkcja znajduje i zwraca wskaźnik na **pierwszy najdłuższy wspólny ciąg kolejnych elementów** w dwóch tablicach 32-bitowych liczb całkowitych.

**Zasady:**

- Tablice zakończone są elementem `0` (nie wliczanym do ciągu)
- Jeśli brak wspólnego podciągu dłuższego niż 1 element – zwracane jest `0`

---
