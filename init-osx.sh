
UVE_FFMPEG_UPSTREAM=https://github.com/FFmpeg/FFmpeg.git
UVE_FFMPEG_FORK=https://github.com/FFmpeg/FFmpeg.git
UVE_FFMPEG_COMMIT=n4.2.4
UVE_FFMPEG_LOCAL_REPO=extra/ffmpeg

set -e
TOOLS=tools

# FF_ALL_ARCHS="i386 x86_64"
FF_ALL_ARCHS="x86_64"
FF_TARGET=$1

function echo_ffmpeg_version() {
    echo $UVE_FFMPEG_COMMIT
}

function pull_common() {
    git --version
    # echo "== pull gas-preprocessor base =="
    # sh $TOOLS/pull-repo-base.sh $UVE_GASP_UPSTREAM extra/gas-preprocessor

    echo "== pull ffmpeg base =="
    sh $TOOLS/pull-repo-base.sh $UVE_FFMPEG_UPSTREAM $UVE_FFMPEG_LOCAL_REPO
}

function pull_fork() {
    echo "== pull ffmpeg fork $1 =="
    mkdir -p osx/contrib
    sh $TOOLS/pull-repo-ref.sh $UVE_FFMPEG_FORK osx/contrib/ffmpeg-$1 ${UVE_FFMPEG_LOCAL_REPO}
    cd osx/contrib/ffmpeg-$1
    git checkout ${UVE_FFMPEG_COMMIT} -B ffmpeg-uve
    cd -
}

function pull_fork_all() {
    for ARCH in $FF_ALL_ARCHS
    do
        pull_fork $ARCH
    done
}

#----------
case "$FF_TARGET" in
    ffmpeg-version)
        echo_ffmpeg_version
    ;;
    i386|x86_64)
        pull_common
        pull_fork $FF_TARGET
    ;;
    all|*)
        pull_common
        pull_fork_all
    ;;
esac

# sync_ff_version

echo "export UVE_FFMPEG_COMMIT=$UVE_FFMPEG_COMMIT" > ./config/config.sh

./init-config.sh
