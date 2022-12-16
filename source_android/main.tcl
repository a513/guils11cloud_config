package require Tk
package require Img
package require Expect
package require tkpath 0.3.3

set ::handle ""
set ::tekFrfunc "-1"
#Адрес обдака
set ::cloudhost "lissi.ru"
set ::cloudport "4444"
set ::cloudlogin ""

set ::presskey ""
set ::presskey1 ""
#Считываем размеры экрана в пикселях
set ::scrwidth [winfo screenwidth .]
set ::scrheight [winfo screenheight .]
#Считываем размеры экрана в миллиметрах
set ::scrwidthmm [winfo screenmmwidth .]
set ::scrheightmm [winfo screenmmheight .]
#Запоминаем сколько пикселей в 1 мм
set ::px2mm [winfo fpixels . 1m]
#Запоминаем сколько целых пикселей в 1 мм
set aa [expr $::px2mm + 0.5]
set ::intpx2mm [expr {int($aa)}]
set ::bdlf [expr $::intpx2mm / 2]

puts "$::scrwidth  $::scrwidthmm $::px2mm"
set ::typetlf 0
global mydir
set mydir [file dirname [info script]]
source [file join $mydir breeze.tcl]

#Проверяем, что это телефон
if {$::scrwidth < $::scrheight} {
    option add *Dialog.msg.wrapLength 750
#    option add *Dialog.msg.wrapLength 11i
#    option add *Dialog.dtl.wrapLength 11i
    option add *Dialog.dtl.wrapLength 750
	set ::typetlf 1
}

if {!$::typetlf} {
    ttk::style theme use Breeze
}
#Грузим пакет для работы с токенами PKCS11
if {$::tcl_platform(os) == "Linux"} {
    if {$::tcl_platform(machine) == "x86_64"} {
	set ltclpkcs11 [file join $mydir tclpkcs11.so]
	set ::llc11cloud [file join $mydir libls11cloud.so]
    } else {
	set ltclpkcs11 "tclpkcs11.so"
	set ::llc11cloud [file join $mydir libls11cloud.so]
#	set ::llc11cloud "libls11cloud.so"
    }
#    set ltclpkcs11 [file join $mydir tclpkcs11.so]
#    set ::llc11cloud [file join $mydir libls11cloud.so]
} else {
	set ltclpkcs11 [file join $mydir tclpkcs11.dll]
	set ::llc11cloud [file join $mydir libls11cloud.dll]
}
#set xaxa [array get tcl_platform]
#tk_messageBox -title "ENV" -icon info -message "$xaxa"  -parent .
load $ltclpkcs11 Tclpkcs11


#Грузим картинки
#Логотип продукта
image create photo logo_product -file [file join $mydir "imageme" "validcertkey_51x24.png"] 
#Логотип производителя
#image create photo logo_orel -file [file join $mydir "imageme" "я_орел_160x75.png"] -format "png -alpha 1.0"
image create photo logo_cloud -file [file join $mydir "imageme" "logo_cloud_200x75.png"] -format "png -alpha 1.0"
#Андроида с tcl/tk
image create photo logo_and -file [file join $mydir "imageme" "AndTk_inv_147x173.png"] -format "png -alpha 1.0"
#Свиток опечатанный
image create photo svitok -file [file join $mydir "imageme" "blue_svitok.png"] -format "png -alpha 1.0"
image create photo cloud_100x50 -file [file join $mydir "imageme" "cloud_100x50.png"]
#Плитка
#image create photo tileand -file [file join $mydir "imageme" "tile_green_and_32x32.png"] -format "png -alpha 1.0"
image create photo tileand -data {
R0lGODlhIgAiAOelAEWeR0WeSEaeR0aeSEWfRkWfR0WfSEafR0afSEafSUefSEefSUifSUWgSEifSkagSEmfSkagSUegSEegSUegSkigSUigSkigS0mgSkmgS0ihSkih
S0mhSkmhS0mhTEqhS0qhTEmiSkmiS0yhTUqiTE2hTk2hT0uiTUyiTUyiTkyiT02iTk2iT06iUEyjTkyjT02jTk2jT02jUE6jTk6jT06jUE+jUE2kT02kUE6kT06kUE+k
UE+kUVGkU1KkU1KkVFOkVFOkVVKlU1KlVFKlVVOlVFOlVVOlVlKmU1KmVFOmVFOmVVOmVlSmVVSmVlWmVlKnVVOnVFOnVVSnVVSnVlinW1eoWVioWVioWlioW1moWlmo
W1moXFqoW1ipWlipW1mpWlmpW1mpXFqpW1qpXFmqWlmqW1mqXFqqW1qqXFqqXVuqXFyqXl2qX16qYF+qYF2rXl2rX12rYF6rXl6rX16rYF+rX1+rYF+rYV2sX2CrYV6s
X16sYF6sYV+sX1+sYF+sYWCsYGCsYWCsYl6tYGGsYmGsY1+tYF+tYWKsY1+tYmKsZGCtYmGtYmGtY2GtZGKtYmKtY2KtZGKtZWOtY2OtZGOtZWStZWKuYmKuY2KuZGKu
ZWOuY2OuZGOuZWOuZmSuZGSuZWSuZmWuZmSvZf//////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////yH+EUNyZWF0ZWQgd2l0aCBHSU1QACH5BAEKAP8ALAAAAAAiACIAAAj+ADPUqfOhRiQwCIhYWjJhCyMYAvlwYPEozIQjkpQs2OIoh0CCdP6AYBFp
zIMhoZokwBJJR4aQHVhUSvOgSKUlCbR0wmEh5EiJMRwhNBJKCYItkWhsqLNHAwtNYR4k0aQkAtIYGugAddQhRSM0EYSQWiLgiiaXdf5scFFpTAEhKRFo0cSCgh1BXb+y
cBQGgZNQSQ6EqRTDQtoNMTp9OUBEFM4ukmB0wNPHKV8EksgoKOLYAJhQNQwD6hCjEhkDnJ0gwCJJhoU/iDSkyLw5zIEhnsiG8eSCQVoLKzR9IVBklBEALG844MOnQgqo
tz0lGNJpCoIrnHT0RATCa1/cTpD+Z6qRIc6fDiscjZleHUjKBFs23YCA51BMR2YUABHVBACYTmgRwoEJm6CBgHsqdfLEBFg4UkMHMKVQyBgTGNGJajrtsAFMMkRCxgI/
KMjgEgdo4UhhdfAhmyR9FaFJEgWE0YlracUkiRkGDHEJiSau1ogOHjAVUyNlLGBEJEtsNN4FcewBQguNeBGBhU34qANrMmTwx3krZHZSbgp0MUkMFdzVwQySiIFAEZ40
YQCWGbQkUB4a1MAiAklUolEYmcRwwR3n7WXGA0bkJpecdegwgVYbwNCJGAUMIQqGkrygwR16aHBCJFENMcoSBWBxiaJaTVCHHxNVAkYBREVxFCX+heERyAbPDVVUAVt0
EoOpqMYxCHqapIGAEJMiV4kOFfyB13NrKIBSEwJo8YmivqKHCAcqJOIFAkaIIkUBVWhCw5+HcJDCIn394IkUB3DRyQ2GXZstCChAgsYCcFEBgBWd8KABHIh0lYmwPoDi
xAJXvLsdvfamYMgYEhhx0wGs0ZCBHHuEQFEYEgxhiRMSZCFJDBy8MZrDEHs4wRCVVKkFJToweQcJBp2xQBGhULEAS+TRgRcMKg9hhgRFSAKFXJnAYBgfIpAEBqFtrtYR
BkzJhh/RkkyARCZNTABGSxf4FEMhUSlh8GqR2ADhHx68gAkaWnOt4xIK5BorIOZeTZT+EgdkASAGcvwxkSQGzq1AKJQWpqxsmcBNZQFagFLDBXucF8PAOSIuFxWQj2yq
IhSMIImwQ3wC6haeyLAoIBuUMFOkonCuhSQDaBFJDhfUAUgGLNxoZCdLDJCrcinGVBICQZDiRO23X+FJaHUEjEIlagzrCRVyeaKdGwGvEIkZw05agPOhnZVBG3x0oEIk
aDwARCcqbZEJ7m6MZoIjjuccABbmt8GDBWxIXwocQZMeeOIJD7iCJHSggTjgQQQoKAQZJiAESzDhAGb5XwAxEAc6FOQgCamEFHbGCIsVzwQVqVBGEpCF23HQg3PgAwm8
R4aOeUI1DdIBB2CSngkOQRJCTMiJJkITwxlazhBgaABRpHAUSUCvKU/plCaW0ER41SgGhugAChphhrCQoj8J0w4dACGbmQwrFFNYgE5qsDotcjEgADs=
}

image create photo newtile -data {
iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAIAAAD8GO2jAAAC5HpUWHRSYXcgcHJvZmlsZSB0eXBlIGV4aWYAAHja7ZZNkhshDIX3nCJHQBJCcBx+q3KDHD8PmrE9nkkq
k8oiC0M1NGpaEu+jsd348X26byiUhV1QSzHH6FFCDpkLbpK/ytWTD7vdhc8jjN/Z3e0BwyTo5RrGceYX2PX+goVjr+/tztrxk46j8+DNoazIK1o/SR5Hwpedztjlk1KJ
D8s5Vz0v78j+4zgYxOgKf9CIh5D4q70iyXUVXISWRddE1CIqCS3KR/3cTbpPBLzdPenn27HLXY7L0duy4pNOx076uX5bpceMiG+R+TEjEIr+sTzoN2dPc45rdSVEB7ni
WdTbUvYdJlbIeakRUQ2X4t52zajJF99ArWOp1fmKQSaG1pMCdSo0aey+UUOKgQcbeubGsm1JjDO3DSOsSpPNSZYOFiwN5ARmvuVCO25e8RAsIXInzGSCM9ocH6p7Nvxt
fedozrXNiXy6aYW8eG1ZpLHIrRazAITm0VS3vuSuzj+XBVZAULfMCQssvl4uqtJ9b8nmLF4dpgZ/fS9k/TiARIitSIYEBHwkUYrkjdmIoGMCn4LMWQJXECB1yh1ZchCJ
gJN4xcY7RnsuK19mHC8AoRLFgCZLAawQNER8bwlbqDgVDaoa1TRp1hIlhqgxRovrnComFkwtmlmybCVJCklTTJZSyqlkzoJjTF2O2XLKOZeCoCUU+CqYX2CoXKWGqjVW
q6nmWhq2TwtNW2zWUsutdO7ScQS4Hrv11HMvgwa20ghDRxw20sijTOy1KTNMnXHaTDPPcqN2qL6n9kzu99ToUOMNas2zOzWYzd5c0DpOdDEDMQ4E4rYIYEPzYuYThcCL
3GLmM4sTnFvIUhecTosYCIZBrJNu7O7kfsnNQd2vcuPPyLmF7l+QcwvdA7mP3D6h1ss+bmUDWl8hNMUJKfj8po7CqXCtbeLcSWuwfqL+vHdffeHl6OXo5ejl6OXo5ejl
6L93hL8P2f0EZEWS2uWral8AAAGFaUNDUElDQyBwcm9maWxlAAB4nH2RPUjDUBSFT1ulIhWHdlBxyFAdxIKoSEetQhEqhFqhVQeTl/5Bk4YkxcVRcC04+LNYdXBx1tXB
VRAEf0CcHJ0UXaTE+5JCixgvPN7Hefcc3rsP8DcqTDW7JgBVs4x0MiFkc6tC8BU+DCKMOMYkZupzopiCZ33dUzfVXYxneff9WX1K3mSATyCeZbphEW8Qz2xaOud94ggr
SQrxOfG4QRckfuS67PIb56LDfp4ZMTLpeeIIsVDsYLmDWclQiaeJo4qqUb4/67LCeYuzWqmx1j35C0N5bWWZ67SGkcQiliBCgIwayqjAQox2jRQTaTpPePiHHL9ILplc
ZTByLKAKFZLjB/+D37M1C1OTblIoAXS/2PbHCBDcBZp12/4+tu3mCRB4Bq60tr/aAOKfpNfbWvQI6N8GLq7bmrwHXO4AA0+6ZEiOFKDlLxSA9zP6phwQvgV619y5tc5x
+gBkaFapG+DgEBgtUva6x7t7Ouf2b09rfj/PTHLM9yO/3gAAAAlwSFlzAAAOxAAADsQBlSsOGwAAAAd0SU1FB+QBGRM6I8jecLMAAAAsSURBVEjH7c0xDQAwCAAwmH9N
+EEEyUzA1xpoVk9cenFMIBAIBAKBQCAQbPmRCALkiseKdAAAAABJRU5ErkJggg==
}

global env
set myHOME1 $env(HOME)
set mydir [file dirname [info script]]
set ::mm [file join $myHOME1 "ls11cloud_config"]
set ::libcloud [file join $mydir "libls11cloud.so"]
if {$::typetlf} {
    set userpath $env(EXTERNAL_STORAGE)
set ::libcloud [file join $mydir "libls11cloud.so"]
} else {
    set userpath $env(HOME)
set ::libcloud [file join $mydir "libls11cloud.so"]
}
set ::dstlib [file join $userpath "ls11cloud" "libls11cloud.so"]

catch {[file delete -force $mm]}
file copy [file join $mydir ls11cloud_config] $::mm
file attribute $::mm -permissions +x	

#Увеличить/уменьшить (отрицательное значение - уменьшение)
proc scaleImage {im xfactor {yfactor 0}} {
   set mode -subsample
   if {$xfactor>=0 && $yfactor>=0} {
       set mode -zoom
   } else {
	set xfactor [expr $xfactor * -1]
   }

   if {$yfactor == 0} {set yfactor $xfactor}
   set t [image create photo]
   $t copy $im
   $im blank
   $im copy $t -shrink $mode $xfactor $yfactor
   image delete $t
}

proc createtile {w  backg} {
    image create photo tiled
    tiled copy $backg -to 0 0 $::scrwidth [expr {$::scrheight + 30}] -shrink
    $backg copy tiled
    image delete tiled
# Мостим холст
    $w create image 0 0  \
      -image $backg  \
      -anchor nw
}

proc create_rectangle  {canv img x1 y1 x2 y2 color alfa {wbd 0} {colorline black} } {
    image create photo $img -format "default -colorformat  rgb"
    set rgb1 [winfo rgb $canv $color]
    set cr  [lindex $rgb1 0]
    set cg  [lindex $rgb1 1]
    set cb  [lindex $rgb1 2]
    set fill [format "#%04x%04x%04x" $cr $cg $cb ]
#Создаем цветной праямоугольник
    $img put $fill -to 0 0 [expr {$x2 - $x1}] [expr {$y2 -$y1}]
#Сохраняем картинку
    set dimg [$img data -format png]
#Создаем image с учетом alpha канала
    image create photo $img -data $dimg -format "png -alpha $alfa"
#    $img put [list $rgb1] -to 0 0 [expr {$x2 - $x1}] [expr {$y2 -$y1}]
#Отображаем цветной прямоугольник
    set imgr [$canv create image $x1 $y1 -image $img -anchor nw] 
    set cc [subst {butImg $img}]
    $canv bind $imgr <ButtonPress-1> $cc
#Оконтовка вокруг цветного прямоугольника
    if {$wbd > 0 } {
	set item [$canv create rect $x1 $y1 $x2 $y2 -outline $colorline -width $wbd ]
	$canv bind $item <ButtonPress-1> $cc
    }
   return $imgr
}

proc butImg {img} {
#    tk_messageBox -title "Кнопка" -icon info -message "Нажали кнопку=$img" -detail "::screenwidth=$::scrwidth\n::screenheight=$::scrheight" -parent .
    if {$img == "but2"} {
	pack forget  .fr0
	pack .fr1 -side top -anchor center -expand 1 -fill both -side top  -padx 0 -pady 0 
    } elseif {$img == "but1"} {
	pack forget  .fr1
	pack .fr0 -side top -anchor center -expand 1 -fill both -side top  -padx 0 -pady 0 
    } elseif {$img == "exit"} {
	set answer [tk_dialog .dialog2 "Конец работы" "Вы действительно\nхотите выйти?" question 0 "Да" "Нет" ]
	if {$answer == 0} {
    	    exit
	}	
    } else {
	tk_messageBox -title "Кнопка" -icon info -message "Нажали кнопку=$img" -detail "::screenwidth=$::scrwidth\n::screenheight=$::scrheight" -parent .
    }
}

proc exitPKCS {} {
    global retmes
    set retmes -1
    foreach id [.fr0.can find withtag but1] {
	break
    }
    foreach {fx0 fy0 fx1 fy1} [.fr0.can bbox $id ] {break}
    makeMessage .fr0.can "Для завершения работы\nнажмите кнопку <Да>.\nЕсли вы решили продолжить\nработу - нажмите <Нет>" yesno [expr {$fx0 + (($fx1 - $fx0) / 2)}] $fy0
    vwait retmes
    if {$retmes == 1} {
	exit
    } else {
	set retmes -1
	return
    }
    
    set answer [tk_dialog .dialog2 "Конец работы" "Вы действительно\nхотите выйти?" question 0 "Да" "Нет" ]
    if {$answer == 0} {
      exit
    }
}

proc page_titul {fr  logo_manufacturer} {
    global mydir
#Создаем холст на весь экран
    tkp::canvas $fr.can -borderwidth 0 -height $::scrheight  -width $::scrwidth -relief flat
#Мостим холст плиткой 
#    createtile "$fr.can"  "tileand"

    pack $fr.can  -anchor center -expand 1 -fill both -side top  -padx 0 -pady 0
#Вычисляем координаты для логотипа производителя
#update чтобы обновилась информация в БД об окнах
    update
set gradientButOk [$fr.can gradient create linear -method pad -units bbox -stops { { 0.00 #0000ff 0.50} { 0.80 #99cc00 0.90}} -lineartransition {0.00 0.00 1.00 0.00} ]
#set gradientBut [$fr.can gradient create linear -method pad -units bbox -stops { { 0.00 #00aa55 0.90} { 0.80 #0055aa 1.00}} -lineartransition {0.19 0.00 0.60 0.00} ]
set gradientBut [$fr.can  gradient create linear -method pad -units bbox -stops { { 0.00 #0055aa 0.50} { 1.00 #99cc00 }} -lineartransition {0.19 0.00 0.70 0.00} ]
#set gradientBut [$fr.can  gradient create linear -method pad -units bbox -stops { { 0.00 #0055aa 0.50} { 1.00 #00aa55 }} -lineartransition {0.19 0.00 0.70 0.00} ]

set ::gradientCloud [$fr.can gradient create linear -method pad -units bbox \
    -stops { { 0.05 #87ceeb 1.00} { 0.17 #ffffff 1.00} { 0.29 skyblue 1.00} { 0.87 #ffffff 1.00} { 1.00 skyblue 1.00}} -lineartransition {1.00 0.00 0.75 1.00} ]

#    set aa [winfo height $fr.labtitul]
    set aa $::padly
#Центрируем логотип разработчика
    set ha [image width $logo_manufacturer]
    set xman [expr {($::scrwidth - $ha) / 2 }]
    $fr.can create image $xman $aa -image $logo_manufacturer -anchor nw -tag tag_logo
	update

    set blogo [$fr.can bbox tag_logo]
    set wexit [lindex $blogo 3]
#puts "FTXT=$::ftxt, dlx1=$::dlx1"
	set dlx [expr {$::padlx / 1}]
#Центрируем текст
#############################
	set allfunc "Электронная подпись"
	catch {font delete fontTEMP_titul0}
	set font_titul "-family {$::ftxt} -size 15"
        eval font create fontTEMP_titul0  $font_titul
	set funcWidthPx [font measure fontTEMP_titul0 "$allfunc"]
	set dlx [expr {($::scrwidth - $funcWidthPx) / 2}]
#Центрирование текста
	set cc [expr {[winfo width "."] / 2 }]

#	$fr.can create text [expr $dlx + $::dlx1 * 2] [expr {$wexit + $::dlx1 * 2}] -anchor nw -text "$allfunc" -fill black -font fontTEMP_titul0
#	$fr.can create text $cc $wexit  -anchor n -text "$allfunc" -fill #296ea1 -font fontTEMP_titul0 -tag id_text0
      $fr.can create ptext $cc $wexit -fill #296ea1 -strokewidth 1  -stroke #969696 -fontfamily {Roboto} -fontsize [expr {20.0 * $::tlffont}] -fontslant oblique -fontweight bold -text "$allfunc" -textanchor n -filloverstroke 0 -tag id_text0
# -fontfamily {Nimbus Sans Narrow}

	update
	set blogo [$fr.can bbox id_text0]
	set wexit [lindex $blogo 3]
#Центрируем текст
	set allfunc "для платформы Android"
	catch {font delete fontTEMP_titul1}
	set font_titul "-family {$::ftxt} -size 12 -weight bold"
        eval font create fontTEMP_titul1  $font_titul
	set funcWidthPx [font measure fontTEMP_titul1 "$allfunc"]
	
	set dlx [expr {($::scrwidth - $funcWidthPx) / 2}]

#	$fr.can create text [expr $dlx + $::dlx1 * 1] [expr {$wexit + $::dlx1 * 1}] -anchor nw -text "$allfunc" -fill black -font fontTEMP_titul1
#	$fr.can create text $cc [expr {$wexit}] -anchor n -text "$allfunc" -fill #296ea1 -font fontTEMP_titul1 -tag id_text1
       $fr.can create ptext $cc $wexit -fill #296ea1 -strokewidth 1  -stroke #969696 -fontfamily {Roboto} -fontsize [expr {18.0 * $::tlffont}] -fontslant oblique -fontweight bold -text "$allfunc" -textanchor n -filloverstroke 0 -tag id_text1

	update
	set blogo [$fr.can bbox id_text1]
	set wexit [lindex $blogo 3]
	set font_titul "-family {$::ftxt} -size 11 -weight bold"
	catch {font delete fontTEMP_titul2}
	eval font create fontTEMP_titul2  $font_titul
	set allfunc "Регистрация личного токена PKCS11"
	set funcWidthPx [font measure fontTEMP_titul2 "$allfunc"]
	set dlx [expr {($::scrwidth - $funcWidthPx) / 2}]
	set x1 [expr {int($::px2mm * 2)}]
#	$fr.can create text [expr $dlx + $::dlx1] [expr {$wexit + $x1 + $::dlx1}] -anchor nw -text "Регистрация личного токена PKCS11\nв облаке LS11CLOUD" -fill black -font fontTEMP_titul2
	$fr.can create text $::px2mm [expr {$wexit + $x1}] -anchor nw -text "Регистрация личного токена\nPKCS11 в облаке LS11CLOUD" -fill #296ea1 -font fontTEMP_titul2 -tag id_text2

	set blogo [$fr.can bbox id_text2]
	set wexit [lindex $blogo 3]
	set font_titul "-family {$::ftxt} -size 10 -weight bold"
    catch {font delete fontTEMP_titul3}
    eval font create fontTEMP_titul3  $font_titul
	set auther "Авторы: В.Н. Орлов\nhttp://soft.lissi.ru, http://www.lissi.ru\n+7(495)589-99-53\ne-mail: support@lissi.ru\n"
#	$fr.can create text [expr $dlx + $::dlx4] [expr {$wexit + $::dlx1}] -text "$auter" -anchor nw -fill black  -font fontTEMP_titul3
	$fr.can create text $::px2mm [expr {$wexit + 0}] -text "$auther" -anchor nw -fill #296ea1 -tag id_text3  -font fontTEMP_titul3


    set blogo [$fr.can bbox id_text3]
    set wland [lindex $blogo 3]
#Размеры logo_and
    set ha [image height logo_and]
    set wa [image width logo_and]
    set hy1 [expr $ha / 4]
set widthrect [expr $ha / 4]
    set hy2 [expr $hy1 / 4]

    $fr.can create image $::padlx $wland -image logo_and -anchor nw -tag tag_land
    set ha1 [expr {$ha - ($ha / 2 ) }]
    $fr.can create image [expr {$wa - 80 }] [expr {$wland + $ha1}] -image svitok -anchor nw -tag tag_land
    set dlx [expr {$::intpx2mm * 7}]

	set x1 $dlx
	set y1 [expr {$wland + $hy2}]
	set x2 [expr {$::scrwidth - $x1}]
	set y2 [expr {$y1 + $widthrect}]
	set  wd $::px2mm
#    set im1 [create_rectangle $fr.can "but1" $x1 $y1 $x2 $y2 "gray42" 0.5 [expr int($wd)] "#5e90a0"]
    set im1 [$fr.can create prect  $x1 $y1 $x2 $y2 -fill $gradientButOk -fillopacity 0.5 -stroke "#5e90a0" -strokewidth $::intpx2mm -strokeopacity 0.5 -tags "but1"]
#Печатаем техт
    set blogo [$fr.can bbox $im1]
    set by2 [lindex $blogo 3]
    set by1 [lindex $blogo 1]
    set bb [expr {($by2 - $by1) / 2}]
    set bx2 [lindex $blogo 2]
    set bx1 [lindex $blogo 0]
    set bbx [expr {($bx2 - $bx1) / 2}]
    set txt0 [$fr.can create text [expr {$x1 + $::padlx * 2}] [expr {$y1 + 1 }] -anchor nw -text {Сайт разработчика} -fill black -font fontTEMP_titul2 -tags "but1"]
    set txt1 [$fr.can create text [expr {$x1 + $::padlx * 2}] [expr {$y1 + 1 }] -anchor nw -text {Сайт разработчика} -fill white -font fontTEMP_titul2 -tags "but1"]
#Центрируем техт
    set btxt1 [$fr.can bbox $txt1]
#Смещение по оси Y
    set ty2 [lindex $btxt1 3]
    set ty1 [lindex $btxt1 1]
    set tt [expr {$ty2 - $ty1}]
    set tt [expr {$tt / 2}]
    set offsy [expr {($by1 + $bb) - ($ty1 + $tt)}]
#Смещение по оси X
    set tx2 [lindex $btxt1 2]
    set tx1 [lindex $btxt1 0]
    set ttx [expr {$tx2 - $tx1}]
    set ttx [expr {$ttx / 2}]
    set offsx [expr {($bx1 + $bbx) - ($tx1 + $ttx)}]
    $fr.can move $txt0 [expr $offsx + $::dlx1] [expr $offsy + $::dlx1]
    $fr.can move $txt1 $offsx $offsy
    $fr.can bind "but1" <ButtonPress-1> {butImg "img1"}

	set y1 [expr {$y2 + $hy2}]
	set y2 [expr {$y1 + $widthrect}]
#    set im1 [create_rectangle $fr.can "but2" $x1 $y1 $x2 $y2 "gray42" 0.5 $wd "#5e90a0"]
    set im1 [$fr.can create prect  $x1 $y1 $x2 $y2 -fill $gradientBut -fillopacity 0.5 -stroke "#5e90a0" -strokewidth $::intpx2mm -strokeopacity 0.5 -tags "but2"]
#    return [.c create prect $x1 $y1 $x2 $y2 -fill $col -fillopacity $fopat -stroke {}  -tags "but2"]

#Печатаем техт
    set blogo [$fr.can bbox $im1]
    set by2 [lindex $blogo 3]
    set by1 [lindex $blogo 1]
    set bb [expr {($by2 - $by1) / 2}]
    set bx2 [lindex $blogo 2]
    set bx1 [lindex $blogo 0]
    set bbx [expr {($bx2 - $bx1) / 2}]
    set txt0 [$fr.can create text [expr {$x1 + $::padlx * 2}] [expr {$y1 + 1 }] -anchor nw -text "Переход в основное меню" -fill black -font fontTEMP_titul2 -tags "but2"] 
    set txt1 [$fr.can create text [expr {$x1 + $::padlx * 2}] [expr {$y1 + 1 }] -anchor nw -text "Переход в основное меню" -fill white -font fontTEMP_titul2 -tags "but2"] 
#Центрируем текст
    set btxt1 [$fr.can bbox $txt1]
#Смещение по оси Y
    set ty2 [lindex $btxt1 3]
    set ty1 [lindex $btxt1 1]
    set tt [expr {$ty2 - $ty1}]
    set tt [expr {$tt / 2}]
    set offsy [expr {($by1 + $bb) - ($ty1 + $tt)}]
#Смещение по оси X
    set tx2 [lindex $btxt1 2]
    set tx1 [lindex $btxt1 0]
    set ttx [expr {$tx2 - $tx1}]
    set ttx [expr {$ttx / 2}]
    set offsx [expr {($bx1 + $bbx) - ($tx1 + $ttx)}]
    $fr.can move $txt0 [expr $offsx + $::dlx1] [expr $offsy + $::dlx1]
    $fr.can move $txt1 $offsx $offsy
    $fr.can bind "but2" <ButtonPress-1> {butImg "but2"}
###############
	set y1 [expr {$y2 + $hy2}]
	set y2 [expr {$y1 + $widthrect}]

#    set im1 [create_rectangle $fr.can "but3" $x1 $y1 $x2 $y2 "gray42" 0.5 $wd "#5e90a0"]
    set im1 [$fr.can create prect  $x1 $y1 $x2 $y2 -fill $gradientBut -fillopacity 0.5 -stroke "#5e90a0" -strokewidth $::intpx2mm -strokeopacity 0.5 -tags "but3"]

    set blogo [$fr.can bbox $im1]
    set by2 [lindex $blogo 3]
    set by1 [lindex $blogo 1]
    set bb [expr {($by2 - $by1) / 2}]
    set bx2 [lindex $blogo 2]
    set bx1 [lindex $blogo 0]
    set bbx [expr {($bx2 - $bx1) / 2}]
    set txt0 [$fr.can create text [expr {$x1 + $::padlx * 2}] [expr {$y1 + 1 }] -anchor nw -text "Конец работы" -fill black  -font fontTEMP_titul2 -tags "but3"]
    set txt1 [$fr.can create text [expr {$x1 + $::padlx * 2}] [expr {$y1 + 1 }] -anchor nw -text "Конец работы" -fill white  -font fontTEMP_titul2 -tags "but3"]
    $fr.can bind "but3" <ButtonPress-1> {exitPKCS}
    set btxt1 [$fr.can bbox $txt1]
#Смещение по оси Y
    set ty2 [lindex $btxt1 3]
    set ty1 [lindex $btxt1 1]
    set tt [expr {$ty2 - $ty1}]
    set tt [expr {$tt / 2}]
    set offsy [expr {($by1 + $bb) - ($ty1 + $tt)}]
#Смещение по оси X
    set tx2 [lindex $btxt1 2]
    set tx1 [lindex $btxt1 0]
    set ttx [expr {$tx2 - $tx1}]
    set ttx [expr {$ttx / 2}]
    set offsx [expr {($bx1 + $bbx) - ($tx1 + $ttx)}]
    $fr.can move $txt0 [expr $offsx + $::dlx1] [expr $offsy + $::dlx1]
    $fr.can move $txt1 $offsx $offsy
}
#Собственно скрипт
set ::typetlf 0
#Считываем размеры экрана в пикселях
set ::scrwidth [winfo screenwidth .]
set ::scrheight [winfo screenheight .]
#Считываем размеры экрана в миллиметрах
set ::scrwidthmm [winfo screenmmwidth .]
set ::scrheightmm [winfo screenmmheight .]
#puts "$::scrwidth  $::scrwidthmm $::px2mm"
#Проверяем, что это телефон

if {$::scrwidth < $::scrheight} {
    set ::typetlf 1
}
####################
set machine $tcl_platform(machine)
set machArm [string first "arm" $machine]
if {$machArm != -1} {
    set ::typetlf 1
}

set ::padls [winfo pixels . 3m]
set ::padlx [winfo pixels . 2m]
set ::padly [winfo pixels . 1m]
set ::tlffont 1
if {$::typetlf} {
#Шрифт для Androwish
#    set ::ftxt "Roboto Condensed Medium"
    set ::ftxt "Roboto"
    set ::ftxt1 "Roboto"
    set ::dlx1 6
    set ::dlx2 4
    set ::dlx3 3
    set ::dlx4 2
    wm attributes . -fullscreen 1
#Логотип производителя
#	scaleImage logo_orel 4
	scaleImage logo_cloud 4
#Логотип продуктв
	scaleImage logo_product 2
#Андроида tcl/tk
    if { $::px2mm > 15} {
	scaleImage logo_and 4
	scaleImage cloud_100x50 5
	set ::tlffont 4
    } elseif { $::px2mm > 10} {
	scaleImage logo_and 3
	scaleImage cloud_100x50 3
	set ::tlffont 3
    } elseif { $::px2mm > 5} {
	scaleImage logo_and 2
	scaleImage cloud_100x50 2
	set ::tlffont 2
    }
#Свиток опечатанный
	scaleImage svitok 4
} else {
    set ::ftxt "Nimbus Sans Narrow"
    set ::ftxt1 "Nimbus Sans Narrow"
    set ::dlx1 2
    set ::dlx2 2
    set ::dlx3 3
    set ::dlx4 1
#Конфигурирование виджета под смартфон
#    scaleImage logo_orel 1
    scaleImage logo_cloud 1
    scaleImage cloud_100x50 1

	scaleImage logo_product -2
#Ширина 75 mm
    set ::scrwidth [expr {int(75 * $px2mm)}]
#Высота 140 mm
    set ::scrheight [expr int(140 * $px2mm)]

    wm minsize . $::scrwidth $::scrheight
    set geometr $::scrwidth
    append geometr "x"
    append geometr $::scrheight
    append geometr "+0+0"
    wm geometry . $geometr
#Главное окно неизменяемое
    wm resizable . 0 0
}
if {1} {
	    set ::namescmd UXTY
	    frame .retpage0
	    set frret .retpage0
	    eval "frame $frret.sep -bg #a0a0a0 -height $::intpx2mm -relief groove -bd $::intpx2mm"
	    eval "label $frret.seplab -textvariable ::namecmd -bg skyblue -font {-family {$::ftxt} -size 12}"
	    eval "button $frret.sepbut -text {Возврат в основное меню} -bg skyblue -command {butReturn}"
	    pack $frret.sepbut -side bottom  
	    pack $frret.seplab -side bottom -fill x -expand 1 -pady 1mm
	    pack $frret.sep -side bottom  -fill x

}

proc read_password {tit w num} {
    global yespas
    global pass
    set tit_orig "$::labpas"
    if {$tit != ""} {
	set ::labpas "$tit"
    }
    tk busy hold $w
    set xshift $::scrwidth
    if {$::typetlf} {
	set xshift 0
    } else {
	set xshift $::scrwidth
    }
#    place .topPinPw -in $w  -width  [expr {$::scrwidth - 4 * $::px2mm}]  -rely 3.0   -x [expr $xshift + 2 * $::px2mm]
#    place .topPinPw -in $w  -width  [expr {$::scrwidth - 4 * $::px2mm}]  -rely 3.0   -x [expr $xshift + 2 * $::px2mm]
#	    set num 6
	    set zz [.fr1.can find withtag "textlineTag($num)"]
	    incr zz
	    set bb [.fr1.can bbox $zz]
	    foreach {fx0 fy0 fx1 fy1} $bb {break}
    place .topPinPw -in $w -x $fx0 -y $fy0
    set yespas ""
    focus .topPinPw.labFrPw.entryPw
    vwait yespas
    tk busy forget $w
    if {$tit != ""} {
	set ::labpas "$tit_orig"
    }
    place forget .topPinPw
    return $yespas
}

proc readPw ent {
  global widget
  global yespas
  global pass
  set pass [$ent get]
  puts "readPWD= $pass"
  $ent delete 0 end
  set yespas "yes"
}

proc page_password {}  {
  set ::labpas  "PIN-код для токена"
  ttk::label .lforpas -text "PIN-код для токена"  -textvariable ::labpas

  #Widget for enter PIN or Password
  frame .topPinPw -relief flat -bd $::bdlf -bg chocolate
  labelframe .topPinPw.labFrPw -borderwidth 4 -labelanchor nw -relief groove -labelwidget .lforpas -foreground black -height 120 -width 200  -bg #eff0f1
  pack .topPinPw.labFrPw -in .topPinPw  -anchor nw -padx 1mm -pady $::bdlf -fill both -expand 0
  entry .topPinPw.labFrPw.entryPw -background snow -show * -highlightbackground gray85 -highlightcolor skyblue -justify left -relief sunken
  entry .topPinPw.labFrPw.entryLb -background snow -highlightbackground gray85 -highlightcolor skyblue -justify left -relief sunken
  pack .topPinPw.labFrPw.entryPw -fill x -expand 1 -padx 1mm -ipady 2 -pady 2mm
  bind .topPinPw.labFrPw.entryPw <Key-Return> {readPw .topPinPw.labFrPw.entryPw}
  bind .topPinPw.labFrPw.entryLb <Key-Return> {readPw .topPinPw.labFrPw.entryLb}
  ttk::button .topPinPw.labFrPw.butPw  -command {global yespas;set yespas "no"; } -text "Отмена"
  ttk::button .topPinPw.labFrPw.butOk  -command {readPw .topPinPw.labFrPw.entryPw} -text "Готово"
  ttk::button .topPinPw.labFrPw.butLbOk  -command {readPw .topPinPw.labFrPw.entryLb} -text "Готово"
  pack .topPinPw.labFrPw.butPw .topPinPw.labFrPw.butOk -pady {0 5} -sid right -padx 5 -pady {0 2mm}
}

proc butCliked {num fr} {
    global retmes
    global but
    set retmes -1
#puts "butCliked START:  ::tekFrfunc=$::tekFrfunc num=$num fr=$fr retmes=$retmes"
    set ::namecmd "$but($num)"
    if {$fr == ".fn3"} {
#pack .retpage0 -in . -side bottom -fill x -expand 1 -anchor s
	$fr.fratext.text configure -state normal
	$fr.fratext.text  delete 0.0 end;
	$fr.fratext.text insert end "\n  \tНажмите кнопку\n" tagAbout
	$fr.fratext.text insert end "\n  \"Статус облачного токена\"\n" 
	$fr.fratext.text configure -state disabled
    }  elseif {$fr == ".fn1"} {
	    set zz [.fr1.can find withtag "textlineTag($num)"]
	    incr zz
	    set bb [.fr1.can bbox $zz]
	    foreach {fx0 fy0 fx1 fy1} $bb {break}
	    makeCallout ".fr1.can" "     Подождите!\nИдёт проверка\nоблачного токена" up $fx0 $fy0
	    update
	set err [execstatus]
	.fr1.can delete Callout

	if {$err == -3 || $err == -2} {
	    makeMessage .fr1.can "Нет токена в облаке (-3).\nДля регистрации нового\nтокена PKCS#11 в облаке LS11CLOUD\nнажмите кнопку <Да>\n \
	    Если передумали - нажмите <Нет>" yesno [expr {$fx0 + (($fx1 - $fx0) / 2)}] $fy0
	    vwait retmes
	    if {$retmes == 0} {
		return
	    }
#	    tk_messageBox -title "Статус LS11CLOUD" -icon info -message "Нет токена в облаке (-3).\nНачинается процесс регистрации \nнового токена PKCS#11 в облаке LS11CLOUD.\nБудьте внимательны"
	} elseif {$err == 0} {
#	    tk_messageBox -title "Статус токена" -icon info -message "Вы зарегистрированы в облаке PKCS#11.\nОблачный токен готов к использованию."
	    makeMessage .fr1.can "Вы зарегистрированы\nв облаке PKCS#11.\nОблачный токен\nготов к использованию." ok [expr {$fx0 + (($fx1 - $fx0) / 2)}] $fy0
	    vwait retmes
	    return
	} elseif { $err == -1} {
	    makeMessage .fr1.can "Вы имеете токен в облаке.\nНеобходимо его инициализация." ok [expr {$fx0 + (($fx1 - $fx0) / 2)}] $fy0
	    vwait retmes
	    return

	    tk_messageBox -title "Статус токена" \
		-icon warning -message "Вы имеете токен в облаке.\nНо необходимо его инициализация."
		return 
	} else {
	    tk_messageBox -title "Статус токена" -icon error -message "Неизвестная ошибка\n$::resstat"
	    return
	}
    } elseif {$fr == ".fn2"} {
	    set zz [.fr1.can find withtag "textlineTag($num)"]
	    set bb [.fr1.can bbox $zz]
	    foreach {fx0 fy0 fx1 fy1} $bb {break}
	    makeCallout ".fr1.can" "Подождите!\nИдёт провекрка\nОблачного токена" down $fx0 $fy0
	    update

	set err [execstatus]
	.fr1.can delete Callout

	if {$err == -3 || $err == -2} {
	    makeMessage .fr1.can "У вас нет доступа к облаку.\nДля подключения к вашему токену \nв облаке нажмите кнопку <Да>\n \
Если вы передумали -\nнажмине кнопку <Нет>" yesno [expr {$fx0 + (($fx1 - $fx0) / 2)}] $fy0
	    vwait retmes
	    if {$retmes == 0} {
		return
	    }
#	    tk_messageBox -title "Статус LS11CLOUD" -icon info -message "У вас нет доступа к облаку.\nУкажите путь к вашему токену PKCS#11 \nв облаке LS11CLOUD.\nБудьте внимательны"
	} elseif {$err == 0} {
#	    tk_messageBox -title "Статус токена" -icon info -message "Вы зарегистрированы в облаке PKCS#11.\nОблачный токен готов к использованию."
	    incr zz
	    set bb [.fr1.can bbox $zz]
	    foreach {fx0 fy0 fx1 fy1} $bb {break}
	    makeMessage .fr1.can "Вы зарегистрированы\nв облаке PKCS#11.\nОблачный токен\nготов к использованию." warn [expr {$fx0 + (($fx1 - $fx0) / 2)}] $fy0
	    return
	} elseif { $err == -1} {
	    incr zz
	    set bb [.fr1.can bbox $zz]
	    foreach {fx0 fy0 fx1 fy1} $bb {break}
	    makeMessage .fr1.can "Вы имеете токен в облаке.\nНеобходимо его инициализация." warn [expr {$fx0 + (($fx1 - $fx0) / 2)}] $fy0
	    return
	    
	    tk_messageBox -title "Статус токена" \
		-icon warning -message "Вы имеете токен в облаке.\nНо необходимо его проинициализировать."
		return 
	} else {
	    tk_messageBox -title "Статус токена" -icon error -message "Неизвестная ошибка\n$::resstat"
	    return
	}
    } elseif {$fr == ".fn4"} {
	set dircloud [file dirname $::dstlib]
	set fileconf [file join "$dircloud" "config.txt"]
	if {![file exists "$fileconf"]} {
	    set zz [.fr1.can find withtag "textlineTag($num)"]
	    incr zz
	    set bb [.fr1.can bbox $zz]
	    foreach {fx0 fy0 fx1 fy1} $bb {break}
	    makeMessage .fr1.can "Вы не зарегистрированы в облаке\nУ вас нет токена" warn [expr {$fx0 + (($fx1 - $fx0) / 2)}] $fy0
#    	    tk_messageBox -title "Смена пароля" -icon error -message "Вы не зарегистрированы в облаке\n"
    	    return
	}
	set fp [open "$fileconf" r]
	set host ""
	set port ""
	set id ""
	while {![eof $fp]} {
	    gets $fp res
    	    if { "host = \"" == [string range $res 0 7]} {
    		set h [string range $res 8 end]
    		set ptr [string first "\"" $h]
    		set host [string range $h 0 $ptr-1]
    	    } elseif { "port = \"" == [string range $res 0 7]} {
    		set h [string range $res 8 end]
    		set ptr [string first "\"" $h]
    		set port [string range $h 0 $ptr-1]
    	    } elseif { "id = \"" == [string range $res 0 5]} {
    		set h [string range $res 6 end]
    		set ptr [string first "\"" $h]
    		set id [string range $h 0 $ptr-1]
    	    }
	}
	if {$host == "" || $port == "" || $id == ""} {
    	    tk_messageBox -title "Смена пароля" -icon error -message "Регистрационный файл испорчен\n"
    	    return
	}
puts "$host,$port,$id"
	.fn4.url.entTok configure -state normal
	.fn4.url.entPort configure -state normal
	.fn4.aut.entLogin configure -state normal
	.fn4.url.entTok delete 0 end
	.fn4.url.entTok insert end $host
	.fn4.url.entPort delete 0 end
	.fn4.url.entPort insert end $port
	.fn4.url.entTok configure -state disabled
	.fn4.url.entPort configure -state disabled
	.fn4.aut.entLogin delete 0 end
	.fn4.aut.entLogin insert end $id
	.fn4.aut.entLogin configure -state disabled
	.fn4.aut.entRepUserPin delete 0 end
	.fn4.aut.entCloudPas delete 0 end
	.fn4.aut.entUserPin delete 0 end
    } elseif {$num == 6 || $num == 7}  {
	incr num
	    set zz [.fr1.can find withtag "textlineTag($num)"]
	    set bb [.fr1.can bbox $zz]
	    foreach {fx0 fy0 fx1 fy1} $bb {break}
	    makeCallout ".fr1.can" "Подождите!\nИдёт провекрка\nОблачного токена" down $fx0 $fy0
	    update

	set err [execstatus]
	.fr1.can delete Callout

	if {$err == -3 || $err == -2} {
	    makeMessage .fr1.can "У вас нет доступа к облаку." warn [expr {$fx0 + (($fx1 - $fx0) / 2)}] $fy0
	    vwait retmes
	    return
	} else {
	    global pass
	    global yespas
	    global retmes
	    set retmes -1
	    incr num -1
	    if {$num == 6} {
		set typecmd "recreate"
		set mestok "Вы действительно хотите\nпересоздать токен?\nВсе данные на\nтокене будут уничтожены!"
		set mestok1 "Токен в облаке пересоздан.\nНеобходимо его инициализировать"
	    } elseif {$num == 7} {
		set typecmd "unregister"
		set mestok "Вы действительно хотите\nуничтожмть токен?\nВсе данные на\nтокене будут уничтожены!"
		set mestok1 "Ваш токен в облаке уничтоженю\nУ вас больше нет\nдоступа к облаку!"
	    } else {
		set mestok "Неизвестная команда $num"
		makeMessage .fr1.can "$mestok" warn [expr {$fx0 + (($fx1 - $fx0) / 2)}] $fy0
		vwait retmes
		return 0
	    }
	    makeMessage .fr1.can "$mestok" yesno [expr {$fx0 + (($fx1 - $fx0) / 2)}] $fy0
	    vwait retmes
	    if {$retmes == 0} {
		return 0
	    } 
	    set retmes -1
	    read_password "Введите пароль для облака" ".fr1.can" $num
	    if { $yespas == "no" } {
    		set pass ""
    		return 0
	    }
	    set cmd "$::mm $typecmd -p \"$pass\""
	    if {[catch {eval exec "$cmd" } res]} {
		set pass ""
    		set meser "Ошибка доступа к облаку\nПроверьте пароль и\nстатус токена"
		makeMessage .fr1.can "$meser" "error" [expr {$fx0 + (($fx1 - $fx0) / 2)}] $fy0
#		mesls11cloud "$meser" ".fr1.can" "error"
    		return
	    }
	    set pass ""
	    makeMessage .fr1.can "$mestok1" "ok" [expr {$fx0 + (($fx1 - $fx0) / 2)}] $fy0
#	    mesls11cloud "$mestok1" ".fr1.can" "ok"
	}
	return
    } elseif {$fr == ".fn8"} {
#	pack .retpage0 -in . -side bottom -fill x -expand 1 -anchor s
#	pack .retpage0 -anchor center -expand 0 -fill x -ipadx 0 -ipady 0 -padx 0 -pady 0 -side top
    }
    pack forget  .fr1
    set ::tekFrfunc $fr
#puts "butCliked=$num fr=$fr"
#$fr configure -bg red
#. configure -bg blue
#    pack $fr -in . -side top -anchor center -expand 1 -fill both -side top  -padx 0 -pady 0 
    pack .retpage0 -anchor center -expand 0 -fill x -ipadx 0 -ipady 0 -padx 0 -pady 0 -side top
    pack $fr -anchor center -expand 1 -fill both -ipadx 0 -ipady 0 -padx 0 -pady 0 -side top

pack $fr .retpage0 -in .
    if {$fr == ".fn3"} {
#	update
#Эмуляция нажатия кнопки "Статус облачного токена"
#	statcloud  $fr.fratext
	$fr.butop invoke
    }
}

proc butReturn {} {
    switch $::tekFrfunc {
	".fn1" {
		place forget .lfrnd
	    } 
	".fn2" {
		place forget .lfrnd1
	}
    }
    if {$::tekFrfunc == ".fn1" || $::tekFrfunc == ".fn2"} {
	set w "$::tekFrfunc"
	$w.butop configure -state normal
	catch {tk busy forget $w.aut}
	catch {tk busy forget $w.url}
    }
    pack forget .retpage0
    pack forget  $::tekFrfunc
    pack .fr1 -side top -anchor center -expand 1 -fill both -side top  -padx 0 -pady 0 
#    tk_dialog .dialog1 "Dear user:" "Button $num was clicked\nFr=$fr" info 0 OK 
}

proc execstatus {} {
    set err [catch {exec $::mm  status } ::resstat]
    set cm [string first "Use register or dublicate command first" $::resstat]
    if { $cm != -1} {
	return -2
    }

    set cm [string first "Token Info:" $::resstat]
    if { $cm == -1} {
	return -3
    }
    set cm [string first "CKF_USER_PIN_INITIALIZED" $::resstat]
    if { $cm == -1} {
	return -1
    }
    if {$err} {
	return -3
	return $err
    }
    return 0
}


#Статус облачного токена
proc statcloud {w} {
    $w.text configure -state normal
    $w.text  delete 0.0 end;
#    $w.text insert end "\n  Подождите ...\nПроверяется статус LS11CLOUD\n\n" tagAbout
    update
    set messtat "Подождите ...\nПроверяется статус LS11CLOUD\n"
	    foreach {wmes hmes} [makeMessage "" "$messtat" warn 0 0] {break}
#Добавим дельту (для учета, например толщины линий)
	    set del 8
	    set wmes [expr {int($wmes + $del)}]
	    set hmes [expr {int($hmes + $del)}]
	    set retmes -1
	    set imagefe [CaptureWindow $w]
	    set wcan [expr {[winfo width $w]}]
#	set hcan [winfo height $w]
	    set hcan [expr {[winfo height $w]}]
	    tk busy hold $w
	    tkp::canvas .cancloud  -background black -width $wmes -height $hmes -borderwidth 0
#Вырезаем прямоугольник
    	    set xoff [expr {int(($wcan - $wmes) / 2.0 ) - $del / 2}]
#    	    set yoff [expr {[winfo y $w] + [winfo height $w] - $del / 2}]
    	    set yoff [expr {[winfo y $w] + [winfo height $w] / 4  - $del / 2}]
#puts "wmes=$wmes hmes=$hmes"
	    image create photo imfn
	    imfn copy $imagefe -from  $xoff $yoff  [expr {$xoff + $wmes + $del / 2 }] [expr {$yoff + $hmes + $del / 2}]
	    place .cancloud -in $w -x $xoff    -y  $yoff
	    .cancloud create pimage 0 0 -image imfn -anchor nw
	    makeMessage .cancloud $messtat warn [expr {int($wmes / 2.0) + 0}]  [expr {$del / 2 }]
    update
###########
#set passw "Jephpotmas"
#set passw "11111111"
#    set err [catch {exec $::mm  status -p $passw} result]
####
    set err [execstatus]
	    image delete imfn $imagefe
	    destroy .cancloud
	    tk busy forget $w

    $w.text  delete 0.0 end;

    $w.text insert end "\n  Полная информация о LS11CLOUD ($err)\n\n" tagAbout
    $w.text insert end "TEST UTILE=$::mm\n"

    $w.text insert end "$::resstat\n"
    $w.text insert end "TEST END\n"
    $w.text configure -state disabled
    update
#Тип сообщения
    switch $err {
	-3 {
	    set messtat "Нет токена в облаке (-3).\nНеобходимо зарегистрировать \nновый токен или\nподключиться к имеющемуся \nтокену в облаке"
	}
	-2 {
	    set messtat "Нет токена в облаке (-2).\nНеобходимо зарегистрировать \nновый токен или\nподключиться к имеющемуся \nтокену в облаке"
	}
	-1 {
	    set messtat "Вы имеете токен в облаке.\nНо необходимо его \nпроинициализировать."
	}
	default {
	    set messtat "Вы зарегистрированы \nв облаке PKCS#11.\nТокен готов к использованию."
	}
    }
	    foreach {wmes hmes} [makeMessage "" "$messtat" info 0 0] {break}
#Добавим дельту (для учета, например толщины линий)
	    set del 8
	    set wmes [expr {int($wmes + $del)}]
	    set hmes [expr {int($hmes + $del)}]
	    set retmes -1
	    set imagefe [CaptureWindow $w]
	    set wcan [expr {[winfo width $w]}]
#	set hcan [winfo height $w]
	    set hcan [expr {[winfo height $w]}]
	    tk busy hold $w
	    tkp::canvas .cancloud  -background black -width $wmes -height $hmes -borderwidth 0
#Вырезаем прямоугольник
    	    set xoff [expr {int(($wcan - $wmes) / 2.0 ) - $del / 2}]
#    	    set yoff [expr {[winfo y $w] + [winfo height $w] - $del / 2}]
    	    set yoff [expr {[winfo y $w] + [winfo height $w] / 4  - $del / 2}]
#puts "wmes=$wmes hmes=$hmes"
	    image create photo imfn
	    imfn copy $imagefe -from  $xoff $yoff  [expr {$xoff + $wmes + $del / 2 }] [expr {$yoff + $hmes + $del / 2}]
	    place .cancloud -in $w -x $xoff    -y  $yoff
	    .cancloud create pimage 0 0 -image imfn -anchor nw
	    makeMessage .cancloud $messtat info [expr {int($wmes / 2.0) + 0}]  [expr {$del / 2 }]
	    vwait retmes
	    image delete imfn $imagefe
	    destroy .cancloud
	    tk busy forget $w

    return $err
}

proc mesls11cloud {meser w type} {
    if {$meser != ""} {
	    foreach {wmes hmes} [makeMessage "" "$meser" "$type" 0 0] {break}
#Добавим дельту (для учета, например толщины линий)
	    set del 8
	    set wmes [expr {int($wmes + $del)}]
	    set hmes [expr {int($hmes + $del)}]
	    set retmes -1
	    set imagefe [CaptureWindow $w]
	    set wcan [expr {[winfo width $w]}]
	    set hcan [expr {[winfo height $w.lurl]}]
	    tk busy hold $w
	    tkp::canvas .cancloud  -background black -width $wmes -height $hmes -borderwidth 0
#Вырезаем прямоугольник
    	    set xoff [expr {int(($wcan - $wmes) / 2.0 ) - $del / 2}]
    	    set yoff [expr {[winfo y $w.url] + [winfo height $w.url] - $del / 2}]
	    image create photo imfn
	    imfn copy $imagefe -from  $xoff $yoff  [expr {$xoff + $wmes + $del / 2 }] [expr {$yoff + $hmes + $del / 2}]
	    place .cancloud -in $w -x $xoff    -y  $yoff
	    .cancloud create pimage 0 0 -image imfn -anchor nw
	    makeMessage .cancloud $meser $type [expr {int($wmes / 2.0) + 0}] [expr {$del / 2}]
	    vwait retmes
	    image delete imfn $imagefe
	    destroy .cancloud
	    tk busy forget $w
	    set meser ""
    }
}
proc mes2frame {meser w type {wait "yes"}} {
    global retmes
puts "mes2frame: wait=$wait"
    if {$meser != ""} {
	    foreach {wmes hmes} [makeMessage "" "$meser" "$type" 0 0] {break}
#Добавим дельту (для учета, например толщины линий)
	    set del 8
	    set wmes [expr {int($wmes + $del)}]
	    set hmes [expr {int($hmes + $del)}]
	    set retmes -1
	    set imagefe [CaptureWindow $w]
	    set wcan [expr {[winfo width $w]}]
	    set hcan [expr {[winfo height $w]}]
	    tk busy hold $w
	    tkp::canvas .cancloud  -background black -width $wmes -height $hmes -borderwidth 0
#Вырезаем прямоугольник
    	    set xoff [expr {int(($wcan - $wmes) / 2.0 ) - $del / 2}]
    	    set yoff [expr {[winfo y $w] + [winfo height $w] / 4 - $del / 2}]
	    image create photo imfn
	    imfn copy $imagefe -from  $xoff $yoff  [expr {$xoff + $wmes + $del / 2 }] [expr {$yoff + $hmes + $del / 2}]
	    place .cancloud -in $w -x $xoff    -y  $yoff
	    .cancloud create pimage 0 0 -image imfn -anchor nw
	    makeMessage .cancloud $meser $type [expr {int($wmes / 2.0) + 0}] [expr {$del / 2}]
	    if {$wait == "yes"} {
		vwait retmes
		image delete imfn $imagefe
		destroy .cancloud
		tk busy forget $w
		set meser ""
	    }
    }
}

proc req2cloud {w type} {
#type - register or dublicate
  set typemes ""
  if {$type == "register"} {
    set typemes "Регистрация пользователя в облаке"
  } elseif {$type == "duplicate"} {
    set typemes "Дубликат регистрации в облаке"
  } elseif {$type == "change_pswd"} {
    set typemes "Смена пароля для доступа к облаку"
  } else {
    tk_messageBox -title "Регистрация пользователя в облаке" -icon error -message "Неизвестная команда\n$type"
    return
  }

    set pas1 [$w.aut.entUserPin get]
    set pas2 ""
    if {$type == "register" || $type == "change_pswd"} {
      set pas2 [$w.aut.entRepUserPin get]
    }
    set len [string length $::cloudlogin]
    set lenpas [string length $pas1]
    if {$type == "change_pswd"} {
      set tekpswd $pas1
      set pas1 [$w.aut.entCloudPas get]
      set lenpas [string length $pas1]

      if { $pas1 == "" || $pas2 == "" || $tekpswd == ""} {
#        tk_messageBox -title "$typemes" -icon error -message "Не все поля заполнены\n"
        set meser "Не все поля заполнены"
	mesls11cloud "$meser" $w "error"
        return
      }
      if {$pas1 != $pas2} {
#        tk_messageBox -title "$typemes" -icon error -message "Разные пароли\n"
        set meser "Разные пароли"
	mesls11cloud "$meser" $w "error"
        return
      }
    } else {
#register or dublicate
	global retmes
	set meser ""
        if { $::cloudhost == "" || $::cloudport == "" || $::cloudlogin == "" || $pas1 == "" || ("$type" == "register" && $pas2 == "")} {
	    set meser "Не все поля заполнены"
        } elseif {$len < 6 || $lenpas < 6} {
	    set meser "Логин и пароль должны\nиметь не менее 6 символов"
        } elseif {$type == "register" && ($pas1 != $pas2)} {
	    set meser "Разные пароли"
        } 
if {1} {
        if {$meser == ""} {    
#Проверка доступности облака с токенами
	    foreach {wmes hmes} [makeMessage "" "Подождите!\nИдёт провекрка\nдоступности облака LC11Cloud" info 0 0] {break}
#	    foreach {wmes hmes} [makeCallout "" "Подождите!\nИдёт провекрка\nдоступности облака LC11Cloud" down 0 0] {break}
#Добавим дельту (для учета, например толщины линий)
	    set del 8
	    set wmes [expr {int($wmes + $del)}]
	    set hmes [expr {int($hmes + $del)}]
	    set retmes -1
	    set imagefe [CaptureWindow $w]
	    set wcan [expr {[winfo width $w]}]
#	set hcan [winfo height $w]
	    set hcan [expr {[winfo height $w.lurl]}]
	    tk busy hold $w
	    tkp::canvas .cancloud  -background black -width $wmes -height $hmes -borderwidth 0
#Вырезаем прямоугольник
    	    set xoff [expr {int(($wcan - $wmes) / 2.0 ) - $del / 2}]
    	    set yoff [expr {[winfo y $w.url] + [winfo height $w.url] - $del / 2}]
#puts "wmes=$wmes hmes=$hmes"
	    image create photo imfn
	    imfn copy $imagefe -from  $xoff $yoff  [expr {$xoff + $wmes + $del / 2 }] [expr {$yoff + $hmes + $del / 2}]
	    place .cancloud -in $w -x $xoff    -y  $yoff
	    .cancloud create pimage 0 0 -image imfn -anchor nw

	    makeMessage ".cancloud" "Подождите!\nИдёт провекрка\nдоступности облака LC11Cloud" info [expr {int($wmes / 2.0) + 0}] [expr {$del / 2}]
#	    makeCallout ".cancloud" "Подождите!\nИдёт провекрка\nдоступности облака LC11Cloud" down $del $hmes
	    update
    	    if {[catch {socket $::cloudhost  $::cloudport } res]} {
		set meser "Облачный токен не доступен\nПроверьте адрес хоста и\nномер порта"
	    } else {
		close $res
	    }
after 1000
	    image delete imfn $imagefe
#	    .cancloud delete Callout
	    .cancloud delete Message
	    destroy .cancloud
	    tk busy forget $w
	}
}         
        if {$meser != ""} {    
	    foreach {wmes hmes} [makeMessage "" "$meser" error 0 0] {break}
#Добавим дельту (для учета, например толщины линий)
	    set del 8
	    set wmes [expr {int($wmes + $del)}]
	    set hmes [expr {int($hmes + $del)}]
	    set retmes -1
	    set imagefe [CaptureWindow $w]
	    set wcan [expr {[winfo width $w]}]
#	set hcan [winfo height $w]
	    set hcan [expr {[winfo height $w.lurl]}]
	    tk busy hold $w
	    tkp::canvas .cancloud  -background black -width $wmes -height $hmes -borderwidth 0
#Вырезаем прямоугольник
    	    set xoff [expr {int(($wcan - $wmes) / 2.0 ) - $del / 2}]
    	    set yoff [expr {[winfo y $w.url] + [winfo height $w.url] - $del / 2}]
#puts "wmes=$wmes hmes=$hmes"
	    image create photo imfn
	    imfn copy $imagefe -from  $xoff $yoff  [expr {$xoff + $wmes + $del / 2 }] [expr {$yoff + $hmes + $del / 2}]
	    place .cancloud -in $w -x $xoff    -y  $yoff
	    .cancloud create pimage 0 0 -image imfn -anchor nw
#	.cancloud create pimage [expr {$wmes + 4 }] [expr {$hmes + 4}] -image imfn -anchor se
	    makeMessage .cancloud $meser error [expr {int($wmes / 2.0) + 0}] [expr {$del / 2}]
	    vwait retmes
	    image delete imfn $imagefe
	    destroy .cancloud
	    tk busy forget $w
	    return
        }
    }
    if { $lenpas < 6} {
      tk_messageBox -title "$typemes" -icon error -message "Пароль должен иметь не менее 6 символов\n"
      return
    }
    if {$type == "change_pswd"} {
	set cmd "$::mm change_pswd -p $tekpswd -n \"$pas1\""
	if {[catch {eval exec "$cmd" } res]} {
#    	    tk_messageBox -title "$typemes" -icon error -message "Ошибка доступа к облаку" -detail "$res"
    	    set meser "Смена пароля!\nОшибка доступа к облаку\nПроверьте текущий пароль"
	    mesls11cloud "$meser" $w "error"
    	    return
	}
	set cmd "$::mm save_pswd_hash -p \"$pas1\""
	if {[catch {eval exec "$cmd" } res]} {
#    	    tk_messageBox -title "$typemes" -icon error -message "Ошибка доступа к облаку" -detail "$res"
    	    set meser "Смена пароля (hash)!\nОшибка доступа к облаку\nПроверьте текущий пароль"
	    mesls11cloud "$meser" $w "error"
    	    return
	}
#    	tk_messageBox -title "$typemes" -icon info -message "Пароль успешно изменен"
        set meser "Пароль для доступа к\nоблаку успешно изменен"
	mesls11cloud "$meser" $w "ok"

	$w.aut.entRepUserPin delete 0 end
	$w.aut.entCloudPas delete 0 end
	$w.aut.entUserPin delete 0 end

	return
    }
#tk_messageBox -title "$typemes" -icon info -message "Здесь будет выполняться $type\n"

    spawn $::mm $type $::cloudhost $::cloudport $::cloudlogin -p $pas1
    set press ""
    set lineterminationChar "Press key *"
    set reqok 0
    set meser ""
    expect  { 
	$lineterminationChar {
    	    set ttt $expect_out(buffer)
	    set cm [string first "Press key " $ttt]
	    if { $cm == -1} {
    		exp_continue;
	    } else {
		incr cm 10
		set ::initSym [string index  $expect_out(buffer) $cm]
	    }
	    if {$press == "" && ($type == "register" || $type == "duplicate") } {
		set press 1
		if {$type == "duplicate"} {
		    place .lfrnd1 -in $w.lurl -relx 0.15 -rely 1.2
		    focus .lfrnd1.frsym.ent80
		} else {
		    place .lfrnd -in $w.lurl -relx 0.15 -rely 1.2
		    focus .lfrnd.frsym.ent80
		}
		$w.butop configure -state disabled
		tk busy hold $w.aut
		tk busy hold $w.url
	    }
    	    update
	    set  ::presskey1 ""
	    vwait ::presskey1
#    	    exp_send "$::initSym"
    	    exp_send "$::presskey1"
	    set  ::presskey $::presskey1
    	    exp_continue;	
	}
	"Replace this file" {
#puts "REPLACE\n"
    	    exp_send "n"
#	    tk_messageBox -title "Регистрация в облаке" -icon info -message "Вы уже зарегистрированы в облаке\n"
	    set meser "Вы уже зарегистрированы\nв облаке LC11Cloud"
	    mesls11cloud $meser $w "ok"
    	    exp_continue;	
	}
	"Account duplicated OK" {
#puts "OKOK DUP w=$w \n"
	    catch {[file delete -force $::dstlib]}
#	    file copy $::libcloud $::dstlib
	    file copy $::llc11cloud $::dstlib

#	    tk_messageBox -title "Подключение к облаку" -icon info -message "Вы успешно подключились к токену\nПроверьте его статус\n"
#	    place forget .lfrnd1
	    set meser "Вы успешно подключились к\nоблачному токену.\nПроверьте его статус"
	    mesls11cloud $meser $w "ok"
	    set reqok 1
	    exp_continue;	
	}
	"Successful registration" {
#puts "OKOK\n"
	    catch {[file delete -force $::dstlib]}
	    file copy $::libcloud $::dstlib

#	    tk_messageBox -title "Регистрация в облаке" -icon info -message "Вы зарегмистрированы в облаке\nТребуется инициализация токена\n"
	    set meser "Вы зарегмистрированы в облаке\nТребуется инициализация токена"
	    mesls11cloud $meser $w "ok"
	    set reqok 1
    	    exp_continue;	
	}
	"40 random bytes" {append out $expect_out(buffer)
	    if {$type == "duplicate"} {
		place forget .lfrnd1
	    } else {
		place forget .lfrnd
	    }
#tk_messageBox -title "$typemes" -icon info -message "RANDOM END\n$expect_out(buffer)"
	    set meser "Начальное значение \nДСЧ сформировано"
	    mesls11cloud $meser $w "info"
	    exp_continue;	
	}
	"already registered" {append out $expect_out(buffer)
#tk_messageBox -title "$typemes" -icon info -message "Already Registered\n$expect_out(buffer)"
	    set meser "Вы уже зарегистрированы\nв облаке LC11Cloud"
	    mesls11cloud $meser $w "info"
    	    exp_continue;	
	}
	"ERROR:" {append out $expect_out(buffer)
#tk_messageBox -title "$typemes" -icon info -message "ERROR\n$expect_out(buffer)"
	    set meser "Ошибка аутентификации!\nПроверьте логин и пароль"
	    mesls11cloud $meser $w "error"
    	    exp_continue;	
	}
	eof {
if {0} {
global env
set userpath $env(EXTERNAL_STORAGE)
set logfile [file join $userpath "LOGCLOUD.txt"]
  set fd [open $logfile w]
  chan configure $fd -translation binary
  puts -nonewline $fd $expect_out(buffer)
  close $fd
}
#    puts "EOF=$expect_out(buffer)"
#	    tk_messageBox -title "$typemes" -icon info -message "EOF регистрации END\n"

	}
    }

catch {tk busy forget $w}
    if {$reqok} {
	set cmd "$::mm save_pswd_hash -p \"$pas1\""
	if {[catch {eval exec "$cmd" } res]} {
    	    tk_messageBox -title "$typemes" -icon error -message "Ошибка доступа к облаку" -detail "$res"
    	    return
	}
    }

    $w.butop configure -state normal
    tk busy forget $w.aut 
    tk busy forget $w.url 
    if {$type == "duplicate"} {
	place forget .lfrnd1
    } else {
	place forget .lfrnd
    }
#tk_messageBox -title "$typemes" -icon info -message "END ls11cloud_config\n"

}

proc ::entryRnd {ent len text size} {
  puts "DIGIT $ent $len $text $size"
  $ent configure -text $text
  if { $text != $::initSym } {
    $ent configure -bg red
  } else {
    $ent configure -bg skyblue
  }
  set ::presskey1 $text
    return 0
}

#Регистрация в облаке
proc func_page1 {w} {
    set px2cm [expr {$::intpx2mm * 10}]
#Окно регистрации в облаке
    set pretext "  Для регистрации токена в облаке необходимо указать адрес облака (хост/порт), а также логин пользователя и пароль для доступа в облако.\n \
  P.S. Длина пароля должна быть не менее 6 (шести) символов и не используйте в нем нелатинские символы."
    message $w.lurl -relief groove -bd 3 -fg blue  -text $pretext -pady $::intpx2mm  -padx 2mm  -font "helvetica 8 bold italic" -bg #eff0f1 -justify left -aspect $::scrwidth
    labelframe $w.url -relief groove -bd 3 -fg blue  -text "Адрес облака" -padx 2mm -pady 0 -font "helvetica 8 bold italic" -bg #eff0f1
    label $w.url.labTok -bg wheat -justify left -text "Хост:"  -anchor w
    entry $w.url.entTok -background snow -width 27 -textvariable ::cloudhost
    grid $w.url.labTok $w.url.entTok -padx 2 -sticky news
    label $w.url.labPort -text "Порт:" -anchor w -bg wheat
    entry $w.url.entPort -background snow -textvariable ::cloudport
    grid $w.url.labPort $w.url.entPort  -padx 2 -pady 2 -sticky news
    grid columnconfigure $w.url 1 -weight 1
    labelframe $w.aut -relief groove -bd 3 -fg blue  -text "Авторизация в облаке" -padx 2mm -pady 0 -font "helvetica 8 bold italic" -bg #eff0f1
    label $w.aut.labLogin -background wheat -text "Логин:" -anchor w
    entry $w.aut.entLogin -background snow -width 23  -textvariable ::cloudlogin
    grid $w.aut.labLogin $w.aut.entLogin  -padx 2 -pady 2 -sticky news
    label $w.aut.labUserPin  -bg wheat -text "Пароль:" -anchor w
    entry $w.aut.entUserPin -background snow -show *
    grid $w.aut.labUserPin $w.aut.entUserPin  -padx 2 -pady 2 -sticky news
    label $w.aut.labRepUserPin  -bg wheat -text "Повторите" -anchor w
    entry $w.aut.entRepUserPin -background snow -show *
    grid $w.aut.labRepUserPin $w.aut.entRepUserPin  -padx 2 -pady 2 -sticky news
    grid columnconfigure $w.aut 1 -weight 1
#Кнопка регистрации:
    set cmd "ttk::button  $w.butop -command {req2cloud $w \"register\"} -text {Зарегистрироваться} "
    eval [subst $cmd]
#Фрейм инициализации ДСЧ
    labelframe .lfrnd -borderwidth 5 -foreground black \
		-text {Инициализация ДСЧ}  -fg black -font "helvetica 8 bold italic" -bg #eff0f1
    frame .lfrnd.frsym -borderwidth 2 -relief groove
    label .lfrnd.frsym.lab77 -bg wheat -text {Введите символ: } 
    set len 1
    set com "entry .lfrnd.frsym.ent80 -width 2 -validate key -validatecommand {::entryRnd .lfrnd.labViewSym %i %P $len}"
    eval [subst $com]
    .lfrnd.frsym.ent80 configure -width 5
    set ::initSym "X"
    label .lfrnd.frsym.labSym -text $::initSym -width 2  -textvariable ::initSym \
		-background {#00ffff} \
		-font "-family {Liberation Sans} -size 18 -weight normal -slant roman -underline 0 -overstrike 0"
    pack .lfrnd.frsym.lab77 -anchor center -expand 0 -fill none -side left -padx 5
    pack .lfrnd.frsym.ent80 -anchor center -expand 0 -fill none -padx 10 -side right 
    pack .lfrnd.frsym.labSym -anchor center -expand 0 -fill none -side left 
    label .lfrnd.labViewSym \
		-background {#00ffff} -borderwidth 4 -width 2 \
		-relief groove -text X -textvariable ::presskey \
		-font "-family {Liberation Sans} -size 48 -weight normal -slant roman -underline 0 -overstrike 0"
    pack .lfrnd.frsym  -anchor n -expand 1 -fill x -side top -pady 10 -padx 10
    pack .lfrnd.labViewSym -anchor center -expand 1 -fill y -side bottom -pady 10
#Упаковка frame-ов
    pack $w.butop -in $w -fill none -side bottom -pady $::intpx2mm
    eval "pack $w.lurl -in $w -side top -fill none -pady {5mm 0}"
    pack $w.url -in $w -side top -fill x -pady $px2cm -padx $::intpx2mm
    pack $w.aut -in $w -side top -fill x -padx $::intpx2mm
}

#Доступ к существующему токену в облаке
proc func_page2 {w} {
    set px2cm [expr {$::intpx2mm * 10}]
#Окно регистрации в облаке
    set pretext "  Для доступа к вашему токену в облаке необходимо указать адрес облака (хост/порт), а также логин пользователя и пароль для доступа к облаку.\n"
    message $w.lurl -relief groove -bd 3 -fg blue  -text $pretext -pady $::intpx2mm  -padx 2mm  -font "helvetica 8 bold italic" -bg #eff0f1 -justify left -aspect $::scrwidth

    labelframe $w.url -relief groove -bd 3 -fg blue  -text "Адрес облака" -padx 2mm -pady 0 -font "helvetica 8 bold italic" -bg #eff0f1

    label $w.url.labTok -bg wheat -justify left -text "Хост:"  -anchor w
    entry $w.url.entTok -background snow -width 27 -textvariable ::cloudhost
    grid $w.url.labTok $w.url.entTok -padx 2 -sticky news
    label $w.url.labPort -text "Порт:" -anchor w -bg wheat
    entry $w.url.entPort -background snow -textvariable ::cloudport
    grid $w.url.labPort $w.url.entPort  -padx 2 -pady 2 -sticky news
    grid columnconfigure $w.url 1 -weight 1

    labelframe $w.aut -relief groove -bd 3 -fg blue  -text "Авторизация в облаке" -padx 2mm -pady 0 -font "helvetica 8 bold italic" -bg #eff0f1
    label $w.aut.labLogin -background wheat -text "Логин:" -anchor w
    entry $w.aut.entLogin -background snow -width 23  -textvariable ::cloudlogin
    grid $w.aut.labLogin $w.aut.entLogin  -padx 2 -pady 2 -sticky news
    label $w.aut.labUserPin  -bg wheat -text "Пароль:" -anchor w
    entry $w.aut.entUserPin -background snow -show *
    grid $w.aut.labUserPin $w.aut.entUserPin  -padx 2 -pady 2 -sticky news
    grid columnconfigure $w.aut 1 -weight 1
#Кнопка регистрации:
    set cmd "ttk::button  $w.butop -command {req2cloud $w \"duplicate\"} -text {Продублировать доступ} "
    eval [subst $cmd]
#Фрейм инициализации ДСЧ
    labelframe .lfrnd1 \
		-borderwidth 5 -foreground black \
		-text {Инициализация ДСЧ}  -fg black -font "helvetica 8 bold italic" -bg #eff0f1
    frame .lfrnd1.frsym \
		-borderwidth 2 -relief groove
    label .lfrnd1.frsym.lab77 -bg wheat -text {Введите символ: } 
    set len 1
    set com "entry .lfrnd1.frsym.ent80 -width 2 -validate key -validatecommand {::entryRnd .lfrnd1.labViewSym %i %P $len}"
        set com1 [subst $com]
        eval $com1
    .lfrnd1.frsym.ent80 configure -width 5
    set ::initSym "X"
    label .lfrnd1.frsym.labSym -text $::initSym -width 2  -textvariable ::initSym \
		-background {#00ffff} \
		-font "-family {Liberation Sans} -size 18 -weight normal -slant roman -underline 0 -overstrike 0"
    pack .lfrnd1.frsym.lab77 -anchor center -expand 0 -fill none -side left -padx 5
    pack .lfrnd1.frsym.ent80 -anchor center -expand 0 -fill none -padx 10 -side right 
    pack .lfrnd1.frsym.labSym -anchor center -expand 0 -fill none -side left 
    label .lfrnd1.labViewSym \
		-background {#00ffff} -borderwidth 4 -width 2 \
		-relief groove -text X -textvariable ::presskey \
		-font "-family {Liberation Sans} -size 48 -weight normal -slant roman -underline 0 -overstrike 0"
    pack .lfrnd1.frsym -anchor n -expand 1 -fill x -side top -pady 10 -padx 10
    pack .lfrnd1.labViewSym -anchor center -expand 1 -fill y -side bottom -pady 10
#Увакрвка frame-s
    pack $w.butop -in $w -fill none -side bottom -pady $::intpx2mm
    eval "pack $w.lurl -in $w -side top -fill none -pady {5mm 0}"
    pack $w.url -in $w -side top -fill x -pady $px2cm -padx $::intpx2mm
    pack $w.aut -in $w -side top -fill x -padx $::intpx2mm
}

#Статус облачного токене
proc func_page3 {w} {
  frame $w.fratext -borderwidth 0 -relief flat
  text $w.fratext.text -yscrollcommand [list $w.fratext.scy set] -xscrollcommand [list $w.fratext.scx set] \
  -insertbackground black -bg #f5f5f5 -highlightcolor skyblue -wrap none  -height 27
  $w.fratext.text tag configure tagAbout -foreground blue -font {{Roboto} 9}
  ttk::scrollbar $w.fratext.scy  -command [list $w.fratext.text yview]
  ttk::scrollbar $w.fratext.scx -command [list $w.fratext.text xview] -orient horizontal
  #ttk::scrollbar $w.fratext.xscr -orient horizontal -command [list $w.fratext.text xview]
  pack $w.fratext.scy -anchor center -expand 0 -fill y -side right -pady {0 5mm}
  pack $w.fratext.scx -anchor center -expand 0 -fill x -side bottom
  pack $w.fratext.text -anchor center -expand 1 -fill both -side top -padx 0 -pady {0 0}
    $w.fratext.text configure -background white
  pack $w.fratext -in $w -anchor center -expand 1 -fill both -side top
#Информация о токене:
  set cmd "ttk::button  $w.butop -command {statcloud  $w.fratext} -text {Статус облачного токена} "
  eval [subst $cmd]
  pack $w.butop -fill none -side top -padx 10 -pady {4 }
}

#Смена пароля для доступа к токену
proc func_page4 {w} {
#Окно для смены пароля
    set pretext "  Для смены пароля для доступа к облаку необходимо ввсети текущий пароль и дважды новый. Остальная информация берется из регистрационного файла.
  P.S. Длина пароля должна быть не менее 6 (шести) символов и не используйте в нем нелатинские символы."
    label $w.lurl -relief groove -bd 3 -fg blue  -text $pretext -padx 0 -pady 3 -font "helvetica 8 bold italic" -bg #eff0f1 -justify left -wraplength $::scrwidth 
#     -width 40
#message $w.lurl -relief groove -bd 3 -fg blue  -text $pretext -pady 3 -font "helvetica 10 bold italic" -bg #eff0f1 -justify left -aspect $::scrwidth -width $::scrwidth
    pack $w.lurl -side top -fill both -expand 1 -padx 5 -pady 5
    labelframe $w.url -relief groove -bd 3 -fg blue  -text "Адрес облака" -padx 5 -pady 3 -font "helvetica 8 bold italic" -bg #eff0f1
    pack $w.url -side top -fill x -expand 1 -padx 5
    label $w.url.labTok -bg wheat -justify left -text "Хост:"  -anchor w
    entry $w.url.entTok -background snow
    $w.url.entTok configure -width 25
    grid $w.url.labTok $w.url.entTok -padx 2 -sticky news
    label $w.url.labPort -text "Порт:" -anchor w -bg wheat
    entry $w.url.entPort -background snow
    grid $w.url.labPort $w.url.entPort  -padx 2 -pady 2 -sticky news
    labelframe $w.aut -relief groove -bd 3 -fg blue  -text "Авторизация в облаке" -padx 5 -pady 3 -font "helvetica 8 bold italic" -bg #eff0f1
    pack $w.aut -side top -fill x -expand 1 -pady 5 -padx 5
    label $w.aut.labLogin -background wheat -text "Логин:" -anchor w
    entry $w.aut.entLogin -background snow  -width 15
    grid $w.aut.labLogin $w.aut.entLogin  -padx 2 -pady 2 -sticky news
    label $w.aut.labUserPin  -bg wheat -text "Текущий пароль:" -anchor w
    entry $w.aut.entUserPin -background snow -show * -width 15
    grid $w.aut.labUserPin $w.aut.entUserPin  -padx 2 -pady 2 -sticky news
    label $w.aut.labRepUserPin  -bg wheat -text "Новый пароль" -anchor w
    entry $w.aut.entRepUserPin -background snow -show * -width 15
    grid $w.aut.labRepUserPin $w.aut.entRepUserPin  -padx 2 -pady 2 -sticky news
    label $w.aut.labCloudPas  -bg wheat -text "Повторите :" -anchor w
    entry $w.aut.entCloudPas -background snow -show * -width 15
    grid $w.aut.labCloudPas $w.aut.entCloudPas  -padx 2 -pady 2 -sticky news
#####################
#Кнопка регистрации:
    set cmd "ttk::button  $w.butop -command {req2cloud $w \"change_pswd\"} -text {Сменить пароль} "
    eval [subst $cmd]
    pack $w.butop -fill none -side top -padx 10 -pady {4 }
}
#Конфигурирование токена
proc p11conf {c} {
  global ::handle
  global ::slotid_tek
    set ::slotid_tek 0
  variable optok
  global retmes 
  set retmes -1
    set meser "Подождите!!!\nИдет проверка токена."
    mes2frame "$meser" $c "info" "no"
    update


  if {$::handle != ""} {
    catch {::pki::pkcs11::logout $::handle 0}
    catch {set ::handle [pki::pkcs11::unloadmodule $::handle]}
    set ::handle ""
  }
#  if {[catch {set ::handle [pki::pkcs11::loadmodule "$::dstlib"]} result]} {}
  if {[catch {set ::handle [pki::pkcs11::loadmodule "libls11cloud.so"]} result]} {
#$::llc11cloud
    destroy .cancloud
    tk busy forget $c
    set meser ""

    set cm [string first "TOKEN_NOT_RECOGNIZED" $result]
    if { $cm != -1} {
      #У Токена отсутствует лицензия
	set meser "Проблемы с токеном.\nОтсутствует лицунзия"
    } else {
	set meser "Проблемы с токеном.\nВернитесь в основное меню.\nПроверьте статус токена"
    }
#puts "c=$c p11conf: $result"
    mes2frame "$meser" $c "error"
tk_messageBox -title "Проблемы" -icon info -message "$result" -detail "$::llc11cloud\n$::dstlib"  -parent .

    return $result
  }
  destroy .cancloud
  tk busy forget $c
  set meser ""

#puts "c=$c p11conf: $result ::handle=$::handle"
#Список токенов со слотами
    set slots [pki::pkcs11::listslots $handle]
#Byajhvfwbz j njrtyt
    foreach {slotid slotlabel slotflags tokeninfo} [lindex $slots 0] {break}
#puts "p11conf: slotid=$slotid slotlabel=$slotlabel slotflags=$slotflags tokeninfo=$tokeninfo"
#Проверяем делал ли пользователь инициализацию токена
    if {$optok != 0 && [string first "USER_PIN_INITIALIZED" $slotflags] == -1} {
	set meser "Вы не инициализировали токен.\nСначала требуется\nпроинициализировать токен."
	mes2frame "$meser" $c "warn"
#    tk_messageBox -title "Используемый токен"   -icon info -message "Сначало проинициализируйте токен."
	return $slotflags
    }
  switch $optok {
    0 {
      if {[string first "USER_PIN_INITIALIZED" $slotflags] != -1} {
        global retmes
        set retmes -1
        set labtok [string trim [lindex $tokeninfo 0]]
        set meser "Токен проинициализирован ранее.\nМетка: $labtok\nПовторная инициализация\nприведет к потере данных\nБудете продолжать?"
	mes2frame "$meser" $c "yesno"
puts "p11conf: retmes=$retmes"
	if {$retmes == 0} {
	    return
	}
if {0} {
        set answer [tk_messageBox -icon question \
        -title "Инициализация токена" \
        -message "Токен проинициализирован ранее." \
        -detail "Повторная инициализация приведет к потере данных\nБудете продолжать?" \
        -type yesno]

        if {$answer != "yes"} {
          return 0
        }
}
      }

      set ltok [$c.lfr2.entTok get]
      set sopin [$c.lfr2.entSoPin get]
      set upin [$c.lfr2.entUserPin get]
      set rupin [$c.lfr2.entRepUserPin get]
      if {$ltok == "" || $sopin == "" || $upin == "" || $rupin == "" || $upin != $rupin} {
        set meser "Инициализация токена\nНе все поля заполнены\nБудьте внимательны!"
	mes2frame "$meser" $c "error"
#        tk_messageBox -title "Инициализация токена" -icon info -message "Ошибка в заполнении полей. Будьте внимательны!" 
#        -detail "upin=$upin\nrupin=$rupin\nltok=$ltok\nsopin=$sopin"
        return
      }
      set ret [::pki::pkcs11::inittoken $::handle $::slotid_tek $sopin $ltok]

      if {!$ret} {
        set meser "Инициализация токена\nПроизошла ошибка\nПроверьте SO-PIN-код!"
	mes2frame "$meser" $c "error"
#        tk_messageBox -title "Инициализация токена" -icon error -message "Неудача\nПроверьте SO-PIN-код"
        return
      }
      catch {::pki::pkcs11::logout $::handle $::slotid_tek}
      set oldpin "11111111"
      ::pki::pkcs11::inituserpin $::handle $::slotid_tek $sopin $oldpin
      if {!$ret} {
        set meser "Инициализация токена\nПроизошла ошибка\nПроверьте SO-PIN-код!"
	mes2frame "$meser" $c "error"
#        tk_messageBox -title "Инициализация токена" -icon error -message "Неудача 1\n" -detail "Проверьте SO-PIN-код"
        return
      }
      set ret [::pki::pkcs11::setpin $::handle $::slotid_tek user $oldpin $upin]	
      if {$ret} {
        set meser "Инициализация токена\nТокен проинициализирован\nХраните надежно токен\n\"$ltok\"\nи PIN-коды к нему.\nПосмотрите статус токена"
	mes2frame "$meser" $c "info"
#        tk_messageBox -title "Инициализация токена" -icon info -message "Токен успешно проинициализирован" -detail "Храните надежно и токен \"$ltok\" и PIN-коды"
        $c.lfr2.entSoPin delete 0 end
        $c.lfr2.entUserPin delete 0 end
        $c.lfr2.entRepUserPin delete 0 end
      } else {
        set meser "Инициализация токена\nПроизошла ошибка\nПроверьте SO-PIN-код!"
	mes2frame "$meser" $c "error"
#        tk_messageBox -title "Инициализация токена" -icon error -message "Инициализация 2 токена не удалась" -detail "Проверьте SO-PIN-код"
      }
    }
    1 {
      set labtok [string trim [lindex $tokeninfo 0]]
      set tpin [$c.lfr2.entSoPin get]
      if {$tpin == ""} {
        set meser "Не задан текущий PIN-код.\nБудьте внимательны!"
	mes2frame "$meser" $c "error"
#        tk_messageBox -title "Смена пользовательского PIN-кода" -icon info -message "Не задан текущий PIN-код. Будьте внимательны!"
        return
      }
      set upin [$c.lfr2.entUserPin get]
      set rupin [$c.lfr2.entRepUserPin get]
      if {$upin == "" || $rupin == "" || $upin != $rupin || [string length $upin] < 6} {
        set meser "Смена USER-PIN-а\nНе все поля заполнены\nили короткий новый PIN-код.\nБудьте внимательны!"
	mes2frame "$meser" $c "error"
#        tk_messageBox -title "Смена пользовательского PIN-кода" -icon info -message "Ошибка в новом PIN-коде. Будьте внимательны!" -detail "upin=$upin\nrupin=$rupin"
        return
      }
      catch {::pki::pkcs11::logout $::handle $::slotid_tek}
      set ret [::pki::pkcs11::setpin $::handle $::slotid_tek user $tpin $upin]
      catch {::pki::pkcs11::logout $::handle $::slotid_tek}
      if {$ret} {
        set meser "Новый PIN-код установленю\nХраните надежно токен\n\"$labtok\"\nи PIN-коды к нему."
	mes2frame "$meser" $c "info"
#        tk_messageBox -title "Смена пользовательского PIN-кода" -icon info -message "Новый PIN-код установлен" -detail "Храните надежно и токен и PIN-коды"
        $c.lfr2.entSoPin delete 0 end
        $c.lfr2.entUserPin delete 0 end
        $c.lfr2.entRepUserPin delete 0 end
      } else {
        set meser "Произошла ошибка\nПроверьте PIN-код пользователя!"
	mes2frame "$meser" $c "error"
#        tk_messageBox -title "Смена пользовательского PIN-кода" -icon error -message "Сменить PIN-код не удалось" -detail "Проверьте текущий PIN-код"
      }
    }
    2 {
      set sopin [$c.lfr2.entSoPin get]
      set upin [$c.lfr2.entUserPin get]
      set rupin [$c.lfr2.entRepUserPin get]
      if {$sopin == "" || $upin == "" || $rupin == "" || $upin != $rupin || $upin == "87654321" || [string length $upin] < 6 } {
        set meser "Смена SO-PIN-а\nНе все поля заполнены\nили короткий новый PIN-код.\nБудьте внимательны!"
	mes2frame "$meser" $c "error"
#        tk_messageBox -title "Смена SO-PIN-а" -icon info -message "Ошибка в заполнении полей. Будьте внимательны!" -detail "SO-PIN не может быть равен первоначальному значению"
        return
      }
      set ret [::pki::pkcs11::setpin $::handle $::slotid_tek so $sopin $upin]
      if {$ret} {
        set meser "Смена SO-PIN-кода\nНовый SO-PIN установленю\nХраните надежно токен\n\"$labtok\"\nи PIN-коды к нему."
	mes2frame "$meser" $c "info"
#        tk_messageBox -title "Смена SO-PIN-кода" -icon info -message "Новый SO-PIN-код установлен" -detail "Храните надежно и токен и PIN-коды"
        $c.lfr2.entSoPin delete 0 end
        $c.lfr2.entUserPin delete 0 end
        $c.lfr2.entRepUserPin delete 0 end
      } else {
        set meser "Произошла ошибка\nПопробуйте повторить операцию."
	mes2frame "$meser" $c "error"
#        tk_messageBox -title "Смена SO-PIN-кода" -icon error -message "Сменить SO-PIN-код не удалось" -detail "Проверьте текущий SO-PIN-код"
      }
    }
    3 {
      set sopin [$c.lfr2.entSoPin get]
      set upin [$c.lfr2.entUserPin get]
      set rupin [$c.lfr2.entRepUserPin get]
      if {$sopin == "" || $upin == "" || $rupin == "" || $upin != $rupin} {
        tk_messageBox -title "Деблокировать USER-PIN" -icon info -message "Ошибка в заполнении полей. Будьте внимательны!" \
        -detail "upin=$upin\nrupin=$rupin\nsopin=$sopin"
        return
      }
      set ret [::pki::pkcs11::inituserpin $::handle $::slotid_tek $sopin $upin]
      if {$ret} {
        set meser "Деблокировать USER-PIN\nВаш PIN-код разблокирован\nХраните надежно токен\n\"$labtok\"\nи PIN-коды к нему."
	mes2frame "$meser" $c "info"
#        tk_messageBox -title "Деблокировать USER-PIN" -icon info -message "Ваш PIN-код разблокирован" -detail "Храните надежно и токен и PIN-коды"
        $c.lfr2.entSoPin delete 0 end
        $c.lfr2.entUserPin delete 0 end
        $c.lfr2.entRepUserPin delete 0 end
      } else {
        set meser "Деблокирование USER-PIN-а.\nПроизошла ошибка\nПопробуйте ещё раз."
	mes2frame "$meser" $c "error"
#        tk_messageBox -title "Деблокировать USER-PIN" -icon error -message "Разблокировать PIN-код не удалось" -detail "Проверьте PIN-коды"
      }
    }
    4 {
      set labtok [string trim [lindex $tokeninfo 0]]
      set ret [::deleteallobj $c]
      if {$ret} {
        set meser "Токен \"$::slotid_teklab\" очищен\nХраните надежно токен\n\"$labtok\"\nи PIN-коды к нему."
	mes2frame "$meser" $c "info"
#        tk_messageBox -title "Очистить токен" -icon info -message "Токен \"$::slotid_teklab\" очищен"
      }
    }
  }

}
#Настройка Страницы конфигурирования токена
proc setoptok {c} {
  set listop [list "Для инициализации токена \nзаполните следующие поля:" "Для смены USER-PIN \nзаполните следующие поля:" \
  "Для смены SO-PIN \nзаполните следующие поля:" "Для разблокировки USER-PIN \nзаполните следующие поля:" \
  "Очистка токена: \nвсе данные будут уничтожены"]
  variable optok
  variable laboptok
  set laboptok [lindex $listop $optok]
#      pack $c.lfr2 -side top -fill x -padx 20
  switch $optok {
    0 {
      grid $c.lfr2.labTok -column 0 -padx 5 -pady 2 -row 0 -sticky we
      grid $c.lfr2.entTok -column 0 -padx 2 -pady 2 -row 1 -sticky we -padx {0 5}
      $c.lfr2.labTok configure -text "Введите метку токена"
      $c.lfr2.labSoPin configure -text "Введите SO PIN"
      $c.lfr2.labUserPin configure -text "Новый PIN-пользователя"
      $c.lfr2.labRepUserPin configure -text "Повторите PIN-пользователя"
    }
    1 {
      grid forget $c.lfr2.labTok
      grid forget $c.lfr2.entTok
      $c.lfr2.labSoPin configure -text "Текущий PIN-пользователя"
      $c.lfr2.labUserPin configure -text "Новый PIN-пользователя"
      $c.lfr2.labRepUserPin configure -text "Повторите новый USER-PIN"
    }
    2 {
      grid forget $c.lfr2.labTok
      grid forget $c.lfr2.entTok
      $c.lfr2.labSoPin configure -text "Текущий SO-PIN"
      $c.lfr2.labUserPin configure -text "Новый SO-PIN"
      $c.lfr2.labRepUserPin configure -text "Повторите новый SO-PIN"
    }
    3 {
      grid forget $c.lfr2.labTok
      grid forget $c.lfr2.entTok
      $c.lfr2.labSoPin configure -text "Введите SO PIN"
      $c.lfr2.labUserPin configure -text "Текущий PIN-пользователя"
      $c.lfr2.labRepUserPin configure -text "Повторите PIN-пользователя"
    }
    4 {
      $c.lfr2.labTok configure -text ""
      $c.lfr2.labSoPin configure -text ""
      $c.lfr2.labUserPin configure -text ""
      $c.lfr2.labRepUserPin configure -text ""
    }
  }
  if {$optok != 4} {
	set padx [expr {$::intpx2mm * 5}]
       pack $c.lfr2 -fill both -anchor center  -ipadx 0 -ipady 0 -padx $padx -pady 0 -side top
  }
}

proc func_page8 {c} {
  variable optok
  set optok 0
  variable laboptok
if {0} {
set ::listtok [list здесь должно быть имя токена]
  labelframe $c.tok -text "Выберите токен PKCS11"  -bd $::bdlf
  ttk::combobox $c.tok.listTok -textvariable ::nickTok -values $::listtok
  set ::nickTok [lindex $::listtok 0]
  $c.tok.listTok configure -state readonly
  pack $c.tok.listTok -side left  -padx {2 1} -pady {1 0} -ipady 1  -expand 1 -fill x
  pack $c.tok -fill both -side top
}
  set laboptok "Для инициализации токена \nзаполните следующие поля:"
  labelframe $c.lfr1 -text "Выберите операцию с токеном:" -bd $::bdlf -bg wheat -relief groove -padx $::intpx2mm

  set cmd "ttk::radiobutton $c.lfr1.rb1 -value 0 -variable optok -text {Инициализация токена} -width 30 -command {setoptok $c} -pad 0"
  eval [subst $cmd]
  set cmd "ttk::radiobutton $c.lfr1.rb2 -value 1 -variable optok -text {Сменить USER-PIN} -command {setoptok $c} -pad 0"
  eval [subst $cmd]
  set cmd "ttk::radiobutton $c.lfr1.rb3 -value 2 -variable optok -text {Сменить SO-PIN} -width 30 -command {setoptok $c} -pad 0"
  eval [subst $cmd]
  set cmd "ttk::radiobutton $c.lfr1.rb4 -value 3 -variable optok -text {Разблокировать USER-PIN} -command {setoptok $c} -pad 0"
  eval [subst $cmd]
#  set cmd "ttk::radiobutton $c.lfr1.rb5 -value 4 -variable optok -text {Очистить токен} -command {setoptok $c} -pad 0"
#  eval [subst $cmd]

  grid $c.lfr1.rb1 -row 0 -column 0 -sticky news   -pady 0
  eval "grid $c.lfr1.rb2 -row 1 -column 0 -sticky news  -pady $::intpx2mm"
  grid $c.lfr1.rb3 -row 2 -column 0 -sticky news  -pady 0
  eval "grid $c.lfr1.rb4 -row 3 -column 0 -sticky news  -pady $::intpx2mm"
#  eval "grid $c.lfr1.rb5 -row 4 -column 0 -sticky news   -pady {0 $::intpx2mm}"
#  eval "pack $c.lfr1 -fill both -side top -padx 10 -pady $::intpx2mm "
  eval "pack $c.lfr1 -fill none -anchor center  -ipadx 0 -ipady 0 -padx 0 -pady {10mm 5mm} -side top"

  grid columnconfigure $c.lfr1 0  -weight 1

  ttk::label .lfortok -textvariable laboptok -background wheat
  labelframe $c.lfr2 -labelwidget .lfortok  -bd $::bdlf -bg wheat -relief groove -padx $::intpx2mm
  label $c.lfr2.labTok -background skyblue -justify left -text "Введите метку токена"  -anchor nw
  grid $c.lfr2.labTok -column 0 -padx 0 -row 0 -sticky we -pady 0
  entry $c.lfr2.entTok -background snow
  grid $c.lfr2.entTok -column 0   -row 1 -sticky nwse
  label $c.lfr2.labSoPin -background skyblue -text "Введите SO PIN" -anchor nw
  grid $c.lfr2.labSoPin -column 0  -row 2 -sticky we
  entry $c.lfr2.entSoPin -background snow -show *
  grid $c.lfr2.entSoPin -column 0 -sticky nwse -row 3
  label $c.lfr2.labUserPin -background skyblue -text "Новый PIN-пользователя" -anchor w
  grid $c.lfr2.labUserPin -column 0 -row 4 -sticky we
  entry $c.lfr2.entUserPin -background snow -show *
  grid $c.lfr2.entUserPin -column 0 -row 5 -sticky nwse
  label $c.lfr2.labRepUserPin -background skyblue -text "Повторите PIN-пользователя" -anchor nw
  grid $c.lfr2.labRepUserPin -column 0  -row 6 -sticky we
  entry $c.lfr2.entRepUserPin -background snow -show *
  eval "grid $c.lfr2.entRepUserPin -column 0  -sticky nwse -row 7  -pady {0 $::intpx2mm}"
  grid columnconfigure $c.lfr2 0  -weight 1

#  eval "pack $c.lfr2 -fill both -side top -padx 10  -pady {0 $::intpx2mm} -anchor center"
    set padx [expr {$::intpx2mm * 5}]
  eval "pack $c.lfr2 -fill both -anchor center  -ipadx 0 -ipady 0 -padx $padx -pady 0 -side top"

  set cmd "ttk::button  $c.butop -command {p11conf  $c} -text {Выполнить операцию} -style TButton"
  eval [subst $cmd]
#  eval "pack $c.butop -fill none -side top -padx 10  -pady $::intpx2mm -anchor s"
  eval "pack $c.butop -fill none -anchor center  -ipadx 0 -ipady 0 -padx 0 -pady {3mm} -side bottom"
  
  pack $c.lfr1 $c.lfr2 $c.butop -in $c

if {0} {
  labelframe $c.licfr -text "Лицензирование токена:" -background wheat
  label  $c.licfr.llic -text {Лицензию:} -bg skyblue
  ttk::button  $c.licfr.bread -command {licload } -text {Получить} -style TButton -pad 0
  ttk::button  $c.licfr.bust -command {licinstall } -text {Установить} -style TButton -pad 0
  pack $c.licfr.llic -fill none -side left -padx 10
  pack $c.licfr.bread -fill none -side left -padx 10
  pack $c.licfr.bust -fill none -side left -padx 10 -pady {5}
  eval "pack $c.licfr -fill both -side top -padx 10 -pady $::intpx2mm"
}
}


proc page_func {fr tile titul functions} {
#Кнопки  меню
    upvar $functions but
#parray but
#Создаем шрифт для кнопок
    if {$::typetlf} {
	set feFONT_button "-family {Roboto} -size 10  -slant roman -weight bold"
	set widl 10
    } else {
	set feFONT_button "-family {Arial} -size 12  -slant roman"
	set widl 5
    }
    catch {font delete fontTEMP_drawer}
    eval font create fontTEMP_drawer  $feFONT_button
#Вычисляем максимальныю длину текста
    set drawerCNT 0
    set strMaxWidthPx 15
    set Ndrawers [expr {[array size but] - 1}]
    while { $drawerCNT <= $Ndrawers } {
	set strWidthPx [font measure fontTEMP_drawer "$but($drawerCNT)"]
	if { $strWidthPx > $strMaxWidthPx } {
    	    set strMaxWidthPx $strWidthPx
	}
	incr drawerCNT
    }
    set drawerWidthPx [expr $strMaxWidthPx + 10]
    set xxx [expr {($::::scrwidth - $drawerWidthPx) / 2}]

    if {$fr != ".fr1"} {
	set hret [expr $::scrheight / 4]
    } else {
	set hret $::scrheight
    }
	set hret [expr $::scrheight / 4]
#    tkp::canvas $fr.can -borderwidth 0 -height $hret -width $::scrwidth -relief flat
    tkp::canvas $fr.can -borderwidth 0 -height $hret -width $::scrwidth -relief flat
#Мостим холст плиткой 
#    createtile "$fr.can"  $tile
    pack $fr.can  -anchor center -expand 1 -fill both -side top  -padx 0 -pady 0
#Градиентная заливка
if {$fr == ".fr1"} { 
set ::gradientCloud [$fr.can gradient create linear -method pad -units bbox \
    -stops { { 0.05 #87ceeb 1.00} { 0.17 #ffffff 1.00} { 0.29 skyblue 1.00} { 0.87 #ffffff 1.00} { 1.00 skyblue 1.00}} -lineartransition {1.00 0.00 0.75 1.00} ]
    set hp [winfo height .fr0]
    set wp [winfo width .fr0]
#puts "wp=$wp hp=$hp"
     $fr.can create prect "0 0 $wp $hp"  -strokelinejoin miter  -fill $::gradientCloud
}

    if {$titul != "" } {
	set allfunc $titul
#    set dlx [expr {$::padlx / 1}]
	catch {font delete fontTEMP_titul}
	set font_titul "-family {Roboto} -size 15"
        eval font create fontTEMP_titul  $font_titul
	set funcWidthPx [font measure fontTEMP_titul "$allfunc"]
	set dlx [expr {($::::scrwidth - $funcWidthPx) / 2}]
#Отступ по вертикали
	set y_otstup 20
	$fr.can create text [expr $dlx + $::dlx1] [expr {$y_otstup + $::dlx1}] -anchor nw -text "$allfunc" -fill black -font fontTEMP_titul
	$fr.can create text $dlx $y_otstup -anchor nw -text "$allfunc" -fill white -font fontTEMP_titul -tag id_text0
	set blogo [$fr.can bbox id_text0]
	set boxbut [expr ([lindex $blogo 3] + $y_otstup + 6)]
    } else {
	set boxbut [expr $y_otstup + 6]
    }
#Вычисляем самый широкий текст у кнопок
#См. выше
#Размещаем кнопки
    set BDwidth_canvas 0

    set maxTextHeightPx [font metrics fontTEMP_drawer -linespace] 

    set maxTextHeightPx [expr {$maxTextHeightPx + ( $maxTextHeightPx / 2)}]

##+########################################################################
## Set the height of the toolchest drawers (in pixels) from either
## the 'linespace' height of the text strings OR perhaps some other measure.
##+#########################################################################

    set drawerHeightPx $maxTextHeightPx

##+########################################################################
## Set the x-offset in the one big canvas widget (relative to the left side
## of the canvas widget) at which the left side of each text string will be
## located.
##
## We adjust the x text offset according the the width of the
## border of the canvas --- so that the text does not lie on the border.
##+########################################################################

    set xLocTextPx [expr {($::::scrwidth - $drawerWidthPx) / 2}]


##+########################################################################
## Initialize the y-offset in the one big canvas widget (relative to the
## top of the canvas widget) at which the mid-left side of each text string
## will be located.
##+########################################################################

    set yLocTextPx [expr $BDwidth_canvas + ($drawerHeightPx / 2) + $boxbut]


##+########################################################################
## - Define the one big canvas widget. 
## - Put the background image on it with 'image create'.
## - Pack the canvas widget.
##+########################################################################

    set canvasHeightPx [expr $Ndrawers * $drawerHeightPx]

    set drawerCNT 0
    set Ndrawers [expr {[array size but] - 1}]
    while { $drawerCNT <= $Ndrawers } {
      set yLineLocPx [ expr (( $drawerCNT ) * $drawerHeightPx + $boxbut)]
#Линия перед текстом
      $fr.can create line \
         $xLocTextPx $yLineLocPx \
         [expr $drawerWidthPx + $xLocTextPx] $yLineLocPx \
         -fill "#a0a0a0" -width $widl

   ## Put the text line on the canvas, with a tag.
      $fr.can create text [expr $xLocTextPx + 5] $yLocTextPx \
	-anchor w \
        -font fontTEMP_drawer \
        -text "$but($drawerCNT)"  
#        -tag textlineTag($drawerCNT)
#Прозрачный прямоугольник между двумя линиями - это и есть кнопка
      $fr.can create rect $xLocTextPx [expr $yLineLocPx + $widl]  [expr $drawerWidthPx + $xLocTextPx] [expr $yLineLocPx + $boxbut - $widl] \
	-width 0 \
	-fill "" \
        -tag "textlineTag($drawerCNT)"
#        -tag "textlineTag($drawerCNT) {$but($drawerCNT)}"

   ## Bind an action to the text line.
	if {$drawerCNT == 0} {
	    if {$fr == ".fr1"} {
		$fr.can bind textlineTag($drawerCNT)  <Button-1>   {butImg "but1"}
	    } else {
		$fr.can bind textlineTag($drawerCNT)  <Button-1>   {butReturn}
	    }
	} else {
#	    frame .fn$drawerCNT -background white -relief flat -pady 0 -padx 0
	    tkp::canvas .fn$drawerCNT -background white -relief flat 
	    set titul $but($drawerCNT)
	    if {$drawerCNT != 1 &&  $drawerCNT != 2 &&  $drawerCNT != 3 &&  $drawerCNT != 4 &&  $drawerCNT != 8 } {
		label .fn$drawerCNT.lab -text $but($drawerCNT) 
		pack .fn$drawerCNT.lab -side top 
	    } else {
		func_page$drawerCNT .fn$drawerCNT
	    }
	    set cmd "$fr.can bind textlineTag($drawerCNT)  <Button-1>   {butCliked $drawerCNT .fn$drawerCNT}"
	    set cmd [subst "$cmd"]
	    eval $cmd 
#Облачный градиент
	    set gradCloud [.fn$drawerCNT gradient create linear -method pad -units bbox \
		-stops { { 0.05 #87ceeb 1.00} { 0.17 #ffffff 1.00} { 0.29 skyblue 1.00} { 0.87 #ffffff 1.00} { 1.00 skyblue 1.00}} -lineartransition {1.00 0.00 0.75 1.00} ]
	    set hp [winfo height .fr0]
	    set wp [winfo width .fr0]
    	    set rect0 [.fn$drawerCNT create prect "0 0 $wp $hp"  -strokelinejoin miter  -fill $gradCloud ]
    	    #$::gradientCloud
    	    .fn$drawerCNT lower $rect0
	}

   ## Get ready for the next text line.
	incr drawerCNT

	set yLocTextPx [ expr $yLocTextPx + $drawerHeightPx]
    	    set yLineLocPx [ expr (( $drawerCNT ) * $drawerHeightPx + $boxbut)]
	if {$Ndrawers > 0 && ($drawerCNT  > $Ndrawers) } {
#Завершаюшая линия
    		$fr.can create line $xLocTextPx $yLineLocPx \
        	[expr $drawerWidthPx + $xLocTextPx] $yLineLocPx \
        	-fill "#a0a0a0" -width $widl
    	    set yLineLocPx [ expr (( $drawerCNT + 1 ) * $drawerHeightPx + $boxbut)]
	    set wa [image width cloud_100x50]
	    set dlx [expr {($::::scrwidth - $wa) / 2}]

    $fr.can create image $dlx $yLineLocPx -image cloud_100x50 -anchor nw -tag tag_land
	}
    }
}
###############CallOut#############################
proc TP_CloudWithTongue { p1 p2 rx ton} {
    foreach {x1 y1} $p1 {break}
    foreach {x2 y2} $p2 {break}
    foreach {p1x p2x p3x p1y } $ton {break}
    if {$p1y > 1 || $p1y < 0} {
puts "TP_CloudWithTongue 1"
	return -1
    }
    set y2orig $y2
    set y2 [expr {($y2 -$y1) * $p1y + $y1}]
#Начальная точка
    set mx $x1
    if {($x2 > $x1 && $y2 < $y1) || ($x2 < $x1 && $y2 > $y1)} {
	set my [expr {$y1 - $rx}]
    } else {
	set my [expr {$y1 + $rx}]
    }
#Первая вершина
    set q1_1x $x1
    set q1_1y $y1
    set q1_2x [expr {$x1 + $rx}]
    set q1_2y $y1
#Отрезок между первой и второй вершиной
    set l1_x [expr {$x2 - $rx}]
    set l1_y $y1
#Вторая  вершина
    set q2_1x $x2
    set q2_1y $y1
    set q2_2x $x2
    if {($x2 > $x1 && $y2 < $y1) || ($x2 < $x1 && $y2 > $y1)} {
	set q2_2y [expr {$y1 - $rx}]
    } else {
	set q2_2y [expr {$y1 + $rx}]
    }
#Отрезок между второй и третьей вершиной
    set l2_x $x2
    if {($x2 > $x1 && $y2 < $y1) || ($x2 < $x1 && $y2 > $y1)} {
	set l2_y [expr {$y2 + $rx}]
    } else {
	set l2_y [expr {$y2 - $rx}]
    }
#Третья  вершина
    set q3_1x $x2
    set q3_1y $y2
    set q3_2x [expr {$x2 - $rx}]
    set q3_2y $y2 
#Отрезок между третьей и правой точкой язычка
    set t1   [expr {($x2 - $x1) * $p3x + $x1}]
    set l3_x $t1
    set l3_y $y2
#Вершина язычка - вторая точка язычка
    set l4_x [expr {($x2 - $x1) * $p2x + $x1}]
    set l4_y $y2orig
#Первая/левая точка язычка
    set l5_x [expr {($x2 - $x1) * $p1x + $x1}]
    set l5_y $y2
#Отрезок между левой/первой вершиной язычка и четвёртой вершиной прямоугольника
    set l6_x [expr {$x1 + $rx}]
    set l6_y $y2
#Четвёртая вершина
    set q4_1x $x1
    set q4_1y $y2
    set q4_2x $x1
    if {($x2 > $x1 && $y2 < $y1) || ($x2 < $x1 && $y2 > $y1)} {
	set q4_2y [expr {$y2 + $rx}]
    } else {
	set q4_2y [expr {$y2 - $rx}]
    }
#Отрезок между четвёртой вершиной и начальной точкой
#Замыкаем path	    Z
    set coords [list M $mx $my Q $q1_1x $q1_1y $q1_2x $q1_2y L $l1_x $l1_y Q $q2_1x $q2_1y $q2_2x $q2_2y L $l2_x $l2_y Q $q3_1x $q3_1y $q3_2x $q3_2y L $l3_x $l3_y $l4_x $l4_y $l5_x $l5_y $l6_x $l6_y Q $q4_1x $q4_1y $q4_2x $q4_2y Z]
    return $coords

#Хороший язычок
#M 0.0 20.0 Q 0.0 0.0 20.0 0.0 L 180.0 0.0 Q 200.0 0.0 200.0 20.0 L 200.0 80.0 Q 200.0 100.0 180.0 100.0 L 150.0 100.0 L 150.0 150.0 L 100.0 100.0 L 20.0 100.0 Q 0.0 100.0 0.0 80.0 Z
#Начальная точка
            set mx $x1
            set my [expr {$y1 + $rx}]
#Первая вершина
            set q1_1x $x1
            set q1_1y $y1
            set q1_2x [expr {$x1 + $rx}]
            set q1_2y $y1
#Отрезок между первой и второй вершиной
            set l1_x [expr {$x2 - $rx}]
            set l1_y $y1
#Вторая  вершина
            set q2_1x $x2
            set q2_1y $y1
            set q2_2x $x2
            set q2_2y [expr {$y1 + $rx}]
#Отрезок между второй и третьей вершиной
            set l2_x $x2
            set l2_y [expr {$y2 - $rx}]
#Третья  вершина
            set q3_1x $x2
            set q3_1y $y2
            set q3_2x [expr {$x2 - $rx}]
            set q3_2y $y2
#Отрезок между третьей и четвёртой вершиной
            set l3_x [expr {$x1 + $rx}]
            set l3_y $y2
#Четвёртая вершина
            set q4_1x $x1
            set q4_1y $y2
            set q4_2x $x1
            set q4_2y [expr {$y2 - $rx}]
#Отрезок между четвёртой вершиной и начальной точкой
#Замыкаем path	    Z
            set coords [list  M $mx $my Q $q1_1x $q1_1y $q1_2x $q1_2y L $l1_x $l1_y Q $q2_1x $q2_1y $q2_2x $q2_2y L $l2_x $l2_y Q $q3_1x $q3_1y $q3_2x $q3_2y L $l3_x $l3_y Q $q4_1x $q4_1y $q4_2x $q4_2y Z]

}
proc makeCallout {can tinfo arrow x0 y0 } {
  global Callout Graphics
#координаты 
  set ytoken 0

#Вычисляем прямоугольник для текста tinfo
#x y
  set ltinfo [split $tinfo "\n"]
  #Вычисляем максимальныю длину текста
  set x1 1
  foreach ss $ltinfo {
    set strWidthPx [font measure TkDefaultFont $ss]
    if { $strWidthPx > $x1 } {
      set x1 $strWidthPx
    }
  }


#  set lentinfo [llength [split $tinfo "\n"]]
  set lentinfo [llength $ltinfo]
  #Высота строки
  set yfont [font metrics TkDefaultFont -linespace]
  #Центрирование инф. окна по Y
  set yoff [expr $ytoken -  [expr $yfont * ($lentinfo + 4)]]
  set x1 [expr $x1 + 2 * $yfont]
  set xoff [expr ($::scrwidth - $x1) / 2]
  #Высота виджеты = высота строки * кол-во строк (\n)
  set y1 [expr $yfont * ($lentinfo + 2)]
#puts "x1=$x1 y1=$y1"
  set x [expr {$x1 + $x0}]
#Учёт язычка
  foreach {w1 w2 w3 w4} $Graphics(callout,tongue) {break}
#Высота язычка
  set htongue [expr {$y1 * (1 - $w4)}]  
  set y [expr {$y1 + $y0 + $htongue}]

#Непрозрачность
  set fillstyle 1.0
  set linestyle 1.0
  set Callout(options)  [list \
           -strokewidth   $Graphics(line,width) \
           -stroke $Graphics(line,color) \
           -strokedasharray  $Graphics(linesvg,dash) \
           -fill    $Graphics(fill,color) \
           -fillopacity $fillstyle -strokeopacity $linestyle \
           -tags    {Callout obj svg spline}       \
  ]

  if {$arrow == "down"} {
#    set Callout(coords) "$x0 $y0 $x $y"
    set Callout(coords) "$x0 [expr {$y0 - $y1 - $htongue}] $x [expr {$y - $y1 - $htongue}]"
  } else {
    set Callout(coords) "$x $y $x0 $y0"
  }
#Размеры Callout
  if {$can == ""} {
#	return $Callout(coords)
	foreach {xx0 yy0 xx1 yy1} $Callout(coords) {break}
	return [list [expr {$xx1 - $xx0}] [expr {$yy1 - $yy0}]]
  }

  catch {$can delete $Callout(id)}
  if {$Graphics(type) != "SVG"} {
	return
  }
  foreach {x0 y0 x1 y1} $Callout(coords) {break}
  #Радиус
    set rx [expr {($x1 - $x0) * $Graphics(callout,rx)}]
    set d [TP_CloudWithTongue "$x0 $y0" "$x1 $y1" $rx "$Graphics(callout,tongue)" ]
    set Callout(id) [eval $can create path "\"$d\"" $Callout(options)]

  if {$arrow == "down"} {
    $can create text [expr $x0 + $yfont ] [expr $y0 + $yfont] -anchor nw -text "$tinfo" -fill navy  -tag "Callout"
  } else {
    foreach {x1 y1 x0 y0} $Callout(coords) {break}
    $can create text [expr $x0 + $yfont ] [expr $y0 + $yfont + $htongue] -anchor nw -text "$tinfo" -fill navy  -tag "Callout"
  }
}
#Default Graphics
set pxtwomm [expr $::intpx2mm * 2]
#set pxtwomm [expr $::px2mm * 2]

global Graphics
   array set Graphics {
     line,width      $pxtwomm
     line,color      gray85
     line,style      {}
     line,dash       {}
     linesvg,dash    {}
     linedefault,dash  {Solid line}
     line,joinstyle  miter
     line,capstyle   butt
     line,arrow      none
     arrowshape      {8 10 4}
     splinesteps     20
     shape           none
     fill,color      white
     fill,style      {}
     mode            NULL
     font,size       10
     font,color      black
     font,normal     0
     font,bold       0
     font,italic     0
     font,roman      0
     font,underline  0
     font,overstrike 0
     font,style      {}
     font,stipple    {}
     text,anchor     c
     grid,on         0
     ticks,on        0
     snap,on         0
     grid,size       10m
     grid,snap       1
     snap,size       1
     callout,tongue {0.5 0.6 0.8 0.85}
     callout,rx 0.05
     type	    SVG
   }
set Graphics(line,width)  $::intpx2mm
#Создаем информационное окно
proc makeMessage {can tinfo type x0 y0 } {
#Код возврата
  global retmes;

#x0 - центральная точка по оси X
  global Graphics
#координаты 
  set ytoken 0
  set x0ok $x0
#Тип сообщения
  switch -- $type {
    info {
	set Message(line,color) "green"
    }
    warn {
	set Message(line,color) "yellow"
    }
    error {
	set Message(line,color) "red"
    }
    ok {
	set Message(line,color) "skyblue"
    }
    yesno {
	set Message(line,color) "gray42"
    }
    default {
	return
    }
  }

#Вычисляем прямоугольник для текста tinfo
#x y
  set ltinfo [split $tinfo "\n"]
  #Вычисляем максимальныю длину текста
  set x1 1
  foreach ss $ltinfo {
    set strWidthPx [font measure TkDefaultFont $ss]
    if { $strWidthPx > $x1 } {
      set x1 $strWidthPx
    }
  }
#  set lentinfo [llength [split $tinfo "\n"]]
  set lentinfo [llength $ltinfo]
  #Высота строки
  set yfont [font metrics TkDefaultFont -linespace]
  #Центрирование инф. окна по Y
  set yoff [expr $ytoken -  [expr $yfont * ($lentinfo + 4)]]
  set x1 [expr $x1 + 2 * $yfont]
  set xoff [expr ($::scrwidth - $x1) / 2]
  #Высота виджеты = высота строки * кол-во строк (\n)
  set y1 [expr $yfont * ($lentinfo + 2)]
#puts "x1=$x1 y1=$y1"
set x0 [expr {$x0 - ($x1 / 2.0)}]

  set x [expr {$x1 + $x0}]
#Учёт поля кнопок
#Высота поля кнопок
  set butWidth [font measure TkDefaultFont "ОК"]
  set htongue [expr {$yfont * 2 + 3}]  
  set y [expr {$y1 + $y0 + $htongue}]

#Непрозрачность
  set fillstyle 1.0
  set linestyle 1.0
  set Message(options)  [list \
           -strokewidth   $Graphics(line,width) \
           -stroke $Message(line,color) \
           -fill    $Graphics(fill,color) \
           -tags    {Message}       \
  ]
#Размеры Message
  if {$can == ""} {
	return [list [expr {$x - $x0}] [expr {$y - $y0}]]
  }

  #Радиус
    set rx [expr {($x1 - 0) * $Graphics(callout,rx)}]
    eval $can create prect $x0 $y0 $x $y -rx $rx $Message(options)
    set ysep [expr {$y1 + $y0}]
    $can create pline $x0 $ysep $x $ysep -strokewidth   $Graphics(line,width) \
           -stroke $Message(line,color) \
           -tags    {Message}
#Кнопки Ок или Да и Нет
  if {$type != "yesno"} {
    set xb0 [expr {$x0ok - $butWidth}]
    set yb0 [expr {$ysep + $Graphics(line,width) + $Graphics(line,width)}]
    set xb1 [expr {$x0ok + $butWidth }]
    set yb1 [expr {$y - ($Graphics(line,width) * 1.2)}]
    $can create text [expr {$xb0 + ($butWidth / 2.0)}] [expr {$yb0 + $::px2mm / 3}] -anchor nw -text "ОК" -fill navy -tag "Message"
    set bok [$can create prect $xb0 $yb0 $xb1 $yb1 -rx 2 -strokewidth 2 -stroke gray42 -fill skyblue -fillopacity 0.0 -tag "Message"]
    $can bind $bok <Button-1> "$can delete Message; global retmes; set retmes 1"
    $can bind $bok <Enter> "$can itemconfigure $bok -fillopacity 0.5"
    $can bind $bok <Leave> "$can itemconfigure $bok -fillopacity 0.0"
  } else {
#Левая точка Да
    set xb0 [expr {$x0ok - $butWidth * 2.5}]
    set yb0 [expr {$ysep + $Graphics(line,width) + $Graphics(line,width)}]
    set xb1 [expr {$xb0 + $butWidth * 2.0 }]
    set yb1 [expr {$y - ($Graphics(line,width) * 1.2)}]
    $can create text [expr {$xb0 + ($butWidth / 2.0)}] [expr {$yb0 + $::px2mm / 3}] -anchor nw -text "Да" -fill navy -tag "Message"
    set bok [$can create prect $xb0 $yb0 $xb1 $yb1 -rx 2 -strokewidth 2 -stroke gray42 -fill skyblue -fillopacity 0.0 -tag "Message"]
    $can bind $bok <Button-1> "$can delete Message; global retmes; set retmes 1"
    $can bind $bok <Enter> "$can itemconfigure $bok -fillopacity 0.5"
    $can bind $bok <Leave> "$can itemconfigure $bok -fillopacity 0.0"
#Правая точка Нет
    set xb0 [expr {$x0ok + ($x0ok - $xb1)}]
    set yb0 [expr {$ysep + $Graphics(line,width) + $Graphics(line,width)}]
    set xb1 [expr {$xb0 + $butWidth * 2.0 }]
    set yb1 [expr {$y - ($Graphics(line,width) * 1.2)}]
    $can create text [expr {$xb0 + ($butWidth / 2.0)}] [expr {$yb0 + $::px2mm / 3}] -anchor nw -text "Нет" -fill navy -tag "Message"
    set bok [$can create prect $xb0 $yb0 $xb1 $yb1 -rx 2 -strokewidth 2 -stroke gray42 -fill skyblue -fillopacity 0.0 -tag "Message"]
    $can bind $bok <Button-1> "$can delete Message; global retmes; set retmes 0"
    $can bind $bok <Enter> "$can itemconfigure $bok -fillopacity 0.5"
    $can bind $bok <Leave> "$can itemconfigure $bok -fillopacity 0.0"

  }

    $can create text [expr $x0 + $yfont ] [expr $y0 + $yfont] -anchor nw -text "$tinfo" -fill navy  -tag "Message"

}
#Скриншот окна
proc CaptureWindow {win {baseImg ""} {px 0} {py 0}} {
   # create the base image of win (the root of capturing process)
   if {$baseImg eq ""} {
     set baseImg [image create photo -format window -data $win]
   }
   # paste images of win's children on the base image
   foreach child [winfo children $win] {
     if {![winfo ismapped $child]} continue
     set childImg [image create photo -format window -data $child]
     regexp {\+(\d*)\+(\d*)} [winfo geometry $child] -> x y
     $baseImg copy $childImg -to [incr x $px] [incr y $py]
     image delete $childImg
     CaptureWindow $child $baseImg $x $y
   }
   return $baseImg
}

#Создаем название продукта
set name_product "LS11CloudToken-A" 
label .labtitul -image logo_product -compound left -fg snow -text $name_product -font {Arial 10 bold} -anchor w  -width $::scrwidth  -pady $::padls -padx 10 -bg #222222 
set ::scrheight [expr {$::scrheight -  $::padls * 3 - [image height logo_product]}]
pack .labtitul -anchor nw -expand 0 -fill x -side top  -padx 1 -pady 0

#Создаем стартовую страницу
set i 0
ttk::frame .fr$i -pad 0 -padding 0
#page_titul ".fr$i"  "logo_orel"
page_titul ".fr$i"  "logo_cloud"
pack .fr$i -side top -anchor center -expand 1 -fill both -side top  -padx 0 -pady 0 
update
if {1} {
    set hp [winfo height .fr0]
    set wp [winfo width .fr0]
puts "wp=$wp hp=$hp"
     set rect0 [.fr0.can create prect "0 0 $wp $hp"  -strokelinejoin miter  -fill $::gradientCloud]
     .fr0.can lower $rect0
}

#Создаем страницы с функционалом
incr i
ttk::frame .fr$i -pad 0 -padding 0
#Кнопки основного меню
    set but(0) "Стартовая страница" 
    set but(1) "Регистрация в облаке"
    set but(2) "Дубликат токена" 
    set but(3) "Статус токена" 
    set but(4) "Сменить пароль" 
    set but(5) "Просмотреть журнал"
    set but(6) "Пересоздать токен" 
    set but(7) "Удалить регистрацию" 
    set but(8) "Настройка токена"
#parray but

#Всплывающая информация
set tinfo "\n\tПодождите!\nИдет проверка облачного токена!\n"
label .linfo -relief groove -bd 3 -fg blue  -text $tinfo -padx 0 -pady 3 -font "helvetica 8 bold italic" -bg #eff0f1 -justify left -wraplength $::scrwidth

page_func ".fr$i" newtile "Функционал" "but"
page_password