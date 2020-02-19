import SpriteKit

extension GameScene: SKPhysicsContactDelegate {
    
    // MARK: - didBegin()
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == playerCategory || contact.bodyB.categoryBitMask == playerCategory {
            ricochets += 1
        }
        if contact.bodyA.categoryBitMask == enemyCategory || contact.bodyB.categoryBitMask == enemyCategory {
            ricochets += 1
        }
    }
}
