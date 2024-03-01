//
//  PlayerViewController.swift
//  MaxMusic
//
//  Created by APPLE on 29/01/24.
//

import UIKit
import AVFoundation

class PlayerViewController: UIViewController {

    public var position: Int = 0
    public var songs: [Song] = []
    
    var holderView = UIView()
    var player: AVAudioPlayer?
    
    private var albumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private var songNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    private var artistNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    private var albumNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let playPauseButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let player = player {
            player.stop()
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if holderView.subviews.count == 0 {
            configure()
        }
    }

    func configure() {
        //set up player
        let song = songs[position]
        let url = Bundle.main.path(forResource: song.trackName, ofType: "mp3")
        do {
            try AVAudioSession.sharedInstance().setMode(.default)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            
            guard let urlString = url else {
                return
            }
            player = try AVAudioPlayer(contentsOf: URL(string: urlString)!)
            
            guard let player = player else {
                return
            }
            player.volume = 0.5
            player.play()
        }
        catch {
            print("Error occured")
        }
        //set up user interface elements
        albumImageView.frame = CGRect(x: 10, y: 10, width: holderView.frame.size.width-20, height: holderView.frame.size.width-20)
        albumImageView.image = UIImage(named: song.imageName)
        holderView.addSubview(albumImageView)
        
        //labels
        songNameLabel.frame = CGRect(x: 10, y: albumImageView.frame.size.height + 10, width: holderView.frame.size.width-20, height: 70)
        albumNameLabel.frame = CGRect(x: 10, y: albumImageView.frame.size.height + 10 + 70, width: holderView.frame.size.width-20, height: 70)
        artistNameLabel.frame = CGRect(x: 10, y: albumImageView.frame.size.height + 10 + 140, width: holderView.frame.size.width-20, height: 70)
        holderView.addSubview(songNameLabel)
        holderView.addSubview(albumNameLabel)
        holderView.addSubview(artistNameLabel)
        
        //data
        songNameLabel.text = song.name
        albumNameLabel.text = song.albumName
        artistNameLabel.text = song.artistName
        
        //player controls
        let nextButton = UIButton()
        let backButton = UIButton()
        
        //Frame
        let yPosition = artistNameLabel.frame.origin.y + 70 + 20
        let size: CGFloat = 70
        
        playPauseButton.frame = CGRect(x: (holderView.frame.size.width - size) / 2.0, y: yPosition, width: size, height: size)
        nextButton.frame = CGRect(x: holderView.frame.size.width - size - 20, y: yPosition, width: size, height: size)
        backButton.frame = CGRect(x: 20, y: yPosition, width: size, height: size)
        
        //AddActions
        playPauseButton.addTarget(self, action: #selector(didTapPlayPause), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        //Images
        playPauseButton.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
        nextButton.setBackgroundImage(UIImage(systemName: "backward.fill"), for: .normal)
        backButton.setBackgroundImage(UIImage(systemName: "forward.fill"), for: .normal)
        
        playPauseButton.tintColor = .black
        nextButton.tintColor = .black
        backButton.tintColor = .black
        
        holderView.addSubview(playPauseButton)
        holderView.addSubview(nextButton)
        holderView.addSubview(backButton)
        
        let slider = UISlider(frame: CGRect(x: 20, y: holderView.frame.size.height-60, width: holderView.frame.size.width-40, height: 50))
        holderView.addSubview(slider)
        slider.value = 0.5
        slider.addTarget(self, action: #selector(didSlide(_ :)), for: .valueChanged)
    }
    
    @objc func didSlide(_ slider:UISlider){
        let value = slider.value
        player?.volume = value
    }
    
    @objc func didTapPlayPause() {
        if player?.isPlaying == true {
            //pause
            player?.pause()
            //show Play button
            playPauseButton.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)
            UIView.animate(withDuration: 0.2, animations: { [self] in
                self.albumImageView.frame = CGRect(x: 30,
                                                   y: 30,
                                                   width: holderView.frame.size.width-60,
                                                   height: holderView.frame.size.width-60)
            })
        } else {
            //play
            player?.play()
            playPauseButton.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
            UIView.animate(withDuration: 0.2, animations: { [self] in
                self.albumImageView.frame = CGRect(x: 10, y: 10, width: holderView.frame.size.width-20, height: holderView.frame.size.width-20)
            })
        }
    }
    @objc func didTapBack() {
        if position > 0 {
            position = position - 1
            player?.stop()
            for subView in holderView.subviews {
                subView.removeFromSuperview()
            }
            configure()
        }
    }
    
    @objc func didTapNext() {
        if position > songs.count - 1 {
            position = position + 1
            player?.stop()
            for subView in holderView.subviews {
                subView.removeFromSuperview()
            }
            configure()
        }
    }
    func setupUI() {
        holderView = UIView()
        holderView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(holderView)
        
        NSLayoutConstraint.activate([holderView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
                                     holderView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
                                     holderView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
                                     holderView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)])
    }
}
