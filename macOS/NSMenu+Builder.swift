import AppKit

public enum MenuItem {
    /**
     * A clickable menu item with the given label, callback, and hotkey.
     */
    case action(
        title: String,
        action: Selector,
        keyEquivalent: String = "",
        keyEquivalentModifierMask: NSEvent.ModifierFlags = NSEvent.ModifierFlags()
    )

    /**
     * A submenu with the given label and children.
     */
    case submenu(title: String, children: [MenuItem])

    /**
     * A separator item.
     */
    case separator
}

public extension NSMenu {
    static func make(title: String, children: [MenuItem]) -> NSMenu {
        let menu = NSMenu(title: title)
        children.forEach { menu.addItem(self.makeItem(root: $0)) }
        return menu
    }

    private static func makeItem(root: MenuItem) -> NSMenuItem {
        switch root {
        case .action(let title, let action, let keyEquivalent, let keyEquivalentModifierMask):
            let item = NSMenuItem(title: title, action: action, keyEquivalent: keyEquivalent)
            item.keyEquivalentModifierMask = keyEquivalentModifierMask
            return item
        case .submenu(let title, let children):
            let item = NSMenuItem(title: title, action: nil, keyEquivalent: "")
            item.submenu = self.make(title: title, children: children)
            return item
        case .separator:
            return NSMenuItem.separator()
        }
    }
}
