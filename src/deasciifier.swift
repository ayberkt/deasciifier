import patterns

var turkishString = String();
var asciiString = String();

let asciiRepresentations : [Character: Character] = [
  "ç": "c",
  "Ç": "C",
  "ğ": "g",
  "Ğ": "G",
  "ö": "o",
  "Ö": "O",
  "ş": "s",
  "Ş": "S",
  "ü": "U",
  "Ü": "U"
]

let originalRepresentations : [Character: Character] = [
  "c": "ç", "C": "Ç",
  "g": "ğ", "G": "Ğ",
  "o": "ö", "O": "Ö",
  "i": "ı", "I": "İ",
  "s": "ş", "S": "Ş"
]

let upperCaseLetters = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ".characters)

let toggleAccentTable : [Character: Character] = [
  "c": "ç", "C": "Ç", "g": "ğ", "G": "Ğ", "o": "ö",
  "O": "Ö", "u": "ü", "U": "Ü", "i": "ı", "I": "İ",
  "s": "ş", "S": "Ş",
  "ç": "c", "Ç": "C", "ğ": "g", "Ğ": "G", "ö": "o",
  "Ö": "O", "ü": "u", "Ü": "U", "ı": "i", "İ": "I",
  "ş": "s", "Ş": "S"
]

enum AsciifyLetterMode { case regular, lowercase, uppercase }

func lowercased(letter : Character) -> Character {
  let s = String(letter); return s.lowercased()[s.startIndex];
}

func uppercased(letter : Character) -> Character {
  let s = String(letter);
  return s.uppercased()[s.startIndex];
}

func asciify(letter : Character, mode : AsciifyLetterMode)
            -> Character? {
  print("asciify: letter: \(letter), mode: \(mode)")
  if let r = asciiRepresentations[letter] {
    switch (mode) {
      case .regular:   return r;
      case .lowercase: return lowercased(letter: r);
      case .uppercase: return uppercased(letter: r);
    }
  }
  return nil;
}

func toggleAccent(letter : Character) -> Character {
  if let val = toggleAccentTable[letter] { return val; }
  return letter;
}

func setCharAt(s : String, n : Int, c : Character) -> String {
  print("setCharAt (before): s: \(s), n: \(n), c: \(c)")
  var modifiedString = String()
  for (i, char) in s.characters.enumerated() {
      modifiedString += String((i == n) ? c : char)
  }
  print("setCharAt (after): s: \(s), n: \(n), c: \(c)")
  return modifiedString
}
assert(setCharAt(s: "ayberk", n: 0, c: "b") == "byberk")
assert(setCharAt(s: "ayberk", n: 1, c: "b") == "abberk")

func charAt(s : String, i : Int) -> Character {
  print("charAt: s: \(s), i: \(i)")
  let index = s.index(s.startIndex, offsetBy: i);
  print("HELLO")
  return s[index];
}

func substring(x : Int, y : Int, s : String) -> String {
  print("substring: x: \(x), y: \(y), s: \(s), len: \(s.characters.count)")
  let start = s.index(s.startIndex, offsetBy: x);
  let end   = s.index(s.startIndex, offsetBy: y);
  return s[start..<end];
}
assert(substring(x: 0, y: 3, s: "ayberk") == "ayb")
assert(substring(x: 0, y: 0, s: "ayberk") == "")
assert(substring(x: 0, y: 1, s: "ayberk") == "a")

func getContext(size : Int, point : Int) -> String {
  print("getContext: size: \(size), point: \(point)")
  var s = String(repeating: " ", count: 1 + 2 * size);
  // s = setCharAt(s: s, n: size, c: "X");
  s = substring(x: 0, y: size, s: s)
    + "X"
    + substring(x: size+1, y: s.characters.count, s: s)

  var (i, space, index) = (size + 1, false, point);
  index += 1;
  var currentChar : Character;

  while (i < s.characters.count &&
  !space && index < asciiString.characters.count) {
    print("getContext: turkishString: \(turkishString), i: \(i)")
    currentChar = charAt(s: turkishString, i: index);
    if let x = asciify(letter: currentChar, mode: .lowercase) {
      s = setCharAt(s: s, n: i, c: x);
      i += 1;
      space = false;
    } else {
      if !space { i += 1; space = true; }
    }
    index += 1;
  }
  s = substring(x: 0, y: i, s: s);

  index = point;
  i = size - 1;
  space = false;
  index -= 1;

  print("turkishString: \(turkishString)");
  while i >= 0 && index >= 0 {
    currentChar = charAt(s: turkishString, i: index);
    if let x = asciify(letter: currentChar, mode: .uppercase) {
      s = setCharAt(s: s, n: i, c: x);
      i -= 1;
      space = false;
    } else {
      if !space { i -= 1; space = true; }
    }
    index -= 1;
  }
  return s;
}

let contextSize = 10;

func matchPattern(dlist : [String: Int], point : Int) -> Bool {
  print("matchPattern: dlist: <dlist>, point: \(point)")
  var rank = dlist.count * 2;
  print("turkishString: \(turkishString)");
  let str = getContext(size: contextSize, point: point);
  print("str: \(str)")
  var (start, end, _len) = (0, 0, str.characters.count);

  while start <= contextSize {
    end = contextSize + 1;
    while end <= _len {
      let s = substring(x: start, y: end, s: str);
      if let r = dlist[s] { if abs(r) < abs(rank) { rank = r; } }
      end += 1;
    }
    start += 1;
  }
  return rank > 0;
}

func needsCorrection(c : Character, point : Int) -> Bool {
  print("needsCorrection: c: \(c), point: \(point)")
  let ch = c;
  var tr : Character;
  if let v = asciify(letter: c, mode: .regular)
    { tr = v; }
  else
    { tr = ch; }

  var m = false;
  if let pl = lookupPattern(letter: lowercased(letter: tr)) {
    m = matchPattern(dlist: pl, point: point)
  }

  return tr == "I" ? (ch == tr ? !m : m) : (ch == tr ? m : !m)
  // if (tr == "I") { return ch == tr ? !m : m }
  // return ch == tr ? m : !m;
}

func deasciify(s : String) -> String {
  print("deasciify: \(s)")
  asciiString = s;
  turkishString = s;
  for (i, c) in s.characters.enumerated() {
    if needsCorrection(c: charAt(s: s, i: i), point: i) {
      turkishString =
        setCharAt(s: turkishString, n: i, c: toggleAccent(letter: c))
    } else {
      turkishString = setCharAt(s: turkishString, n: i, c: c)
    }
  }
  return turkishString
}

print(deasciify(s: "opusmeyi"))
