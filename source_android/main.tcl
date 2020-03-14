package require Tk
package require Expect

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

puts "$::scrwidth  $::scrwidthmm $::px2mm"
set ::typetlf 0
#Проверяем, что это телефон
if {$::scrwidth < $::scrheight} {
    option add *Dialog.msg.wrapLength 750
#    option add *Dialog.msg.wrapLength 11i
#    option add *Dialog.dtl.wrapLength 11i
    option add *Dialog.dtl.wrapLength 750
    set ::typetlf 1
}

global mydir
set mydir [file dirname [info script]]
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
set ::dstlib [file join $myHOME1 "ls11cloud" "libls11cloud.so"]
if {$::typetlf} {
    set userpath $env(EXTERNAL_STORAGE)
} else {
    set userpath $env(HOME)
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
    set answer [tk_dialog .dialog2 "Конец работы" "Вы действительно\nхотите выйти?" question 0 "Да" "Нет" ]
    if {$answer == 0} {
      exit
    }
}

proc page_titul {fr  logo_manufacturer} {
    global mydir
#Создаем холст на весь экран
    canvas $fr.can -borderwidth 0 -height $::scrheight  -width $::scrwidth -relief flat
#Мостим холст плиткой 
    createtile "$fr.can"  "tileand"

    pack $fr.can  -anchor center -expand 1 -fill both -side top  -padx 0 -pady 0
#Вычисляем координаты для логотипа производителя
#update чтобы обновилась информация в БД об окнах
    update
#    set aa [winfo height $fr.labtitul]
    set aa $::padly
#Центрируем логотип разработчика
    set ha [image width $logo_manufacturer]
    set xman [expr {($::scrwidth - $ha) / 2 }]
    $fr.can create image $xman $aa -image $logo_manufacturer -anchor nw -tag tag_logo

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

	$fr.can create text [expr $dlx + $::dlx1] [expr {$wexit + $::dlx1}] -anchor nw -text "$allfunc" -fill black -font fontTEMP_titul0
	$fr.can create text $dlx [expr {$wexit }] -anchor nw -text "$allfunc" -fill white -font fontTEMP_titul0 -tag id_text0
	update
	set blogo [$fr.can bbox id_text0]
	set wexit [lindex $blogo 3]
#Центрируем текст
	set allfunc "для платформы Android"
	catch {font delete fontTEMP_titul1}
	set font_titul "-family {$::ftxt} -size 13"
        eval font create fontTEMP_titul1  $font_titul
	set funcWidthPx [font measure fontTEMP_titul1 "$allfunc"]
	
	set dlx [expr {($::scrwidth - $funcWidthPx) / 2}]

	$fr.can create text [expr $dlx + $::dlx1] [expr {$wexit + $::dlx1}] -anchor nw -text "$allfunc" -fill black -font fontTEMP_titul1
	$fr.can create text $dlx [expr {$wexit}] -anchor nw -text "$allfunc" -fill white -font fontTEMP_titul1 -tag id_text1
	update
	set blogo [$fr.can bbox id_text1]
	set wexit [lindex $blogo 3]
	set font_titul "-family {$::ftxt} -size 12"
	catch {font delete fontTEMP_titul2}
	eval font create fontTEMP_titul2  $font_titul
	set allfunc "Регистрация личного токена PKCS11"
	set funcWidthPx [font measure fontTEMP_titul2 "$allfunc"]
	set dlx [expr {($::scrwidth - $funcWidthPx) / 2}]
	set x1 [expr {int($::px2mm * 2)}]
	$fr.can create text [expr $dlx + $::dlx1] [expr {$wexit + $x1}] -anchor nw -text "Регистрация личного токена PKCS11\nв облаке LS11CLOUD" -fill black -font fontTEMP_titul2
	$fr.can create text $dlx [expr {$wexit + $x1}] -anchor nw -text "Регистрация личного токена PKCS11\nв облаке LS11CLOUD" -fill white -font fontTEMP_titul2 -tag id_text2

	set blogo [$fr.can bbox id_text2]
	set wexit [lindex $blogo 3]
	set font_titul "-family {$::ftxt} -size 10"
    catch {font delete fontTEMP_titul3}
    eval font create fontTEMP_titul3  $font_titul
	$fr.can create text [expr $dlx + $::dlx4] [expr {$wexit + $::dlx1}] -text "Авторы: В.Н. Орлов\nhttp://soft.lissi.ru, http://www.lissi.ru\n+7(495)589-99-53\ne-mail: support@lissi.ru\n" \
	-anchor nw -fill black  -font fontTEMP_titul3
	$fr.can create text $dlx [expr {$wexit + 0}] -text "Авторы: В.Н. Орлов\nhttp://soft.lissi.ru, http://www.lissi.ru\n+7(495)589-99-53\ne-mail: support@lissi.ru\n" \
	-anchor nw -fill white -tag id_text3  -font fontTEMP_titul3


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

	set x1 $dlx
	set y1 [expr {$wland + $hy2}]
	set x2 [expr {$::scrwidth - $x1}]
	set y2 [expr {$y1 + $widthrect}]
	set  wd $::px2mm
    set im1 [create_rectangle $fr.can "but1" $x1 $y1 $x2 $y2 "green" 0.5 [expr int($wd)] "skyblue"]
    $fr.can bind $im1 <ButtonPress-1> {butImg "img1"}
#Печатаем техт
    set blogo [$fr.can bbox $im1]
    set by2 [lindex $blogo 3]
    set by1 [lindex $blogo 1]
    set bb [expr {($by2 - $by1) / 2}]
    set bx2 [lindex $blogo 2]
    set bx1 [lindex $blogo 0]
    set bbx [expr {($bx2 - $bx1) / 2}]
    set txt0 [$fr.can create text [expr {$x1 + $::padlx * 2}] [expr {$y1 + 1 }] -anchor nw -text {Сайт разработчика} -fill black -font fontTEMP_titul2]
    set txt1 [$fr.can create text [expr {$x1 + $::padlx * 2}] [expr {$y1 + 1 }] -anchor nw -text {Сайт разработчика} -fill white -font fontTEMP_titul2]
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
    $fr.can bind $txt1 <ButtonPress-1> {butImg "img1"}

	set y1 [expr {$y2 + $hy2}]
	set y2 [expr {$y1 + $widthrect}]
    set im1 [create_rectangle $fr.can "but2" $x1 $y1 $x2 $y2 "green" 0.5 $wd "skyblue"]
#Печатаем техт
    set blogo [$fr.can bbox $im1]
    set by2 [lindex $blogo 3]
    set by1 [lindex $blogo 1]
    set bb [expr {($by2 - $by1) / 2}]
    set bx2 [lindex $blogo 2]
    set bx1 [lindex $blogo 0]
    set bbx [expr {($bx2 - $bx1) / 2}]
    set txt0 [$fr.can create text [expr {$x1 + $::padlx * 2}] [expr {$y1 + 1 }] -anchor nw -text "Переход в основное меню" -fill black -font fontTEMP_titul2] 
    set txt1 [$fr.can create text [expr {$x1 + $::padlx * 2}] [expr {$y1 + 1 }] -anchor nw -text "Переход в основное меню" -fill white -font fontTEMP_titul2] 
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
    $fr.can bind $txt1 <ButtonPress-1> {butImg "but2"}
###############
	set y1 [expr {$y2 + $hy2}]
	set y2 [expr {$y1 + $widthrect}]

    set im1 [create_rectangle $fr.can "but3" $x1 $y1 $x2 $y2 "green" 0.5 $wd "skyblue"]
    set blogo [$fr.can bbox $im1]
    $fr.can bind $im1 <ButtonPress-1> {exitPKCS}
    set by2 [lindex $blogo 3]
    set by1 [lindex $blogo 1]
    set bb [expr {($by2 - $by1) / 2}]
    set bx2 [lindex $blogo 2]
    set bx1 [lindex $blogo 0]
    set bbx [expr {($bx2 - $bx1) / 2}]
    set txt0 [$fr.can create text [expr {$x1 + $::padlx * 2}] [expr {$y1 + 1 }] -anchor nw -text "Конец работы" -fill black  -font fontTEMP_titul2]
    set txt1 [$fr.can create text [expr {$x1 + $::padlx * 2}] [expr {$y1 + 1 }] -anchor nw -text "Конец работы" -fill white  -font fontTEMP_titul2]
    $fr.can bind $txt1 <ButtonPress-1> {exitPKCS}
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
set ::padls [winfo pixels . 3m]
set ::padlx [winfo pixels . 2m]
set ::padly [winfo pixels . 1m]
if {$::typetlf} {
#Шрифт для Androwish
    set ::ftxt "Roboto Condensed Medium"
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
    } elseif { $::px2mm > 10} {
	scaleImage logo_and 3
	scaleImage cloud_100x50 3
    } elseif { $::px2mm > 5} {
	scaleImage logo_and 2
	scaleImage cloud_100x50 2
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
}

proc butCliked {num fr} {
puts "::tekFrfunc=$::tekFrfunc"
    if {$fr == ".fn3"} {
	$fr.fratext.text configure -state normal
	$fr.fratext.text  delete 0.0 end;
	$fr.fratext.text insert end "\n  \tНажмите кнопку\n" tagAbout
	$fr.fratext.text insert end "\n  \"Статус облачного токена\"\n" 
	$fr.fratext.text configure -state disabled
    }  elseif {$fr == ".fn1"} {
#	focus .lfrnd.frsym.ent80
place .linfo -in .fr1 -relx 0.05 -rely 0.4
update
	set err [execstatus]
place forget .linfo
	if {$err == -3 || $err == -2} {
	    tk_messageBox -title "Статус LS11CLOUD" -icon info -message "Нет токена в облаке (-3).\nНачинается процесс регистрации \nнового токена PKCS#11 в облаке LS11CLOUD.\nБудьте внимательны"
	} elseif {$err == 0} {
	    tk_messageBox -title "Статус токена" -icon info -message "Вы зарегистрированы в облаке PKCS#11.\nОблачный токен готов к использованию."
	    return
	} elseif { $err == -1} {
	    tk_messageBox -title "Статус токена" \
		-icon warning -message "Вы имеете токен в облаке.\nНо необходимо его проинициализировать."
		return 
	} else {
	    tk_messageBox -title "Статус токена" -icon error -message "Неизвестная ошибка\n$::resstat"
	    return
	}
    } elseif {$fr == ".fn2"} {
#	focus .lfrnd.frsym.ent80
place .linfo -in .fr1 -relx 0.05 -rely 0.4
update
	set err [execstatus]
place forget .linfo
	if {$err == -3 || $err == -2} {
	    tk_messageBox -title "Статус LS11CLOUD" -icon info -message "У вас нет доступа к облаку.\nУкажите путь к вашему токену PKCS#11 \nв облаке LS11CLOUD.\nБудьте внимательны"
	} elseif {$err == 0} {
	    tk_messageBox -title "Статус токена" -icon info -message "Вы зарегистрированы в облаке PKCS#11.\nОблачный токен готов к использованию."
	    return
	} elseif { $err == -1} {
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
    	    tk_messageBox -title "Смена пароля" -icon error -message "Вы не зарегистрированы в облаке\n"
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
    } 
    pack forget  .fr1
    set ::tekFrfunc $fr
puts "butCliked=$num"
    pack $fr -side top -anchor center -expand 1 -fill both -side top  -padx 0 -pady 0 
}

proc butReturn {} {
    pack forget  $::tekFrfunc
    pack .fr1 -side top -anchor center -expand 1 -fill both -side top  -padx 0 -pady 0 
#    tk_dialog .dialog1 "Dear user:" "Button $num was clicked\nFr=$fr" info 0 OK 
}

proc execstatus {} {
#set passw "Jephpotmas"
set passw "11111111"
#return
#    set err [catch {exec $::mm  status -p $passw} ::resstat]
    set err [catch {exec $::mm  status } ::resstat]
#tk_messageBox -title "Статус токена" -icon info -message "err=$err\n$::resstat"
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
    $w.text insert end "\n  Подождите ...\nПроверяется статус LS11CLOUD\n\n" tagAbout
    update
###########
#set passw "Jephpotmas"
#set passw "11111111"
#    set err [catch {exec $::mm  status -p $passw} result]
####
    set err [execstatus]
    $w.text  delete 0.0 end;

    $w.text insert end "\n  Полная информация о LS11CLOUD ($err)\n\n" tagAbout
    $w.text insert end "TEST UTILE=$::mm\n"

    $w.text insert end "$::resstat\n"
    $w.text insert end "TEST END\n"
    $w.text configure -state disabled
    if {$err == -3} {
	tk_messageBox -title "Статус LS11CLOUD" \
	-icon error -message "Нет токена в облаке (-3).\nНеобходимо зарегистрировать новый токен или\nподключиться к имеющемуся токену в облаке"
	return -3
    }
    if { $err == -2} {
	tk_messageBox -title "Статус токена" \
	-icon error -message "Нет токена в облаке.\nНеобходимо зарегистрировать новый токен или\nподключиться к имеющемуся токену в облаке"
	return -2
    }
    if { $err == -1} {
	tk_messageBox -title "Статус токена" \
	-icon warning -message "Вы имеете токен в облаке.\nНо необходимо его проинициализировать."
	return -1
    }
    tk_messageBox -title "Статус токена" -icon info -message "Вы зарегистрированы в облаке PKCS#11.\nОблачный токен готов к использованию."


if {0} {
    set tube [ open |$::mm r+]
    while {![eof $tube]} {
      gets $tube res
#      $list insert end "$res\n"
      $w.text insert end "$res\n"
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

if {0} {
    set err [execstatus]
puts "execstatus=$err"
    if {$err == -3} {
	tk_messageBox -title "Статус LS11CLOUD" \
	-icon error -message "Нет токена в облаке (-3).\nНеобходимо зарегистрировать новый токен или\nподключиться к имеющемуся токену в облаке"
	return -3
    }
    if { $err == -2} {
	tk_messageBox -title "Статус токена" \
	-icon error -message "Нет токена в облаке.\nНеобходимо зарегистрировать новый токен или\nподключиться к имеющемуся токену в облаке"
	return -2
    }
    if {$err == -3 || $err == -2} {
	tk_messageBox -title "Статус LS11CLOUD" \
	-icon error -message "Нет токена в облаке (-3).\nНачинается процесс регистрации \nнового токена PKCS#11 в облаке LS11CLOUD.\nБудьте внимательны"
	return -3
    }
    if {$err == 0} {
	tk_messageBox -title "Статус токена" -icon info -message "Вы зарегистрированы в облаке PKCS#11.\nОблачный токен готов к использованию."
	return 0
    }
    if { $err == -1} {
	tk_messageBox -title "Статус токена" \
	-icon warning -message "Вы имеете токен в облаке.\nНо необходимо его проинициализировать."
	return -1
    }
}
    set pas1 [$w.aut.entUserPin get]
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
        tk_messageBox -title "$typemes" -icon error -message "Не все поля заполнены\n"
        return
      }
      if {$pas1 != $pas2} {
        tk_messageBox -title "$typemes" -icon error -message "Разные пароли\n"
        return
      }

    } elseif {$type == "register" } {
      if { $::cloudhost == "" || $::cloudport == "" || $::cloudlogin == "" || $pas1 == "" || $pas2 == "" } {
        tk_messageBox -title "$typemes" -icon error -message "Не все поля заполнены\n"
        return
      }
      if {$pas1 != $pas2} {
        tk_messageBox -title "$typemes" -icon error -message "Разные пароли\n"
        return
      }
      if { $len < 6} {
        tk_messageBox -title "$typemes" -icon error -message "Логин должен иметь не менее 6 символов\n"
    	return
      }
    } else {
      if { $::cloudhost == "" || $::cloudport == "" || $::cloudlogin == "" || $pas1 == ""} {
        tk_messageBox -title "$typemes" -icon error -message "Не все поля заполнены\n"
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
    	    tk_messageBox -title "$typemes" -icon error -message "Ошибка доступа к облаку" -detail "$res"
    	    return
	}
	set cmd "$::mm save_pswd_hash -p \"$pas1\""
	if {[catch {eval exec "$cmd" } res]} {
    	    tk_messageBox -title "$typemes" -icon error -message "Ошибка доступа к облаку" -detail "$res"
    	    return
	}
    	tk_messageBox -title "$typemes" -icon info -message "Пароль успешно изменен"
	$w.aut.entRepUserPin delete 0 end
	$w.aut.entCloudPas delete 0 end
	$w.aut.entUserPin delete 0 end

	return
    }
tk_messageBox -title "$typemes" -icon info -message "Здесь будет выполняться $type\n"
    spawn $::mm $type $::cloudhost $::cloudport $::cloudlogin -p $pas1
    set press ""
    set lineterminationChar "Press key *"
    set reqok 0
    expect  { 
puts "Press key *\n"
	$lineterminationChar {
    	    set ttt $expect_out(buffer)
	    set cm [string first "Press key " $ttt]
	    if { $cm == -1} {
    		exp_continue;
	    } else {
		incr cm 10
		set ::initSym [string index  $expect_out(buffer) $cm]
	    }
	    if {$press == "" && $type == "register"} {
		set press 1
		place .lfrnd -in $w.lurl -relx 0.15 -rely 1.2
		focus .lfrnd.frsym.ent80
		$w.butop configure -state disabled
	    } elseif {$press == "" && $type == "duplicate"} {
		set press 1
		place .lfrnd1 -in $w.lurl -relx 0.15 -rely 1.2
		focus .lfrnd1.frsym.ent80
		$w.butop configure -state disabled
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
puts "REPLACE\n"
    	    exp_send "n"
	    tk_messageBox -title "Регистрация в облаке" -icon info -message "Вы уже зарегистрированы в облаке\n"
    	    exp_continue;	
	}
	"Account duplicated OK" {
puts "OKOK DUP\n"
	    catch {[file delete -force $::dstlib]}
	    file copy $::libcloud $::dstlib

	    tk_messageBox -title "Подключение к облаку" -icon info -message "Вы успешно подключились к токену\nПроверьте его статус\n"
	    set reqok 1
    	    exp_continue;	
	}
	"Successful registration" {
puts "OKOK\n"
	    catch {[file delete -force $::dstlib]}
	    file copy $::libcloud $::dstlib

	    tk_messageBox -title "Регистрация в облаке" -icon info -message "Вы зарегмистрированы в облаке\nТребуется инициализация токена\n"
	    set reqok 1
    	    exp_continue;	
	}
	"40 random bytes" {append out $expect_out(buffer)
tk_messageBox -title "$typemes" -icon info -message "RANDOM END\n$expect_out(buffer)"
	    exp_continue;	
	}
	"already registered" {append out $expect_out(buffer)
tk_messageBox -title "$typemes" -icon info -message "Already Registered\n$expect_out(buffer)"
    	    exp_continue;	
	}
	"ERROR:" {append out $expect_out(buffer)
tk_messageBox -title "$typemes" -icon info -message "ERROR\n$expect_out(buffer)"
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
#tk_messageBox -title "$typemes" -icon info -message "EOF регистрации\n$expect_out(buffer)"
tk_messageBox -title "$typemes" -icon info -message "EOF регистрации END\n"
puts "EOFEOF\n"

	}
    }
    if {$reqok} {
	set cmd "$::mm save_pswd_hash -p \"$pas1\""
	if {[catch {eval exec "$cmd" } res]} {
    	    tk_messageBox -title "$typemes" -icon error -message "Ошибка доступа к облаку" -detail "$res"
    	    return
	}
    }

    $w.butop configure -state normal
    place forget .lfrnd
tk_messageBox -title "$typemes" -icon info -message "END ls11cloud_config\n"

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
#Окно регистрации в облаке
    set pretext "  Для регистрации токена в облаке необходимо указать адрес облака (хост/порт), а также логин пользователя и пароль для доступа в облако.\n \
  P.S. Длина пароля должна быть не менее 6 (шести) символов и не используйте в нем нелатинские символы."
    label $w.lurl -relief groove -bd 3 -fg blue  -text $pretext -padx 0 -pady 3 -font "helvetica 8 bold italic" -bg #eff0f1 -justify left -wraplength $::scrwidth  -width 40
#message $w.lurl -relief groove -bd 3 -fg blue  -text $pretext -pady 3 -font "helvetica 10 bold italic" -bg #eff0f1 -justify left -aspect $::scrwidth -width $::scrwidth
    pack $w.lurl -side top -fill both -expand 1
    labelframe $w.url -relief groove -bd 3 -fg blue  -text "Адрес облака" -padx 5 -pady 3 -font "helvetica 8 bold italic" -bg #eff0f1
    pack $w.url -side top -fill x -expand 1
    label $w.url.labTok -bg wheat -justify left -text "Хост:"  -anchor w
    entry $w.url.entTok -background snow -width 27 -textvariable ::cloudhost
    grid $w.url.labTok $w.url.entTok -padx 2 -sticky news
    label $w.url.labPort -text "Порт:" -anchor w -bg wheat
    entry $w.url.entPort -background snow -textvariable ::cloudport
    grid $w.url.labPort $w.url.entPort  -padx 2 -pady 2 -sticky news
    labelframe $w.aut -relief groove -bd 3 -fg blue  -text "Авторизация в облаке" -padx 5 -pady 3 -font "helvetica 8 bold italic" -bg #eff0f1
    pack $w.aut -side top -fill x -expand 1 -pady 5
    label $w.aut.labLogin -background wheat -text "Логин:" -anchor w
    entry $w.aut.entLogin -background snow -width 23  -textvariable ::cloudlogin
    grid $w.aut.labLogin $w.aut.entLogin  -padx 2 -pady 2 -sticky news
    label $w.aut.labUserPin  -bg wheat -text "Пароль:" -anchor w
    entry $w.aut.entUserPin -background snow -show *
    grid $w.aut.labUserPin $w.aut.entUserPin  -padx 2 -pady 2 -sticky news
    label $w.aut.labRepUserPin  -bg wheat -text "Повторите" -anchor w
    entry $w.aut.entRepUserPin -background snow -show *
    grid $w.aut.labRepUserPin $w.aut.entRepUserPin  -padx 2 -pady 2 -sticky news
#####################
#Кнопка регистрации:
    set cmd "ttk::button  $w.butop -command {req2cloud $w \"register\"} -text {Зарегистрироваться} "
    eval [subst $cmd]
    pack $w.butop -fill none -side top -padx 10 -pady {4 }
#Фрейм инициализации ДСЧ
    labelframe .lfrnd \
		-borderwidth 5 -foreground black \
		-text {Инициализация ДСЧ}  -fg black -font "helvetica 8 bold italic" -bg #eff0f1
    frame .lfrnd.frsym \
		-borderwidth 2 -relief groove
    label .lfrnd.frsym.lab77 -bg wheat -text {Введите символ: } 
    set len 1
    set com "entry .lfrnd.frsym.ent80 -width 2 -validate key -validatecommand {::entryRnd .lfrnd.labViewSym %i %P $len}"
        set com1 [subst $com]
        eval $com1
    .lfrnd.frsym.ent80 configure -width 5
    set ::initSym "X"
    label .lfrnd.frsym.labSym -text $::initSym -width 2  -textvariable ::initSym \
		-background {#00ffff} \
		-font "-family {Liberation Sans} -size 18 -weight normal -slant roman -underline 0 -overstrike 0"
#		-font {-family lucida -size 18}
    pack .lfrnd.frsym.lab77 -anchor center -expand 0 -fill none -side left -padx 5
    pack .lfrnd.frsym.ent80 -anchor center -expand 0 -fill none -padx 10 -side right 
    pack .lfrnd.frsym.labSym -anchor center -expand 0 -fill none -side left 
    label .lfrnd.labViewSym \
		-background {#00ffff} -borderwidth 4 -width 2 \
		-relief groove -text X -textvariable ::presskey \
		-font "-family {Liberation Sans} -size 48 -weight normal -slant roman -underline 0 -overstrike 0"
    pack .lfrnd.frsym  -anchor n -expand 1 -fill x -side top -pady 10 -padx 10
    pack .lfrnd.labViewSym -anchor center -expand 1 -fill y -side bottom -pady 10
}

#Доступ к существующему токену в облаке
proc func_page2 {w} {
#Окно регистрации в облаке
    set pretext "  Для доступа к вашему токену в облаке необходимо указать адрес облака (хост/порт), а также логин пользователя и пароль для доступа к облаку.\n"
    label $w.lurl -relief groove -bd 3 -fg blue  -text $pretext -padx 0 -pady 3 -font "helvetica 8 bold italic" -bg #eff0f1 -justify left -wraplength $::scrwidth  -width 40
#message $w.lurl -relief groove -bd 3 -fg blue  -text $pretext -pady 3 -font "helvetica 10 bold italic" -bg #eff0f1 -justify left -aspect $::scrwidth -width $::scrwidth
    pack $w.lurl -side top -fill both -expand 1
    labelframe $w.url -relief groove -bd 3 -fg blue  -text "Адрес облака" -padx 5 -pady 3 -font "helvetica 8 bold italic" -bg #eff0f1
    pack $w.url -side top -fill x -expand 1
    label $w.url.labTok -bg wheat -justify left -text "Хост:"  -anchor w
    entry $w.url.entTok -background snow -width 27 -textvariable ::cloudhost
    grid $w.url.labTok $w.url.entTok -padx 2 -sticky news
    label $w.url.labPort -text "Порт:" -anchor w -bg wheat
    entry $w.url.entPort -background snow -textvariable ::cloudport
    grid $w.url.labPort $w.url.entPort  -padx 2 -pady 2 -sticky news
    labelframe $w.aut -relief groove -bd 3 -fg blue  -text "Авторизация в облаке" -padx 5 -pady 3 -font "helvetica 8 bold italic" -bg #eff0f1
    pack $w.aut -side top -fill x -expand 1 -pady 5
    label $w.aut.labLogin -background wheat -text "Логин:" -anchor w
    entry $w.aut.entLogin -background snow -width 23  -textvariable ::cloudlogin
    grid $w.aut.labLogin $w.aut.entLogin  -padx 2 -pady 2 -sticky news
    label $w.aut.labUserPin  -bg wheat -text "Пароль:" -anchor w
    entry $w.aut.entUserPin -background snow -show *
    grid $w.aut.labUserPin $w.aut.entUserPin  -padx 2 -pady 2 -sticky news
#####################
#Кнопка регистрации:
    set cmd "ttk::button  $w.butop -command {req2cloud $w \"duplicate\"} -text {Продублировать доступ} "
    eval [subst $cmd]
    pack $w.butop -fill none -side top -padx 10 -pady {4 }
#Фрейм инициализации ДСЧ
if {1} {
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
#		-font {-family lucida -size 18}
    pack .lfrnd1.frsym.lab77 -anchor center -expand 0 -fill none -side left -padx 5
    pack .lfrnd1.frsym.ent80 -anchor center -expand 0 -fill none -padx 10 -side right 
    pack .lfrnd1.frsym.labSym -anchor center -expand 0 -fill none -side left 
    label .lfrnd1.labViewSym \
		-background {#00ffff} -borderwidth 4 -width 2 \
		-relief groove -text X -textvariable ::presskey \
		-font "-family {Liberation Sans} -size 48 -weight normal -slant roman -underline 0 -overstrike 0"
    pack .lfrnd1.frsym -anchor n -expand 1 -fill x -side top -pady 10 -padx 10
    pack .lfrnd1.labViewSym -anchor center -expand 1 -fill y -side bottom -pady 10
}
}

#Статус облачного токене
proc func_page3 {w} {
  frame $w.fratext -borderwidth 0 -relief flat
  text $w.fratext.text -yscrollcommand [list $w.fratext.scy set] -xscrollcommand [list $w.fratext.scx set] \
  -insertbackground black -bg #f5f5f5 -highlightcolor skyblue -wrap none  -height 27
  $w.fratext.text tag configure tagAbout -foreground blue -font {{Roboto Condensed Medium} 9}
  ttk::scrollbar $w.fratext.scy  -command [list $w.fratext.text yview]
  ttk::scrollbar $w.fratext.scx -command [list $w.fratext.text xview] -orient horizontal
  #ttk::scrollbar $w.fratext.xscr -orient horizontal -command [list $w.fratext.text xview]
  pack $w.fratext.scy -anchor center -expand 0 -fill y -side right
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

proc page_func {fr tile titul functions} {
#Кнопки  меню
    upvar $functions but
#parray but
#Создаем шрифт для кнопок
    if {$::typetlf} {
	set feFONT_button "-family {Roboto} -size 9  -slant roman"
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
    canvas $fr.can -borderwidth 0 -height $hret -width $::scrwidth -relief flat
#Мостим холст плиткой 
    createtile "$fr.can"  $tile
    pack $fr.can  -anchor center -expand 1 -fill both -side top  -padx 0 -pady 0

    if {$titul != "" } {
	set allfunc $titul
#    set dlx [expr {$::padlx / 1}]
	catch {font delete fontTEMP_titul}
	set font_titul "-family {Roboto Condensed Medium} -size 15"
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
        -tag textlineTag($drawerCNT) 

   ## Bind an action to the text line.
	if {$drawerCNT == 0} {
	    if {$fr == ".fr1"} {
		$fr.can bind textlineTag($drawerCNT)  <ButtonRelease-1>   {butImg "but1"}
	    } else {
		$fr.can bind textlineTag($drawerCNT)  <ButtonRelease-1>   {butReturn}
	    }
	} else {
	    frame .fn$drawerCNT -background white -relief flat -pady 0 -padx 0
	    set titul $but($drawerCNT)
	    if {$drawerCNT != 1 &&  $drawerCNT != 2 &&  $drawerCNT != 3 &&  $drawerCNT != 4 } {
		label .fn$drawerCNT.lab -text $but($drawerCNT) 
		pack .fn$drawerCNT.lab -side top 
	    } else {
		func_page$drawerCNT .fn$drawerCNT
	    }
	    set cmd "$fr.can bind textlineTag($drawerCNT)  <ButtonRelease-1>   {butCliked $drawerCNT .fn$drawerCNT}"
	    set cmd [subst "$cmd"]
	    eval $cmd 
	    set but1(0) "Возврат в основное меню"
	    frame .fn$drawerCNT.can
	    set frret .fn$drawerCNT.can
	    eval "frame $frret.sep -bg #a0a0a0 -height $::intpx2mm -relief groove -bd $::intpx2mm"
	    eval "label $frret.seplab -text {$titul}  -bg skyblue -font {-family {$::ftxt} -size 12}"
	    eval "button $frret.sepbut -text {Возврат в основное меню} -bg skyblue -command {butReturn}"
	    pack $frret.sepbut -side bottom  -expand 1
	    pack $frret.seplab -side bottom -fill x -expand 1
	    pack $frret.sep -side bottom  -fill x
	    pack $frret -side bottom -fill both -expand 1

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
    set but(8) "Инициализировать токен"
#parray but

#Всплывающая информация
set tinfo "\n\tПодождите!\nИдет проверка облачного токена!\n"
label .linfo -relief groove -bd 3 -fg blue  -text $tinfo -padx 0 -pady 3 -font "helvetica 8 bold italic" -bg #eff0f1 -justify left -wraplength $::scrwidth

page_func ".fr$i" newtile "Функционал" "but"
