#!/bin/bash
###########################################################
## DEF
###########################################################
export DEF_COLOR_RED='\033[0;31m'
export DEF_COLOR_YELLOW='\033[0;33m'
export DEF_COLOR_GREEN='\033[0;32m'
export DEF_COLOR_NORMAL='\033[0m'

###########################################################
## Vars
###########################################################
export VAR_SCRIPT_NAME="$(basename ${BASH_SOURCE[0]%=.})"
export VAR_CPU_CNT=$(nproc --all)
export VAR_TIMESTAMP=$(date +%Y%m%d_%H%M%S)

if test -n "${HS_ENV_AI_SERVICE_URL}"; then
    export VAR_SERVER_URL="${HS_ENV_AI_SERVICE_URL}"
else
    export VAR_SERVER_URL="http://localhost:11434"
fi
if test -n "${HS_ENV_AI_MODEL}"; then
    export VAR_DEFAULT_MODEL="${HS_ENV_AI_MODEL}"
else
    export VAR_DEFAULT_MODEL="qwen2.5:7b-instruct-q8_0"
fi
export VAR_DEFAULT_PROMPT="It's an simple anwser system."

###########################################################
## Options
###########################################################
export OPTION_VERBOSE=false

###########################################################
## Path
###########################################################
export SCRIPT_ROOT="$(realpath $(dirname ${BASH_SOURCE[0]}))"
export PATH_ROOT="$(pwd)"

###########################################################
## Utils Functions
###########################################################
fPrintHeader()
{
    local msg=${1}
    printf "###########################################################\n"
    printf "###########################################################\n"
    printf "##  %- $((60-4-${#msg}))s  ##\n" "${msg}"
    printf "###########################################################\n"
    printf "###########################################################\n"
    printf ""
}
fErrControl()
{
    local ret_var=$?
    local func_name=${1}
    local line_num=${2}
    if [[ ${ret_var} == 0 ]]
    then
        return ${ret_var}
    else
        echo ${func_name} ${line_num}
        exit ${ret_var}
    fi
}
fHelp()
{
    echo "${VAR_SCRIPT_NAME}"
    echo "[Example]"
    printf "    %s\n" "run test: .sh -a"
    echo "[Options]"
    printf "    %- 16s\t%s\n " " -s|--server-url " " Specify server url"
    printf "    %- 16s\t%s\n " " -p|--promote    " " Specify system promte"
    printf "    %- 16s\t%s\n " " -f|--file       " " File mode, file to attach"
    printf "    %- 16s\t%s\n " " -g|--git-commit " " Git comimt mode."
    printf "    %- 16s\t%s\n " " -q|--question   " " Question to ask."
    printf "    %- 16s\t%s\n " " -v|--verbose    " " Print in verbose mode"
    printf "    %- 16s\t%s\n " " -h|--help       " " Print helping"
}
fInfo()
{
    local var_title_pading""

    fPrintHeader ${FUNCNAME[0]}
    printf "###########################################################\n"
    printf "##  Vars\n"
    printf "###########################################################\n"
    printf "##    %s\t: %- 16s\n" "Script" "${VAR_SCRIPT_NAME}"
    printf "###########################################################\n"
    printf "##  Path\n"
    printf "###########################################################\n"
    printf "##    %s\t: %- 16s\n" "Working Path" "${PATH_ROOT}"
    printf "###########################################################\n"
    printf "##  Options\n"
    printf "###########################################################\n"
    printf "##    %s\t: %- 16s\n" "Verbose" "${OPTION_VERBOSE}"
    printf "###########################################################\n"
}
fSleepSeconds()
{
    local var_sleep_cnt=0
    if [ $# = 1 ]
    then
        var_sleep_cnt=${1}
    else
        return -1
    fi
    # only sleep for seconds
    for each_idx in $(seq 1 $var_sleep_cnt)
    do
        printf "\rSleeping (%d/%d)" ${each_idx} ${var_sleep_cnt}
        sleep 1
    done;
    printf "\nwakeup from sleep(${var_sleep_cnt})\n"
    return 1
}
fEval()
{
    local var_commands=0
    if [[ $# = 1 ]]
    then
        var_commands=${1}
    elif [[ $# > 1 ]]
    then
        if [[ "${1}" = "-s" ]]
        then
            shift 1
            var_commands="sudo ${@}"
        else
            var_commands=${@}
        fi
    else
        return -1
    fi
    echo -e "Executing: ${DEF_COLOR_YELLOW}${var_commands}${DEF_COLOR_NORMAL} "
    ${var_commands}
    return $?
}
fAskInput()
{
    local var_default_value=""
    local var_msg="value"
    if [[ $# = 1 ]]
    then
        var_default_value=${1}
    elif [[ $# > 1 ]]
    then
        var_default_value=${1}
        var_msg=${2}
    else
        return -1
    fi

    printf "Please enter for ${var_msg}(Default ${var_default_value}):" 1>&2
    read tmp_input
    if test -n "${tmp_input}"
    then
        echo "${tmp_input}"
    elif test -n "${var_default_value}"
    then
        echo "${var_default_value}"
    fi
    return 0
}
###########################################################
## Functions
###########################################################
function fexample()
{
    fPrintHeader ${FUNCNAME[0]}
}
function ai_git_commit() {
    local git_template=("$(eval "cat $(git config --get commit.template)")")
    local prompt="Help user to generate git commit message with given template.\n"
    local diff_buffer="git diff content as follow:\n"
    prompt+="1. The first none-# line is title line, update it inline.\n"
    prompt+="2. For each following sessions, update it as template dose.\n"
    prompt+="3. # is for comment, will be removed latter. it's not a valid message."
    diff_buffer+="$(git diff --cached)\n"
    diff_buffer+="Please help me to fill out the git commit message, and only output the message with unreated words.\n"
    diff_buffer+="Template as follow:\n${git_template[*]}\n"

    promote_msg=$(echo -E "${prompt}")
    question_msg=$(echo -E "${diff_buffer}")
    # printf "Diff: ${diff_buffer}"
    git_message=$(ask_ollama "${promote_msg}" "${question_msg}" | sed 's/^Answser: //g')
    echo -E "##################################################################\n"
    echo -E "${git_message}"
    echo -E "##################################################################\n"
    git status
    result=$(fAskInput "n" "Do you want to procced git commmit?(y/N)")
    if [ "${result}" = "y" ]
    then
        git commit -m "${git_message}" && git commit --amend
    fi
}
function ai_file() {
    local var_file_path=$1
    shift 1
    local question="${*}"

    local prompt="Read the text content and anwser user's question. \n"
    # local text_buffer="$(<${var_file_path})"
    local text_buffer=""

    while IFS= read -r line; do
        text_buffer+="$line"$'\n'
    done < ${var_file_path}
    if [ ${OPTION_VERBOSE} = y ]
    then
        printf "${text_buffer}"
    fi

    result_message=$(ask_ollama "${promote_msg}" "${text_buffer}\nUser Question:${question}\n")
    printf "${result_message}\n"
}
function ask_ollama() {
    local model=${VAR_DEFAULT_MODEL}
    # it must be: http://localhost:11434/api/chat
    local service_url="${VAR_SERVER_URL}/api/chat"
    local prompt=$1
    local question=$2

    prompt=$(echo "$prompt" | jq -Rs .)
    question=$(echo "$question" | jq -Rs .)

    if [ ${OPTION_VERBOSE} = y ]
    then
        echo "${model}@${service_url}: ${prompt}=>${question}"
    fi


    response=$(curl -s ${service_url} -H "Content-Type: application/json" -d "{
    \"model\": \"${model}\",
    \"messages\": [
    {\"role\": \"system\", \"content\": ${prompt}},
    {\"role\": \"user\", \"content\": ${question}}
    ],
    \"stream\": false
    }")

    # Show, result.
    answer=$(echo $response | jq -r '.message.content')
    echo "Answser: $answer"
}
## Main Functions
###########################################################
function fMain()
{
    # fPrintHeader "Launch ${VAR_SCRIPT_NAME}"
    local flag_verbose=false
    local var_action=""
    local var_promote="${VAR_DEFAULT_PROMPT}"
    local var_question=""
    local var_file_path=""

    while [[ $# != 0 ]]
    do
        case $1 in
            -s|--server-url)
                VAR_SERVER_URL="${2}"
                shift 1
                ;;
            -p|--promote)
                var_promote="${2}"
                shift 1
                ;;
            -m|--model)
                VAR_DEFAULT_MODEL="${2}"
                shift 1
                ;;
            -f|--file)
                var_action="file"
                var_file_path="$2"
                shift 1
                ;;
            -g|--git-commit)
                var_action="git"
                ;;
            -q|--question)
                var_action="question"
                var_question="${2}"
                shift 1
                ;;
            # Options
            -v|--verbose)
                flag_verbose=true
                ;;
            -h|--help)
                fHelp
                exit 0
                ;;
            *)
                var_question="${*}"
                ;;
        esac
        shift 1
    done

    ## Download
    if [ ${flag_verbose} = true ]
    then
        OPTION_VERBOSE=y
        echo SERVER:${VAR_SERVER_URL}
        # fInfo; fErrControl ${FUNCNAME[0]} ${LINENO}
    fi
    if [ "${var_action}" = "question" ]
    then
        ask_ollama "${var_promote}" "${var_question}"
    elif [ "${var_action}" = "git" ]; then
        ai_git_commit
    elif [ "${var_action}" = "file" ]; then
        ai_file "${var_file_path}" "${var_question}"
    fi
}

fMain $@
