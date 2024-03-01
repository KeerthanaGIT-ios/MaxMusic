//
//  ViewController.swift
//  MaxMusic
//
//  Created by APPLE on 29/01/24.
//

import UIKit

class ViewController: UIViewController {
    
    //SubViews
    var musicTable = UITableView()
    var songs = [Song]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.configureSongs()
        self.setupUI()
    }

    func setupUI() {
        musicTable = UITableView()
        musicTable.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(musicTable)
        musicTable.dataSource = self
        musicTable.delegate = self
        musicTable.showsVerticalScrollIndicator = false
        musicTable.showsHorizontalScrollIndicator = false
        musicTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        NSLayoutConstraint.activate([musicTable.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
                                     musicTable.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
                                     musicTable.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
                                     musicTable.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)])
    }
    func configureSongs() {
        songs.append(Song(name: "Background music", albumName: "Other", artistName: "Rnado", imageName: "cover1", trackName: "song1"))
        songs.append(Song(name: "Havana", albumName: "Havana Album", artistName: "Camillo Cambella", imageName: "cover2", trackName: "song2"))
        songs.append(Song(name: "Viva La Vida", albumName: "Something", artistName: "Coldplay", imageName: "cover3", trackName: "song3"))
        songs.append(Song(name: "Background music", albumName: "Other", artistName: "Rnado", imageName: "cover1", trackName: "song1"))
        songs.append(Song(name: "Havana", albumName: "Havana Album", artistName: "Camillo Cambella", imageName: "cover2", trackName: "song2"))
        songs.append(Song(name: "Viva La Vida", albumName: "Something", artistName: "Coldplay", imageName: "cover3", trackName: "song3"))
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var config = cell.defaultContentConfiguration()
        //data
        let songs = songs[indexPath.row]
        config.text = songs.name
        config.secondaryText = songs.albumName
        config.image = UIImage(named: songs.imageName)
        config.textProperties.font = UIFont(name: "Helvetica-Bold", size: 18)!
        config.secondaryTextProperties.font = UIFont(name: "Helvetica", size: 17)!
        config.imageProperties.maximumSize = CGSize(width: 100, height: 100)
        cell.contentConfiguration = config
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //prsent the player
        let position = indexPath.row
        
        //songs
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "player") as? PlayerViewController else {
            return
        }
        vc.position = position
        vc.songs = songs
        present(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
