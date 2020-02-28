import SpriteKit
import Starscream
import CoreMotion
import UIKit

extension GameScene {
    
    //MARK: - object
    func object() {
        
        //SKLabelNode
        btmLabel = self.childNode(withName: "btmLabel") as! SKLabelNode
        topLabel = self.childNode(withName: "topLabel") as! SKLabelNode
        
        btmScore = 0
        topScore = 0
        
        topLabel.text = "\(topScore)"
        btmLabel.text = "\(btmScore)"
        
        //SKSpriteNode
        let playerCategory: UInt32 = 3
        let enemyCategory: UInt32 = 1
        let ballCategory: UInt32 = 2
        let borderCategory: UInt32 = 4
        
        enemy = self.childNode(withName: "enemy") as! SKSpriteNode
        enemy.position.y = (self.frame.height / 2) - 50
        enemy.zPosition = 0
        
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody?.isDynamic = false
        enemy.physicsBody?.friction = 0
        enemy.physicsBody?.density = 1
        enemy.physicsBody?.affectedByGravity = false
        enemy.physicsBody?.restitution = 0
        enemy.physicsBody?.linearDamping = 0.1
        enemy.physicsBody?.angularDamping = 0.1
        enemy.physicsBody?.fieldBitMask = ballCategory
        enemy.physicsBody?.mass = 0.30
        enemy.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        enemy.physicsBody?.categoryBitMask = enemyCategory
        enemy.physicsBody?.contactTestBitMask = ballCategory
        enemy.physicsBody?.collisionBitMask = ballCategory
        enemy.physicsBody?.usesPreciseCollisionDetection = true
        
        ball = self.childNode(withName: "ball") as! SKSpriteNode
        ball.zPosition = 0
        
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2)
        ball.physicsBody?.categoryBitMask = ballCategory
        ball.physicsBody?.isDynamic = true
        ball.physicsBody?.affectedByGravity = false
        ball.physicsBody?.fieldBitMask = enemyCategory | borderCategory
        ball.physicsBody?.friction = 0
        ball.physicsBody?.density = 1
        ball.physicsBody?.restitution = 1
        ball.physicsBody?.restitution = 1
        ball.physicsBody?.linearDamping = 0
        ball.physicsBody?.angularDamping = 0
        ball.physicsBody?.mass = 0.01
        ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        ball.physicsBody?.contactTestBitMask = enemyCategory | borderCategory | playerCategory
        ball.physicsBody?.collisionBitMask =  enemyCategory | borderCategory | playerCategory
        ball.physicsBody?.usesPreciseCollisionDetection = true
        
        player = self.childNode(withName: "main") as! SKSpriteNode
        player.position.y = (-self.frame.height / 2) + 50
        player.zPosition = 0
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.isDynamic = false
        player.physicsBody?.friction = 0
        player.physicsBody?.density = 1
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.restitution = 0
        player.physicsBody?.linearDamping = 0.1
        player.physicsBody?.angularDamping = 0.1
        player.physicsBody?.fieldBitMask = ballCategory
        player.physicsBody?.mass = 0.30
        player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        player.physicsBody?.categoryBitMask = playerCategory
        player.physicsBody?.contactTestBitMask = ballCategory
        player.physicsBody?.collisionBitMask = ballCategory
        player.physicsBody?.usesPreciseCollisionDetection = true
        
        self.xAccelerate = 0
        let motionManager = CMMotionManager()
        motionManager.accelerometerUpdateInterval = 0.02
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!) {
            (data: CMAccelerometerData?, error: Error?) in
            if let accelerometrData = data {
                let acceleration = accelerometrData.acceleration
                self.xAccelerate = CGFloat(acceleration.x) * 0.30 + self.xAccelerate * 0.25
            }
        }
        
        //Self
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        border.friction = 0
        border.restitution = 1
        border.isDynamic = false
        border.categoryBitMask = borderCategory
        border.contactTestBitMask = ballCategory
        border.collisionBitMask = ballCategory
        border.usesPreciseCollisionDetection = true
        
        self.physicsBody = border
        self.backgroundColor = .black
        self.scene?.physicsWorld.contactDelegate = self
        self.scene?.physicsWorld.speed = 0.8
        self.scene?.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
        limit = 10
        gameOver = false
    }
    
    //MARK: - managment
    func managment(location: CGPoint) {
        switch gameType {
        case .player2:
            if location.x < ((view?.frame.width)! / 2) - player.size.width / 2 && location.x > -((view?.frame.width)! / 2) + player.size.width / 2 {
                if location.y > 0 {
                    enemy.run(SKAction.moveTo(x: location.x, duration: 0.2))
                }
                if location.y < 0 {
                    player.run(SKAction.moveTo(x: location.x, duration: 0.2))
                }
            }
            else {
                break
            }
            
        case .offline:
            enemy.run(SKAction.moveTo(x: ball.position.x, duration: 0.1))
            fallthrough
        default:
            player.position.x += xAccelerate * 50
            if player.position.x < 0 {
                player.position = CGPoint(x: UIScreen.main.bounds.width - player.size.width, y: player.position.y)
            }
            if gameType == .online, isConnected == true {
                send(data: User(id: identifier, position: player.position))
            }
        }
    }
    
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
                сountdown()
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
    
    // MARK: - server
    func server() {
        if gameType == .online {
            let url = URL(string: "http://localhost:8080/ws")!
            let request = URLRequest(url: url)
            socket = WebSocket(request: request)
            socket.delegate = self
            socket.connect()
            
        }
    }
    
    // MARK: - victory
    func victory(winner: SKSpriteNode) {
        player.position.x = 0
        enemy.position.x = 0
        ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        let background = SKSpriteNode(color: .black, size: CGSize(width: self.frame.width, height: self.frame.height))
        background.alpha = 0
        background.zPosition = 3
        self.addChild(background)
        background.run(SKAction.fadeAlpha(by: 0.5, duration: 2))
        
        let topLabel = SKLabelNode(text: "Defeat")
        topLabel.color = .white
        topLabel.fontColor = .white
        topLabel.position = CGPoint(x: 0, y: 0)
        topLabel.zPosition = 5
        topLabel.alpha = 0
        topLabel.fontSize = 40
        topLabel.horizontalAlignmentMode = .center
        topLabel.verticalAlignmentMode = .center
        self.addChild(topLabel)
        topLabel.run(SKAction.fadeAlpha(by: 1, duration: 1))
        
        let topReminder = SKLabelNode(text: "touch on screen")
        topReminder.color = .white
        topReminder.fontColor = .white
        topReminder.position = CGPoint(x: 0, y: -125)
        topReminder.zPosition = 5
        topReminder.alpha = 0
        topReminder.fontSize = 15
        topReminder.horizontalAlignmentMode = .center
        topReminder.verticalAlignmentMode = .center
        self.addChild(topReminder)
        topTimer = Timer.scheduledTimer(withTimeInterval: 0.8, repeats: true) { timer
            in
            timer.tolerance = 0.2
            if topReminder.alpha == 0 {
                topReminder.run(SKAction.fadeIn(withDuration: 0.6))
            } else {
                topReminder.run(SKAction.fadeOut(withDuration: 0.6))
            }
        }
        
        if gameType == .player2 {
            let btmlabel = SKLabelNode(text: "Victory")
            btmlabel.color = .white
            btmlabel.fontColor = .white
            btmlabel.position = CGPoint(x: 0, y: -100)
            btmlabel.zPosition = 5
            btmlabel.alpha = 0
            btmlabel.fontSize = 40
            btmlabel.horizontalAlignmentMode = .center
            btmlabel.verticalAlignmentMode = .center
            self.addChild(btmlabel)
            btmlabel.run(SKAction.fadeAlpha(by: 1, duration: 1))
            topLabel.zRotation = 3.14159
            topLabel.position.y = 100
            
            
            let btmReminder = SKLabelNode(text: "touch on screen")
            btmReminder.color = .white
            btmReminder.fontColor = .white
            btmReminder.position = CGPoint(x: 0, y: 125)
            btmReminder.zPosition = 5
            btmReminder.alpha = 0
            btmReminder.fontSize = 15
            btmReminder.horizontalAlignmentMode = .center
            btmReminder.verticalAlignmentMode = .center
            self.addChild(btmReminder)
            btmReminder.zRotation = 3.14159
            btmReminder.run(SKAction.fadeAlpha(by: 1, duration: 1))
            
            btmTimer = Timer.scheduledTimer(withTimeInterval: 0.8, repeats: true) { timer
                in
                timer.tolerance = 0.2
                if btmReminder.alpha == 0 {
                    btmReminder.run(SKAction.fadeIn(withDuration: 0.6))
                } else {
                    btmReminder.run(SKAction.fadeOut(withDuration: 0.6))
                }
            }
            
            if winner == enemy {
                btmlabel.text = "Defeat"
                topLabel.text = "Victory"
            }
        }
        
        
        if gameType == .offline {
        if winner == enemy {
            topLabel.text = "Defeat"
            background.color = .black
        }
        }
    }
    
    // MARK: - refresh
    func refresh(winner : SKSpriteNode) {
        ball.position = CGPoint(x: 0, y: 0)
        ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        if winner == player {
            if btmScore == limit {
                victory(winner: winner)
                gameOver = true
                return
            }
            
            btmScore += 1
            ball.physicsBody?.applyImpulse(CGVector(dx: 10, dy: 10))
        }
        else if winner == enemy {
            if topScore == limit {
                victory(winner: winner)
                gameOver = true
                return
            }
           
            topScore += 1
            ball.physicsBody?.applyImpulse(CGVector(dx: -10, dy: -10))
        }
        topLabel.text = "\(topScore)"
        btmLabel.text = "\(btmScore)"
    }
    
    // MARK: - connected
    func connected() {
        if gameType == .online {
        background = SKSpriteNode(color: .black, size: CGSize(width: self.frame.width, height: self.frame.height))
        background.alpha = 1
        background.zPosition = 2
        
        search = SKLabelNode(text: "Enemy search")
        search.color = .white
        search.position = CGPoint(x: 0, y: 0)
        search.zPosition = 3
        search.horizontalAlignmentMode = .center
        search.verticalAlignmentMode = .center
        
        progress = SKLabelNode(text: ".")
        progress.color = .white
        progress.position = CGPoint(x: 0, y: -30)
        progress.zPosition = 3
        progress.horizontalAlignmentMode = .center
        progress.verticalAlignmentMode = .center
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            switch self.progress.text {
            case ".":
                self.progress.text = ".."
            case "..":
                self.progress.text = "..."
            case "...":
                self.progress.text = ""
            case "":
                self.progress.text = "."
            default:
                self.progress.text = ""
            }
        }
        timer.tolerance = 1
        self.addChild(search)
        self.addChild(progress)
        self.addChild(background)
        }
    }

    // MARK: - detected
    func detected() {
        timer.invalidate()
        progress.removeFromParent()
        let attenuation = SKAction.fadeOut(withDuration: 5)
        background.run(attenuation)
        search.run(attenuation)
    }
    
    // MARK: - сountdown
    func сountdown() {
        var inverted = SKLabelNode()
        var сountdown = SKLabelNode()
        var score = 5 {
            didSet {
                сountdown.text = "Start \(score)"
                inverted.text = "Start \(score)"
            }
        }
        
        if gameType == .player2 {
            inverted.text = "Start \(score)"
            inverted.horizontalAlignmentMode = .center
            inverted.verticalAlignmentMode = .center
            inverted.fontSize = 40
            inverted.color = .white
            inverted.position = CGPoint(x: 0, y: 150)
            inverted.zPosition = 3
            inverted.zRotation = 3.14159
            inverted.run(SKAction.fadeOut(withDuration: 10))
            self.addChild(inverted)
        }
        
        сountdown.text = "Start \(score)"
        сountdown.horizontalAlignmentMode = .center
        сountdown.verticalAlignmentMode = .center
        сountdown.fontSize = 50
        сountdown.color = .white
        сountdown.position = CGPoint(x: 0, y: 0)
        сountdown.zPosition = 3
        сountdown.run(SKAction.fadeOut(withDuration: 10))
     
        if gameType == .player2 {
            сountdown.fontSize = 40
            сountdown.position = CGPoint(x: 0, y: -150)
        }

        self.addChild(сountdown)
        _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            score -= 1
            if score == 0 {
                if gameType == .online {
                    self.search.removeFromParent()
                    self.background.removeFromParent()
                }
                timer.invalidate()
                сountdown.removeFromParent()
                inverted.removeFromParent()
                self.start()
            }
        }
    }
    
    // MARK: - start
    func start() {
        ball.physicsBody?.applyImpulse(CGVector(dx: 0 , dy: 10))
    }
}



