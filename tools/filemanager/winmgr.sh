#!/bin/bash
###########################################################
## window Manager.
###########################################################

fwinmgr_draw_window() {
    # Args
    local var_width=${VAR_TERM_COLUMN_CNT}
    local var_height=${VAR_TERM_MSGWIN_HEIGHT}
    local var_start_line=$((1 + ${VAR_TERM_TAB_LINE_HEIGHT} + ${VAR_TERM_CONTENT_MAX_CNT}))
    local var_start_col=0
    # local var_buffer=("${VAR_TERM_MSGWIN_BUFFER[@]}")
    local var_win_title="[MSG WIN]"

    # Test center
    ############################################################################
    # var_width=$((${VAR_TERM_COLUMN_CNT}/2))
    # var_height=$((${VAR_TERM_LINE_CNT}/2))
    # var_start_line=$((${VAR_TERM_LINE_CNT}/4))
    # var_start_col=$((${VAR_TERM_COLUMN_CNT}/4))
    # flog_msg "ORI WH: ${VAR_TERM_LINE_CNT}/${VAR_TERM_COLUMN_CNT}, WH: ${var_width}/${var_height}, POS: ${var_start_line}/${var_start_col}"
    ############################################################################

    fterminal_print '\e7'

    fterminal_print '\e[%sH\e[%sm%*s\e[m' \
           "${var_start_line};${var_start_col}" \
           "${HSFM_COLOR_TAB_BOOKMARK_FG};${HSFM_COLOR_TAB_BOOKMARK_BG}" \
           "${var_width}"
    fterminal_print '\e[%sH\e[%sm %s \e[m' \
           "${var_start_line};${var_start_col}" \
           "${HSFM_COLOR_TAB_BOOKMARK_FG};${HSFM_COLOR_TAB_BOOKMARK_BG}" \
           "${var_win_title}"

    local var_cnt=0
    while read each_line || ((var_cnt < var_height - 1));
    do
        local var_line_buf=""
        # clean lines
        fterminal_print '\e[%sH\e[%sm%*s\e[m' \
            "$((var_start_line + 1 + var_cnt));${var_start_col}" \
            "${HSFM_COLOR_TAB_BOOKMARK_FG};${HSFM_COLOR_TAB_BOOKMARK_BG}" \
            "${var_width}"

        # Draw lines
        if test -n "${each_line}"
        then
            fterminal_print '\e[%sH\e[%sm %s \e[m' \
                "$((var_start_line + 1 + var_cnt));${var_start_col}" \
                "${HSFM_COLOR_TAB_BOOKMARK_FG};${HSFM_COLOR_TAB_BOOKMARK_BG}" \
                "${var_cnt}: ${each_line}"
        fi
        ((var_cnt++))
    done << EOF
$(printf  "${VAR_TERM_MSGWIN_BUFFER[@]}")
EOF
# $(printf  "${var_buffer[@]}")

    fterminal_print '\e8'
}
