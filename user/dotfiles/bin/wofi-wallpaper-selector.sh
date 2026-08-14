#!/usr/bin/env bash
# Thanks to https://github.com/highonskooma/Wofi-Wallpaper-Picker

# Configuration
WALLPAPER_DIR="$HOME/Pictures/my-wallpaper" # Change this to your wallpaper directory
CACHE_DIR="$HOME/.cache/wallpaper-selector"
THUMBNAIL_WIDTH="250" # Size of thumbnails in pixels (16:9)
THUMBNAIL_HEIGHT="141"

# Create cache directory if it doesn't exist
mkdir -p "$CACHE_DIR"

if [[ ! -d $WALLPAPER_DIR ]]; then
	notify-send "Folder $WALLPAPER_DIR does not exist"
	exit 1
fi

_wwp_has() { command -v "$1" &>/dev/null; }

set_wallpaper() {
	[[ -z $1 ]] && return 1
	hyprctl hyprpaper wallpaper ,"$1"
}

# Function to generate thumbnail
generate_thumbnail() {
	local input="$1"
	local output="$2"
	magick "$input" -thumbnail "${THUMBNAIL_WIDTH}x${THUMBNAIL_HEIGHT}^" -gravity center -extent "${THUMBNAIL_WIDTH}x${THUMBNAIL_HEIGHT}" "$output"
}

# Create shuffle icon thumbnail on the fly
SHUFFLE_ICON="$CACHE_DIR/shuffle_thumbnail.png"
if [[ ! -f $SHUFFLE_ICON ]]; then
	# Create a properly sized shuffle icon thumbnail
	magick -size "${THUMBNAIL_WIDTH}x${THUMBNAIL_HEIGHT}" xc:#1e1e2e \
		\( "$HOME/.config/wofi/wallpaper/shuffle.png" -resize "80x80" \) \
		-gravity center -composite "$SHUFFLE_ICON"
fi

# Generate thumbnails and create menu items
generate_menu() {
	# Add random/shuffle option with a name that sorts first (using ! prefix)
	echo -en "img:$SHUFFLE_ICON\x00info:!Random Wallpaper\x1fRANDOM\n"

	# Then add all wallpapers
	for img in "$WALLPAPER_DIR"/*.{jpg,jpeg,png}; do
		# Skip if no matches found
		[[ -f $img ]] || continue

		# Generate thumbnail filename
		thumbnail="$CACHE_DIR/$(basename "${img%.*}").png"

		# Generate thumbnail if it doesn't exist or is older than source
		if [[ ! -f $thumbnail ]] || [[ $img -nt $thumbnail ]]; then
			generate_thumbnail "$img" "$thumbnail"
		fi

		# Output menu item (filename and path)
		echo -en "img:$thumbnail\x00info:$(basename "$img")\x1f$img\n"
	done
}

selected=$(generate_menu | wofi --conf ~/.config/wofi/wallpaper/wallpaper.conf)

# Set wallpaper if one was selected
if [ "$selected" != "" ]; then
	# Remove the img: prefix to get the cached thumbnail path
	thumbnail_path="${selected#img:}"

	# Check if random wallpaper was selected
	if [[ $thumbnail_path == "$SHUFFLE_ICON" ]]; then
		# Select a random wallpaper from the directory
		original_path=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | shuf -n 1)
	else
		# Get the original filename from the thumbnail path
		original_filename=$(basename "${thumbnail_path%.*}")

		# Find the corresponding original file in the wallpaper directory
		original_path=$(find "$WALLPAPER_DIR" -type f -name "${original_filename}.*" | head -n1)
	fi

	# Ensure a valid wallpaper was found before proceeding
	if [ "$original_path" != "" ]; then
		# Set wallpaper using swww with the original file
		set_wallpaper "$original_path"

		# Optional: Notify user
		notify-send "Wallpaper" "Wallpaper has been updated" -i "$thumbnail_path"
	else
		notify-send "Wallpaper Error" "Could not find the original wallpaper file."
	fi
fi
