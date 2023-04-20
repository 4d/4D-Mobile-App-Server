#!/bin/sh

package="4D-Mobile-App-Server"
branch=main

root=$(pwd)

TMP="${TMPDIR}"
if [ "x$TMP" = "x" ]; then
  TMP="/tmp/"
fi
TMP="${TMP}$package.$$"
rm -rf "$TMP" || true
mkdir "$TMP"
if [ $? -ne 0 ]; then
  echo "failed to mkdir $TMP" >&2
  exit 1
fi

cd $TMP

echo "⬇️  Download $package component"
archive=$TMP/$package.4dbase.zip 
curl -sL https://github.com/4d/$package/archive/refs/heads/$branch.zip -o $archive


echo "📦 Unpack into temporary folder"
unzip -q $archive -d $TMP/
src=$TMP/$package-$branch 
mv "$src" $TMP/$package.4dbase
src=$TMP/$package.4dbase
echo $src

dst="$root/Components"
if [ ! -d "$dst" ]; then
  mkdir -p "$dst"
fi

if [ -d "$dst" ]; then
  if [ -d "$dst/$package.4dbase" ]; then
    echo "🗑  Remove previous installation"
    rm -Rf "$dst/$package.4dbase"
  fi
  echo "⏳ Install into $dst"

  cp -Rf $src $dst/

  echo "🧹 Clean temporary files"
  rm -rf "$TMP"

  open $dst

else
  echo "🛑 No $dst path created. Component in $src" >&2
  exit 1
fi
