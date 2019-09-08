; The ethime project
; This is a full input method for the Ethiopic script, written in AutoHotKey.
; The way of writing is the same as Power Ge'ez
; But the number writing system is fully compatible with normal number writing.
;   for example, typing 345 will automatically produce ፫፻፵፭.

; This project is under the MIT License.
; 2019, K1DV5 (Kidus Adugna, kidusadugna@gmail.com, github.com/K1DV5)

#SingleInstance force ; prevent multiple instances
#Hotstring * C ? ; all hotstrings case sensitive
SendMode Input ; use SendInput by default

; the following are for numbers
accumNum := ""
accumLen := 0

nums1 := {1: Chr(0x1369)
        , 2: Chr(0x136A)
        , 3: Chr(0x136B)
        , 4: Chr(0x136C)
        , 5: Chr(0x136D)
        , 6: Chr(0x136E)
        , 7: Chr(0x136F)
        , 8: Chr(0x1370)
        , 9: Chr(0x1371)
        , 0: ""}

nums10 := {1: Chr(0x1372)
         , 2: Chr(0x1373)
         , 3: Chr(0x1374)
         , 4: Chr(0x1375)
         , 5: Chr(0x1376)
         , 6: Chr(0x1377)
         , 7: Chr(0x1378)
         , 8: Chr(0x1379)
         , 9: Chr(0x137A)
         , 0: ""}

num00 := Chr(0x137B)
num0000 := Chr(0x137C)

geezNum(n) {
    global num00, nums1, nums10
    numlen := StrLen(n)
    if (Mod(numlen, 2) = 1) {
        numlen := numlen + 1
        n := "0" . n
    }
    ret := ""
    Loop % numlen/2 {
        c := SubStr(n, 1 - 2*A_index, 2) ; take two at a time from the end
        ret := num00 . nums10[SubStr(c, 1, 1)] . nums1[SubStr(c, 0)] . ret
    }
    ; clip the 00 and the first if it is 1
    startPos := SubStr(ret, 2, 1) = nums1[1] and StrLen(ret) > 2 ? 3 : 2
    return SubStr(ret, startPos)
}

writeNum(n) {
    global accumNum, accumLen, nums1
    if (nums1.HasKey(A_PriorKey)) { ; the previous key is a number
        accumNum :=  accumNum . n
        Send {Backspace %accumLen%}
    } else {
        accumNum := n
    }
    gNum := geezNum(accumNum)
    accumLen := StrLen(gNum)
    Send %gNum%
}


1::writeNum(1)
2::writeNum(2)
3::writeNum(3)
4::writeNum(4)
5::writeNum(5)
6::writeNum(6)
7::writeNum(7)
8::writeNum(8)
9::writeNum(9)
0::writeNum(0)

; some characters

:::Send {U+1361}
::::::{U+1362}
,::Send {U+1363}
::;::{U+1364}
-::Send {U+1366}
?::Send {U+1367}

h::
if GetKeyState("Capslock", "T")=1
	{
	Send {U+1280}
	}
	else
	{
	Send {U+1200}
	}
return
::hu::{U+1201}
::hi::{U+1202}
::ha::{U+1203}
::hy::{U+1204}
::he::{U+1205}
::ho::{U+1206}

l::Send {U+1208}
::lu::{U+1209}
::li::{U+120A}
::la::{U+120B}
::ly::{U+120C}
::le::{U+120D}
::lo::{U+120E}

+h::
if GetKeyState("Capslock", "T")=1
	{
	Send {U+12B8}
	}
	else
	{
	Send {U+1210}
	}
return
::Hu::{U+1211}
::Hi::{U+1212}
::Ha::{U+1213}
::Hy::{U+1214}
::He::{U+1215}
::Ho::{U+1216}

m::Send {U+1218}
::mu::{U+1219}
::mi::{U+121A}
::ma::{U+121B}
::my::{U+121C}
::me::{U+121D}
::mo::{U+121E}

s::
if GetKeyState("Capslock", "T")=1
	{
	Send {U+1238}
	}
	else
	{
	Send {U+1230}
	}
return
::su::{U+1231}
::si::{U+1232}
::sa::{U+1233}
::sy::{U+1234}
::se::{U+1235}
::so::{U+1236}

r::Send {U+1228}
::ru::{U+1229}
::ri::{U+122A}
::ra::{U+122B}
::ry::{U+122C}
::re::{U+122D}
::ro::{U+122E}

+s::Send {U+1220}
::Su::{U+1221}
::Si::{U+1222}
::Sa::{U+1223}
::Sy::{U+1224}
::Se::{U+1225}
::So::{U+1226}

;ሸ up!............................
::SU::{U+1239}
::SI::{U+123A}
::SA::{U+123B}
::SY::{U+123C}
::SE::{U+123D}
::SO::{U+123E}

q::Send {U+1240}
::qu::{U+1241}
::qi::{U+1242}
::qa::{U+1243}
::qy::{U+1244}
::qe::{U+1245}
::qo::{U+1246}

b::Send {U+1260}
::bu::{U+1261}
::bi::{U+1262}
::ba::{U+1263}
::by::{U+1264}
::be::{U+1265}
::bo::{U+1266}

t::
if GetKeyState("Capslock", "T")=1
	{
	Send {U+1338}
	}
	else
	{
	Send {U+1270}
	}
return
::tu::{U+1271}
::ti::{U+1272}
::ta::{U+1273}
::ty::{U+1274}
::te::{U+1275}
::to::{U+1276}

c::Send {U+1278}
::cu::{U+1279}
::ci::{U+127A}
::ca::{U+127B}
::cy::{U+127C}
::ce::{U+127D}
::co::{U+127E}

; ha up!.................................
::HU::{U+1281}
::HI::{U+1282}
::HA::{U+1283}
::HY::{U+1284}
::HE::{U+1285}
::HO::{U+1286}

n::Send {U+1290}
::nu::{U+1291}
::ni::{U+1292}
::na::{U+1293}
::ny::{U+1294}
::ne::{U+1295}
::no::{U+1296}

+n::Send {U+1298}
::Nu::{U+1299}
::Ni::{U+129A}
::Na::{U+129B}
::Ny::{U+129C}
::Ne::{U+129D}
::No::{U+129E}

x::Send {U+12A0}
::xu::{U+12A1}
::xi::{U+12A2}
::xa::{U+12A3}
::xy::{U+12A4}
::xe::{U+12A5}
::xo::{U+12A6}

k::Send {U+12A8}
::ku::{U+12A9}
::ki::{U+12AA}
::ka::{U+12AB}
::ky::{U+12AC}
::ke::{U+12AD}
::ko::{U+12AE}
;
; he up!...........................
::hU::{U+12B9}
::hI::{U+12BA}
::hA::{U+12BB}
::hY::{U+12BC}
::hE::{U+12BD}
::hO::{U+12BE}

w::Send {U+12C8}
::wu::{U+12C9}
::wi::{U+12CA}
::wa::{U+12CB}
::wy::{U+12CC}
::we::{U+12CD}
::wo::{U+12CE}

+x::Send {U+12D0}
::Xu::{U+12D1}
::Xi::{U+12D2}
::Xa::{U+12D3}
::Xy::{U+12D4}
::Xe::{U+12D5}
::Xo::{U+12D6}

z::Send {U+12D8}
::zu::{U+12D9}
::zi::{U+12DA}
::za::{U+12DB}
::zy::{U+12DC}
::ze::{U+12DD}
::zo::{U+12DE}

+z::Send {U+12E0}
::Zu::{U+12E1}
::Zi::{U+12E2}
::Za::{U+12E3}
::Zy::{U+12E4}
::Ze::{U+12E5}
::Zo::{U+12E6}

+y::Send {U+12E8}
::Yu::{U+12E9}
::Yi::{U+12EA}
::Ya::{U+12EB}
::Yy::{U+12EC}
::Ye::{U+12ED}
::Yo::{U+12EE}

d::Send {U+12F0}
::du::{U+12F1}
::di::{U+12F2}
::da::{U+12F3}
::dy::{U+12F4}
::de::{U+12F5}
::do::{U+12F6}

j::Send {U+1300}
::ju::{U+1301}
::ji::{U+1302}
::ja::{U+1303}
::jy::{U+1304}
::je::{U+1305}
::jo::{U+1306}

g::Send {U+1308}
::gu::{U+1309}
::gi::{U+130A}
::ga::{U+130B}
::gy::{U+130C}
::ge::{U+130D}
::go::{U+130E}

+t::
if GetKeyState("Capslock", "T")=1
	{
	Send {U+1340}
	}
	else
	{
	Send {U+1320}
	}
return
::Tu::{U+1321}
::Ti::{U+1322}
::Ta::{U+1323}
::Ty::{U+1324}
::Te::{U+1325}
::To::{U+1326}

+c::Send {U+1328}
::Cu::{U+1329}
::Ci::{U+132A}
::Ca::{U+132B}
::Cy::{U+132C}
::Ce::{U+132D}
::Co::{U+132E}

+p::Send {U+1330}
::Pu::{U+1331}
::Pi::{U+1332}
::Pa::{U+1333}
::Py::{U+1334}
::Pe::{U+1335}
::Po::{U+1336}

;ጸ up!..............................
::TU::{U+1339}
::TI::{U+133A}
::TA::{U+133B}
::TY::{U+133C}
::TE::{U+133D}
::TO::{U+133E}

;ፀ up!.............................
::tU::{U+1341}
::tI::{U+1342}
::tA::{U+1343}
::tY::{U+1344}
::tE::{U+1345}
::tO::{U+1346}

f::Send {U+1348}
::fu::{U+1349}
::fi::{U+134A}
::fa::{U+134B}
::fy::{U+134C}
::fe::{U+134D}
::fo::{U+134E}

p::Send {U+1350}
::pu::{U+1351}
::pi::{U+1352}
::pa::{U+1353}
::py::{U+1354}
::pe::{U+1355}
::po::{U+1356}

v::Send {U+1268}
::vu::{U+1269}
::vi::{U+126A}
::va::{U+126B}
::vy::{U+126C}
::ve::{U+126D}
::vo::{U+126E}

::LWA::{U+120F}
::hWA::{U+1217}
::MWA::{U+121F}
::sWA::{U+1227}
::RWA::{U+122F}
::SWA::{U+1237}
::SHWA::{U+123F}
::QWA::{U+124B}
::BWA::{U+1267}
::TWA::{U+1277}
::CWA::{U+127F}
::HWA::{U+128B}
::NWA::{U+1297}
::nWA::{U+129F}
::KWA::{U+12B3}
::KWE::{U+12B4}
::ZWA::{U+12DF}
::zWA::{U+12DF}
::DWA::{U+12F7}
::JWA::{U+1307}
::GWA::{U+1313}
::tWA::{U+1327}
::cWA::{U+132F}
::pWA::{U+1337}
::T.WA::{U+133F}
::FWA::{U+134F}
::PWA::{1357}

::/\::
Suspend Permit
if A_IsSuspended
{
Suspend Off
splashtexton, , , Ethiopic keyboard
WinMove, Ethiopic keyboard, , 20, 20
sleep, 1000
splashtextoff
}
else
{
Suspend On
splashtexton, , , Latin keyboard
WinMove, Latin keyboard, , 20, 20
sleep, 1000
splashtextoff
}

