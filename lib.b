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

printn(n,b) {
	extrn putchar;
	auto a;

	if (a = n/b)
		printn(a, b);
	putchar(char("0123456789ABCDEF", n%b));
}

putnumb(n) {
	printn(n,10);
	putchar('*n');
}

putstr(s) {
	auto c, i;

	i = 0;
	while ((c = char(s,i++)) != '*e')
		putchar(c);
}

getstr(s) {
	auto c, i;

	while ((c = getchar()) != '*n')
		lchar(s,i++,c);
	lchar(s,i,'*e');
	return (s);
}

printf(fmt, x1,x2,x3,x4,x5,x6,x7,x8,x9) {
	extrn printn, char, putchar;
	auto adx, x, c, i, j;

	i = 0;
	adx = &x1;
loop:
	while((c=char(fmt,i++)) != '%') {
		if(c == '*e')
			return;
		putchar(c);
	}
	x = *adx++;
	switch (c = char(fmt,i++)) {

	case 'd':
	case 'o':
		if(x < 0) {
			x = -x;
			putchar('-');
		}
		printn(x, c=='o'?8:10);
		goto loop;

	case 'x':
		if(x < 0) {
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
		while((c=char(x,j++)) != '*e')
			putchar(c);
		goto loop;
	}
	putchar('%');
	i--;
	adx--;
	goto loop;
}

