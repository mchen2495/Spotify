//
//  ActionLabelView.swift
//  Spotify
//
//  Created by Michael Chen on 3/14/21.
//

import UIKit

struct ActionLabelViewViewModel {
    let text: String
    let actionTitle: String
}

protocol ActionLabelViewDelegate: AnyObject {
    func actionLabelViewDidTapButton(_ actionView: ActionLabelView)
}

//used in albums view in library view controller
class ActionLabelView: UIView {
    
    weak var delegate: ActionLabelViewDelegate?
    
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.setTitleColor(.link, for: .normal)
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        addSubview(button)
        addSubview(label)
        isHidden = true
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    @objc func didTapButton(){
        delegate?.actionLabelViewDidTapButton(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        button.frame = CGRect(x: 0, y: height-40, width: width, height: 40)
        label.frame = CGRect(x: 0, y: 0, width: width, height: height - 45)
    }
    
    
    func configure(with viewModel: ActionLabelViewViewModel) {
        label.text = viewModel.text
        button.setTitle(viewModel.actionTitle, for: .normal)
    }
    
    
    
}
