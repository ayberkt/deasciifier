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

func asciify(letter : Character, mode : AsciifyLetterMode)
            -> Character {
  if let r = asciiRepresentations[letter] {
    switch (mode) {
      case .regular:   return r;
      case .lowercase: return r.capitalized();
      case .uppercase: return r.();
    }
  }
  return letter;
}

func toggleAccent(letter : Character) -> Character {
  if let val = toggleAccentTable[letter] { return val; }
  return letter;
}

func setCharAt(s : String, n : Int, c : Character) -> String {
  var modifiedString = String()
  for (i, char) in s.characters.enumerated() {
      modifiedString += String((i == n) ? c : char)
  }
  return modifiedString
}

func charAt(s : String, i : Int) -> Character {
  let index = s.index(s.startIndex, offsetBy: i);
  return s[index];
}

func substring(x : Int, y : Int, s : String) -> String {
  let start = s.index(s.startIndex, offsetBy: x);
  let end   = s.index(s.startIndex,   offsetBy: y);
  return s[start..<end];
}

var asciiString = String()
var turkishString = String()

func getContext(size : Int, point : Int) -> String {
  var s = String(repeating: " ", count: 1 + 2 * size);
  s = setCharAt(s: s, n: size, c: "X");

  var (i, space, index) = (size + 1, false, point);
  index += 1;
  var currentChar : Character = " ";

  while (i < s.characters.count &&
  !space && index < asciiString.characters.count) {
    currentChar = charAt(s: turkishString, i: index);
  }
}
