import UIKit

class DetailButton: UIButton {
    var labelText: String = "" {
        didSet {
            updateText()
        }
    }

    var insets: UIEdgeInsets
    init(insets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)) {
        self.insets = insets
        super.init(frame: .zero)
        setupButton()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let buttonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "plane")
        return imageView
    }()

    private let buttonLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = AppFont.poppinsRegular.withSize(10)
        label.text = "Add"
        return label
    }()

    private func setupButton() {
        addSubviews(buttonLabel, buttonImageView)
        backgroundColor = AppColor.primary.color
        setupLayout()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners(corners: [.topLeft, .bottomLeft, .topRight], radius: 16)
    }

    private func updateText() {
        buttonLabel.text = labelText
    }

    private func setupLayout() {
        buttonImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.centerX.equalToSuperview()
            make.width.equalTo(22)
            make.height.equalTo(18)
        }
        buttonLabel.snp.makeConstraints { make in
            make.top.equalTo(buttonImageView.snp.bottom)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-8)
        }
    }
}
