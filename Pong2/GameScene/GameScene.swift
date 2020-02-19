
import SpriteKit
import GameplayKit
import Foundation
import CoreMotion
import Starscream

class GameScene: SKScene {
    
    // MARK: - variables
    var ball = SKSpriteNode()
    var enemy = SKSpriteNode()
    var player = SKSpriteNode()
    
    var topLbl = SKLabelNode()
    var btmLbl = SKLabelNode()
    
    var playerCategory = UInt32()
    var enemyCategory = UInt32()
    var ballCategory = UInt32()
    var borderCategory = UInt32()
    
    var pScore = Int()
    var eScore = Int()
    var ricochets = Int()
    var 
    
    var message: UserData!
    var socket: WebSocket!

    var skpBorder = SKPhysicsBody()
    var skpPlayer = SKPhysicsBody()
    var skpEnemy = SKPhysicsBody()
    var skpBall = SKPhysicsBody()
    
    var xAccelerate = CGFloat()
    
    var isConnected = Bool()

    // MARK: - didMove()
    override func didMove(to view: SKView) {
        loadGameSettings()
        connectionToServer()
        startGame()
    }

    deinit {
        if gameType == .online {
            socket?.disconnect (closeCode: 0)
            socket?.delegate = nil
        }
    }
}







