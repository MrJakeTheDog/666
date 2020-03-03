import SpriteKit

var gameType: GameType = .offline

class GameViewController: UIViewController, Transition {

    func transition() {
        let menuVC = self.storyboard?.instantiateViewController(withIdentifier: "menuVC") as? MenuVC
        let view = self.view as? SKView
        let scene = view?.scene as? GameScene
        scene?.delegateVC = nil
        self.navigationController?.pushViewController(menuVC ?? MenuVC(), animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if let view = self.view as? SKView {
            guard let scene = SKScene(fileNamed: "GameScene") else {
                return
            }
            scene.scaleMode = .aspectFill
            scene.size = view.bounds.size
            let gameScene = scene as? GameScene
            gameScene?.delegateVC = self
            view.presentScene(scene)
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
            //view.showsPhysics = true
        }
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
}