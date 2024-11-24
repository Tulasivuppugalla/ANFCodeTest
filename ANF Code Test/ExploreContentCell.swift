
import UIKit

class ExploreContentCell: UITableViewCell {

    // MARK: - UI Elements
    var backgroundImageView: UIImageView!
    var topDescriptionLabel: UILabel!
    var titleLabel: UILabel!
    var promoMessageLabel: UILabel!
    var bottomDescriptionTextView: UITextView!
    var contentStackView: UIStackView!
    var activityIndicator: UIActivityIndicatorView!

    // MARK: - Constants
    private let backgroundImageHeight: CGFloat = 200
    private let backgroundImageWidth: CGFloat = UIScreen.main.bounds.width
    private let padding: CGFloat = 15
    private let labelHeight: CGFloat = 20
    private let buttonHeight: CGFloat = 40
    private let stackSpacing: CGFloat = 8

    // MARK: - Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup UI
    private func setupUI() {
        backgroundImageView = UIImageView()
        backgroundImageView.contentMode = .scaleAspectFit
        backgroundImageView.clipsToBounds = true
        contentView.addSubview(backgroundImageView)

        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.hidesWhenStopped = true
        contentView.addSubview(activityIndicator)

        topDescriptionLabel = UILabel()
        topDescriptionLabel.font = UIFont.systemFont(ofSize: 13)
        topDescriptionLabel.textColor = .darkGray
        topDescriptionLabel.textAlignment = .center
        contentView.addSubview(topDescriptionLabel)

        titleLabel = UILabel()
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        contentView.addSubview(titleLabel)

        promoMessageLabel = UILabel()
        promoMessageLabel.font = UIFont.systemFont(ofSize: 11)
        promoMessageLabel.textColor = .gray
        promoMessageLabel.textAlignment = .center
        contentView.addSubview(promoMessageLabel)

        bottomDescriptionTextView = UITextView()
        bottomDescriptionTextView.isEditable = false
        bottomDescriptionTextView.isSelectable = true
        bottomDescriptionTextView.font = UIFont.systemFont(ofSize: 13)
        bottomDescriptionTextView.textColor = .darkGray
        bottomDescriptionTextView.textAlignment = .center
        contentView.addSubview(bottomDescriptionTextView)

        contentStackView = UIStackView()
        contentStackView.axis = .vertical
        contentStackView.spacing = stackSpacing
        contentStackView.alignment = .fill
        contentStackView.distribution = .fillProportionally
        contentView.addSubview(contentStackView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        // Layout for background image
        backgroundImageView.frame = CGRect(x: 0, y: 0, width: backgroundImageWidth, height: backgroundImageHeight)

        // Center the activity indicator in the background image view
        activityIndicator.center = backgroundImageView.center

        // Layout for labels
        var currentY: CGFloat = backgroundImageView.frame.maxY + 10

        // Top Description Label
        topDescriptionLabel.frame = CGRect(x: padding, y: currentY, width: contentView.frame.width - 2 * padding, height: labelHeight)
        currentY = topDescriptionLabel.frame.maxY + 5

        // Title Label
        titleLabel.frame = CGRect(x: padding, y: currentY, width: contentView.frame.width - 2 * padding, height: labelHeight)
        currentY = titleLabel.frame.maxY + 5

        // Promo Message Label (conditionally show it or hide it)
        let promoMessageHeight: CGFloat = promoMessageLabel.isHidden || (promoMessageLabel.text?.isEmpty ?? true) ? 0 : labelHeight
        promoMessageLabel.frame = CGRect(x: padding, y: currentY, width: contentView.frame.width - 2 * padding, height: promoMessageHeight)
        currentY = promoMessageLabel.frame.maxY + (promoMessageHeight > 0 ? 5 : 0)

        // Bottom Description TextView (dynamically adjust height based on content)
        let bottomDescriptionHeight = calculateTextViewHeight(for: bottomDescriptionTextView)
        
        // Check if bottomDescriptionTextView should be shown
        if bottomDescriptionHeight > 0 {
            bottomDescriptionTextView.frame = CGRect(x: padding, y: currentY, width: contentView.frame.width - 2 * padding, height: bottomDescriptionHeight)
            currentY = bottomDescriptionTextView.frame.maxY + 10
        } else {
            // If not shown, do not increment currentY for bottom description
            bottomDescriptionTextView.frame = .zero // Optionally hide it by setting frame to zero
        }

        // Adjust currentY for the case when both promoMessageLabel and bottomDescriptionTextView are not present
        if (promoMessageLabel.text?.isEmpty ?? true) && (bottomDescriptionTextView.text?.isEmpty ?? true) {
            currentY -= 40  // Adjust to move the stack view up if both are missing/empty
        }

        // Layout Stack View for buttons
        var contentStackViewYPosition = currentY

        // Calculate the total height of the stack view buttons
        var contentStackHeight: CGFloat = 0
        for button in contentStackView.arrangedSubviews {
            if let button = button as? UIButton {
                contentStackHeight += buttonHeight + stackSpacing
            }
        }

        // Set the stack view frame
        contentStackView.frame = CGRect(x: padding, y: contentStackViewYPosition, width: contentView.frame.width - 2 * padding, height: contentStackHeight)

        // Layout each button in the stack view
        var buttonYOffset: CGFloat = 0
        for button in contentStackView.arrangedSubviews {
            if let button = button as? UIButton {
                button.frame = CGRect(x: 0, y: buttonYOffset, width: contentStackView.frame.width, height: buttonHeight)
                buttonYOffset += buttonHeight + stackSpacing
            }
        }
    }

    private func calculateTextViewHeight(for textView: UITextView) -> CGFloat {
        guard let text = textView.text else { return 0 }

        let textViewSize = textView.sizeThatFits(CGSize(width: contentView.frame.width - 2 * padding, height: CGFloat.greatestFiniteMagnitude))
        return textViewSize.height
    }

    // MARK: - Configuration
    func configure(with promoItem: PromoItem) {
        // Start loading indicator when image starts fetching
        activityIndicator.startAnimating()

        // Check if the backgroundImage URL is valid
        if let urlString = promoItem.backgroundImage, let url = URL(string: urlString) {
            // Load the image and display it
            loadImage(from: url)
            backgroundImageView.isHidden = false
        } else {
            // Hide the background image if the URL is invalid or empty
            backgroundImageView.isHidden = true
            activityIndicator.stopAnimating() // Stop the loading spinner
        }

        // Set labels' text based on the promo item
        topDescriptionLabel.text = promoItem.topDescription
        titleLabel.text = promoItem.title
        promoMessageLabel.text = promoItem.promoMessage
        if let bottomDescription = promoItem.bottomDescription {
            let styledString = htmlStringToAttributedString(htmlString: bottomDescription)
            bottomDescriptionTextView.attributedText = styledString
            bottomDescriptionTextView.isHidden = false
        } else {
            bottomDescriptionTextView.isHidden = true
        }

        // Clear previous buttons in stack view
        contentStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        if let contentItems = promoItem.content {
            for contentItem in contentItems {
                let button = UIButton(type: .system)
                button.setTitle(contentItem.title, for: .normal)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
                button.addTarget(self, action: #selector(contentButtonTapped(_:)), for: .touchUpInside)
                button.accessibilityHint = contentItem.target

                // Add border around each button
                button.layer.borderWidth = 1
                button.layer.borderColor = UIColor.lightGray.cgColor
                button.layer.cornerRadius = 5

                contentStackView.addArrangedSubview(button)
            }
        }

        // Force layout update after configuring
        setNeedsLayout()
    }

    // MARK: - Button Action
    @objc private func contentButtonTapped(_ sender: UIButton) {
        guard let targetURLString = sender.accessibilityHint, let targetURL = URL(string: targetURLString) else { return }
        UIApplication.shared.open(targetURL)
    }

    // MARK: - Image Loading
    private func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            if let data = data, error == nil, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.backgroundImageView.image = image
                    // Stop the activity indicator once image is loaded
                    self?.activityIndicator.stopAnimating()
                    self?.setNeedsLayout()  // Trigger layout update after the image is loaded
                }
            }
        }.resume()
    }

    // MARK: - HTML to Attributed String
    private func htmlStringToAttributedString(htmlString: String) -> NSAttributedString {
        if let data = htmlString.data(using: .utf8) {
            do {
                let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf8.rawValue
                ]
                let attributedString = try NSAttributedString(data: data, options: options, documentAttributes: nil)
                return attributedString
            } catch {
                print("Error parsing HTML string: \(error)")
            }
        }
        return NSAttributedString(string: htmlString)
    }
}
