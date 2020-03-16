import SpriteKit
import CoreMotion.CMMotionManager
import Starscream

// MARK: - protocols
protocol Transition {
    func transition()
}

protocol addFuncShakeAndFlashAnimation {
    func shakeAndFlashAnimation(view: SKView)
}

class GameScene: SKScene {

    // MARK: - variables
    var ball = SKSpriteNode()
    var enemy = SKSpriteNode()
    var player = SKSpriteNode()
    var backButton = SKSpriteNode()
    var player2Button = SKSpriteNode()

    var topLabel = SKLabelNode()
    var btmLabel = SKLabelNode()
    var pauseLbl = SKLabelNode()
    var inverted = SKLabelNode()
    var сountdown = SKLabelNode()

    var background: SKSpriteNode!
    var search: SKLabelNode!
    var progress: SKLabelNode!

    var timer: Timer!
    var topTimer: Timer!
    var btmTimer: Timer!
    var сountdownT: Timer!

    var identifier: Int!

    var playerCategory = UInt32()
    var enemyCategory = UInt32()
    var ballCategory = UInt32()
    var borderCategory = UInt32()

    var btmScore = Int()
    var topScore = Int()
    var matchLimit = Int()
    var ricochetScore = Int()

    let motionManager = CMMotionManager()

    var delegateVC: Transition?

    var type = DecodeType.identifiers

    var isConnected = Bool()
    var gameOver = Bool()

    var ricochetEmitter = SKEmitterNode()

    var socket: WebSocket!

    var xAccelerate = CGFloat()

    var score = Int() {
        didSet {
            сountdown.text = "Start \(score)"
            inverted.text = "Start \(score)"
        }
    }

    // MARK: - didMove()
    override func didMove(to view: SKView) {
        loadGameSettings()
        loadServerSettings()
        searchEnemyProgress()
        if gameType != .online {
            сountdownf()
        }
    }

    deinit {
        print("Scene deinit")
        if gameType == .online {
            do {
                let jsonEncoder = JSONEncoder()
                let jsonData = try jsonEncoder.encode(Disconnect(id: identifier))
                socket.write(data: jsonData)
            } catch {
                print("Unexpected error: \(error).")
            }
            socket?.disconnect(closeCode: 0)
            socket?.delegate = nil
            delegateVC = nil

            //49. 3

            player.removeAllActions()
            enemy.removeAllActions()
            ball.removeAllActions()
            player.removeFromParent()
            enemy.removeFromParent()
            ball.removeFromParent()

            search.removeAllActions()
            progress.removeAllActions()
            background.removeAllActions()
            backButton.removeAllActions()
            search.removeFromParent()
            progress.removeFromParent()
            background.removeFromParent()
            backButton.removeFromParent()

            inverted.removeAllActions()
            inverted.removeFromParent()

            сountdown.removeAllActions()
            сountdown.removeFromParent()
            сountdownT.invalidate()

            pauseLbl.removeAllActions()
            pauseLbl.removeFromParent()

            self.removeAllActions()
            self.removeFromParent()
            self.removeAllChildren()
            self.removeChildren(in: self.children)
        }
    }
}

// MARK: - Extensions
extension GameScene: SKPhysicsContactDelegate {}
extension GameScene: WebSocketDelegate {}
extension GameScene: addFuncShakeAndFlashAnimation {}

extension addFuncShakeAndFlashAnimation {
    func shakeAndFlashAnimation(view: SKView) {
        let aView = UIView(frame: view.frame)
        aView.backgroundColor = UIColor.white
        view.addSubview(aView)
        UIView.animate(withDuration: 1,
                       delay: 0,
                       options: .allowUserInteraction,
                       animations: { aView.alpha = 0.0 },
                       completion: { _ in aView.removeFromSuperview() })
        let shake = CAKeyframeAnimation(keyPath: "transform")
        shake.values = [
            NSValue(caTransform3D: CATransform3DMakeTranslation(-15, 5, 5)),
            NSValue(caTransform3D: CATransform3DMakeTranslation(15, 5, 5))]
        shake.autoreverses = true
        shake.repeatCount = 2
        shake.duration = 7/100
        view.layer.add(shake, forKey: nil)
    }
}
