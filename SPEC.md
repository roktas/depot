# Home

Bu projede agentlar yoluyla bir makinede SSH yoluyla uzaktan veya yerelden provizyonlama yapılması hedefleniyor.

## Özet

- Her alt dizin bir uygulamanın provizyonlamasını tanımlıyor. Buna "görev dizini" veya kısaca "görev" diyelim.
- Genel olarak görev dizinleri uygulamanın tanınan adına karşı geliyor ve çoğunlukla dizin adı aynı zamanda uygulamanın
  brew paket adı
- Ama bunun istisnaları olabiliyor ve bu durum ilgili dizindeki README.md dosyasında (frontmatter veya gövdede)
  belirtiliyor.
- Bazı dizin adları uygulama değil bir tür sanal uygulama veya provizyonlama adına karşı geliyor.
- `_` özel bir sanal uygulama. Bu dizin altında bulunan alt dizinler sadece ilgili platformda seçiliyor. Ör. `_/linux`
  sadece Linux platformunu hedefliyor. Provizyonlama sırasında çalışılan platforma göre sadece ilgili dizin seçiliyor,
  diğerleri işlem dışı bırakılıyor.
- Görev dizinlerinde YAML frontmatter'lı README.md dosyaları ve provizyonlamada kullanılan diğer dosyalar bulunuyor.
  README.md biçimi için ilgili bölüme bakın.
- İlgili kontaktaki durum bilgisi yüklendikten sonra provizyonlama kararı verilmişse önce `_` görevi, daha sonra sırayla
  görev dizinleri gerçekleştiriliyor.
- Görev gerçekleştirilirken önce dizine geçip README.md yüklenerek içindeki talimatlar ve frontmatter'daki bilgiler
  okunuyor.
- İlgili host için her provizyonlama repo kökünde `.agents/state/hosts/HOST/home.md` dosyasına yazılır. Log formatı için
  ilgili bölüme bakın.

## Format: README.md

YAML frontmatter ve metin gövdesinden oluşur. Örneğin `foo/` görevinde `foo/README.md` dosyası:

        ---
        all:
          links:
            config: ~/.config/git/config
            ignore: ~/.config/git/ignore
            hooks/: ~/.config/git/hooks
            bin/:   ~/.local/bin
          packages:
            - foo-bar
            - cask:foo-baz
            - deb:baz
            - npm:qux
            - gem:fred
            - egg:waldo
            - flatpak:org.foo.bar
            - github:user/project
          hosts:
            - hostname
        osx:
          links:
            bin/:   ~/.local/bin
        ---

        # Foo

        Foo is bla bla.

        ## Install

        ```bash
        brew install foo-qux
        ```

### Frontmatter

İki seviyeli bir sözlük: ilk seviyede platform adları, ikinci seviyede dosya, paket ve (opsiyonel olarak) konak adı.

#### İlk Seviye

- Platform adları: `all`, `linux`, `osx`, `windows`
- İlgili konakta provizyonlama yaparken (varsa) önce `all` sözlüğü alınır, daha sonra konağın ait olduğu platforma ait
  sözlük tanımlıysa bununla "merge" yapılarak nihai sözlük elde edilir.

#### İkinci Seviye

**`links`**: Görev dizinindeki dosyalar ve sembolik linkleneceği hedefler. Linklemede hedef dizin yoksa önce o
oluşturulur.

**`packages`**: Paket listesi.

- `[paket-tipi:]paket-adı`

- Geçerli paket tipleri: `brew`, `cask`, `deb`, `npm`, `gem`, `egg`, `flatpak`, `github`

- Paket tipi verilmemişse öntanımlı olarak `brew`'dir.

- `deb` kurulumları doğal olarak `sudo` ile sistem geneli yapılır.

- Bunun haricindeki tüm paketler ilgili paket yöneticileriyle "kullanıcı geneli" kurulur.

- `npm` için `bun`, `egg` için `uv` paket yöneticileri tercih edilir.

- `github` paket tipi URL'i verilen bir repo'nun asset'lerinde ilgili platforma özgü uygulamayı kurar. Paket içinden
  çıkan programlar mutlaka `~/.local/bin` dizinine yerleştirilir.

Bu anahtar mevcut değilse öntanımlı olarak görev dizini adıyla doldurulan "brew" paketi varsayılır. Yani `foo` görevi
için `packages: [ foo ]`

**`hosts`**: Konak süzgeci, provizyonlamanın yapılacağı konak adları.

- Bu adlar `hostname -f` çıktısıyla, sondaki `.*` kısmı çıkarılarak eşleştirilir.
- Bu anahtar opsiyoneldir. Yokluğu halinde konak süzgeci etkin değildir (sadece platform süzgeci etkindir).

### Gövde

Gövde metni agent talimatları olarak kullanılır ve dilenilen şekilde doldurulur. Öte yandan bazı bölüm adları
konvansiyonel olarak özeldir. Bu adlar Provizyonlama bölümünde dokümante edilniştir.

## Format: Log

Log dosyası `.agents/state/hosts/HOST/home.md` lokasyonunda, YAML frontmatter'lı bir Markdown dosyadır. HOST
`hostname -f` çıktısında sonda `.*` varsa çıkarılarak belirlenir (ör. `kant.local` için `kant`). YAML frontmatter
aşağıdaki anahtarların yer aldığı bir sözlüktür:

- `head`: Provizyonlamanın yapıldığında repo'nun HEAD komiti, `git -rev-parse HEAD` çıktısı.

- `date`: Provizyonlama tarihi, `date --iso-8601=seconds` çıktısı.

- `done`: Provizyonlaması yapılan görev dizinleri sözlüğü. Görev dizinleri provizyonlama sırasıyla yer alır ve her
  anahtar 3 değerden birini alabilir. `ok`: provizyonlama başarılı, `notok`: provizyonlama başarısız, `ignored`:
  provizyonlama yapılmadı/yapılmayacak.

`kant` konağında örnek log: `.agents/state/hosts/kant/home.md`

        ---
        head: a10a8ae3db88c91f792b54b76db93dc30e09341e
        done:
          foo: ok
          bar: notok
          baz: ignored
        ---

    Opsiyonel detaylar, ör. `bar` provizyonlanması neden başarısız oldu?

Veri kaybı olmaması için mevcut log dosyası provizyonlama yapılmadan önce yedeklenebilir. Provizyonlama tamamlandıktan
sonra güncelleme yapılır. `head` değişmeden tekrar tekrar provizyonlama yapılabilir. Bu durumda sadece `notok` durumlu
görev dizinleri dikkate alınır, `ok` ve `ignored` durumlu görev dizinleri işlenmez.

Log gövdesini kullanmak tamamen opsiyoneldir. Özellikle `notok` durumunu gelecekte çözmek için yararlı olabilecek
detaylar varsa kaydedilir.

## Linkleme

- GNU semantiğiyle `cp -as` kullanılır. Bunun anlamı OS X gibi GNU'ya dayanmayan platformalarda `cp -as` değil `gcp -as`
  kullanılmalı.

- `config: ~/.config/foo/config` gibi bir girdide görev dizinindeki `config` dosyası `~/.config/foo/config` dosyasına
  linklenir. Bu işlem sırasında `cp -as` komutu `~/.config/foo` dizini yoksa oluşturulur.

  ```bash
  cp  -as config ~/.config/foo/config # Linux
  gcp -as config ~/.config/foo/config # Mac OS X
  ```

## Provizyonlama

Provizyonlama aşağıdaki aaçıklanan akışa sahip ve genel olarak idempotent olan bir işlemdir. Fakat bu "idempotency"
mutlak değil "best effort"dur.

Provizyonlamarda bu reponun makinede bulunduğu yer hakkında bir kabul yapılmaz. Linkleme vb tüm işlemler ilgili dosyanın
bulunduğu yer çalışma zamanında çözülerek gerçekleştirilir. Provizyonlama yerelde (bu dizin içinde) veya uzaktan
yapılabilir. Uzaktan (SSH) yoluyla provizyonlama yapılmadan önce repo uzak makineye bir şekilde transport edilmiş
olmalıdır (ör. git, rsync, dropbox). Uzak makineye sadece bu reponun transport edildiği durumlarda `~/.home` lokasyonu
varsayılır.

### Init

- Güncel state'i log dosyasından oku. State'in olmaması bunun yeni bir kurulum olduğunu gösterir.

- Repo `HEAD`'yle güncel `head`'i karşılaştır ve değişen görev dizinlerini belirle.

- Provizyonlama yapmayı gerektiren değişiklikleri not et. Örneğin çoğunlukla sadece `README.md` frontmatter'ındaki
  değişiklikler provizyonlama gerektirir. Görev dizinindeki dosyalarda yapılan değişiklikler, bu dosyalar zaten
  linklenmiş ise provizyonlama gerektirmez.

- Değişen her görev dizini için aşağıda açıklanan provizyonlama adımlarını icra et.

### Loop

- Daima önce `_` görev dizininden başla

- Görev dizinine girerek `README.md`'yi oku ve provizyonlama sözlüğünü yükle. Bu yüklemede `all` ve (varsa) platforma
  ait sözlükler birleştirilir.

- `HEAD`, `head` farkını yorumlayarak provizyonlama sözlüğünü güncelle. Eklenen/çıkartılan paketler, eklenen/çıkartılan
  linkleri dikkate alarak aktif provizyonlama sözlüğünü oluştur.

- Aktif provizyonlama sözlüğünü kullanarak sırasıyla `Install` ve `Link` aşamalarını icra et.

- Güncel durumu kaydet.

#### Install

- Varsa `README.md`'de "Preinstall" başlığında belirtilen işlemleri yap.

- Aktif provizyonlama sözlüğünde kayıtlı eklenen paketleri paket tipini dikkate alarak kur, çıkarılan paketleri de
  kaldır.

- Varsa `README.md`'de "Install""veya "Postinstall" başlığında belirtilen işlemleri yap.

#### Link

- Varsa `README.md`'de "Prelink" veya "Presetup" başlığında belirtilen işlemleri yap.

- Aktif provizyonlama sözlüğünde kayıtlı eklenen dosyaları sembolik linkle hedefe bağla, çıkarılan dosyaların linkini
  kaldır.

- Varsa `README.md`'de "Link" veya "Postlink" veya "Setup" başlığında belirtilen işlemleri yap.
