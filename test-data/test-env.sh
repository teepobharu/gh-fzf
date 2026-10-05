#!/usr/bin/env bash
# Mock environment configuration for testing

# Override glab commands with mock data during testing
export GLAB_MOCK_MODE=1

# Mock glab command wrapper
glab() {
    local command="$1"
    local subcommand="$2"
    shift 2

    case "$command" in
        "issue")
            case "$subcommand" in
                "list")
                    cat "$MOCK_DATA_DIR/issues.txt"
                    ;;
                "view")
                    local issue_id="$1"
                    if [[ -f "$MOCK_DATA_DIR/commands/issue-view-${issue_id}.txt" ]]; then
                        cat "$MOCK_DATA_DIR/commands/issue-view-${issue_id}.txt"
                    else
                        echo "Issue #${issue_id} not found"
                    fi
                    ;;
                *)
                    echo "Mock: glab issue $subcommand $*"
                    ;;
            esac
            ;;
        "mr")
            case "$subcommand" in
                "list")
                    cat "$MOCK_DATA_DIR/mrs.txt"
                    ;;
                "view")
                    local mr_id="$1"
                    if [[ -f "$MOCK_DATA_DIR/commands/mr-view-${mr_id}.txt" ]]; then
                        cat "$MOCK_DATA_DIR/commands/mr-view-${mr_id}.txt"
                    else
                        echo "Merge request !${mr_id} not found"
                    fi
                    ;;
                *)
                    echo "Mock: glab mr $subcommand $*"
                    ;;
            esac
            ;;
        "pipeline")
            case "$subcommand" in
                "list")
                    cat "$MOCK_DATA_DIR/pipelines.txt"
                    ;;
                "view")
                    local pipeline_id="$1"
                    if [[ -f "$MOCK_DATA_DIR/commands/pipeline-view-${pipeline_id}.txt" ]]; then
                        cat "$MOCK_DATA_DIR/commands/pipeline-view-${pipeline_id}.txt"
                    else
                        echo "Pipeline ${pipeline_id} not found"
                    fi
                    ;;
                *)
                    echo "Mock: glab pipeline $subcommand $*"
                    ;;
            esac
            ;;
        "repo")
            case "$subcommand" in
                "list")
                    cat "$MOCK_DATA_DIR/projects.txt"
                    ;;
                "view")
                    local repo_path="$1"
                    local safe_path="${repo_path//\//-}"
                    if [[ -f "$MOCK_DATA_DIR/commands/project-view-${safe_path}.txt" ]]; then
                        cat "$MOCK_DATA_DIR/commands/project-view-${safe_path}.txt"
                    else
                        echo "Repository ${repo_path} not found"
                    fi
                    ;;
                *)
                    echo "Mock: glab repo $subcommand $*"
                    ;;
            esac
            ;;
        *)
            echo "Mock: glab $command $subcommand $*"
            ;;
    esac
}

# Export the mock function
export -f glab

echo "Mock environment loaded. Use 'unset GLAB_MOCK_MODE' to disable."
