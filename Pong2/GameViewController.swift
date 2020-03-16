import SpriteKit

var gameType: GameType = .offline

class GameViewController: UIViewController, Transition {

    var skView: SKView {
        (self.view as? SKView)!
    }

    func transition() {
        let menuVC = self.storyboard?.instantiateViewController(withIdentifier: "menuVC") as? MenuVC
        let scene = skView.scene as? GameScene
        scene?.delegateVC = nil
        skView.presentScene(nil)
        self.navigationController?.pushViewController(menuVC ?? MenuVC(), animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
            guard let scene = SKScene(fileNamed: "GameScene") else {
                return
            }
            scene.scaleMode = .aspectFill
            scene.size = view.bounds.size
            let gameScene = scene as? GameScene
            gameScene?.delegateVC = self
            skView.presentScene(scene)
            skView.ignoresSiblingOrder = true
            skView.showsFPS = true
            skView.showsNodeCount = true
            //view.showsPhysics = true
//        if skView != nil {
//            skView.presentScene(skView.scene)
//        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    deinit {
        print("GameViewController")
    }
}
