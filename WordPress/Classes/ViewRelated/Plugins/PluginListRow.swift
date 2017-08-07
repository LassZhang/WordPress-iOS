import Gridicons

struct PluginListRow: ImmuTableRow {
    static let cell = ImmuTableCell.class(WPTableViewCellSubtitle.self)
    let name: String
    let version: String?
    let action: ImmuTableAction? = nil

    func configureCell(_ cell: UITableViewCell) {
        WPStyleGuide.configureTableViewSmallSubtitleCell(cell)
        cell.textLabel?.text = name
        cell.detailTextLabel?.text = version
        cell.selectionStyle = .none
        cell.imageView?.image = Gridicon.iconOfType(.plugins)
    }
}
