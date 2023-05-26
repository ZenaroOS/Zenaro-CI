cd /tmp

git clone https://github.com/elkowar/eww

cd eww

cargo build --release --no-default-features --features=wayland
