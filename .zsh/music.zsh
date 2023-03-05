music() {
    if [[ `hostname` == "hackintosh" ]]; then
        if [[ "$1" == "--enable" ]]; then

            if ! ssh -q -O check gate-infn; then
                echo "INFO: setting up proxy..."
                ssh -fN gate-infn
            fi

            if ! ps aux | grep sshfs | grep -q /home/gipert/music; then
                echo "INFO: mounting remote music library..."
                sshfs gipert@localhost:/data/pertoldi/music ~/music -p 9093 -o idmap=user,ro
            fi

            if ! ps aux | grep -q ' [m]pd'; then
                echo "INFO: starting MPD server..."
                mpd
            fi

            if ! ps aux | grep polybar | grep -q music; then
                echo "INFO: enabling music bar..."
                bspc config -m eDP1 bottom_padding 29 && \
                polybar music &> ~/.config/polybar/music.log & disown && \
                echo $! > ~/.config/polybar/polybar.pid
            fi

        elif [[ "$1" == "--disable" ]]; then
            echo "INFO: killing the MPD server..."
            mpd --kill
            echo "INFO: removing the music bar..."
            kill -s TERM `cat ~/.config/polybar/polybar.pid`
            bspc config bottom_padding -7
            rm -f ~/.config/polybar/polybar.pid
            echo "INFO: unmounting music library..."
            fusermount3 -u ~/music
        else
            echo "ERROR: unsupported option '$1'"
        fi
    else
        echo "ERROR: works only on 'hackintosh'"
    fi
}

cdrip() {

    local output="$HOME/ripped"
    mkdir -p "$output"

    cdparanoia -Q || return 1

    for tr in $(seq 99); do
        cdparanoia \
            --log-summary="$output/cdparanoia.log" \
            --abort-on-skip \
            -- "$tr" - \
        | flac - \
            -o "$output/track-$tr.flac" \
            --warnings-as-errors \
            --silent \
            --force \
            --best \
        || break

    done

    eject

    # https://musicbrainz.org/doc/Disc_ID
    pycode='
import discid
import musicbrainzngs
musicbrainzngs.set_useragent("gipert", "v0.1", "gipert@pm.me")
data = musicbrainzngs.get_releases_by_discid(discid.read().id)
print(":".join([r["id"] for r in data["disc"]["release-list"]]))
'
    musicbrainz_releases=$(python -c "$pycode")

    # TODO: configuration dotfile
    beet --directory "$HOME/music" \
        import \
        --move \
        --search-id $musicbrainz_discid \
        "$output"

    [ "$(ls -A $output)" ] || rm -r "$output"
}
