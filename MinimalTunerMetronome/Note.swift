import Foundation

enum Accidental: Int {
    case natural = 0
    case sharp = 1
    case flat = 2
}

class Note: Equatable {
    enum Accidental: Int { case natural = 0, sharp, flat }
    enum Name: Int { case a = 0, b, c, d, e, f, g }
    
    static let all: [Note] = [
        Note(.c, .natural), Note(.c, .sharp),
        Note(.d, .natural),
        Note(.e, .flat), Note(.e, .natural),
        Note(.f, .natural), Note(.f, .sharp),
        Note(.g, .natural),
        Note(.a, .flat), Note(.a, .natural),
        Note(.b, .flat), Note(.b, .natural)
    ]
    
    var note: Name
    var accidental: Accidental
    
    var frequency: Double {
        let index = Note.all.index(of: self)! - Note.all.index(of: Note(.a, .natural))!
        return 440.0 * pow(2.0, Double(index) / 12.0)
    }
    
    init(_ note: Name, _ accidental: Accidental) {
        self.note = note
        self.accidental = accidental
    }
    
    static func ==(lhs: Note, rhs: Note) -> Bool {
        return lhs.note == rhs.note && lhs.accidental == rhs.accidental
    }
    
    static func !=(lhs: Note, rhs: Note) -> Bool {
        return !(lhs == rhs)
    }
}
