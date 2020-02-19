import SpriteKit
import CoreMotion
import Starscream

extension GameScene {
    
    // MARK: - TopLblSettings()
    func topLblSettings() {
        topLbl = self.childNode(withName: "topLabel") as! SKLabelNode
        
    }
    
    // MARK: - btmLblSettings()
    func btmLblSettings() {
        btmLbl = self.childNode(withName: "btmLabel") as! SKLabelNode
    }
    
    // MARK: - bitMaskSettings()
    func bitMaskSettings() {
        ballCategory = 2
        enemyCategory = 1
        playerCategory = 3
        borderCategory = 4
    }
    
    func connectionToServer() {
        if gameType == .online {
            let url = URL(string: "http://localhost:8080/ws")!
            let request = URLRequest(url: url)
            socket = WebSocket(request: request)
            socket.delegate = self
            socket.connect()
            serverMessage()
        }
    }
    
    // MARK: - ballSettings()
    func ballSettings() {
        ball = self.childNode(withName: "ball") as! SKSpriteNode
        ball.zPosition = 0
        skpBall = SKPhysicsBody(circleOfRadius: ball.size.width / 2)
        skpBall.categoryBitMask = ballCategory
        skpBall.isDynamic = true
        skpBall.affectedByGravity = false
        skpBall.fieldBitMask = enemyCategory | borderCategory
        skpBall.friction = 0
        skpBall.density = 1
        skpBall.restitution = 1
        skpBall.restitution = 1
        skpBall.linearDamping = 0
        skpBall.angularDamping = 0
        skpBall.mass = 0.01
        skpBall.velocity = CGVector(dx: 0, dy: 0)
        skpBall.contactTestBitMask = enemyCategory | borderCategory | playerCategory
        skpBall.collisionBitMask =  enemyCategory | borderCategory | playerCategory
        skpBall.usesPreciseCollisionDetection = true
        ball.physicsBody = skpBall
    }
    
    // MARK: - enemySettings()
    func enemySettings() {
        enemy = self.childNode(withName: "enemy") as! SKSpriteNode
        enemy.position.y = (self.frame.height / 2) - 50
        enemy.zPosition = 0
        skpEnemy = SKPhysicsBody(rectangleOf: enemy.size)
        skpEnemy.isDynamic = false
        skpEnemy.friction = 0
        skpEnemy.density = 1
        skpEnemy.affectedByGravity = false
        skpEnemy.restitution = 0
        skpEnemy.linearDamping = 0.1
        skpEnemy.angularDamping = 0.1
        skpEnemy.fieldBitMask = ballCategory
        skpEnemy.mass = 0.30
        skpEnemy.velocity = CGVector(dx: 0, dy: 0)
        skpEnemy.categoryBitMask = enemyCategory
        skpEnemy.contactTestBitMask = ballCategory
        skpEnemy.collisionBitMask = ballCategory
        skpEnemy.usesPreciseCollisionDetection = true
        enemy.physicsBody = skpEnemy
    }
    
    // MARK: - playerSettings()
    func playerSettings() {
        player = self.childNode(withName: "main") as! SKSpriteNode
        player.position.y = (-self.frame.height / 2) + 50
        player.zPosition = 0
        skpPlayer = SKPhysicsBody(rectangleOf: player.size)
        skpPlayer.isDynamic = false
        skpPlayer.friction = 0
        skpPlayer.density = 1
        skpPlayer.affectedByGravity = false
        skpPlayer.restitution = 0
        skpPlayer.linearDamping = 0.1
        skpPlayer.angularDamping = 0.1
        skpPlayer.fieldBitMask = ballCategory
        skpPlayer.mass = 0.30
        skpPlayer.velocity = CGVector(dx: 0, dy: 0)
        skpPlayer.categoryBitMask = playerCategory
        skpPlayer.contactTestBitMask = ballCategory
        skpPlayer.collisionBitMask = ballCategory
        skpPlayer.usesPreciseCollisionDetection = true
        player.physicsBody = skpPlayer
        
    }
    
    // MARK: - motionManagerSettings()
    func motionManagerSettings() {
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
    }
    
    // MARK: - borderSettings()
    func borderSettings() {
        skpBorder = SKPhysicsBody(edgeLoopFrom: self.frame)
        skpBorder.friction = 0
        skpBorder.restitution = 1
        skpBorder.isDynamic = false
        skpBorder.categoryBitMask = borderCategory
        skpBorder.contactTestBitMask = ballCategory
        skpBorder.collisionBitMask = ballCategory
        skpBorder.usesPreciseCollisionDetection = true
        self.physicsBody = skpBorder
    }
    
    // MARK: - loadSettings()
    func loadGameSettings() {
        self.scene?.physicsWorld.contactDelegate = self
        self.scene?.physicsWorld.speed = 0.8
        self.scene?.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        motionManagerSettings()
        topLblSettings()
        btmLblSettings()
        bitMaskSettings()
        enemySettings()
        playerSettings()
        ballSettings()
        borderSettings()
    }
    
    // MARK: - startGame()
    func startGame() {
        pScore = 0
        eScore = 0
        topLbl.text = "\(eScore)"
        btmLbl.text = "\(pScore)"
        ball.physicsBody?.applyImpulse(CGVector(dx: 0 , dy: 10))
    }
    
    // MARK: - refreshWinnerScore()
    func refreshWinnerScore(winner : SKSpriteNode) {
        ball.position = CGPoint(x: 0, y: 0)
        ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        if winner == player {
            pScore += 1
            ball.physicsBody?.applyImpulse(CGVector(dx: 10, dy: 10))
        }
        else if winner == enemy {
            eScore += 1
            ball.physicsBody?.applyImpulse(CGVector(dx: -10, dy: -10))
            
        }
        topLbl.text = "\(eScore)"
        btmLbl.text = "\(pScore)"
    }
}
