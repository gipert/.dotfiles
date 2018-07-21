# set here env variables
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export GCC_COLORS="error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01"
export MAKEFLAGS="-j8"
export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:/usr/local/lib/pkgconfig:/usr/lib64/pkgconfig:/usr/share/pkgconfig"
export LD_LIBRARY_PATH="/usr/local/lib:/usr/lib:/usr/lib64:/usr/lib64/llvm3.9/lib/"

export HOME="/home/pertoldi"
export TERM="xterm-256color-italic"
export EDITOR="vim"
export BROWSER="vivaldi"
export LESSOPEN='|pygmentize %s'

# mutt
export EMAIL="pertoldi@pd.infn.it"
export VISUAL='vim'

# homebrew
export PATH="/home/pertoldi/.linuxbrew/bin:$PATH"
export PATH="/home/pertoldi/.linuxbrew/sbin:$PATH"
export LD_LIBRARY_PATH="/home/pertoldi/.linuxbrew/lib:$LD_LIBRARY_PATH"
export MANPATH="$(brew --prefix)/share/man:$MANPATH"
export INFOPATH="$(brew --prefix)/share/info:$INFOPATH"

# julia
export PATH="$PATH:/usr/local/julia/usr/bin"

# python
export PATH="$PATH:/home/pertoldi/.local/bin"

# root
export ROOTSYS=""

# geant4
export G4LEDATA="$(brew --cellar)/geant4/10.4.2/share/Geant4-10.4.2/data/G4EMLOW7.3"
export G4LEVELGAMMADATA="$(brew --cellar)/geant4/10.4.2/share/Geant4-10.4.2/data/PhotonEvaporation5.2"
export G4NEUTRONHPDATA="$(brew --cellar)/geant4/10.4.2/share/Geant4-10.4.2/data/G4NDL4.5"
export G4NEUTRONXSDATA="$(brew --cellar)/geant4/10.4.2/share/Geant4-10.4.2/data/G4NEUTRONXS1.4"
export G4PIIDATA="$(brew --cellar)/geant4/10.4.2/share/Geant4-10.4.2/data/G4PII1.3"
export G4RADIOACTIVEDATA="$(brew --cellar)/geant4/10.4.2/share/Geant4-10.4.2/data/RadioactiveDecay5.2"
export G4REALSURFACEDATA="$(brew --cellar)/geant4/10.4.2/share/Geant4-10.4.2/data/RealSurface2.1.1"
export G4SAIDXSDATA="$(brew --cellar)/geant4/10.4.2/share/Geant4-10.4.2/data/G4SAIDDATA1.1"
export G4ENSDFSTATEDATA="$(brew --cellar)/geant4/10.4.2/share/Geant4-10.4.2/data/G4ENSDFSTATE2.2"
export G4ABLADATA="$(brew --cellar)/geant4/10.4.2/share/Geant4-10.4.2/data/G4ABLA3.1"
export AllowForHeavyElements=1

# gerdasw
export MGDODIR="/home/pertoldi/code/gerda/MGDO"
export GELATIODIR="/home/pertoldi/code/gerda/GELATIO"
export MGGERDAGEOMETRY="/home/pertoldi/code/gerda/MaGe/gerdageometry"
export MGGENERATORDATA="/home/pertoldi/code/gerda/MaGe/generators/data"
export MU_CAL="/home/pertoldi/code/gerda/gerda-metadata/config/_aux/geruncfg"

# texlive
export PATH="$PATH:/usr/local/texlive/2018/bin/x86_64-linux"
export MANPATH="$MANPATH:/usr/local/texlive/2018/texmf-dist/doc/man"
export INFOPATH="$INFOPATH:/usr/local/texlive/2018/texmf-dist/doc/info"
