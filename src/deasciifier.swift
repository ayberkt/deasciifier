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

enum AsciifyLetterMode { case regular, lowercase, uppercase }

func asciify(letter : String, mode : AsciifyLetterMode) -> String? {
  if let r = asciiRepresentations[letter] {
    switch (mode) {
      case .regular:   return r;
      case .lowercase: return r.lowercaseString;
      case .uppercase: return r.uppercaseString;
    }
  }
  return nil;
}

let upperCaseLetters = Array(arrayLiteral: "ABCDEFGHIJKLMNOPQRSTUVWXYZ")
print(upperCaseLetters)
