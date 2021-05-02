//
//  NewReleaseCollectionViewCell.swift
//  Spotify
//
//  Created by Michael Chen on 3/1/21.
//

import UIKit
import SDWebImage

//struct NewReleasesCellViewModel {
//    let name: String
//    let artworkURL: URL?
//    let numberOfTracks: Int
//    let artistName: String
//}

//used in the new release section in home view
class NewReleaseCollectionViewCell: UICollectionViewCell {
    static let identifier = "NewReleaseCollectionViewCell"
    
    private let albumCoverImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let albumNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    
    private let numberOfTracksLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .light)
        label.numberOfLines = 0
        return label
    }()
    
    private let artistsNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .thin)
        //label.textColor = .red
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(albumCoverImageView)
        contentView.addSubview(albumNameLabel)
        contentView.addSubview(artistsNameLabel)
        contentView.clipsToBounds = true
        contentView.addSubview(numberOfTracksLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize : CGFloat = contentView.height - 10
        //subtraction is omitting the space that the label can use
        let albumLabelSize = albumNameLabel.sizeThatFits(CGSize(width: contentView.width - imageSize-10,
                                                                height: contentView.height - 10))
        albumNameLabel.sizeToFit()
        artistsNameLabel.sizeToFit()
        numberOfTracksLabel.sizeToFit()
        
        //place image 5 pts to the right and 5 pts down of content view (the cell)
        albumCoverImageView.frame = CGRect(x: 5, y: 5, width: imageSize, height: imageSize)
        
        let albumLabelHeight = min(60, albumLabelSize.height)
        
        //place label 10 pt to right of image and 5 pts down of content view (the cell)
        albumNameLabel.frame = CGRect(x: albumCoverImageView.right + 10,
                                      y: 5,
                                      width: albumLabelSize.width,
                                      height: albumLabelHeight)
        
        artistsNameLabel.frame = CGRect(x: albumCoverImageView.right + 10,
                                        y: albumNameLabel.bottum,
                                        width: contentView.width - albumCoverImageView.right-10,
                                        height: 30)
        
        
        numberOfTracksLabel.frame = CGRect(x: albumCoverImageView.right + 10,
                                           y: albumCoverImageView.bottum - 45,
                                           width: numberOfTracksLabel.width,
                                           height: 50)
        
    }
    
    //when we want to reuse a cell
    override func prepareForReuse() {
        albumNameLabel.text = nil
        artistsNameLabel.text = nil
        numberOfTracksLabel.text = nil
        albumCoverImageView.image = nil
        
    }
    
    func configure(with viewModel: NewReleasesCellViewModel){
        albumNameLabel.text = viewModel.name
        artistsNameLabel.text = viewModel.artistName
        numberOfTracksLabel.text = "Tracks: \(viewModel.numberOfTracks)"
        albumCoverImageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
    }
}
