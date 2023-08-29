import Kingfisher
import UIKit

extension UIImage {
    enum ImageFormat {
        case jpeg(compressionQuality: CGFloat)
        case png
    }
    
    func convertToData(withFormat format: ImageFormat) -> Data? {
        switch format {
        case .jpeg(let compressionQuality):
            return self.jpegData(compressionQuality: compressionQuality)
        case .png:
            return self.pngData()
        }
    }
}

extension String {
    var isValidURL: Bool {
        if let url = URL(string: self), UIApplication.shared.canOpenURL(url) {
            return true
        }
        return false
    }
}

extension String {
    func formatISO8601ToCustomFormat() -> String {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withFractionalSeconds, .withFullDate, .withFullTime, .withTimeZone]

        if let date = dateFormatter.date(from: self) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "dd MMMM yyyy"
            let formattedDate = outputFormatter.string(from: date)
            return formattedDate
        }
        return self
    }
}

extension UIImage {
    func resized(to newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage ?? self
    }
}

extension UIImageView {
    func loadImage(_ url: URL?) {
        self.kf.indicatorType = .activity
        self.kf.setImage(with: url)
    }

    func loadImage(_ url: String?) {
        guard let urlStr = url else { return }
        self.kf.setImage(with: URL(string: urlStr))
    }
}

extension UIView {
    /// Add multiple subview to a view.
    /// - Parameter view: It is a subviews array which add to parent view
    func addSubviews(_ view: UIView...) {
        view.forEach { v in
            self.addSubview(v)
        }
    }

    func addCornerRadiusToTopLeft(withRadius radius: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: bounds,
                                    byRoundingCorners: [.topLeft],
                                    cornerRadii: CGSize(width: radius, height: radius))
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = maskPath.cgPath
        layer.mask = shapeLayer
    }

    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }

    func animateBorderColor(toColor: UIColor, duration: Double) {
        let animation = CABasicAnimation(keyPath: "borderColor")
        animation.fromValue = layer.borderColor
        animation.toValue = toColor.cgColor
        animation.duration = duration
        layer.add(animation, forKey: "borderColor")
        layer.borderColor = toColor.cgColor
    }

    func addDashedBorder(color: UIColor) {
        let color = color.cgColor

        let shapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width - 2, height: frameSize.height)

        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width / 2, y: frameSize.height / 2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 1.5
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [4, 4]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 0).cgPath
        self.layer.addSublayer(shapeLayer)
    }

    func rotate(angle: CGFloat) {
        let radians = angle / 180.0 * CGFloat.pi
        let rotation = self.transform.rotated(by: radians)
        self.transform = rotation
    }

    var globalPoint: CGPoint? {
        return self.superview?.convert(self.frame.origin, to: nil)
    }
}

extension URL {
    func toImage(completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: self) { data, _, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }

            let image = UIImage(data: data)
            completion(image)
        }.resume()
    }
}

extension UIColor {
    class func applyGradient(colors: [UIColor], bounds: CGRect) -> UIColor {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)

        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return UIColor(patternImage: image!)
    }
}

extension UITextField {
    var placeholder: String? {
        get {
            attributedPlaceholder?.string
        }

        set {
            guard let newValue = newValue else {
                attributedPlaceholder = nil
                return
            }
            let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.blue]
            let attributedText = NSAttributedString(string: newValue, attributes: attributes)
            attributedPlaceholder = attributedText
        }
    }
}

enum FormatType: String {
    case longFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    case longWithoutZone = "yyyy-MM-dd'T'HH:mm:ss"
    case withoutYear = "dd MMMM"
    case localeStandard = "dd.MM.yyyy"
    case standard = "yyyy-MM-dd"
    case dateAndTime = "dd.MM.yyyy'T'HH:mm"
    case time = "HH:mm"
}

extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach {
            self.addArrangedSubview($0)
        }
    }
}

extension UIViewController {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }

    func showDeleteConfirmationAlert(completion: @escaping (Bool) -> Void) {
        let alertController = UIAlertController(title: "Confirm Deletion", message: "Are you sure you want to delete this item?", preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            completion(false)
        }

        let deleteConfirmAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            completion(true)
        }

        alertController.addAction(cancelAction)
        alertController.addAction(deleteConfirmAction)

        present(alertController, animated: true, completion: nil)
    }

    func showEditConfirmationAlert(completion: @escaping (Bool) -> Void) {
        let alertController = UIAlertController(title: "Confirm Edit", message: "Are you sure you want to edit this item?", preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            completion(false)
        }

        let editConfirmAction = UIAlertAction(title: "Edit", style: .default) { _ in
            completion(true)
        }

        alertController.addAction(cancelAction)
        alertController.addAction(editConfirmAction)

        present(alertController, animated: true, completion: nil)
    }
}
