prompt_singularity_venv() {
    if [[ -n "$SINGULARITY_NAME" ]]; then
        p10k segment -i 'ﱾ' -t "$SINGULARITY_NAME"
    fi
}

# vim: syntax=sh
