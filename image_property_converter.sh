#!/usr/bin/env bash
# author    : Bilery Zoo(bilery.zoo@gmail.com)
# create_ts : 2020-01-01
# program   : convert properties of a image file to be compatible with JAVA

# Image color profile cii of "Japan Color 2001 Coated" and colour space of "CMYK" is not compatible with JAVA
# thus causing program BUGs of our system.
# This script is to convert its properties of a image into compatible format.

# This script relays on OS program of `ImageMagick', thanks to the open source developers.
# See also:
#    http://www.imagemagick.org/
# You can easily install `ImageMagick' by
#        > yum install ImageMagick
# on rpm series OS and
#        > apt install imagemagick
# on deb series OS.

# *******************************************************************************
#
#            　　 　 　　　　 　 |＼＿/|
#            　　 　 　　　　 　 | ・x・ |
#            　　 ＼＿＿＿＿＿／　　　 |
#            　　 　 |　　　 　　　　　|    ニャンー ニャンー
#            　　　　＼　　　　　 　ノ　
#            　（（（　(/￣￣￣￣(/ヽ)
#
# User-definition Variables Area
#
folder_source=${1:-'/img'}
folder_backup=${2:-'/img_backup'}
#
# *******************************************************************************


function program_usage() {
    echo -e '\nProgram can get up to 2 valid args(the rest is ignored) from command line.'
    echo "* Input blank string('' or \"\") as placeholder when an arg takes default value and with arg of defined value following *"
    echo ''
    echo -e "\t\$1 -> Source direction of image files be storing. Default value: /img."
	echo -e "\t\$2 -> Backup direction of image files to be converted. Default value: /img_backup.\n"
}

function get_incompatible_image() {
    identify -verbose $1 | grep icc > /dev/null
    return $?
}

function convert_incompatible_image() {
    convert -colorspace sRGB -strip "$1" "$2" &> /dev/null
    return $?
}

function main() {
    case $1 in
    -h|--help)
        program_usage
        exit 0
        ;;
    esac

    local dir_source=${folder_source%/}
    local dir_backup=${folder_backup%/}
    local IFS=$'\n'

    for img in $(ls ${dir_source})
    do
        local img_source_path=${dir_source}/${img}
        get_incompatible_image ${img_source_path}
        if [ $? -eq 0 ]; then
            local img_backup_path=${dir_backup}/${img}
            mv ${img_source_path} ${img_backup_path} && convert_incompatible_image ${img_backup_path} ${img_source_path}
            if [ $? -ne 0 ]; then
                echo "convert file ${img_source_path} failed..."
                continue
            fi
        fi
    done
}


main "$1"
