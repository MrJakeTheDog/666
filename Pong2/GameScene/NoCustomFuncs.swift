import SpriteKit
import Starscream
import CoreMotion
extension GameScene {

    // MARK: - update
    override func update(_ currentTime: TimeInterval) {
        if ball.position.y <= player.position.y - 30 {
            refresh(winner: enemy)
        }
        else if ball.position.y >= enemy.position.y + 30 {
            refresh(winner: player)
        }
    }
    
    // MARK: - didSimulatePhysics
    override func didSimulatePhysics() {
        //managment(location: CGPoint(x: 0, y: 0))
    }
    
    // MARK: - touchesBegan
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if gameOver == false {
        for touch in touches {
            managment(location: touch.location(in: self))
        }
        }
        else if gameOver == true {
            topTimer.invalidate()
            btmTimer.invalidate()
            delegateVC?.transition()
        }
    }
    
    // MARK: - touchesMoved
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            managment(location: touch.location(in: self))
        }
    }
    
    // MARK: - didBegin
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == player.physicsBody?.categoryBitMask || contact.bodyB.categoryBitMask == player.physicsBody?.categoryBitMask {
            ricochetScore += 1
        }
        if contact.bodyA.categoryBitMask == enemy.physicsBody?.categoryBitMask || contact.bodyB.categoryBitMask == enemy.physicsBody?.categoryBitMask {
            ricochetScore += 1
        }
    }
    
    // MARK: - didReceive
    func didReceive(event: WebSocketEvent, client: WebSocket) {

        switch event {
        case .connected(let headers):
            print("websocket is connected: \(headers)")
        case .disconnected(let reason, let code):
            print("websocket is disconnected: \(reason) with code: \(code)")
        case .text(let string):
            print("Received text: \(string)")
        case .binary(let data):
            print("Received data: \(data.count)")
            receive(data: data, type: type)
        case .ping(_):
            break
        case .pong(_):
            break
        case .viablityChanged(_):
            break
        case .reconnectSuggested(_):
            break
        case .cancelled:
            break
        case .error(let error):
            print(error ?? "error")
        }
    }
}