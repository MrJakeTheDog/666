import UIKit
import SwiftGifOrigin
import AVFoundation


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

    // MARK: - Variable
    let sound = AVPlayer(url: Bundle.main.url(forResource: "backgroundMenuSound", withExtension: "mp3")!)

    // MARK: - Custom
    func moveToGameVC(game: GameType) {
        sound.pause()
        let gameVC = self.storyboard?.instantiateViewController(withIdentifier: "gameVC") as? GameViewController
        gameType = game
        self.navigationController?.pushViewController(gameVC ?? GameViewController(), animated: true)
    }

    // MARK: - viewDidLoad
    override func viewDidLoad() {
        sound.play()
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
