import Foundation
import SwiftUI

struct DesignBook {

    struct Design {
        struct Size {
            struct CornerRadius {
                /// small, 8pt
                static let small = 8.0
                /// medium, 25pt
                static let medium = 25.0
            }
            struct Frame {
                struct Width {
                    /// small, 50pt
                    static let small = 50.0
                    /// medium, 100pt
                    static let medium = 100.0
                    /// large, 300pt
                    static let large =  300.0
                }
                struct Height {
                    /// small, 50pt
                    static let small = 50.0
                    /// medium, 100pt
                    static let medium = 100.0
                    /// large, 300pt
                    static let large =  300.0
                }
            }
        }
        struct Padding {
            /// extra small, 5pt
            static let extraSmall = 5.0
            /// small, 7pt
            static let small = 7.0
            /// medium, 10pt
            static let medium = 10.0
            /// large,  25pt
            static let large = 25.0
            /// extra large,  30pt
            static let extraLarge = 30.0
        }
        struct Spacing {
            /// small, 30pt
            static let small = 30.0
        }
        struct Image {
            static let stack = #imageLiteral(resourceName: "stack")
        }

        struct Color {
            struct ColorWrapper {
                let name: String
                func uiColor() -> UIColor {
                    return UIColor(named: name)!
                }
                func swiftUIColor() -> SwiftUI.Color {
                    return SwiftUI.Color(name, bundle: nil)
                }
            }

            struct Background {
                static let main = ColorWrapper(name: "color-background-main")
                static let list = ColorWrapper(name: "color-background-list")
                static let inverse = ColorWrapper(name: "color-background-inverse")
            }

            struct Foreground {
                static let highlighted = ColorWrapper(name: "color-foreground-highlighted")
                static let action = ColorWrapper(name: "color-foreground-action")
                static let element = ColorWrapper(name: "color-foreground-element")
                static let inverse = ColorWrapper(name: "color-foreground-inverse")
                static let light = ColorWrapper(name: "color-foreground-light")

                static let purple = ColorWrapper(name: "color-foreground-purple")
                static let orange = ColorWrapper(name: "color-foreground-orange")
                static let green = ColorWrapper(name: "color-foreground-green")
                static let blue = ColorWrapper(name: "color-foreground-blue")
                static let yellow = ColorWrapper(name: "color-foreground-yellow")
                static let red = ColorWrapper(name: "color-foreground-red")
            }
        }
    }

    struct Text {
        struct CharactersList {

            struct Navigation {
                static var title: String { String(localized: "CHARACTERS_LIST_NAVIGATION_TITLE") }
            }

            struct Search {
                static var nameFieldPlaceholder: String { String(localized: "CHARACTERS_LIST_SEARCH_NAME_FIELD_PLACEHOLDER") }
                static var statusLabel: String { String(localized: "CHARACTERS_LIST_SEARCH_STATUS_LABEL") }
                static var statusPicker: String { String(localized: "CHARACTERS_LIST_SEARCH_STATUS_PIKER") }
                static var genderLabel: String { String(localized: "CHARACTERS_LIST_SEARCH_GENDER_LABEL") }
                static var genderPicker: String { String(localized: "CHARACTERS_LIST_SEARCH_GENDER_PICKER") }
                static var searchButtonLabel: String { String(localized: "CHARACTERS_LIST_SEARCH_SEARCH_BUTTON_LABEL") }

                static var statusPickAll: String { String(localized: "CHARACTERS_LIST_SEARCH_STATUS_PIKED_ALL") }
                static var statusPickAlive: String { String(localized: "CHARACTERS_LIST_SEARCH_STATUS_PIKED_ALIVE") }
                static var statusPickDead: String { String(localized: "CHARACTERS_LIST_SEARCH_STATUS_PIKED_DEAD") }
                static var statusPickUnknown: String { String(localized: "CHARACTERS_LIST_SEARCH_STATUS_PIKED_UNKNOWN") }

                static var genderPickAny: String { String(localized: "CHARACTERS_LIST_SEARCH_GENDER_PIKED_ANY") }
                static var genderPickMale: String { String(localized: "CHARACTERS_LIST_SEARCH_GENDER_PIKED_MALE") }
                static var genderPickFemale: String { String(localized: "CHARACTERS_LIST_SEARCH_GENDER_PIKED_FEMALE") }
                static var genderPickGenderless: String { String(localized: "CHARACTERS_LIST_SEARCH_GENDER_PIKED_GENDERLESS") }
                static var genderPickUnknown: String { String(localized: "CHARACTERS_LIST_SEARCH_GENDER_PIKED_UNKNOWN") }
            }

            struct Error {
                static var dialogName: String { String(localized: "CHARACTERS_LIST_ERROR_DIALOG_NAME") }
                static var dialogButtonName: String { String(localized: "CHARACTERS_LIST_ERROR_DIALOG_BUTTON") }
            }
        }

        struct CharactersDetails {

            struct Navigation {
                static var title: String { String(localized: "CHARACTERS_DETAILS_NAVIGATION_TITLE") }
                static var backButtonLabel: String { String(localized: "CHARACTERS_DETAILS_NAVIGATION_BACK_BUTTON_LABEL") }
            }

            struct Character {
                static var lastLocationLabel: String { String(localized: "CHARACTERS_DETAILS_CHARACTER_LOCATION_LABEL") }
                static var originLabel: String { String(localized: "CHARACTERS_DETAILS_CHARACTER_ORIGIN_LABEL") }
                static var episodesLabel: String { String(localized: "CHARACTERS_DETAILS_CHARACTER_EPISODES_LABEL") }
                static var statusSpeciesFormat: String { String(localized: "CHARACTERS_DETAILS_CHARACTER_STATUS_SPECIES_FORMAT") }

            }
        }
    }
}
