import SpriteKit

var gameType:GameType = .offline
   var j = false
class GameViewController: UIViewController, Transition {
    
    func transition() {
        //self.dismiss(animated: true, completion: nil)
        let menuVC = self.storyboard?.instantiateViewController(withIdentifier: "menuVC") as! MenuVC
        //self.view = nil
        //self.view.removeFromSuperview()
        let view = self.view as! SKView
        let scene = view.scene as! GameScene
        scene.delegateVC = nil
        self.navigationController?.pushViewController(menuVC, animated: true)
    }
    
 
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print(j)
        if let view = self.view as! SKView? {
            if j == true {
                print("1")
            
                } else {
                    if let scene = SKScene(fileNamed: "GameScene") {
                        j = true
                    scene.scaleMode = .aspectFill
                    scene.size = view.bounds.size
                    let game = scene as? GameScene
                    game?.delegateVC = self
                    view.presentScene(scene)
                        print("5")
                }
            }
            

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
