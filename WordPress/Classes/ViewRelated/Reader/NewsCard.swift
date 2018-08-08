import UIKit
import WordPressShared.WPStyleGuide
import Gridicons

/// UI of the New Card
final class NewsCard: UIViewController {
    @IBOutlet weak var dismiss: UIButton!
    @IBOutlet weak var illustration: UIImageView!
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var newsSubtitle: UILabel!
    @IBOutlet weak var readMore: UIButton!
    @IBOutlet weak var borderedView: UIView!

    private let manager: NewsManager

    init(manager: NewsManager) {
        self.manager = manager
        super.init(nibName: "NewsCard", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        applyStyles()
        loadContent()
        prepareForVoiceOver()
    }

    private func applyStyles() {
        styleBackground()
        styleBorderedView()
        styleLabels()
        styleReadMoreButton()
        styleDismissButton()
    }

    private func setupUI() {
        setUpDismissButton()
        populateIllustration()
    }

    private func setUpDismissButton() {
        dismiss.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
    }

    private func populateIllustration() {
        illustration.image = UIImage(named: "wp-illustration-notifications")
    }

    @objc private func dismissAction() {
        manager.dismiss()
    }

    private func loadContent() {
        manager.load { [weak self] newsItem in
            switch newsItem {
            case .error(let error):
                self?.errorLoading(error)
            case .success(let item):
                self?.populate(item)
            }
        }
    }

    private func styleBackground() {
        view.backgroundColor = WPStyleGuide.greyLighten30()
    }

    private func styleBorderedView() {
        borderedView.layer.borderColor = WPStyleGuide.readerCardCellBorderColor().cgColor
        borderedView.layer.borderWidth = 1.0
    }

    private func styleLabels() {
        WPStyleGuide.applyReaderStreamHeaderTitleStyle(newsTitle)
        WPStyleGuide.applyReaderStreamHeaderDetailStyle(newsSubtitle)
    }

    private func styleReadMoreButton() {
        readMore.setTitle("Read More", for: .normal)
    }

    private func styleDismissButton() {
        let dismissIcon = Gridicon.iconOfType(.crossCircle, withSize: CGSize(width: 40, height: 40))
        dismiss.setImage(dismissIcon, for: .normal)
        dismiss.setTitle(nil, for: .normal)
    }

    private func errorLoading(_ error: Error) {
        manager.dismiss()
    }

    private func populate(_ item: NewsItem) {
        let title = item.title
        let content = item.content

        newsTitle.text = title
        newsSubtitle.text = content

        prepareTitleForVoiceOver(label: title)
        prepareSubtitleForVoiceOver(label: content)
    }
}

// MARK: - Accessibility
extension NewsCard: Accessible {
    func prepareForVoiceOver() {
        prepareDismissButtonForVoiceOver()
        prepareReadMoreButtonForVoiceOver()
    }

    private func prepareDismissButtonForVoiceOver() {
        dismiss.accessibilityLabel = NSLocalizedString("Dismiss", comment: "Accessibility label for the Dismiss button on Reader's News Card")
        dismiss.accessibilityTraits = UIAccessibilityTraitButton
        dismiss.accessibilityHint = NSLocalizedString("Dimisses the News Card.", comment: "Accessibility hint for the dismiss button on Reader's News Card")
    }

    fileprivate func prepareTitleForVoiceOver(label: String) {
        newsTitle.accessibilityLabel = label
        newsTitle.accessibilityTraits = UIAccessibilityTraitStaticText
    }

    fileprivate func prepareSubtitleForVoiceOver(label: String) {
        newsSubtitle.accessibilityLabel = label
        newsSubtitle.accessibilityTraits = UIAccessibilityTraitStaticText
    }

    private func prepareReadMoreButtonForVoiceOver() {
        readMore.accessibilityLabel = NSLocalizedString("Read More", comment: "Accessibility label for the Read More button on Reader's News Card")
        dismiss.accessibilityTraits = UIAccessibilityTraitButton
        dismiss.accessibilityHint = NSLocalizedString("Provides more information.", comment: "Accessibility hint for the Read More button on Reader's News Card")
    }
}