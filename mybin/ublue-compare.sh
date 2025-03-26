#!/bin/sh

# first set default values in P1/P2 (if args were not given)
C=$( cat /etc/ublue/image_name )
P1=${1-stable}
P2=${2-latest}

if [[ $1 == *:* ]]; then
    C1="$1" # argument 1 exists and has a colon, use as-is
else
    C1="$C:$P1"
fi
if [[ $2 =~ : ]]; then
    C2="$2" # argument 2 exists and has a colon, use as-is
else
    C2="$C:$P2"
fi

echo Compare
echo "    $C1"
echo to
echo "    $C2"

file1=$(mktemp cmp_ublue_XXXXX)
file2=$(mktemp cmp_ublue_XXXXX)

skopeo inspect docker://ghcr.io/ublue-os/$C1 | jq -r '.Labels."dev.hhd.rechunk.info" | fromjson.packages' | sort > "$file1"
skopeo inspect docker://ghcr.io/ublue-os/$C2 | jq -r '.Labels."dev.hhd.rechunk.info" | fromjson.packages' | sort > "$file2"

#diff "$file1" "$file2" | less
flatpak run --file-forwarding org.gnome.meld $file1 $file2
rm -f $file1 $file2

