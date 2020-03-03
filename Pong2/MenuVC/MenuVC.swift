import UIKit
import AVFoundation

class MenuVC : UIViewController {

    let sound = AVPlayer(url: Bundle.main.url(forResource: "backgroundSound", withExtension: "mp3")!)

    @IBOutlet weak var online: UIButton!
    @IBOutlet weak var status: UILabel!
    //MARK: - @IBActions
    @IBAction func online(_ sender: UIButton) {
        sound.pause()
        moveToGameVC(game: .online)
    }

    @IBAction func player2(_ sender: UIButton) {
        sound.pause()
        moveToGameVC(game: .player2)
    }

    @IBAction func offline(_ sender: UIButton) {
        sound.pause()
        moveToGameVC(game: .offline)
    }
    
    //MARK: - Custom
    func moveToGameVC(game : GameType) {
        let gameVC = self.storyboard?.instantiateViewController(withIdentifier: "gameVC") as! GameViewController
        gameType = game
        self.navigationController?.pushViewController(gameVC, animated: true)
    }
    
    override func viewDidLoad() {
        sound.play()
        if  Internet.connection() == false {
            online.isEnabled = false
            status.text = "No internet connection"
        } else {
            online.isEnabled = true
            status.text = "Internet is connected"
        }
    }
}
