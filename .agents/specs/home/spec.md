# Home Specification

Bu proje, dotfiles benzeri bir repoyu agent yardımıyla yerel olarak veya SSH üzerinden uzak bir makinede
provizyonlamayı hedefler.

## Terimler

- **Modül**: Repo kökündeki her uygulama veya provizyonlama birimi dizini. Önceki taslakta "görev" olarak geçen kavram
  budur. "Modül" terimi `.agents/tasks/` ile kavramsal çakışmayı azaltır.
- **Support alanı**: `_` dizini altındaki state dışı provisioning yardımcıları. `_` normal modül değildir, planlara
  dahil edilmez ve state'e yazılmaz.
- **Platform modülü**: Repo kökündeki `linux/README.md`, `macos/README.md` veya `windows/README.md` dosyasıyla
  tanımlanan jenerik platform modülü. Platformun kendi davranışını hazırlar; örneğin apt policy, Homebrew policy veya
  platform defaults.
- **Host**: `hostname -f` çıktısından sondaki domain kısmı çıkarılarak bulunan kısa makine adı. Örneğin `kant.local`
  için `kant`.
- **State**: Bir host için daha önce hangi modüllerin provizyonlandığını kaydeden çalışma zamanı durumu.

## Genel Model

- Her modül bir uygulamanın veya sanal provizyonlama biriminin kurulumunu tanımlar.
- Modül adı genellikle uygulamanın tanınan adı ve varsayılan paket adıdır. İstisnalar modülün `README.md` dosyasında
  belirtilir.
- Modül dizinlerinde `README.md` dosyası ve provizyonlamada kullanılacak dosyalar bulunur. README frontmatter'ı
  opsiyoneldir.
- Kök modüller, repo kökündeki doğrudan alt dizinlerden seçilir. `.` ile başlayan dizinler, `.git`, `.agents` ve özel
  `_` support dizini kök modül listesine dahil edilmez.
- Modül olarak işlenecek kök dizinlerde `README.md` bulunmalıdır. `README.md` olmayan kök dizinler provizyonlama dışı
  bırakılır.
- Provizyonlama kararı state yüklendikten sonra verilir.
- Fresh host üzerinde normal provizyonlama başlamadan önce gerekiyorsa `_` altındaki support helper'lar explicit olarak
  çalıştırılır. Bu helper'lar state dışıdır ve idempotent olmalıdır.
- Normal provizyonlama yapılacaksa önce aktif platformun kök platform modülü (`linux`, `macos` veya `windows`) varsa
  uygulanır, sonra diğer kök modüller alfabetik sırayla uygulanır. Aktif olmayan platform kök modülleri plan dışıdır.
- Kök modüller platform anahtarlarıyla da süzülebilir. Örneğin bir kök modül yalnızca `linux:` anahtarı içeriyorsa
  modül Linux dışında planlanmaz.
- Her modül uygulanırken önce modül dizinine geçilir, `README.md` okunur, frontmatter verisi ve gövde talimatları
  değerlendirilir.
- İlgili host için provizyonlama state'i işlem yapılan repo kökündeki `.agents/state/hosts/HOST/home.md` dosyasına
  yazılır.

## Repo Yerleşimi

```text
.
  _/
    README.md
    bin/
      bootstrap
  linux/
    README.md
  macos/
    README.md
  git/
    README.md
    config
    ignore
    hooks/
    bin/
  .agents/
    specs/
      home/
        spec.md
    state/
      hosts/
        HOST/
          home.md
```

`.agents/state/` çalışma zamanı state'idir. Git'e alınıp alınmaması repo sahibinin kararıdır; bu spec bunu zorunlu
kılmaz.

## Format: Modül README.md

Opsiyonel YAML frontmatter ve metin gövdesinden oluşur. Açık provizyonlama ayarı olmayan modüllerde frontmatter
tamamen atlanabilir; `all` veya platform anahtarı yoksa boş sözlük gibi yorumlanır. Örneğin `foo/` modülünde
`foo/README.md` dosyası:

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
          level: normal
          hosts:
            - hostname
        macos:
          links:
            bin/:   ~/.local/bin
        windows: ~
        ---

        # Foo

        Foo is bla bla.

        ## Install

        ```bash
        brew install foo-qux
        ```

### Frontmatter Şeması

İki seviyeli bir sözlüktür. İlk seviyede platform adları, ikinci seviyede link, copy, paket, level ve opsiyonel host
süzgeci yer alır.

#### İlk Seviye

- Platform adları: `all`, `linux`, `macos`, `windows`.
- İlgili konakta provizyonlama yaparken önce `all` sözlüğü alınır, daha sonra konağın ait olduğu platforma ait sözlük
  tanımlıysa shallow merge uygulanır.
- Merge işleminde `all` ve aktif platform sözlükleri birleştirilir. Değeri sözlük olan anahtarlar shallow merge edilir;
  diğer değer tiplerinde platform değeri `all` değerinin üzerine yazar.
- Shallow merge yalnızca bir seviye derindir. Nested map değerleri deep merge edilmez.
- Örneğin `links` ve `copies` değerleri sözlük olduğu için `all.links` ile `macos.links`, `all.copies` ile
  `macos.copies` shallow merge edilir. Aynı kaynak anahtarı iki tarafta da varsa platformdaki hedef kullanılır.
- `packages` değeri liste olduğu için merge edilmez; platformda `packages` varsa `all.packages` yerine platform listesi
  nihai liste olur.
- `level` değeri scalar olduğu için merge edilmez; platformda `level` varsa `all.level` yerine platform seviyesi
  kullanılır.
- Bir kök modülün frontmatter'ında `all` yoksa ve yalnızca başka platform anahtarları varsa, modül aktif platform bu
  anahtarlardan biri değilse tamamen plan dışı bırakılır. Bu kural README gövdesindeki özel bölümlerin de yanlış
  platformda uygulanmasını engeller.
- Platform anahtarının değeri YAML boş değeri (`~`) olabilir. Bu, o platformda ek frontmatter ayarı olmadığını ama
  modül gövdesindeki talimatların o platform için geçerli olduğunu belirtir. Örneğin `macos: ~`, modülü macOS'ta seçer
  ve gövde özel bölümlerinin macOS'ta uygulanmasına izin verir.

#### İkinci Seviye

**`links`**: Modül dizinine göre relatif kaynaklar ve sembolik linkleneceği hedefler. Kaynaklar normalde modül
dizinindeki dosyalardır; ortak repo-içi kaynaklar için `../` kullanılabilir. Kaynak yolu normalize edildiğinde repo
dışına çıkamaz. Linklemede hedef dizin yoksa önce o oluşturulur.

Kaynak anahtar `/` ile bitmiyorsa kaynak dosya veya dizinin kendisi hedefe sembolik linklenir. Kaynak anahtar `/` ile
bitiyorsa bu bir **fan-in link** tanımıdır: kaynak dizinin kendisi hedefe linklenmez; kaynak dizinin içindeki doğrudan
çocukların her biri hedef dizin altında aynı adla ayrı ayrı linklenir. Örneğin `bin/: ~/.local/bin` girdisi `bin/foo`
dosyasını `~/.local/bin/foo` hedefine, `bin/bar` dosyasını `~/.local/bin/bar` hedefine linkler.

Link hedefinde mevcut dosya, dizin veya symlink varsa yerine modüldeki kaynak bağlanır. Bu davranış bilinçli olarak
agresiftir; hedefte korunması gereken yerel değişiklik varsa provizyonlama öncesinde kullanıcı tarafından ayrıca
korunmalıdır.

**`copies`**: Modül dizinine göre relatif kaynaklar ve fiziksel olarak kopyalanacağı hedefler. Kaynak yolu normalize
edildiğinde repo dışına çıkamaz. Hedefin üst dizini yoksa önce o oluşturulur. Kaynak dizinse recursive copy yapılır.

Copy hedefinde mevcut dosya, dizin veya symlink varsa yerine modüldeki kaynak kopyalanır. Frontmatter'dan çıkarılan copy
hedefleri otomatik kaldırılmaz; kaldırma ancak kullanıcı agent'a açıkça bu yönde talimat verirse ayrı bir işlem olarak
yapılır.

**`packages`**: Paket listesi.

- `[paket-tipi:]paket-adı`

- Değer düz YAML listesidir. Paket tipleri ayrı alt anahtar olarak yazılmaz; örneğin `packages: [gemini-cli]` veya
  `packages: [brew:gemini-cli]` geçerlidir, `packages: {brew: [gemini-cli]}` geçerli değildir.

- Geçerli paket tipleri: `brew`, `cask`, `deb`, `npm`, `gem`, `egg`, `flatpak`, `scoop`, `github`

- Paket tipi verilmemişse öntanımlı paket tipi platforma göre belirlenir: Linux ve macOS için `brew`, Windows için
  `scoop`.

- `deb` kurulumları doğal olarak `sudo` ile sistem geneli yapılır.

- Bunun haricindeki tüm paketler ilgili paket yöneticileriyle "kullanıcı geneli" kurulur.

- `npm` için `bun`, `egg` için `uv` paket yöneticileri tercih edilir.

- `github` paket tipi URL'i verilen bir repo'nun release asset'lerinden ilgili platforma özgü uygulamayı kurar. Paket içinden
  çıkan programlar mutlaka `~/.local/bin` dizinine yerleştirilir.

Bu anahtar mevcut değilse modül sanal modül sayılır ve paket kurulumu yapılmaz. Paket kurulumu istenen modüller
paketleri açıkça listelemelidir. Örneğin `foo` modülü için Linux ve macOS üzerinde `packages: [foo]` ifadesi
`brew:foo`, Windows üzerinde `scoop:foo` anlamına gelir.

Boş paket listesi (`packages: []`) geçerlidir, ancak genellikle gereksizdir; sanal modüllerde `packages` anahtarını
tamamen atlamak tercih edilir.

Paket yönetiminde güvenli varsayılan yalnızca kurulumdur. Frontmatter'dan çıkarılan paketler otomatik kaldırılmaz.
Paket kaldırma ancak kullanıcı agent'a açıkça bu yönde talimat verirse ayrı bir işlem olarak yapılır.

`packages` yalnızca plan-time deklarasyondur. Harness runtime koşul değerlendirmez. Paket kurulumu runtime koşula
bağlıysa paket `packages` altında yer almamalı; `Install` veya `Preinstall` gibi özel README bölümlerinde guarded komut
olarak yazılmalıdır. Bu durumda koşul sağlanmıyorsa komut `exit 0` ile başarılı no-op olabilir.

**`level`**: Modülün provizyonlama kapsam seviyesi.

- Geçerli değerler: `minimal`, `normal`, `extra`.
- Bu anahtar opsiyoneldir. Yokluğu halinde modül `normal` kabul edilir.
- Plan seçimi eşik semantiğiyle yapılır: `minimal` plan yalnızca `minimal`, `normal` plan `minimal` ve `normal`,
  `extra` plan ise üç seviyedeki modülleri de içerir.
- Varsayılan plan seviyesi `normal`dir. Bu nedenle mevcut modüller `level` eklenmeden normal kurulumda yer alır.
- Daha ağır, isteğe bağlı veya kişisel araçlar `level: extra` ile işaretlenebilir. İlk kurulum için gerekli en küçük
  tabana girmesi gereken modüller `level: minimal` ile işaretlenebilir.

**`hosts`**: Host süzgeci, provizyonlamanın yapılacağı host adları.

- Bu adlar `hostname -f` çıktısıyla, sondaki `.*` kısmı çıkarılarak eşleştirilir.
- Bu anahtar opsiyoneldir. Yokluğu halinde konak süzgeci etkin değildir (sadece platform süzgeci etkindir).

### Gövde Talimatları

Gövde metni agent talimatları olarak kullanılır ve dilenilen şekilde doldurulur. Öte yandan bazı bölüm adları
konvansiyonel olarak özeldir. Bu adlar "Provizyonlama" bölümünde dokümante edilmiştir.

Özel başlıklı bölümlerin içeriği agent talimatı olarak yorumlanır. Eğer ilgili özel başlıklı bölüm yalnızca bir dizi
`bash` fenced code block içeriyorsa ve ayrıca açık talimat metni yoksa, bu blokların yazıldıkları sırayla çalıştırılması
gerektiği anlaşılır.

Özel bölümlerin içinde `###` gibi daha alt başlıklar kullanılabilir. Bu alt başlıklar özel bölüm eşleştirmesini
bozmaz; literate provisioning için talimatı gruplandırır. Bu durumda bölüm yalnızca bash block'lardan oluşmadığı için
agent, bölüm metnini de talimat olarak dikkate alır.

Harness özel `Precondition` bölümü, fenced-block metadata veya özel skip exit code yorumlamaz. Runtime guard gerekiyorsa
ilgili fenced block kendi koşulunu sınar. Exit code semantiği sadedir: `0` başarılı veya bilinçli no-op, non-zero hata.

Komut çalıştırma onayla yapılır. Agent, komutları çalıştırmadan önce her komut veya komut grubu için onay ister.
Kullanıcı provizyonlama başlangıcında açıkça toplu onay verirse bu akışta tekrar tekrar onay alınmayabilir.

## Format: State Log

Log dosyası kaynak repo içindeki `.agents/state/hosts/HOST/home.md` lokasyonunda, YAML frontmatter'lı bir Markdown
dosyadır. HOST
`hostname -f` çıktısında sonda `.*` varsa çıkarılarak belirlenir (ör. `kant.local` için `kant`). YAML frontmatter
aşağıdaki anahtarların yer aldığı bir sözlüktür:

- `head`: Provizyonlama yapıldığında repo'nun HEAD komiti, `git rev-parse HEAD` çıktısı.

- `date`: Provizyonlama tarihi, `date --iso-8601=seconds` çıktısı.

- `done`: Provizyonlaması yapılan modül dizinleri sözlüğü. Modüller provizyonlama sırasıyla yer alır ve her
  anahtar 3 değerden birini alabilir. `ok`: provizyonlama başarılı, `notok`: provizyonlama başarısız, `ignored`:
  provizyonlama yapılmadı/yapılmayacak.

`kant` konağında örnek log: `.agents/state/hosts/kant/home.md`

        ---
        head: a10a8ae3db88c91f792b54b76db93dc30e09341e
        date: 2026-05-15T10:00:00+03:00
        done:
          foo: ok
          bar: notok
          baz: ignored
        ---

    Opsiyonel detaylar, ör. `bar` provizyonlanması neden başarısız oldu?

Veri kaybı olmaması için mevcut log dosyası provizyonlama yapılmadan önce yedeklenir. Provizyonlama tamamlandıktan
sonra güncelleme yapılır. `head` değişmeden tekrar tekrar provizyonlama yapılabilir. Bu durumda sadece `notok` durumlu
modüller dikkate alınır, `ok` ve `ignored` durumlu modüller işlenmez.

Log gövdesini kullanmak tamamen opsiyoneldir. Özellikle `notok` durumunu gelecekte çözmek için yararlı olabilecek
detaylar varsa kaydedilir.

### State Kaynağı

- State önce işlemin yürütüldüğü repo kopyasına yazılır. Yerel provizyonlamada bu yerel repo, SSH ile uzak
  provizyonlamada hedef makinedeki repo kopyasıdır.
- Yerel repo pratik state arşividir. Uzak provizyonlama sonunda hedef repo Dropbox ile yerel makineye senkronize
  olmuyorsa, ilgili host state dosyası hedef makineden yerel repo `.agents/state/hosts/HOST/home.md` yoluna geri
  kopyalanır.
- Hedef repo Dropbox altında ise state için ayrıca kopyalama gerekmez; Dropbox senkronizasyonu state'i de taşır.
- Hedef repo Git klonuysa ve `.agents/state` Git ignore nedeniyle taşınmıyorsa bu normaldir. State hedefte üretilir ve
  provizyonlama sonunda yerele alınır.

## Dosya Yerleşimi

- `config: ~/.config/foo/config` gibi bir girdide modül dizinindeki `config` dosyası `~/.config/foo/config` dosyasına
  linklenir. Bu işlem sırasında önce hedefin üst dizini yoksa oluşturulur. Daha sonra kaynak dosya hedefe sembolik
  linkle bağlanır. Hedef zaten varsa önce hedef kaldırılır, sonra link oluşturulur.

- `bin/: ~/.local/bin` gibi kaynak anahtarı `/` ile biten bir girdide modül dizinindeki `bin` dizini hedefe linklenmez.
  Bunun yerine `bin` dizininin içindeki doğrudan çocuklar `~/.local/bin` altında aynı adlarla linklenir.

- `mc.ini: ~/.config/mc/ini` gibi bir `copies` girdisinde modül dizinindeki `mc.ini` dosyası hedefe fiziksel olarak
  kopyalanır. Kaynak dizin ise hedef dizin yeniden oluşturularak recursive copy yapılır.

### Onay Kapsamı

Komut çalıştırma, paket kurulumu, hedef üzerine link yazma, hedefe copy yazma ve link kaldırma onay kapsamındadır.
Kullanıcı provizyonlama başında toplu onay verdiyse bu işlemler için ayrı ayrı onay alınmayabilir.

## Provizyonlama

Provizyonlama aşağıdaki akışa sahip ve genel olarak idempotent olan bir işlemdir. Fakat bu idempotency mutlak değil,
elden geldiğince sağlanan bir özelliktir.

Provizyonlamada bu reponun makinede bulunduğu yer hakkında bir kabul yapılmaz. Linkleme gibi tüm işlemler ilgili dosyanın
bulunduğu yer çalışma zamanında çözülerek gerçekleştirilir. Provizyonlama yerelde (bu dizin içinde) veya uzaktan
yapılabilir. Repo hedef makinede Dropbox gibi bir senkronizasyonla zaten bulunuyorsa bu çalışma kopyası kullanılabilir.
SSH yoluyla uzaktan provizyonlama yapılacaksa agent yerelde çalışabilir, fakat uygulama hedef makinedeki repo kopyası
üzerinden yapılır. Uzak makineye sadece bu reponun klonlandığı durumlarda `~/.home` lokasyonu varsayılır.

### Platform Bootstrapping

Platform bootstrap helper'ı `_/bin/bootstrap` yolunda bulunur. Bu helper, normal provizyonlamanın çalışabilmesi için
gereken en küçük ön hazırlığı yapar: temel transport araçları, Homebrew ve Ruby. Bootstrap Ruby'ye güvenemez; saf Bash
olmalıdır.

`_` support alanı normal plan helper tarafından keşfedilmez, state'e yazılmaz ve normal paket semantiğine dayanmaz.
Bootstrap paket yöneticisinin kendisini kurmakla sorumlu olabileceği için explicit olarak çağrılır ve idempotent olmak
zorundadır.

Linux bootstrap akışı apt tabanlı sistemlerde Homebrew kurulumu için gerekli küçük tabanı (`build-essential`, `curl`,
`file`, `git`, `procps` gibi) sistem paket yöneticisiyle kurar, ardından Homebrew'i kurar ve `curl`, `git`, `ruby`
araçlarını brew üzerinden sağlar.

macOS bootstrap akışı önce Xcode Command Line Tools varlığını kontrol eder, Homebrew'i kurar ve `curl`, `git`, `ruby`
araçlarını brew üzerinden sağlar.

### Remote Provizyonlama

Üç uzak mod vardır:

- `remote-git`: Varsayılan ve deterministik mod. Repo hedef makineye `git clone` ile genellikle `~/.home` olarak
  alınır. Aksi açıkça belirtilmedikçe `main` branch ve son push edilmiş commit kullanılır. Yerel worktree clean olmalı,
  ilgili commit remote'a push edilmiş olmalıdır.
- `remote-dropbox`: Hedef makinede repo Dropbox altında zaten vardır. Bu repo kopyası kullanılır; Git HEAD eşitliği
  zorunlu değildir. State Dropbox ile senkronize olacağı için provisioning sonunda ayrıca state kopyalama gerekmez.
- `remote-any`: Hedefteki repo path'i ne durumdaysa o kullanılır. Git HEAD, branch ve dirty worktree eşitliği
  dayatılmaz. Agent bu modun deterministik olmadığını belirtir ve açık onayla ilerler.

Tüm uzak modlarda link ve copy kaynakları hedef makinedeki repo kopyasından çözülür. Provizyonlama state'i önce hedef
repo kopyasına yazılır. `remote-git` ve senkronize olmayan `remote-any` akışlarında son çıkış kontrolü olarak hedefteki
state dosyası yerel repo state arşivine geri kopyalanır.

### Kipler

Provizyonlama harness'ı dört kipte yorumlanır:

- `apply`: Repo tanımını hedef host'a uygular. İlk kurulum ve `HEAD`/state temelli olağan yeniden provizyonlama bu
  kiptir.
- `refresh`: Sadece bu repo tarafından yönetilen dış kaynakları tazeler. Managed paket update komutları ve
  `README.md` içindeki `Update` bölümleri bu kipte çalışır. `HEAD` değişmemiş olsa bile çalışabilir.
- `repair`: Aynı `HEAD` altında state'te `notok` kalan modülleri tekrar dener. Paketleri global olarak güncellemez;
  başarısız provisioning adımlarını yeniden dener.
- `upgrade`: Paket yöneticisi genelindeki geniş kapsamlı güncelleme kipidir. Repo dışı paketleri de etkileyebileceği
  için yalnızca açık kullanıcı isteğiyle ve etki alanı belirtilerek yapılır.

`apply` ve `repair` state/HEAD temellidir. `refresh` ve `upgrade` dış kaynak/zaman temellidir; sırf `head` aynı diye
atlanmazlar.

### Init

- Güncel state'i log dosyasından oku. State'in olmaması bunun yeni bir kurulum olduğunu gösterir.

- Repo `HEAD`'i ile güncel `head` değerini karşılaştır ve değişen modül dizinlerini belirle.

- Provizyonlama yapmayı gerektiren değişiklikleri not et. Örneğin çoğunlukla sadece `README.md` frontmatter'ındaki
  değişiklikler provizyonlama gerektirir. Modül dizinindeki dosyalarda yapılan değişiklikler, bu dosyalar zaten
  linklenmiş ise provizyonlama gerektirmez.

- Değişen her modül için aşağıda açıklanan provizyonlama adımlarını icra et.

### Traverse

- Daima önce geçerli platform modülünden başla.
- Geçerli platform dizini altında modül dizinleri varsa bunları kök modüllerden önce alfabetik sırayla işle.

- Modül dizinine girerek `README.md` dosyasını oku ve provizyonlama sözlüğünü yükle. Bu yüklemede `all` ve varsa platforma
  ait sözlükler birleştirilir.

- `HEAD`, `head` farkını yorumlayarak provizyonlama sözlüğünü güncelle. Eklenen paketler, eklenen/çıkartılan linkler ve
  eklenen copy girdilerini dikkate alarak aktif provizyonlama sözlüğünü oluştur. Çıkartılan paketler ve copy girdileri
  otomatik kaldırma nedeni değildir.

- `apply` kipinde aktif provizyonlama sözlüğünü kullanarak sırasıyla `Install` ve `Link` aşamalarını icra et.
- `refresh` kipinde paketleri ve varsa `Update` başlıklarını, yalnızca managed kapsamda tazele.
- `repair` kipinde aynı `HEAD` altında `notok` durumlu modülleri tekrar dene.
- `upgrade` kipinde paket yöneticisi genelindeki güncellemeleri sadece açık onayla yap.

- Güncel durumu kaydet.

### Sıralama

- `_` altındaki geçerli platform modülü her zaman önce uygulanır.
- `_/<platform>/` altındaki platforma özel modüller kök modüllerden önce alfabetik sırayla uygulanır.
- Diğer kök modüller dizin adına göre alfabetik sırayla uygulanır.
- Gelecekte modül frontmatter'ına `order` anahtarı eklenebilir. Bu durumda `order` sayısal weight gibi yorumlanır;
  `order` belirtilmeyen modüller varsayılan weight değeriyle sıralanır. Weight eşitliğinde alfabetik sıra korunur.

#### Install

- Varsa `README.md`'de "Preinstall" başlığında belirtilen işlemleri yap.

- Aktif provizyonlama sözlüğünde kayıtlı eklenen paketleri paket tipini dikkate alarak kur. Frontmatter'dan çıkarılan
  paketleri kaldırma.

- Varsa `README.md` dosyasında `Install` veya `Postinstall` başlığında belirtilen işlemleri yap.

#### Link

- Varsa `README.md`'de "Prelink" veya "Presetup" başlığında belirtilen işlemleri yap.

- Aktif provizyonlama sözlüğünde kayıtlı eklenen linkleri sembolik linkle hedefe bağla.
- Aktif provizyonlama sözlüğünde kayıtlı copy girdilerini hedefe fiziksel olarak kopyala.
- Çıkarılan linkler yalnızca hedef bu repo içindeki bir dosyaya/dizine giden symlink ise kaldırılır. Hedef dangling
  symlink ise her zaman kaldırılır. Hedef symlink değilse veya bu repo dışına gidiyorsa dokunulmaz.
- Çıkarılan copy hedeflerine otomatik dokunulmaz.

- Varsa `README.md`'de "Link" veya "Postlink" veya "Setup" başlığında belirtilen işlemleri yap.

#### Update

- Varsa `README.md`'de "Update" başlığında belirtilen işlemleri `refresh` veya açıkça istenen `upgrade` kipinde yap.
  Bu bölüm normal `apply` sırasında kendiliğinden çalıştırılmaz.
