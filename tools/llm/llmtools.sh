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
    export VAR_DEFAULT_MODEL="qwen3:8b-q8_0"
fi
export VAR_API_KEY=""

export VAR_DEFAULT_PROMPT="It's an simple anwser system."
# google/ollama/ort
export VAR_PROVIDER='google'

###########################################################
## Options
###########################################################
export OPTION_VERBOSE=n

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
    printf "    %- 16s\t%s\n " " -m|--model      " " Specify model to use (Default: ${VAR_DEFAULT_MODEL})"
    printf "    %- 16s\t%s\n " " -q|--question   " " Question to ask."
    printf "    %- 16s\t%s\n " " --provider      " " Specify AI provider (google/ollama/ort, Default: ${VAR_PROVIDER})"
    printf "    %- 16s\t%s\n " " -v|--verbose    " " Print in verbose mode"
    printf "    %- 16s\t%s\n " " -h|--help       " " Print helping"
    echo "[Actions]"
    printf "    %- 16s\t%s\n " " review          " " Do the code review"
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
function ai_code_review() {
    local prompt="Help user to review modified code and generate suggestion\n"
    prompt+=$(cat << 'EOF'
You are an experienced software engineer with expertise in code security, performance, and best practices. 

I will provide you with a `git diff` output that contains code changes between different commits or branches. Your task is to:

1. **Analyze Security Risks:**  
   - Check for potential security vulnerabilities such as SQL injection, command injection, and improper input handling.
   - Look for improper usage of file handling, network requests, or access control.
   - Identify any hardcoded credentials or sensitive data.

2. **Detect Memory Leaks and Resource Management Issues:**  
   - Identify potential memory leaks, especially in languages like C/C++ or Python where improper management may cause resource exhaustion.
   - Check for dangling pointers, double-free, or improper deallocation of resources.

3. **Evaluate Code Efficiency and Optimization Opportunities:**  
   - Suggest performance improvements or refactoring where applicable.
   - Identify redundant operations or unnecessary complexity.

4. **Ensure Consistency with Coding Standards and Best Practices:**  
   - Check if the code follows established coding guidelines and style conventions.
   - Look for inconsistent naming conventions, improper error handling, or missing comments.

5. **Error Handling and Logging:**  
   - Ensure proper error handling and logging mechanisms are in place.
   - Verify that sensitive errors or exceptions are not exposed to the end-user.

### Additional Instructions:
- Focus only on the changed lines provided in the diff.
- Provide detailed explanations for any issues found.
- Suggest safer or more efficient alternatives where applicable.
EOF
)

    local diff_buffer='Here is the `git diff` to review:\n'
    diff_buffer+="$(git diff HEAD)\n"

    diff_buffer+="Please help me to review the code above.\n"

    promote_msg=$(echo -E "${prompt}")
    question_msg=$(echo -E "${diff_buffer}")
    # printf "Diff: ${diff_buffer}"
    review_message=$(ask_llm "${promote_msg}" "${question_msg}")
    echo -E "${review_message}" | less
}
function ai_git_commit() {
    local prompt="Help user to generate git commit message with given template.\n"
    prompt+="1. The first none-# line is title line, update it inline.\n"
    prompt+="2. For each following sessions, update it as template dose.\n"
    prompt+="3. You could add note/comment strating with # as comment."
    prompt+="4. Put your review in the end of commit message. All reviews should start with '# '."
    prompt+="5. Don't use markdown syntax."

    local diff_buffer="git diff content as follow:\n"
    local git_template=("$(eval "cat $(git config --get commit.template) | sed 's/#AI- //g'")")
    diff_buffer+="$(git diff --cached)\n"
    diff_buffer+="Please help me to fill out the git commit message, and dont' output the message with unrelated words.\n"
    diff_buffer+="Template as below in content tag:\n${git_template[*]}\n"

    promote_msg=$(echo -E "${prompt}")
    question_msg=$(echo -E "${diff_buffer}")
    # printf "Diff: ${diff_buffer}"
    git_message=$(ask_llm "${promote_msg}" "${question_msg}" | sed 's/^Answser: //g' | sed 's/^```$//g')
    echo -E "##################################################################"
    echo -E "${git_message}"
    echo -E "##################################################################"
    git status
    local result=""
    while true; do
        result=$(fAskInput " " "Do you want to proceed with git commit?(y/N)")
        case "${result}" in
            [yY])
                git commit -m "${git_message}" && git commit --amend
                break
                ;;
            [nN])
                echo "Git commit aborted."
                break
                ;;
            *)
                echo "Invalid input. Please enter 'y' or 'n'."
                ;;
        esac
    done
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

    result_message=$(ask_llm "${promote_msg}" "${text_buffer}\nUser Question:${question}\n")
    printf "${result_message}\n"
}
###########################################################
## AI Functions
###########################################################

function ask_openai()
{
    # local model="gemini-2.5-pro-exp-03-25"
    # local service_url="https://generativelanguage.googleapis.com/v1beta/openai/chat/completions"
    # local api_key="${GEMINI_API_KEY}"
    local model="$VAR_DEFAULT_MODEL"
    local service_url="$VAR_SERVER_URL"
    local api_key="${VAR_API_KEY}"

    local prompt="$1"
    local question="$2"

    prompt=$(echo "$prompt" | jq -Rs .)
    question=$(echo "$question" | jq -Rs .)

    if [ ${OPTION_VERBOSE} = y ]
    then
        echo "${model}@${service_url}: ${prompt}=>${question}"
    fi
    if test -z "${api_key}"; then
        echo "API KEY not found."
        return 1
    fi

    response=$(curl -s "${service_url}" \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer ${api_key}" \
        -d "{
            \"model\": \"${model}\",
            \"messages\": [
                {\"role\": \"user\", \"content\": ${question}}
                ],
                \"stream\": false
            }")

    # Show, result.
    if [ ${OPTION_VERBOSE} = y ]
    then
        printf "Respone: %s\n" "${response}" >&2
    fi
    answer=$(echo $response | jq -r '.choices[0].message.content')
    echo "Answser: $answer"
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
    if [ ${OPTION_VERBOSE} = y ]
    then
        printf "Respone: %s\n" "${response}" >&2
    fi
    answer=$(echo $response | jq -r '.message.content')
    echo "Answser: $answer"
}
function ask_llm() {
    # printf "Prompt: ${1}"
    # printf "Question: ${2}"
    #
    if [ "${VAR_PROVIDER}" = "ollama" ]
    then
        ask_ollama "$1" "$2"
    elif [ "${VAR_PROVIDER}" = "google" ];then
        VAR_SERVER_URL="https://generativelanguage.googleapis.com/v1beta/openai/chat/completions"
        # switch back to flash, it's too slow on pro modle.
        VAR_DEFAULT_MODEL="gemini-2.5-flash-preview-05-20"
        # VAR_DEFAULT_MODEL="gemini-2.5-pro"
        VAR_API_KEY="${GEMINI_API_KEY}"
        ask_openai "$1" "$2"
    elif [ "${VAR_PROVIDER}" = "ort" ];then
        VAR_SERVER_URL="https://openrouter.ai/api/v1/chat/completions"
        VAR_DEFAULT_MODEL="deepseek/deepseek-r1-0528:free"
        VAR_API_KEY="${OPENROUTER_API_KEY}"
        ask_openai "$1" "$2"
    else
        echo "Unknow provider ${VAR_PROVIDER}"
        return 1
    fi
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
            review)
                var_action="review"
                ;;
            -q|--question)
                var_action="question"
                ;;
            -P|--provider)
                VAR_PROVIDER="$2"
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
                break
                ;;
        esac
        shift 1
    done

    ## Download
    if [ ${flag_verbose} = true ]
    then
        OPTION_VERBOSE='y'
        echo SERVER:${VAR_SERVER_URL}
        # fInfo; fErrControl ${FUNCNAME[0]} ${LINENO}
    fi
    if [ "${var_action}" = "question" ]
    then
        ask_llm "${var_promote}" "${var_question}"
    elif [ "${var_action}" = "git" ]; then
        ai_git_commit
    elif [ "${var_action}" = "file" ]; then
        ai_file "${var_file_path}" "${var_question}"
    elif [ "${var_action}" = "review" ]; then
        ai_code_review
    fi
}

fMain $@
