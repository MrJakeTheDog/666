import Starscream
import CoreMotion.CMMotionManager

extension GameScene {

    // MARK: - receive
    func receive(data: Data, type: DecodeType) {
        let jsonDecoder = JSONDecoder()
        switch type {
        case .identifiers:
            do {
                let identifiers = try jsonDecoder.decode(Identifiers.self, from: data)
                identifier = identifiers.id
                self.type = .connection
            } catch {
                print("Unexpected error: \(error).")
            }
        case .connection:
            do {
                let connection = try jsonDecoder.decode(Connection.self, from: data)
                isConnected = connection.isConnected
                detected()
                сountdownf()
                self.type = .enemy
            } catch {
                print("Unexpected error: \(error).")
                do {
                    let disconnect = try jsonDecoder.decode(Disconnect.self, from: data)
                    print(disconnect.disconnect)
                } catch {
                    print("Unexpected error: \(error).")
                }
            }
        default:
            do {
                let enemy = try jsonDecoder.decode(Enemy.self, from: data)
                self.enemy.position = enemy.position
            } catch {
                print("Unexpected error: \(error).")
                do {
                    let disconnect = try jsonDecoder.decode(Disconnect.self, from: data)
                    print(disconnect.disconnect)
                } catch {
                    print("Unexpected error: \(error).")
                }
            }
        }
    }

    // MARK: - send
    func send(data: User) {
        do {
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(data)
            socket.write(data: jsonData)
        } catch {
            print("Unexpected error: \(error).")
        }
    }

    // MARK: - loadServerSettings
    func loadServerSettings() {
        if gameType == .online {
            let url = URL(string: "http://localhost:8080/ws")!
            let request = URLRequest(url: url)
            socket = WebSocket(request: request)
            socket.delegate = self
            socket.connect()
        }
    }
}
