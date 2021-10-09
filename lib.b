/*
Documentation adapted from [Users' Reference to
B](https://9p.io/cm/cs/who/dmr/kbman.html).
*/

/*
Returns the `i`th character of `string`.
*/
char(string, i) {
	return ((string[i / 4] >> 8 * (i % 4)) & 0377); /* string[i / 4] */
}

/*
Stores `character` in the `i`th position of `string`.
*/
lchar(string, i, character) {
	auto x;
	x = 8 * (i % 4);
	character = (character & 0377) << x;
	x = inv(0377 << x);
	string[(i / 4) * 4] = string[i / 4] & x | character;
}

/*
Writes `character` to the standard output file. Returns `character`.
*/
putchar(character) {
	auto c, i;

	c = character;
	i = 4;
	while ((c & 0377) != '*e' & (c & 0377) != '*0' & i != 0) {
		i--;
		c =>> 8;
	}
	write(1, &character, 4 - i);
	return (character);
}

/*
Returns the next character from the standard input file. Returns '*e' when the
end of the file is reached.
*/
getchar() {
	auto c;
	c = 0;
	read(1, &c, 1);
	return (c);
}

/*
Prints `number` to the standard output file, represented in `base` (where 2 <=
`base` <= 16).
*/
printn(number, base) {
	auto a;
	if (a = number / base) {
		printn(a, base);
	}
	putchar(char("0123456789ABCDEF", number % base));
}

/*
Prints `number` (represented in base 10) to the standard output file, and a
newline.
*/
putnumb(number) {
	printn(number, 10);
	putchar('*n');
}

/*
Prints `string` to the standard output file.
*/
putstr(string) {
	auto c, i;
	i = 0;
	while ((c = char(string, i++)) != '*e') {
		putchar(c);
	}
}

/*
Reads 1 line of characters from the standard input, and writes it into `string`.
Returns `string`.

Note that it is impossible to guarantee that `string` will always point to
enough storage to store all of the input, so this function is unsafe.
*/
getstr(string) {
	auto c, i;
	while ((c = getchar()) != '*n') {
		putchar(c);
		lchar(string, i++, c);
	}
	lchar(string, i, '*e');
	return (string);
}

/*
Prints the given string `format` to the standard output file, but with certain
format specifiers replaced with representations of the positional arguments.

The available format specifiers are:

  %d  Print the argument as a decimal number.
	%o  Print the argument as an octal number.
	%x  Print the argument as a hexadecimal number.
	%c  Print the argument as a character.
	%s  Print the argument as a string.
*/
printf(format, x1, x2, x3, x4, x5, x6, x7, x8, x9) {
	auto adx, x, c, i, j;

	i = 0;
	adx = &x1;
loop:
	while ((c = char(format, i++)) != '%') {
		if (c == '*e') {
			return;
		}
		putchar(c);
	}
	x = *adx++;
	switch (c = char(format, i++)) {
	case 'd':
	case 'o':
		if (x < 0) {
			x = -x;
			putchar('-');
		}
		printn(x, c == 'o' ? 8 : 10);
		goto loop;
	case 'x':
		if (x < 0) {
			x = -x;
			putchar('-');
		}
		printn(x, 16);
		goto loop;
	case 'c':
		putchar(x);
		goto loop;
	case 's':
		j = 0;
		while ((c = char(x, j++)) != '*e') {
			putchar(c);
		}
		goto loop;
	}
	putchar('%');
	i--;
	adx--;
	goto loop;
}
