import SpriteKit

extension GameScene {
    
    // MARK: - update()
    override func update(_ currentTime: TimeInterval) {
        if gameType == .offline {
            enemy.run(SKAction.moveTo(x: ball.position.x, duration: 0.1))
        }
        else if ball.position.y <= player.position.y - 30 {
            refreshWinnerScore(winner: enemy)
        }
        else if ball.position.y >= enemy.position.y + 30 {
            refreshWinnerScore(winner: player)
        }
    }
    
    // MARK: - touchesBegan()
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if gameType == .player2 {
                if location.y > 0 {
                    enemy.run(SKAction.moveTo(x: location.x, duration: 0.2))
                }
                if location.y < 0 {
                    player.run(SKAction.moveTo(x: location.x, duration: 0.2))
                }
            }
        }
    }
    
    // MARK: - touchesMoved()
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if gameType == .player2 {
                if location.y > 0 {
                    enemy.run(SKAction.moveTo(x: location.x, duration: 0.2))
                }
                if location.y < 0 {
                    player.run(SKAction.moveTo(x: location.x, duration: 0.2))
                }
            }
        }
    }
    
    // MARK: - didSimulatePhysics()
    override func didSimulatePhysics() {
        if gameType != .player2 {
            player.position.x += xAccelerate * 50
            if player.position.x < 0 {
                player.position = CGPoint(x: UIScreen.main.bounds.width - player.size.width, y: player.position.y)
                if gameType == .online {
                    do {
                        let jsonEncoder = JSONEncoder()
                        let jsonData = try jsonEncoder.encode(message)
                        socket.write(data: jsonData)
                        print("hellow")
                    } catch {
                        print("Unexpected error: \(error).")
                    }
                }
            }
            else if player.position.x > UIScreen.main.bounds.width {
                player.position = CGPoint(x: 20, y: player.position.y)
            }
        }
    }
}
