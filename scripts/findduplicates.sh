#!/bin/bash
#
# Execute fdupes command with the folders injected via docker
#

CURRENT_TIMESTAMP=$(date +'%Y%m%d%H%M%S')
RESULT_FILE="/findup_result/fdupes_result_${CURRENT_TIMESTAMP}.txt"
RESULT_FILE_RAW="/findup_result/fdupes_result_${CURRENT_TIMESTAMP}_raw.txt"
RESULT_FILE_TMP="/findup_result/fdupes_result_${CURRENT_TIMESTAMP}_tmp.txt"
FDUPES_RECORD_SUMMARY_LINE=''
FDUPES_FILE_LIST=()

echo 'FDupes Tool Version:'
fdupes -v

echo "$(date +'%Y-%m-%d %H:%M:%S'): Start check for duplicates using tool FDUPES..."
fdupes -r -S /findup_data01 /findup_data02 /findup_data03 /findup_data04 /findup_data05 >"${RESULT_FILE}"
cp "${RESULT_FILE}" "${RESULT_FILE_RAW}"

echo "$(date +'%Y-%m-%d %H:%M:%S'): Remove unneccessary records pointing unwantend folders like [#recycle]..."
grep -v '\@eaDir' "${RESULT_FILE}" >"${RESULT_FILE_TMP}"
mv "${RESULT_FILE_TMP}" "${RESULT_FILE}"

grep -v '\#recycle' "${RESULT_FILE}" >"${RESULT_FILE_TMP}"
mv "${RESULT_FILE_TMP}" "${RESULT_FILE}"

echo "$(date +'%Y-%m-%d %H:%M:%S'): Remove results with less than 2 remaining duplicates..."
while IFS= read -r FDUPES_RESULT_LINE; do
    if [ -z "${FDUPES_RESULT_LINE}" ]; then

        if [ ${#FDUPES_FILE_LIST[*]} -gt 1 ]; then
            echo "${FDUPES_RECORD_SUMMARY_LINE}" >>"${RESULT_FILE_TMP}"
            for FDUPES_FILE_ITEM in "${FDUPES_FILE_LIST[@]}"; do
                echo "$FDUPES_FILE_ITEM" >>"${RESULT_FILE_TMP}"
            done
            echo '' >>"${RESULT_FILE_TMP}"

        fi

        unset FDUPES_RECORD_SUMMARY_LINE
        unset FDUPES_FILE_LIST
        unset FDUPES_FILE_ITEM
    else
        if [[ "${FDUPES_RESULT_LINE}" == *"bytes each:"* ]]; then
            FDUPES_RECORD_SUMMARY_LINE="${FDUPES_RESULT_LINE}"
        else
            FDUPES_FILE_LIST+=("${FDUPES_RESULT_LINE}")
        fi
    fi
done <"${RESULT_FILE}"
mv "${RESULT_FILE_TMP}" "${RESULT_FILE}"

echo "$(date +'%Y-%m-%d %H:%M:%S'): Replace file path mappings to match outside world again..."
sed 's;findup_data01;volume1/austausch;g' "${RESULT_FILE}" >"${RESULT_FILE_TMP}"
mv "${RESULT_FILE_TMP}" "${RESULT_FILE}"

sed 's;findup_data02;volume1/daten;g' "${RESULT_FILE}" >"${RESULT_FILE_TMP}"
mv "${RESULT_FILE_TMP}" "${RESULT_FILE}"

sed 's;findup_data03;volume1/homes;g' "${RESULT_FILE}" >"${RESULT_FILE_TMP}"
mv "${RESULT_FILE_TMP}" "${RESULT_FILE}"

sed 's;findup_data04;volume1/music;g' "${RESULT_FILE}" >"${RESULT_FILE_TMP}"
mv "${RESULT_FILE_TMP}" "${RESULT_FILE}"

sed 's;findup_data05;volume1/photo;g' "${RESULT_FILE}" >"${RESULT_FILE_TMP}"
mv "${RESULT_FILE_TMP}" "${RESULT_FILE}"

echo "Logged results in file: ${RESULT_FILE}"

exit 0
