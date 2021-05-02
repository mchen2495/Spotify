//
//  AlbumTrackCollectionViewCell.swift
//  Spotify
//
//  Created by Michael Chen on 3/4/21.
//

import UIKit

//used in album view controller, when you select a album in the new releases
class AlbumTrackCollectionViewCell: UICollectionViewCell {
    static let identifier = "AlbumTrackCollectionViewCell"
        
    private let trackNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .thin)
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(trackNameLabel)
        contentView.addSubview(artistNameLabel)
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //use 196 as contentView.height for reference
        trackNameLabel.frame = CGRect(x: 10,
                                      y: 0,
                                      width: contentView.width-15,
                                      height: contentView.height/2)
        
        artistNameLabel.frame = CGRect(x: 10,
                                       y: contentView.height/2,
                                       width: contentView.width-15,
                                       height: contentView.height/2)
        
        
    }
    
    //when we want to reuse a cell
    override func prepareForReuse() {
        trackNameLabel.text = nil
        artistNameLabel.text = nil
        
    }
    
    func configure(with viewModel: AlbumCollectionViewCellViewModel){
        trackNameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artistName
    }
    
    
    
}
