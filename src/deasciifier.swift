import patterns

let contextSize = 10;

var turkishString = String();
var asciiString   = String();

let upperCaseLetters = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ".characters)

func lowercased(letter : Character) -> Character {
  let s = String(letter); return s.lowercased()[s.startIndex];
}

func uppercased(letter : Character) -> Character {
  let s = String(letter); return s.uppercased()[s.startIndex];
}

var asciifyTable : [Character: Character] = [
  "ç": "c", "Ç": "C",
  "ğ": "g", "Ğ": "G",
  "ö": "o", "Ö": "O",
  "ş": "s", "Ş": "S",
  "ü": "u", "Ü": "U"
]

var lowercaseAsciiTable : [Character: Character] = [
  "ç": "c", "Ç": "c",
  "ğ": "g", "Ğ": "g",
  "ö": "o", "Ö": "o",
  "ı": "i", "İ":  "i",
  "ş": "s", "Ş": "s",
  "ü": "u", "Ü": "u"
]
for ch in upperCaseLetters {
  let lch = lowercased(letter: ch);
  lowercaseAsciiTable[ch] = lch;
  lowercaseAsciiTable[lch] = lch;
}

var uppercaseAsciiTable : [Character: Character] = [
  "ç": "C", "Ç": "C",
  "ğ": "G", "Ğ": "G",
  "ö": "O", "Ö": "O",
  "ı": "I", "İ":  "i",
  "ş": "S", "Ş": "S",
  "ü": "U", "Ü": "U"
]
for ch in upperCaseLetters {
  let lch = lowercased(letter: ch);
  uppercaseAsciiTable[ch] = lch;
  uppercaseAsciiTable[lch] = lch;
}

let toggleAccentTable : [Character: Character] = [
  "c": "ç", "C": "Ç", "g": "ğ", "G": "Ğ", "o": "ö",
  "O": "Ö", "u": "ü", "U": "Ü", "i": "ı", "I": "İ",
  "s": "ş", "S": "Ş",
  "ç": "c", "Ç": "C", "ğ": "g", "Ğ": "G", "ö": "o",
  "Ö": "O", "ü": "u", "Ü": "U", "ı": "i", "İ": "I",
  "ş": "s", "Ş": "S"
]

func toggleAccent(letter : Character) -> Character {
  if let val = toggleAccentTable[letter] { return val; }
  return letter;
}

func setCharAt(s : String, n : Int, c : Character) -> String {
    var string = s
    
    let idx = string.index(string.startIndex, offsetBy: n)
    string.replaceSubrange(idx...idx, with: String(c))
    
    return string
}

func charAt(s : String, i : Int) -> Character {
  let index = s.index(s.startIndex, offsetBy: i); return s[index];
}

func substring(x : Int, y : Int, s : String) -> String {
  let start = s.index(s.startIndex, offsetBy: x);
  let end   = s.index(s.startIndex, offsetBy: y);
  return s[start..<end];
}

func getContext(size : Int, point : Int) -> String {
  let sx = String(repeating: " ", count: 1 + 2 * size);
  var s = setCharAt(s: sx, n: size, c: "X");
  // var s = substring(x: 0, y: size, s: sx)
    // + "X"
    // + substring(x: size+1, y: sx.characters.count, s: sx)

  var (i, space, index) = (size + 1, false, point);
  index += 1;
  var currentChar : Character;

  while (i < s.characters.count &&
  !space && index < asciiString.characters.count) {
    currentChar = charAt(s: turkishString, i: index);
    if let x = lowercaseAsciiTable[currentChar] {
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

  while i >= 0 && index >= 0 {
    currentChar = charAt(s: turkishString, i: index);
    if let x = uppercaseAsciiTable[currentChar] {
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

func matchPattern(dlist : [String: Int], point : Int) -> Bool {
  var rank = dlist.count * 2;
  let str = getContext(size: contextSize, point: point);

  for start in 0...contextSize {
    for end in contextSize+1...str.characters.count {
      let s = substring(x: start, y: end, s: str);
      if let r = dlist[s] { if abs(r) < abs(rank) { rank = r; } }
    }
  }

  return rank > 0;
}

func needsCorrection(c : Character, point : Int) -> Bool {
  let v  = asciifyTable[c]; let tr = v == nil ? c : v!;
  let pl = lookupPattern(letter: lowercased(letter: tr));
  let m  = pl == nil ? false : matchPattern(dlist: pl!, point: point);
  return tr == "I" ? (c == tr ? !m : m) : (c == tr ? m : !m)
}

func deasciify(s : String) -> String {
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

if let input = readLine() {
  print(deasciify(s: input))
}
