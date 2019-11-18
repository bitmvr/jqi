#!/usr/bin/env bash

PATH=./jqi-tmp:$PATH

jqi::getLatestTag(){
  local response
  response="$(curl -s https://github.com/stedolan/jq/releases/latest)"
  response="${response##*tag/}"
  response="${response%%\">*}"
  echo "$response"
}

jqi::osDetection(){
  local os="$OSTYPE"
  case "$os" in
    darwin*)
      echo "macOS"
    ;;
    linux*)
      echo "linux"
    ;;
    msys*)
      echo "windows"
    ;;
    *)
      echo "unknown"
    ;;
  esac   
}

jqi::macosInstall(){
  local version="$1"
  curl -sL -o jq "https://github.com/stedolan/jq/releases/download/${version}/jq-osx-amd64"
  chmod +x ./jq
}

jqi::winInstall(){
  local version="$1"
  curl -sL -o jq.exe "https://github.com/stedolan/jq/releases/download/${version}/jq-win64.exe"
  chmod +x ./jq.exe
}

jqi::linuxInstall(){
  local version="$1"
  curl -sL -o jq "https://github.com/stedolan/jq/releases/download/${version}/jq-linux64"
  chmod +x jq
}

jqi::packageDropzone(){
  mkdir -p ./jqi-tmp && cd "$_" || exit 1
}

jqi::returnToRoot(){
  cd ..  
}

jqi::cleanup(){
  rm -rf ./jqi-tmp
}

jqi::installjq(){
  local tag
  local platform
  tag="$(jqi::getLatestTag)"
  platform="$(jqi::osDetection)"
  jqi::packageDropzone
  case "$platform" in
    macOS)
      jqi::macosInstall "$tag"
    ;;
    linux)
      jqi::linuxInstall "$tag"
    ;;
    windows)
      jqi::winInstall "$tag"
    ;; 
    unknown)
      echo "ERROR: Could not determine your operating system. Exiting..."
      exit 1
  esac
  jqi::returnToRoot
}
