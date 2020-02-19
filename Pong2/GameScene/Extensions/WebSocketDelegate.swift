import Starscream
import Foundation

extension GameScene: WebSocketDelegate {
    
    // MARK: - didReceive()
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(let headers):
            isConnected = true
            print("websocket is connected: \(headers)")
        case .disconnected(let reason, let code):
            isConnected = false
            print("websocket is disconnected: \(reason) with code: \(code)")
        case .text(let string):
            print("Received text: \(string)")
        case .binary(let data):
            print("Received data: \(data.count)")
            do {
                let jsonDecoder = JSONDecoder()
                let message = try jsonDecoder.decode(UserData.self, from: data)
                if message.position != nil {
                enemy.position = message.position 
                }
            } catch {
                print("Unexpected error: \(error).")
            }
        case .ping(_):
            break
        case .pong(_):
            break
        case .viablityChanged(_):
            break
        case .reconnectSuggested(_):
            break
        case .cancelled:
            isConnected = false
        case .error(let error):
            isConnected = false
            print(error ?? "error")
        }
    }
}
