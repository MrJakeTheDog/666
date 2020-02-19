import Foundation
import SpriteKit

extension GameScene {

    func serverMessage() {
        socket.write(string: "Hi Server!")
        _ = Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { timer in
            do {
                let jsonEncoder = JSONEncoder()
                self.message?.position = CGPoint(x: 400, y: 400)
                self.message?.idN = 0
                let jsonData = try jsonEncoder.encode(self.message)
                self.socket.write(data: jsonData)
                print("Sent data")
            } catch {
                print("Unexpected error: \(error).")
            }
        }
    }
}
