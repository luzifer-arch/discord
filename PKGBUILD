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
_electron=32
pkgver=0.0.71
pkgrel=2
pkgdesc="Discord using system provided electron (v${_electron}) for increased security and performance"
arch=('x86_64')
provides=("${_pkgname}")
conflicts=("${_pkgname}")
url='https://discord.com'
license=('custom')
options=('!strip')
depends=("electron${_electron}" 'libnotify' 'libxss' 'nspr' 'nss' 'gtk3')
makedepends=('asar')
optdepends=(
  'libpulse: Pulseaudio support'
  'xdg-utils: Open files'
)
source=(
  "https://dl.discordapp.net/apps/linux/${pkgver}/discord-${pkgver}.tar.gz"
  'discord-launcher.sh'
  'LICENSE.html::https://discord.com/terms'
  'OSS-LICENSES.html::https://discord.com/licenses'
)
sha512sums=('c4042a56e8ad170901367ed562831d0f8933d8f0babf246639f8b5b17d7b437b58d6cf696f3c3d6a30674c041567115d0419a3e4c00de7064db58a4c77a61a93'
            '140b8fd340caf1069fcde0d23c8058488a59518b0b55db70290bd2c50b6c3c1c28978fe7d3a6e8feff65cec990f41e34cf68876acfc0183c51f6a58e9f8cb668'
            'SKIP'
            'SKIP')

prepare() {
  # fix the .desktop file
  sed -i "s|Exec=.*|Exec=/usr/bin/${_pkgname}|" Discord/$_pkgname.desktop
  echo 'Path=/usr/bin' >>Discord/$_pkgname.desktop

  # patch launcher electron version
  sed -i "s|@ELECTRON_VER@|${_electron}|" discord-launcher.sh

  cd "${srcdir}/Discord"

  # use system electron
  asar e resources/app.asar resources/app
  rm resources/app.asar
  sed -i "s|process.resourcesPath|'/usr/share/${_pkgname}/resources'|" resources/app/app_bootstrap/buildInfo.js
  sed -i "s|exeDir,|'/usr/share/pixmaps',|" resources/app/app_bootstrap/autoStart/linux.js
  sed -i -E "s|resourcesPath = _path.+;|resourcesPath = '/usr/share/${_pkgname}/resources';|" resources/app/common/paths.js
  asar p resources/app resources/app.asar
  rm -rf resources/app
}

package() {
  # install the launch script
  install -Dm 755 discord-launcher.sh "${pkgdir}/usr/bin/${_pkgname}"

  # copy resources into patched path
  install -d "${pkgdir}/usr/share/${_pkgname}/resources"
  cp -r Discord/resources/* "${pkgdir}/usr/share/${_pkgname}/resources/"

  install -Dm 644 Discord/$_pkgname.png "${pkgdir}/usr/share/pixmaps/${_pkgname}.png"
  install -Dm 644 Discord/$_pkgname.desktop "${pkgdir}/usr/share/applications/${_pkgname}.desktop"

  # install licenses
  install -Dm 644 -t "${pkgdir}/usr/share/licenses/${_pkgname}" LICENSE.html OSS-LICENSES.html
}
