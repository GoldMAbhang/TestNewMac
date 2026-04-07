//
//  TimelineCell.swift
//  TestNewMac
//
//  Created by Abhang on 17/03/26.
//

import UIKit

class TimelineCell: UICollectionViewCell {
    
    // MARK: - Core Timeline Views
    
    let circleView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.gray.cgColor
        return view
    }()
    
    let horizontalLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    let verticalLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.4)
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    // Optional: label inside card
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    // Layout flag
    var isTopLayout: Bool = true
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        contentView.addSubview(horizontalLineView)
        contentView.addSubview(circleView)
        contentView.addSubview(verticalLineView)
        contentView.addSubview(cardView)
        
        cardView.addSubview(titleLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let centerY = contentView.bounds.midY
        let centerX = contentView.bounds.midX
        
        // Circle
        circleView.frame = CGRect(
            x: centerX - 10,
            y: centerY - 10,
            width: 20,
            height: 20
        )
        
        // Horizontal line
        horizontalLineView.frame = CGRect(
            x: circleView.frame.midX,
            y: centerY,
            width: contentView.bounds.width / 2,
            height: 2
        )
        
        let isTop = isTopLayout   // store this bool
        
        let cardHeight: CGFloat = 100
        let spacing: CGFloat = 10
        
        if isTop {
            // Card ABOVE
            cardView.frame = CGRect(
                x: -20,
                y: centerY - 10 - spacing - cardHeight,
                width: contentView.bounds.width + 70,
                height: cardHeight
            )
            
            // Vertical line (upwards)
            verticalLineView.frame = CGRect(
                x: centerX - 1,
                y: cardView.frame.maxY,
                width: 2,
                height: spacing
            )
            
        } else {
            // Card BELOW
            cardView.frame = CGRect(
                x: -20,
                y: centerY + 10 + spacing,
                width: contentView.bounds.width + 70,
                height: cardHeight
            )
            
            // Vertical line (downwards)
            verticalLineView.frame = CGRect(
                x: centerX - 1,
                y: circleView.frame.maxY,
                width: 2,
                height: spacing
            )
        }
    }

    func configure(item: TimelineItem, index: Int) {
        
        isTopLayout = index % 2 == 0
        
        setNeedsLayout()
        
        // Style
        circleView.backgroundColor = item.isCompleted ? .systemGreen : .white
        
        cardView.backgroundColor = .lightGray
        cardView.layer.cornerRadius = 8
    }
}
