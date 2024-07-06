import UIKit

/**
 * Denotes the type of the preference cell you want.
 */
enum PreferenceType {
    /**
     * A cell with a clickable button.
     */
    case button(label: String)

    /**
     * A cell with an on/off switch.
     */
    case `switch`(label: String)
}

/**
 * Represents a single preference cell.
 */
struct Preference {
    let id: String
    let type: PreferenceType
}

/**
 * Represents a group of preference cells, with an optional header and footer.
 */
struct PreferenceSection {
    let header: String?
    let footer: String?
    let preferences: [Preference]
}

/**
 * Represents the root of your preference tree.
 */
struct PreferenceRoot {
    let sections: [PreferenceSection]
}

/**
 * This is the public preference change protocol that listeners should
 * implement.
 */
@objc
protocol PreferenceDelegate: AnyObject {
    /**
     * Indicates a button preference was clicked.
     */
    @objc
    optional func preferenceView(didClickButton id: String)

    /**
     * Returns the initial value of the given switch preference.
     */
    @objc
    optional func preferenceView(initialSwitchValue id: String) -> Bool

    /**
     * Indicates a switch preference was toggled.
     */
    @objc
    optional func preferenceView(didSetSwitchValue id: String, newValue: Bool)
}

/**
 * Internal delegate for callbacks from the cell to the view controller.
 */
fileprivate protocol PreferenceCellDelegate: AnyObject {
    func preferenceCellDidUpdate(_ sender: PreferenceCell)
}

/**
 * Base class for all preference cells.
 */
fileprivate class PreferenceCell: UITableViewCell {
    var preferenceID: String?
    weak var delegate: PreferenceCellDelegate?
}

/**
 * Preference cell that acts as a button.
 */
fileprivate class ButtonCell: PreferenceCell {
    static let reuseIdentifier = NSStringFromClass(ButtonCell.self)

    required init?(coder: NSCoder) {
        abort()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .default
    }

    func setLabel(_ text: String) {
        var contentConfig = self.defaultContentConfiguration()
        contentConfig.text = text
        contentConfig.textProperties.color = .accent
        self.contentConfiguration = contentConfig
    }
}

/**
 * Preference cell that contains a switch.
 */
fileprivate class SwitchCell: PreferenceCell {
    static let reuseIdentifier = NSStringFromClass(SwitchCell.self)

    private var switchView: UISwitch {
        return self.accessoryView as! UISwitch
    }

    var isOn: Bool {
        get {
            return self.switchView.isOn
        }
        set {
            self.switchView.isOn = newValue
        }
    }

    required init?(coder: NSCoder) {
        abort()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.accessoryView = UISwitch()
        self.selectionStyle = .none
        self.switchView.addTarget(
            self,
            action: #selector(self.switchValueDidChange),
            for: .valueChanged
        )
    }

    func setLabel(_ text: String) {
        var contentConfig = self.defaultContentConfiguration()
        contentConfig.text = text
        self.contentConfiguration = contentConfig
    }

    @objc
    private func switchValueDidChange() {
        self.delegate?.preferenceCellDidUpdate(self)
    }
}

/**
 * Provides a static UITableView that displays preferences, as defined
 * by a PreferenceRoot model object.
 */
class PreferenceViewController
    : UITableViewController
    , UITextViewDelegate
    , PreferenceCellDelegate
{
    private let root: PreferenceRoot

    /**
     * Receive preference actions and change callbacks via this delegate.
     */
    weak var delegate: PreferenceDelegate?

    required init?(coder: NSCoder) {
        abort()
    }

    init(root: PreferenceRoot) {
        self.root = root
        super.init(style: UITableView.Style.insetGrouped)
    }

    override func viewDidLoad() {
        self.tableView.register(
            ButtonCell.self,
            forCellReuseIdentifier: ButtonCell.reuseIdentifier
        )
        self.tableView.register(
            SwitchCell.self,
            forCellReuseIdentifier: SwitchCell.reuseIdentifier
        )
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return root.sections.count
    }

    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return root.sections[section].preferences.count
    }

    override func tableView(
        _ tableView: UITableView,
        titleForHeaderInSection section: Int
    ) -> String? {
        return root.sections[section].header
    }

    override func tableView(
        _ tableView: UITableView,
        titleForFooterInSection section: Int
    ) -> String? {
        return root.sections[section].footer
    }

    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let pref = self.root.sections[indexPath.section].preferences[indexPath.row]
        switch pref.type {
        case .button(let label):
            let cell = tableView.dequeueReusableCell(
                withIdentifier: ButtonCell.reuseIdentifier,
                for: indexPath
            ) as! ButtonCell
            cell.preferenceID = pref.id
            cell.setLabel(label)
            cell.delegate = self
            return cell
        case .switch(let label):
            let cell = tableView.dequeueReusableCell(
                withIdentifier: SwitchCell.reuseIdentifier,
                for: indexPath
            ) as! SwitchCell
            cell.isOn = self.delegate!.preferenceView!(initialSwitchValue: pref.id)
            cell.preferenceID = pref.id
            cell.setLabel(label)
            cell.delegate = self
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Remove cell highlight for buttons
        tableView.deselectRow(at: indexPath, animated: true)

        // If this is a button preference, trigger the callback
        if let buttonCell = tableView.cellForRow(at: indexPath) as? ButtonCell {
            self.delegate!.preferenceView!(didClickButton: buttonCell.preferenceID!)
        }
    }

    fileprivate func preferenceCellDidUpdate(_ sender: PreferenceCell) {
        switch sender {
        case is ButtonCell:
            // Button cells are kind of special in that they don't
            // handle their own clicks, but rather, the entire cell is
            // selected and handled by ourselves, so this is a no-op.
            break
        case let switchCell as SwitchCell:
            self.delegate!.preferenceView!(
                didSetSwitchValue: switchCell.preferenceID!,
                newValue: switchCell.isOn
            )
        default:
            abort()
        }
    }
}
