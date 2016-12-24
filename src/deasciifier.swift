let asciiRepresentations : [String: String] = [
  "ç": "c",
  "Ç": "C",
  "ğ": "g",
  "Ğ": "G",
  "ö": "o",
  "Ö": "O",
  "ı": "i",
  "İ": "I",
  "ş": "s",
  "Ş": "S"
]

let originalRepresentations : [String: String] = [
  "c": "ç",
  "C": "Ç",
  "g": "ğ",
  "G": "Ğ",
  "o": "ö",
  "O": "Ö",
  "i": "ı",
  "I": "İ",
  "s": "ş",
  "S": "Ş"
]

enum AsciifyLetterMode { case regular, lowercase, uppercase }

func asciify(letter : String, mode : AsciifyLetterMode) -> String {
  if let r = asciiRepresentations[letter] {
    switch (mode) {
      case .regular:   return r;
      case .lowercase: return r.lowercased();
      case .uppercase: return r.uppercased();
    }
  }
  return letter;
}

func toggleAccent(letter : String) -> String {
  if let val = asciiRepresentations[letter] {
    return val;
  } else if let val = originalRepresentations[letter] {
    return val;
  }
  return letter;
}

assert(asciify(letter: "ı", mode : .uppercase) == "I")
print(asciify(letter: "ı", mode : .uppercase))
print(asciify(letter: "İ", mode : .lowercase))
print(asciify(letter: "İ", mode : .regular))
print(asciify(letter: "ı", mode : .regular))
