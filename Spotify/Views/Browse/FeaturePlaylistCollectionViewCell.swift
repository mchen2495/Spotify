//
//  FeaturePlaylistCollectionViewCell.swift
//  Spotify
//
//  Created by Michael Chen on 3/1/21.
//

import UIKit

//used in the feature play list section in the home view
class FeaturePlaylistCollectionViewCell: UICollectionViewCell {
    static let identifier = "FeaturePlaylistCollectionViewCell"
    
    private let playlistCoverImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let playlistNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let creatorNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .thin)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(playlistCoverImageView)
        contentView.addSubview(playlistNameLabel)
        contentView.addSubview(creatorNameLabel)
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        creatorNameLabel.frame = CGRect(x: 3,
                                        y: contentView.height-45,
                                        width: contentView.width-6,
                                        height: 45)
        
        //use 196 as contentView.height for reference
        playlistNameLabel.frame = CGRect(x: 3,
                                         y: contentView.height-70,
                                         width: contentView.width-6,
                                         height: 45)
        
        let imageSize = contentView.height-70
        //center image view in x axis
        playlistCoverImageView.frame = CGRect(x: (contentView.width-imageSize)/2,
                                              y: 3,
                                              width: imageSize,
                                              height: imageSize)
        
        
    }
    
    //when we want to reuse a cell
    override func prepareForReuse() {
        playlistNameLabel.text = nil
        creatorNameLabel.text = nil
        playlistCoverImageView.image = nil
        
    }
    
    func configure(with viewModel: FeaturePlaylistCellViewModel){
        playlistNameLabel.text = viewModel.name
        creatorNameLabel.text = viewModel.creatorName
        playlistCoverImageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
    }
    
    
    
}
