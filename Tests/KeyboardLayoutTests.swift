import Testing
@testable import AXe

@Suite("Keyboard Layout Tests")
struct KeyboardLayoutTests {
    @Test("US layout is the unchanged default table")
    func usLayoutMatchesDefaultTable() {
        for character in "azAZ09@'<>-_;:\"|\\~" {
            let string = String(character)
            let us = KeyboardLayout.us.keyEvent(for: string)
            let table = KeyEvent.keyCodeForString(string)
            #expect(us.keyCode == table.keyCode && us.shift == table.shift && !us.option)
        }
    }

    @Test("German layout swaps y/z and moves symbols to their QWERTZ keys")
    func germanLayoutKeys() {
        func key(_ string: String) -> (Int, Bool, Bool) {
            let event = KeyboardLayout.de.keyEvent(for: string)
            return (event.keyCode, event.shift, event.option)
        }
        #expect(key("y") == (29, false, false))
        #expect(key("Z") == (28, true, false))
        #expect(key("@") == (15, false, true))
        #expect(key("'") == (49, true, false))
        #expect(key("<") == (53, false, false))
        #expect(key(">") == (53, true, false))
        #expect(key("\\") == (36, true, true))
        #expect(key("ß") == (45, false, false))
        #expect(key("-") == (56, false, false))
    }

    @Test("German layout rejects dead keys and converts text with Option held")
    func germanLayoutConversion() throws {
        #expect(!TextToHIDEvents.validateText("´", layout: .de))
        #expect(TextToHIDEvents.validateText("max.muster@caperwhite.de", layout: .de))
        // Option down, L down, L up, Option up
        #expect(try TextToHIDEvents.convertTextToHIDEvents("@", layout: .de).count == 4)
    }
}
