rdocs() {
    if [[ "$1" == "TMath" ]]; then
        $BROWSER https://root.cern.ch/doc/v622/namespace$1.html
    else
        $BROWSER https://root.cern.ch/doc/v622/class$1.html
    fi
}

maps() {
    $BROWSER "https://duckduckgo.com/?q=$*&iaxm=maps"
}

_fzf_complete_cp() {
    _fzf_complete -- "$@" < <(
        cat $ENHANCD_DIR/enhancd.log
    )
}
