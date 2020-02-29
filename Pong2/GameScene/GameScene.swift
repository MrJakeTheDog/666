
import SpriteKit
import GameplayKit
import Foundation
import CoreMotion
import Starscream


protocol Transition {
   func transition()
}

class GameScene: SKScene {
    
    // MARK: - variables
    var ball = SKSpriteNode()
    var enemy = SKSpriteNode()
    var player = SKSpriteNode()
    
    var topLabel = SKLabelNode()
    var btmLabel = SKLabelNode()
    var background: SKSpriteNode!
    var search: SKLabelNode!
    var progress: SKLabelNode!
    var timer: Timer!
    var topTimer: Timer!
    var btmTimer: Timer!
    var gameOver = Bool()

    var btmScore = Int()
    var topScore = Int()
    var limit = Int()
    
    let motionManager = CMMotionManager()
    
    var delegateVC: Transition?
    
    var ricochetScore = Int()
    
    var identifier: Int!
    var type = DecodeType.identifiers
    var isConnected = Bool()

    var socket: WebSocket!
    
    var xAccelerate = CGFloat()

    // MARK: - didMove()
    override func didMove(to view: SKView) {
        object()
        
        server()
        connected()
        //TESTMESSAGE()
        if gameType != .online {
            сountdown()
        }
       
        
        //socket.disconnect()
//        _ = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { timer in
//                  do {
//                                 let jsonEncoder = JSONEncoder()
//                    let jsonData = try jsonEncoder.encode(Disconnect(id: self.identifier))
//                    self.socket.write(data: jsonData)
//                             } catch {
//                                 print("Unexpected error: \(error).")
//                             }
//            self.socket?.disconnect (closeCode: 0)
//            
//        }
    }
    

    deinit {
        print("666")
        if gameType == .online {
            do {
                let jsonEncoder = JSONEncoder()
                let jsonData = try jsonEncoder.encode(Disconnect(id: identifier))
                socket.write(data: jsonData)
            } catch {
                print("Unexpected error: \(error).")
            }
            socket?.disconnect (closeCode: 0)
            socket?.delegate = nil
            delegateVC = nil
        }
    }
}

extension GameScene: SKPhysicsContactDelegate {}
extension GameScene: WebSocketDelegate {}





