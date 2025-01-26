#! /usr/bin/env bash
image_name="${PWD#"$HOME"}";
image_name="${image_name#/}";
image_name="${image_name//\//_}"
sleep 2
scrot -s "${image_name}_%Y-%m-%d.png" -e 'du -h $f'
