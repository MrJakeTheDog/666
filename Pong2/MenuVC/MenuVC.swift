import UIKit
import SwiftGifOrigin

class MenuVC: UIViewController {

    // MARK: - @IBOutlets
    @IBOutlet weak var online: UIButton!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!

    // MARK: - @IBActions
    @IBAction func online(_ sender: UIButton) {
        moveToGameVC(game: .online)
    }

    @IBAction func player2(_ sender: UIButton) {
        moveToGameVC(game: .player2)
    }

    @IBAction func offline(_ sender: UIButton) {
        moveToGameVC(game: .offline)
    }

    // MARK: - Custom
    func moveToGameVC(game: GameType) {
        let gameVC = self.storyboard?.instantiateViewController(withIdentifier: "gameVC") as? GameViewController
        gameType = game
        self.navigationController?.pushViewController(gameVC ?? GameViewController(), animated: true)
    }

    // MARK: - viewDidLoad
    override func viewDidLoad() {
        if  Internet.connection() == false {
            online.isEnabled = false
            status.textColor = UIColor.red
            status.text = "No internet connection"
        } else {
            online.isEnabled = true
            status.textColor = UIColor.green
            status.text = "Internet is connected"
        }
        backgroundImageView.loadGif(name: "menuBackground")
    }
}
