import SpriteKit
import CoreMotion

extension GameScene {

    // MARK: - labelNode
    func labelNode() {
        btmLabel = self.childNode(withName: "btmLabel") as? SKLabelNode ?? SKLabelNode()
        topLabel = self.childNode(withName: "topLabel") as? SKLabelNode ?? SKLabelNode()
        btmScore = 0
        topScore = 0
        topLabel.text = "\(topScore)"
        btmLabel.text = "\(btmScore)"
    }

    // MARK: - selfScene
    func selfScene() {
        self.physicsBody = borderPhysicsBody()
        self.backgroundColor = .black
        self.scene?.physicsWorld.contactDelegate = self
        self.scene?.physicsWorld.speed = 0.8
        self.scene?.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
    }

    // MARK: - enemySpriteNode
    func enemySpriteNode() {
        enemy = self.childNode(withName: "enemy") as? SKSpriteNode ?? SKSpriteNode()
        enemy.position.y = (self.frame.height / 2) - 50
        enemy.zPosition = 0
        enemy.physicsBody = enemyPhysicsBody()
    }

    // MARK: - playerSpriteNode
    func playerSpriteNode() {
        player = self.childNode(withName: "main") as? SKSpriteNode ?? SKSpriteNode()
        player.position.y = (-self.frame.height / 2) + 50
        player.zPosition = 0
        player.physicsBody = playerPhysicsBody()
    }

    // MARK: - ballSpriteNode
    func ballSpriteNode() {
        ball = self.childNode(withName: "ball") as? SKSpriteNode ?? SKSpriteNode()
        ball.zPosition = 0
        ball.physicsBody = ballPhysicsBody()
    }

    // MARK: - categoryBitMask
    func categoryBitMask() {
        playerCategory = 3
        enemyCategory = 1
        ballCategory = 2
        borderCategory = 4
    }

    // MARK: - playerPhysicsBody
    func playerPhysicsBody() -> SKPhysicsBody {
        let body = SKPhysicsBody(rectangleOf: player.size)
        body.isDynamic = false
        body.friction = 0
        body.density = 1
        body.affectedByGravity = false
        body.restitution = 0
        body.linearDamping = 0.1
        body.angularDamping = 0.1
        body.fieldBitMask = ballCategory
        body.mass = 0.30
        body.velocity = CGVector(dx: 0, dy: 0)
        body.categoryBitMask = playerCategory
        body.contactTestBitMask = ballCategory
        body.collisionBitMask = ballCategory
        body.usesPreciseCollisionDetection = true
        return body
    }

    // MARK: - categoryBitMask
    func enemyPhysicsBody() -> SKPhysicsBody {
        let body = SKPhysicsBody(rectangleOf: enemy.size)
        body.isDynamic = false
        body.friction = 0
        body.density = 1
        body.affectedByGravity = false
        body.restitution = 0
        body.linearDamping = 0.1
        body.angularDamping = 0.1
        body.fieldBitMask = ballCategory
        body.mass = 0.30
        body.velocity = CGVector(dx: 0, dy: 0)
        body.categoryBitMask = enemyCategory
        body.contactTestBitMask = ballCategory
        body.collisionBitMask = ballCategory
        body.usesPreciseCollisionDetection = true
        return body
    }

    // MARK: - ballPhysicsBody
    func ballPhysicsBody() -> SKPhysicsBody {
        let body = SKPhysicsBody(circleOfRadius: ball.size.width / 2)
        body.categoryBitMask = ballCategory
        body.isDynamic = true
        body.affectedByGravity = false
        body.fieldBitMask = enemyCategory | borderCategory
        body.friction = 0
        body.density = 1
        body.restitution = 1
        body.restitution = 1
        body.linearDamping = 0
        body.angularDamping = 0
        body.mass = 0.01
        body.velocity = CGVector(dx: 0, dy: 0)
        body.contactTestBitMask = enemyCategory | borderCategory | playerCategory
        body.collisionBitMask =  enemyCategory | borderCategory | playerCategory
        body.usesPreciseCollisionDetection = true
        return body
    }

    // MARK: - borderPhysicsBody
    func borderPhysicsBody() -> SKPhysicsBody {
        let body = SKPhysicsBody(edgeLoopFrom: self.frame)
        body.friction = 0
        body.restitution = 1
        body.isDynamic = false
        body.categoryBitMask = borderCategory
        body.contactTestBitMask = ballCategory
        body.collisionBitMask = ballCategory
        body.usesPreciseCollisionDetection = true
        return body
    }

    // MARK: - playerMotionManager
    func playerMotionManager() {
        self.xAccelerate = 0
        if gameType != .player2 {
            motionManager.accelerometerUpdateInterval = 0.02
            motionManager.deviceMotionUpdateInterval = 0.02
            motionManager.startAccelerometerUpdates(
            to: OperationQueue.current!) {(data: CMAccelerometerData?, _: Error?) in
                if let accelerometrData = data {
                    let acceleration = accelerometrData.acceleration
                    self.xAccelerate = CGFloat(acceleration.x) * 0.30 + self.xAccelerate * 0.25
                }
            }
        }
    }

    // MARK: - ballEmitter
    func ballEmitter() {
        ricochetEmitter = SKEmitterNode(fileNamed: "Explosion")!
        ricochetEmitter.zPosition = -1
        let vector = CGVector(dx: 5, dy: 5)
        let arctangent = atan2(-vector.dy, -vector.dx)
        ricochetEmitter.emissionAngle = arctangent
        ball.addChild(ricochetEmitter)
    }

    // MARK: - playerBackButton
    func playerBackButton() {
        if gameType != .online {
            backButton = SKSpriteNode(texture: SKTexture(imageNamed: "iconePause"))
            backButton.zPosition = 3
            backButton.position = CGPoint(x: 150, y: -300)
            backButton.setScale(1.30)
            self.addChild(backButton)
        }
    }

    // MARK: - player2BackButton
    func player2BackButton() {
        if gameType == .player2 {
            player2Button = SKSpriteNode(texture: SKTexture(imageNamed: "iconePause"))
            player2Button.zPosition = 3
            player2Button.position = CGPoint(x: -150, y: 300)
            player2Button.setScale(1.30)
            self.addChild(player2Button)
        }
    }

    // MARK: - loadGameSettings
    func loadGameSettings() {
        // Порядок вызова функций очень важен!
        categoryBitMask()
        selfScene()
        labelNode()
        playerSpriteNode()
        enemySpriteNode()
        ballSpriteNode()
        playerMotionManager()
        ballEmitter()
        playerBackButton()
        player2BackButton()
        matchLimit = 10
        gameOver = false
    }
}
