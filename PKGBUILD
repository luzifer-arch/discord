# Maintainer: Knut Ahlers <knut at ahlers dot me>
# Contributor: Filipe Laíns (FFY00) <lains@archlinux.org>

pkgname=discord
_pkgname=Discord
pkgver=0.0.26
pkgrel=1
pkgdesc="All-in-one voice and text chat for gamers that's free and secure."
arch=('x86_64')
url='https://discordapp.com'
license=('custom')
depends=('libnotify' 'libxss' 'nspr' 'nss' 'gtk3')
optdepends=('libpulse: Pulseaudio support'
	'xdg-utils: Open files')
source=("https://dl.discordapp.net/apps/linux/$pkgver/$pkgname-$pkgver.tar.gz"
	'LICENSE.html::https://discordapp.com/terms'
	'OSS-LICENSES.html::https://discordapp.com/licenses')
sha512sums=('65477c2c033f30850a699706a6502ff4f4af8838185716d968d641fdab3033555139b04bf91a111a847aca14113e33ba6248d49ba317fd43cbacb099e974117b'
            'SKIP'
            'SKIP')

prepare() {
	cd $_pkgname

	sed -i "s|Exec=.*|Exec=/usr/bin/$pkgname|" $pkgname.desktop
	echo 'Path=/usr/bin' >>$pkgname.desktop
}

package() {
	# Install the app
	install -d "$pkgdir"/opt/$pkgname
	cp -a $_pkgname/. "$pkgdir"/opt/$pkgname

	chmod 755 "$pkgdir"/opt/$pkgname/$_pkgname

	rm "$pkgdir"/opt/$pkgname/postinst.sh

	install -d "$pkgdir"/usr/{bin,share/{pixmaps,applications}}
	ln -s /opt/$pkgname/$_pkgname "$pkgdir"/usr/bin/$pkgname
	ln -s /opt/$pkgname/discord.png "$pkgdir"/usr/share/pixmaps/$pkgname.png
	ln -s /opt/$pkgname/$pkgname.desktop "$pkgdir"/usr/share/applications/$pkgname.desktop

	# setuid on chrome-sandbox
	chmod u+s "$pkgdir"/opt/$pkgname/chrome-sandbox

	# Licenses
	install -Dm 644 LICENSE.html "$pkgdir"/usr/share/licenses/$pkgname/LICENSE.html
	install -Dm 644 OSS-LICENSES.html "$pkgdir"/usr/share/licenses/$pkgname/OSS-LICENSES.html
}
