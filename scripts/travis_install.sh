#!/usr/bin/env bash

# Script to setup environment on travis
# install os dependencies and set up matplotlib backend
# travis does not support python on osx - install via miniconda

if [ $TRAVIS_OS_NAME = 'osx' ]; then 
    echo "Installing brew packages..."  
    brew install graphviz
    echo "Setting up conda environment..."
    wget http://repo.continuum.io/miniconda/Miniconda3-latest-MacOSX-x86_64.sh -O miniconda.sh || exit 1
    bash miniconda.sh -b -p "$HOME/miniconda3" || exit 1
    export PATH=$HOME/miniconda3/bin:$PATH
    conda config --set always_yes true || exit 1
    conda create -n primrose python=$PYTHON_VERSION || exit 1
    echo "Activating conda environment"
    source activate primrose
    echo "Updating matplotlib configuration"
    mkdir -p ~/.matplotlib && touch ~/.matplotlib/matplotlibrc
    echo backend: TkAgg >> ~/.matplotlib/matplotlibrc
elif [ $TRAVIS_OS_NAME = 'linux' ]; then
    echo "Installing linux packages"
    sudo add-apt-repository universe
    sudo apt update
    sudo apt-get install graphviz
    echo "Updating matplotlib configuration"
    mkdir -p ~/.config/matplotlib && touch ~/.config/matplotlib/matplotlibrc
    echo backend: Agg >> ~/.config/matplotlib/matplotlibrc
fi

echo "Installing requirements"
pip install -r requirements.txt

pip install --upgrade bump2version
