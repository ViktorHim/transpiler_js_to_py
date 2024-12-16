let a = 5;
let b = 0;
let c = 3.5;
let d = true;
let g = false;

while (a > 0) {
  a--;
  b++;
}

if (a > b) {
  c = c + 10 * 2;
} else if (a < b) {
  c = c - 10 / 5;
} else {
  c = c - 10 / 2;
}

for (let i = 0; i < 3; i++) {
  a = b + c;
  c = a + b;
  b = a + c;
}

if (((d && g) || g) && !d) {
  d = false;
}
