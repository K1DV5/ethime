; $ /mnt/c/Program\ Files/AutoHotkey/v2/AutoHotkey.exe %n

#SingleInstance force ; prevent multiple instances
#Hotstring * C ? ; all hotstrings case sensitive
InstallKeybdHook ; for A_Priorkey below

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
-::Send "{U+1366}"
?::Send "{U+1367}"

#SuspendExempt
::/\::{
    if A_IsSuspended {
        Suspend false
        ToolTip("Ethiopic keyboard")
    } else {
        Suspend true
        ToolTip("Latin keyboard")
    }
    Sleep(2000)
    ToolTip("")
}
#SuspendExempt false

; ^c::ExitApp
