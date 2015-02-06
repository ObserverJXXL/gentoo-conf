# initialize tc queue control
alias sfb='sudo tc qdisc add dev eth0 root handle 1: sfb'

# unmount and remount media partition
alias unmedia='kill $(pgrep -f autoplay); sudo umount ~/media && sudo cryptsetup close media'
alias remedia='pass Disks/media | sudo cryptsetup open /dev/disk/by-uuid/821db9aa-d229-412d-a3b8-e914691fbe9b media && sudo mount /dev/mapper/media ~/media && sudo chown nand:nand ~/media && echo Mounted... && nohup autoplay info >/dev/null 2>&1'

# grep should always be case insensitive
alias grep='grep -i --color=auto'

# some more ls aliases
alias ll='ls -l --si'
alias la='ls -A'
alias l='ls -CF'

alias df='df --total -H'
alias du='du --si'
alias ds='du --total --summarize -- *'

# allow colors in less
alias less='less -R'

# Sort by memory usage per default
alias htop='htop -s PERCENT_MEM'

# start in fullscreen mode
alias sxiv='sxiv -Zf'

# quicker root delete
alias srm='sudo rm'

# prefer floating vim over gvim
alias gvim='urxvt -e vim'
alias gview='urxvt -e vim'
alias svim='sudo vim'

# new mail client and stuff
alias m='notmuch new >/dev/null && ~/dev/bower/bower'

# restore secondary monitor after fullscreen botches it
alias fixmon='xrandr --output DFP1 --mode 4096x2160 --primary --output DFP7 --mode 1920x1200 --rotate left --pos 4096x240'
alias fixcol='argyll-dispwin -I -d1 ~/icc/main.icc; argyll-dispwin -I -d2 ~/icc/alt.icc'
alias fixpulse='sudo fixpulse'

# fix fanspeed
alias fanspeed='aticonfig --pplib-cmd "set fanspeed 0 18"'

# ghetto post-it notes
alias note='cat >> ~/notes'

# quad core make (ht)
alias make='make -j9'

# launch weechat inside dtach
alias weechat='dtach -A /tmp/weechat -Ez weechat-curses'

# scan for replaygain
alias replayscan='find -L . -name \*.flac -printf %h\\n | sort -u | while read -r d; do flacgain "$d"/*.flac; done'
alias mp3scan='find -L . -name \*.mp3 -printf %h\\n | sort -u | while read -r d; do mp3gain "$d"/*.mp3; done'

# automatically copy URL
alias wgetpaste='wgetpaste -X'
alias hpaste='wgetpaste -l Haskell'

# simpler filenames
alias youtube-dl='youtube-dl --id --continue --no-part'

# automatically resume and stuff
alias wget='wget -c -4 --timeout 10'

# Got camera photos and stuff
alias photo='sudo gphoto2 --get-all-files --new && sudo chown nand:nand IMG_*.JPG'

# portage aliases + auto sudo
alias emerge='sudo emerge'
alias euse='sudo euse'
alias eselect='sudo eselect'
alias ebuild='sudo ebuild'
alias eix-update='sudo eix-update'
alias eix-sync='sudo eix-sync'
alias layman='sudo layman'
alias genlop='sudo genlop'
alias egencache='sudo egencache'
alias econf='sudo dispatch-conf'
alias eclean='sudo eclean'
alias erebuild='sudo revdep-rebuild'
alias edepclean='emerge --depclean'
alias module-rebuild='sudo module-rebuild'
alias rc-update='sudo rc-update'
alias rc-config='sudo rc-config'
alias rc-service='sudo rc-service'
alias haskell-updater='sudo haskell-updater'
alias hackport='sudo hackport -p /usr/local/portage'
alias ghc-pkg='sudo ghc-pkg'
alias elogv='sudo elogv'
alias btrfs='sudo btrfs'

alias esync='emerge --ask=n --sync'
alias epull='layman -S && hackport update && esync && eix-update'
alias eworld='emerge --update --newuse --deep @world --exclude portage'
alias deworld='emerge --ask=n --deselect'
alias esmart='sudo smart-live-rebuild -E'
alias eupdate='epull && eworld && haskell-updater && esmart'

# squashfs maintenance aliases
#alias squash-save='sudo squash-save'
#alias squash-reload='for i in /etc/init.d/squash*; do sudo $i restart; done'
#alias squash-update='squash-save && squash-reload'

# dual booting
alias pm-restart='sudo pm-restart'

# make sure we don't break our system
#alias restart='squash-save && sudo reboot'
#alias shutdown='squash-save && sudo poweroff'

# start djbdns manually
# alias djbdns='sudo sh -c "nohup /var/dnscache/run >/dev/null 2>&1 &"'

# quick ssh access to VPS
alias vps='ssh nanovps -l root'
alias uni='ssh bhd48@zeus.rz.uni-ulm.de'

# Run password-store with the primary selection as default
alias pass='PASSWORD_STORE_X_SELECTION=primary pass'

# Syncplay without GUI support
alias syncplay='/home/nand/dev/syncplay/syncplayClient.py --no-gui'

# ln with absolute paths
aln() {
  LNARGS=
  while [[ $1 == -* ]]; do
    LNARGS="$LNARGS $1"
    shift
  done

  P=$(readlink -f "$1")
  shift
  ln $LNARGS "$P" "$*"
}

# More aggressive rate limiting
alias trickle='trickle -s -w 50 -t 0.5'
alias nethogs='sudo nethogs tun0'

# Some darcs aliases
alias da='darcs'

# Darcs colordiff
daff () {
  darcs diff $@ | colordiff
}

# Deselect a package, and remove it too
demerge() {
  deworld $@ && edepclean
}

iup() {
  #curl -F"file=@$1" http://i.intma.in/up.cgi | tee /dev/stderr | xclip
  curl -F"file=@$1" http://i.srsfckn.biz/ | tee /dev/stderr | xclip -selection primary
}

ix() {
    local opts
    local OPTIND
    [ -f "$HOME/.netrc" ] && opts='-n'
    while getopts ":hd:i:n:" x; do
        case $x in
            h) echo "ix [-d ID] [-i ID] [-n N] [opts]"; return;;
            d) $echo curl $opts -X DELETE ix.io/$OPTARG; return;;
            i) opts="$opts -X PUT"; local id="$OPTARG";;
            n) opts="$opts -F read:1=$OPTARG";;
        esac
    done
    shift $(($OPTIND - 1))
    [ -t 0 ] && {
        local filename="$1"
        shift
        [ "$filename" ] && {
            curl $opts -F f:1=@"$filename" $* ix.io/$id
            return
        }
        echo "^C to cancel, ^D to send."
    }
    curl $opts -F f:1='<-' $* ix.io/$id
}

mailsync() {
  nohup mswatch -c ~/.mswatch-nanovps &>/dev/null &
  nohup mswatch -c ~/.mswatch-uulm    &>/dev/null &
  #nohup mswatch -c ~/.mswatch-gmail   &>/dev/null &
}

# Set up PTT redirection
alias evrouter='sudo evrouter /dev/input/event16 -c ~/.evrouterrc'

# GHCid integration

alias ghcid='echo'

alias :quit='exit'
# alias :='ghcid :'
alias :add='ghcid :add'
alias :show='ghcid :show'
alias :set='ghcid :set'
alias :unset='ghcid :unset'
alias :kill='ghcid :quit'
alias :start='ghcid start'
alias :help='ghcid :help'
alias :load='ghcid :load'
alias :info='ghcid :info'
alias :type='ghcid :type'
alias :kind='ghcid :kind'

# GHCid aliases

alias :q=':quit'
alias :h=':help'
alias :?=':help'
alias :l=':load'
alias :i=':info'
alias :t=':type'
alias :k=':kind'

# Newer GHCi

alias ghci-head='PATH="~/ghc-head/bin:$PATH" ghci'

# Tag an image file with my monitor's colorspace

itag() {
  convert "$1" -red-primary 0.6881,0.3068 -green-primary 0.2214,0.7160 -blue-primary 0.1468,0.061 -white-point 0.312874,0.329226 +gamma 0.45454545 "$1"
}
