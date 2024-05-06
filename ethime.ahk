; $ /mnt/c/Program\ Files/AutoHotkey/Compiler/Ahk2Exe.exe /in %n
; $ /mnt/c/Program\ Files/AutoHotkey/v2/AutoHotkey.exe %n

;@Ahk2Exe-AddResource icon/enabled.ico,  160 ; Replaces 'H on blue'
;@Ahk2Exe-AddResource icon/disabled.ico, 206 ; Replaces 'S on green'
;@Ahk2Exe-AddResource icon/enabled.ico,  207 ; Replaces 'H on red'
;@Ahk2Exe-AddResource icon/disabled.ico, 208 ; Replaces 'S on red'
;@Ahk2Exe-SetMainIcon icon/enabled.ico
;@Ahk2Exe-SetCompanyName K1DV5
;@Ahk2Exe-SetCopyright © 2024
;@Ahk2Exe-SetDescription An Ethiopic IME using a similar method as PowerGeez
;@Ahk2Exe-SetFileVersion 1.0.0
;@Ahk2Exe-SetName Ethime
;@Ahk2Exe-SetProductName Ethime
;@Ahk2Exe-SetProductVersion 2.0.0
;@Ahk2Exe-SetVersion 2.0.0

#SingleInstance force ; prevent multiple instances
#Hotstring * C ? ; all hotstrings case sensitive
InstallKeybdHook ; for A_Priorkey access below

; letters -----------------------------

firstChars := Map(
    "h", "ሀ",
    "l", "ለ",
    "H", "ሐ",
    "m", "መ",
    "S", "ሠ",
    "r", "ረ",
    "s", "ሰ",
    "q", "ቀ",
    "Q", "ቐ",
    "b", "በ",
    "t", "ተ",
    "c", "ቸ",
    "n", "ነ",
    "N", "ኘ",
    "x", "አ",
    "k", "ከ",
    "w", "ወ",
    "X", "ዐ",
    "z", "ዘ",
    "Z", "ዠ",
    "Y", "የ",
    "d", "ደ",
    "j", "ጀ",
    "g", "ገ",
    "T", "ጠ",
    "C", "ጨ",
    "P", "ጰ",
    "f", "ፈ",
    "p", "ፐ",
    "v", "ቨ"
)

capsChars := Map( ; lower cases are when shift is held as well
    "S", "ሸ",
    "H", "ኀ",
    "h", "ኸ",
    "T", "ጸ",
    "t", "ፀ"
)

afterChars := Map(
    "LWA", "ሏ",
    "hWA", "ሗ",
    "MWA", "ሟ",
    "RWA", "ሯ",
    "SWA", "ሷ",
    "sWA", "ሿ",
    "QWA", "ቋ",
    "BWA", "ቧ",
    "TWA", "ቷ",
    "CWA", "ቿ",
    "HWA", "ኋ",
    "NWA", "ኗ",
    "nWA", "ኟ",
    "KWA", "ኳ",
    "KWY", "ኴ",
    "ZWA", "ዟ",
    "zWA", "ዧ",
    "DWA", "ዷ",
    "JWA", "ጇ",
    "GWA", "ጓ",
    "tWA", "ጧ",
    "cWA", "ጯ",
    "pWA", "ጷ",
    "twA", "ጿ",
    "FWA", "ፏ",
    "PWA", "ፗ"
)

vowels := Map(
    "u", 1,
    "i", 2,
    "a", 3,
    "y", 4,
    "e", 5,
    "o", 6,
    "U", 1,
    "I", 2,
    "A", 3,
    "Y", 4,
    "E", 5,
    "O", 6
)

minLetter := Ord("A")
maxLetter := Ord("z")
lastChars := ""

arrangeLast(newChar, caps) {
    global lastChars
    max := caps ? 3 : 2
    lastChars .= newChar
    if (StrLen(lastChars) > max) {
        lastChars := SubStr(lastChars, 2)
    }
}

onKey(char) {
    global lastChars
    caps := GetKeyState("Capslock", "T")
    shift := false
    if SubStr(char, 1, 1) = "+" {
        shift := true
        char := SubStr(char, 2)
    }
    if (caps && shift) || (!caps && !shift) {
        char := StrLower(char)
    } else {
        char := StrUpper(char)
    }
    priorCode := StrLen(A_Priorkey) > 1 ? -1 : Ord(A_Priorkey)
    if priorCode < minLetter || priorCode > maxLetter {
        lastChars := ""
    }
    arrangeLast(char, caps)
    collection := caps ? capsChars : firstChars
    if collection.Has(char) { ; consonants
        Send collection[char]
        return
    }
    if !vowels.Has(char) {
        return
    }
    ; vowels
    if caps && afterChars.Has(lastChars) { ; extension letters
        if capsChars.Has(SubStr(lastChars, 1, 1)) {
            Send "{Backspace}"
        }
        Send afterChars[lastChars]
        return
    }
    ; modify consonants with vowels
    lastChar := SubStr(lastChars, -2, -1)
    if !collection.Has(lastChar) {
        return
    }
    lastCode := Ord(collection[lastChar])
    Send "{Backspace}" . Chr(lastCode + vowels[char])
}

setupLetters() {
    Loop maxLetter - minLetter {
        code := minLetter + A_Index
        char := Chr(code)
        if IsLower(char) {
            HotKey(char, onKey)
        } else {
            HotKey("+" . char, onKey)
        }
    }
}

setupLetters()

; numbers ---------------------

nums1 := Map(
    "1", "፩",
    "2", "፪",
    "3", "፫",
    "4", "፬",
    "5", "፭",
    "6", "፮",
    "7", "፯",
    "8", "፰",
    "9", "፱",
    "0", ""
)

nums10 := Map(
    "1", "፲",
    "2", "፳",
    "3", "፴",
    "4", "፵",
    "5", "፶",
    "6", "፷",
    "7", "፸",
    "8", "፹",
    "9", "፺",
    "0", ""
)

num00 := "፻"
num0000 := "፼"

accumNum := ""
accumLen := 0

geezNum(n) {
    global num00, nums1, nums10
    numlen := StrLen(n)
    if Mod(numlen, 2) = 1 {
        numlen := numlen + 1
        n := "0" . n
    }
    ret := ""
    Loop numlen / 2 {
        current2 := SubStr(n, - 2*A_index, 2) ; take two at a time from the end
        ret := num00 . nums10[SubStr(current2, 1, 1)] . nums1[SubStr(current2, 2)] . ret
    }
    ; clip the 00 and the first if it is 1
    startPos := SubStr(ret, 2, 1) = nums1["1"] && StrLen(ret) > 2 ? 3 : 2
    return SubStr(ret, startPos)
}

writeNum(n) {
    global accumNum, accumLen, nums1
    if (nums1.Has(A_PriorKey)) { ; the previous key is a number
        accumNum :=  accumNum . n
        Send "{Backspace " . accumLen . "}"
    } else {
        accumNum := n
    }
    gNum := geezNum(accumNum)
    accumLen := StrLen(gNum)
    Send gNum
}

setupNumbers() {
    Loop 10 {
        HotKey(A_index - 1, writeNum)
    }
}

setupNumbers()

; special chars -----------------------------

:::Send "{U+1361}"
::`:`:::{U+1362}
,::Send "{U+1363}"
::;::{U+1364}
; -::Send "{U+1366}"
; ?::Send "{U+1367}"

; customize tray menu controls --------------

trayMenuName := "&Ethiopic"

toggle(to) {
    global trayMenuName
    if to = -1 {
        to := A_IsSuspended
    }
    if to {
        Suspend false
        A_TrayMenu.Check(trayMenuName)
        ToolTip("Ethiopic keyboard")
    } else {
        Suspend true
        A_TrayMenu.Uncheck(trayMenuName)
        ToolTip("Normal keyboard")
    }
    Sleep(2000)
    ToolTip("")
}

trayToggleCallback(ItemName, ItemPos, MyMenu) {
    toggle(-1)
}

help(ItemName, ItemPos, MyMenu) {
    MyGui := Gui("", "Ethime help")
    MyGui.Add("Text", "", "You can test here:")
    MyGui.Add("Edit", "w600")
    MyGui.Add("Text", "Section", "Consonants:")
    FC := MyGui.AddListView("r20 w150 Sort", ["Letter", "Keyboard"])
    for char, letter in firstChars {
        FC.Add(, letter, char)
    }
    MyGui.Add("Text", "ys", "Consonants with caps lock:")
    CC := MyGui.AddListView("r20 w150 Sort", ["Letter", "Keyboard"])
    for char, letter in capsChars {
        CC.Add(, letter, char)
    }
    MyGui.Add("Text", "ys", "Vowels:")
    VC := MyGui.AddListView("r20 w150 Sort", ["Variant", "Keyboard"])
    for char, toAdd in vowels {
        VC.Add(, toAdd + 1, char)
    }
    MyGui.Add("Text", "ys", "Other letters (caps on):")
    AC := MyGui.AddListView("r20 w150 Sort", ["Letter", "Combination"])
    for chars, letter in afterChars {
        AC.Add(, letter, chars)
    }
    MyGui.Show
}

; help("", "", "")

A_TrayMenu.Delete("&Pause Script")
A_TrayMenu.Rename("&Suspend Hotkeys", trayMenuName)
A_TrayMenu.Add(trayMenuName, trayToggleCallback)
A_TrayMenu.Insert("E&xit", "&Help", help)
A_TrayMenu.Default := trayMenuName
A_TrayMenu.ClickCount := 1

toggle(true)

#SuspendExempt
::/\::{
    toggle(-1)
}
#SuspendExempt false

; ^c::ExitApp
