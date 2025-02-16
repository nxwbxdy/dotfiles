#! /usr/bin/env bash

set -xe

if [[ $# -ne 3 ]]; then
	echo -ne "Usage: $0 <pdf-file> <pages> <output>\n"
	exit 1
fi

pdf_source_path=$1
# pdf_basename=$(basename "pdf_source_path")
pages=$2
pdf_out=$3

if [[ ! -f "$pdf_source_path" ]]; then
	echo -ne "File does not exist!\n"
	exit 1
fi

if [[ "$pages" -lt 1 ]]; then
	echo -ne "Pages should be above 1!\n"
	exit 1
fi

total_pages=$(pdfinfo "$pdf_source_path" | awk '/Pages/ {print $2}')

for ((i = 0; i < "$pages"; i++)); do
	from_page=$(( i * total_pages / pages + 1))
	to_page=$(( (i + 1) * total_pages / pages))
	mutool merge -o "${pdf_out%.pdf}_${from_page}-${to_page}.pdf" "$pdf_source_path" "${from_page}-${to_page}"
done
