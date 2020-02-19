import SpriteKit

// MARK: - User
struct UserData: Codable {
    var idN: Int? = Int()
    var position: CGPoint = CGPoint()
    var roomNumber: Int? = Int()
}

// MARK: - GameType
enum GameType {
    case offline
    case player2
    case online
}
