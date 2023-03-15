function music() {

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

function cdrip() {
    #
    #  CDRIP
    # =======
    #
    # Rip Audio CD with cdparanoia, FLAC-encode it and auto tag it with beets
    #
    # Prerequisites:
    #  - cdparanoia            -> https://xiph.org/paranoia
    #  - flac                  -> https://xiph.org/flac
    #  - python-musicbrainzngs -> https://pypi.org/project/musicbrainzngs
    #  - python-discid         -> https://pypi.org/project/discid
    #  - beets                 -> https://beets.io
    #
    #  On Arch Linux install: cdparanoia python-musicbrainzngs python-discid beets

    setopt pipe_fail
    setopt local_options

    local output="$HOME/ripped"
    mkdir -p "$output"

    # quit if CD not inserted
    cdparanoia --search-for-drive --query || return 1

    local ntracks=$(cdparanoia --query |& grep OK | wc -l)

    # rip CD with cdparanoia and encode to FLAC
    # in one go (all hail Unix pipes)
    for tr in $(seq $ntracks); do
        cdparanoia \
            --search-for-drive \
            --log-summary="$output/cdparanoia.log" \
            --abort-on-skip \
            # --disable-paranoia \
            -- "$tr" - \
        | flac - \
            -o "$output/track-$tr.flac" \
            --warnings-as-errors \
            --silent \
            --force \
            --best \
        || return 1
    done

    # calculate MusicBrainz release [1] with disc ID [2]
    # note: CD must be in!
    # note: needs "pip install discid musicbrainzngs"
    #
    # [1] https://musicbrainz.org/doc/Disc_ID
    # [2] https://musicbrainz.org/doc/Release
    local pycode='
import discid
import musicbrainzngs
musicbrainzngs.set_useragent("cdrip", "v0.1", "gipert@pm.me")
data = musicbrainzngs.get_releases_by_discid(discid.read().id)
print(":".join([r["id"] for r in data["disc"]["release-list"]]))
'
    local musicbrainz_releases=$(python -c "$pycode") || return 1
    echo "MusicBrainz releases found: $musicbrainz_releases"

    # now we can safely eject the CD
    eject

    # import and autotag music with beets
    # further customization in ~/.config/beets/config.yaml
    beet --directory "$HOME/music" \
        import \
        --move \
        --search-id "$musicbrainz_releases" \
        -- "$output" || return 1

    # finally remove temporary directory if empty
    rm "$output/cdparanoia.log"
    [ "$(ls -A $output)" ] || rm -r "$output"
}
