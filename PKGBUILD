# Maintainer: Knut Ahlers <knut at ahlers dot me>
# Contributor: Manuel Hüsers <aur@huesers.de>
# Contributor: Stick <stick@stma.is>
# Contributor: johnnyapol <arch@johnnyapol.me>
# Contributor: huyizheng <huyizheng@hotmail.com>
# Contributor: Filipe Laíns (FFY00) <lains@archlinux.org>
# Contributor: Morgan <morganamilo@archlinux.org>

# Based off the discord_arch_electron_wayland PKGBUILD from Stick
# Based off the discord_arch_electron PKGBUILD from johnnyapol and huyizheng
# Based off the discord community repo PKGBUILD by Filipe Laíns (FFY00)

pkgname=discord
_pkgname=discord
_electron=22
pkgver=0.0.47
pkgrel=1
pkgdesc="Discord using system provided electron (v${_electron}) for increased security and performance"
arch=('x86_64')
provides=("${_pkgname}")
conflicts=("${_pkgname}")
url='https://discord.com'
license=('custom')
options=('!strip')
depends=("electron${_electron}" 'libnotify' 'libxss' 'nspr' 'nss' 'gtk3')
makedepends=('asar' 'curl' 'python-html2text')
optdepends=(
  'libpulse: Pulseaudio support'
  'xdg-utils: Open files'
)
source=("https://dl.discordapp.net/apps/linux/${pkgver}/discord-${pkgver}.tar.gz")
sha512sums=('da08bd801210d7194f8c5de1b43948e018dfccffc7685adbc28d0710351fbf9161f77ccb1e8c0c34b13d1955f53f8dd58f15470415b05d2e22057fe7ae73c703')

prepare() {
  # create launcher script
  cat >>"${srcdir}"/discord-launcher.sh <<EOF
#!/bin/sh

if [ "\$XDG_SESSION_TYPE" = wayland ]; then
	# Using wayland
	exec electron${_electron} \\
		--enable-features=UseOzonePlatform \\
		--ozone-platform=wayland \\
		--enable-accelerated-mjpeg-decode \\
		--enable-accelerated-video \\
		--ignore-gpu-blacklist \\
		--enable-native-gpu-memory-buffers \\
		--enable-gpu-rasterization \\
		--enable-gpu \\
		--enable-features=WebRTCPipeWireCapturer \\
		/usr/lib/discord/app.asar \$@
else
	# Using x11
	exec electron${_electron} \\
		--enable-accelerated-mjpeg-decode \\
		--enable-accelerated-video \\
		--ignore-gpu-blacklist \\
		--enable-native-gpu-memory-buffers \\
		--enable-gpu-rasterization \\
		--enable-gpu \\
		/usr/lib/discord/app.asar \$@
fi
EOF

  # fix the .desktop file
  sed -i "s|Exec=.*|Exec=/usr/bin/${_pkgname}|" Discord/$_pkgname.desktop
  echo 'Path=/usr/bin' >>Discord/$_pkgname.desktop

  # create the license files
  curl https://discord.com/terms | html2text >"${srcdir}"/LICENSE.md
  curl https://discord.com/licenses | html2text >"${srcdir}"/OSS-LICENSES.md
}

package() {
  # create necessary directories
  install -d "${pkgdir}"/usr/{lib/$_pkgname,bin}
  install -d "${pkgdir}"/usr/share/{pixmaps,applications,licenses/$_pkgname}

  cd "${srcdir}/Discord"

  # use system electron
  asar e resources/app.asar resources/app
  rm resources/app.asar
  sed -i "s|process.resourcesPath|'/usr/lib/${_pkgname}'|" resources/app/app_bootstrap/buildInfo.js
  sed -i "s|exeDir,|'/usr/share/pixmaps',|" resources/app/app_bootstrap/autoStart/linux.js
  asar p resources/app resources/app.asar
  rm -rf resources/app

  # copy relevant data
  cp -r resources/* "${pkgdir}"/usr/lib/$_pkgname/
  cp $_pkgname.png \
    "${pkgdir}"/usr/share/pixmaps/$_pkgname.png
  cp $_pkgname.desktop \
    "${pkgdir}"/usr/share/applications/$_pkgname.desktop

  cd "${srcdir}"

  # install the launch script
  install -Dm 755 discord-launcher.sh "${pkgdir}"/usr/bin/$_pkgname

  # install licenses
  install -Dm 644 LICENSE.md "${pkgdir}"/usr/share/licenses/$_pkgname/
  install -Dm 644 OSS-LICENSES.md "${pkgdir}"/usr/share/licenses/$_pkgname/
}
