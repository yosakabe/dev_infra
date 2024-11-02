# ローカル開発環境構築：TeX環境

## TeXLiveのインストール
texliveを使いましょう。

- ネットワークインストーラは失敗しやすいので、ISOイメージからビルドが推奨。
- texWikiからWindows用のインストール解説を読み、最新の作法を確認すること。
    - [TeXWiki | https://texwiki.texjp.org/?TeX Live%2FWindows#zc468876](https://texwiki.texjp.org/?TeX Live%2FWindows#zc468876)
- [Acquiring TeX Live as an ISO image](http://www.tug.org/texlive/acquire-iso.html)から ISO イメージがダウンロードできる。
    - `download from a nearby CTAN mirror`から、`texlive2022.iso`をダウンロード
- Windows 10, Windows 8.1 では基本機能で ISO イメージの中身を見ることが可能
- ダブルクリックすると BD-ROM/DVD-ROM ドライブとしてマウントされる
- 中の`install-tl-windows.bat`をダブルクリックで起動
    - ウィザードが立ち上がってインストールできる
    - 設定は特にいじらなくてもよい（いじらない方がよい）

## SublimeText + SumatraPDF 執筆環境構築

### SublimeText3でのLaTeXビルド環境構築
1. SublimeText3を起動し、`LaTeXtools`をインストール
- Sublimeのメニュー`[Preferences]->[Package Settings]->[LaTeXTools]->[Settings-User]`を選択
- `LaTeXTools.sublime-settings`の`builder_settings`の部分を下記のように編集

```js
"builder_settings" : {
    // General settings:
    // See README or third-party documentation

    "command" : ["latexmk", "-cd",
            "-e", "$latex = 'platex %O -no-guess-input-enc -kanji=utf8 -interaction=nonstopmode -synctex=1 %S'",
            "-e", "$biber = 'biber %O --bblencoding=utf8 -u -U --output_safechars %B'",
            "-e", "$bibtex = 'pbibtex %O %B -kanji=utf8'",
            "-e", "$makeindex = 'upmendex %O -o %D %S'",
            "-e", "$dvipdf = 'dvipdfmx %O -o %D %S'",
            "-f", "-%E", "-norc", "-gg", "-pdfdvi"],
    
    // (built-ins): true shows the log of each command in the output panel
    "display_log" : false,
    
    // Platform-specific settings:
    "osx" : {
        // See README or third-party documentation
    },
    
    "windows" : {
        // See README or third-party documentation
    },
    
    "linux" : {
        // See README or third-party documentation
    }
},
```

- 適当なTeXテンプレートをビルドしてみて、SumatraPDFが起動すればOK
- そうしてSumatraPDFが起動すると、逆順検索コマンドを設定するオプションがあらわれる。

### SumatraPDFの逆順検索コマンド設定
- 上記の通り、一回ビルドしないとコマンド設定用のオプション画面があらわれないので注意
- Sumatra PDFの`メニュー＞[設定]＞[オプション]＞[逆順検索コマンドラインの設定]`を開く
- `"${sublime_path}\sublime_text.exe" "%f:%l"`と設定
    - ※ダブルクオーテーション込みで。

### トラブルシューティング
#### ビルドするたびに新しい空ウィンドウが開いてしまう問題
- 対応するイシューがあった：https://github.com/SublimeText/LaTeXTools/issues/1530
- sumatraPDFのPATHをフルパスで記述する
- `"sublime_executable": "subl.exe",` と設定すると、空ウィンドウが開くのを回避できる。

```js
"windows": {
    // Path used when invoking tex & friends; "" is fine for MiKTeX
    // For TeXlive 2011 (or other years) use
    // "texpath" : "C:\\texlive\\2011\\bin\\win32;$PATH",
    "texpath" : "",
    // TeX distro: "miktex" or "texlive"
    "distro" : "miktex",
    // Command to invoke Sumatra. If blank, "SumatraPDF.exe" is used (it has to be on your PATH)
    "sumatra": "C:\\Users\\[USERNAME]\\AppData\\Local\\SumatraPDF\\SumatraPDF.exe",
    // Command to invoke Sublime Text. Used if the keep_focus toggle is true.
    // If blank, "subl.exe" or "sublime_text.exe" will be used.
    "sublime_executable": "subl.exe",
    // how long (in seconds) to wait after the jump_to_pdf command completes
    // before switching focus back to Sublime Text. This may need to be
    // adjusted depending on your machine and configuration.
    "keep_focus_delay": 0.5
},
```
    
#### sumatraPDFの逆順検索をすると新しいWindowが開いてしまう問題
- 設定＞詳細設定　をクリックすると、メモ帳が起動してオプション入力画面が開く
- そこで以下の項目を設定する

```txt
ReuseInstance = true
ReloadModifiedDocuments = true
InverseSearchCmdLine = "<path>\sublime_text.exe" "%f:%l"
EnableTeXEnhancements = true
UseTabs = true
```


参考：
```txt
Use any simple.TeX Ctrl+Shift+P (Build)
SumatraPDF should have fired up with the compiled PDF
Go To Settings > Advanced Options
and going down the entries check or change the following
ReuseInstance = true
ReloadModifiedDocuments = true
InverseSearchCmdLine = "C:\Program Files\Sublime Text 3\sublime_text.exe" "%f:%l"
EnableTeXEnhancements = true
UseTabs = true
In SumatraPDF Settings > Advanced options there are other settings for color of forward search highlight etc. I recommend you set HighlightPermanent = true
DONT FORGET TO CTRL+S (File Save)
Now a double click in the PDF should take you back to Sublime Text either in an included file or the main file. IF not, check the syntax of the InverseSearchCmdLine = matches YOUR location for sublime_text.exe
Be aware in some languages the path may be translated from a different localised one.
If you have a whatever.pdf, whatever.synctex(.gz) and whatever.tex file in the same folder then you can start by opening the PDF and a double click anywhere will open the tex editor with the cursor at the right file position even if the editor was not started first.
If the file keeps opening a fresh tex file then one or more of the following needs fixing
1) The path to sublime is incorrect
2) The synctex file is incorrect (check the synctex file time is the same as the PDF)
3) The editor is not set correctly so as to reopen the focused file.
There are several settings in Sublime LaTeX that can change behaviour for one affecting focus control see SumatraPDF automatically returns to Sublime Text 3
If you are still having problems with LaTeXTools you need to raise them at  https://github.com/SublimeText/LaTeXTools
```

[参考リンク | https://tex.stackexchange.com/questions/460971/sumatra-inverse-search-open-new-window-in-sublime](https://tex.stackexchange.com/questions/460971/sumatra-inverse-search-open-new-window-in-sublime)
    
    


## VSCodeでのLaTeXビルド環境構築
- ホームディレクトリに空白のファイルを作成、「.latexkmrc.」でファイル名指定すると「.latexmkrc」ができる。
- エディタで開いて次の内容を入力

```perl
#!/usr/bin/env perl

$latex            = 'platex -synctex=1 -halt-on-error';
$latex_silent     = 'platex -synctex=1 -halt-on-error -interaction=batchmode';
$bibtex           = 'pbibtex %O %B';
$dvipdf           = 'dvipdfmx %O -o %D %S';
$makeindex        = 'mendex %O -o %D %S';
$max_repeat       = 5;
$pdf_mode   = 3;
$pvc_view_file_via_temporary = 0;
```


参考）LaTeX Workshop を使いこなす - Qiita
- 拡張機能をVSCodeに「LaTeX Workshop」をインストール
- Ctrl+Shift+Pでコマンドパレットを開き、「Preferences: Open User Settings (JSON)」を選択
- 開いたJSONに追記するかたちで、次の項目を書き加える。
- Ctrl＋Sを押すとレンダリングが実行されるようになる。

```js
{
    // ---------- Language ----------
    "[tex]": {
        // スニペット補完中にも補完を使えるようにする
        "editor.suggest.snippetsPreventQuickSuggestions": false,
        // インデント幅を2にする
        "editor.tabSize": 2
    },
    "[latex]": {
        // スニペット補完中にも補完を使えるようにする
        "editor.suggest.snippetsPreventQuickSuggestions": false,
        // インデント幅を2にする
        "editor.tabSize": 2
    },
    "[bibtex]": {
        // インデント幅を2にする
        "editor.tabSize": 2
    },
    // ---------- LaTeX Workshop ----------
    // 使用パッケージのコマンドや環境の補完を有効にする
    "latex-workshop.intellisense.package.enabled": true,
    // 生成ファイルを削除するときに対象とするファイル
    // デフォルト値に "*.synctex.gz" を追加
    "latex-workshop.latex.clean.fileTypes": [
        "*.aux",
        "*.bbl",
        "*.blg",
        "*.idx",
        "*.ind",
        "*.lof",
        "*.lot",
        "*.out",
        "*.toc",
        "*.acn",
        "*.acr",
        "*.alg",
        "*.glg",
        "*.glo",
        "*.gls",
        "*.ist",
        "*.fls",
        "*.log",
        "*.fdb_latexmk",
        "*.snm",
        "*.nav",
        "*.dvi",
        "*.synctex.gz"
    ],
    // 生成ファイルを "out" ディレクトリに吐き出す
    "latex-workshop.latex.outDir": "out",
    // ビルドのレシピ
    "latex-workshop.latex.recipes": [
        {
            "name": "latexmk",
            "tools": [
                "latexmk"
            ]
        },
    ],
    // ビルドのレシピに使われるパーツ
    "latex-workshop.latex.tools": [
        {
            "name": "latexmk",
            "command": "latexmk",
            "args": [
                "-silent",
                "-outdir=%OUTDIR%",
                "%DOC%"
            ],
        },
    ],
}
```

[参考リンク | https://wanttobenya-n.hatenadiary.jp/entry/2022/07/20/220844](https://wanttobenya-n.hatenadiary.jp/entry/2022/07/20/220844)

- したがって、この時点での「C:\Users\[USERNAME]\AppData\Roaming\Code\User\settings.json」は、次のようになっている。

```js
{
    "workbench.colorTheme": "GitHub Dark",
    "workbench.iconTheme": "material-icon-theme",
    "remote.SSH.remotePlatform": {
        "Galvani_10.232.149.56": "linux"
    },
    "[python]": {
        "editor.formatOnType": true
    },
    // ここから加筆したブロック
    // ---------- Language ----------
    "[tex]": {
        // スニペット補完中にも補完を使えるようにする
        "editor.suggest.snippetsPreventQuickSuggestions": false,
        // インデント幅を2にする
        "editor.tabSize": 2
    },
    "[latex]": {
        // スニペット補完中にも補完を使えるようにする
        "editor.suggest.snippetsPreventQuickSuggestions": false,
        // インデント幅を2にする
        "editor.tabSize": 2
    },
    "[bibtex]": {
        // インデント幅を2にする
        "editor.tabSize": 2
    },
    // ---------- LaTeX Workshop ----------
    // 使用パッケージのコマンドや環境の補完を有効にする
    "latex-workshop.intellisense.package.enabled": true,
    // 生成ファイルを削除するときに対象とするファイル
    // デフォルト値に "*.synctex.gz" を追加
    "latex-workshop.latex.clean.fileTypes": [
        "*.aux",
        "*.bbl",
        "*.blg",
        "*.idx",
        "*.ind",
        "*.lof",
        "*.lot",
        "*.out",
        "*.toc",
        "*.acn",
        "*.acr",
        "*.alg",
        "*.glg",
        "*.glo",
        "*.gls",
        "*.ist",
        "*.fls",
        "*.log",
        "*.fdb_latexmk",
        "*.snm",
        "*.nav",
        "*.dvi",
        "*.synctex.gz"
    ],
    // 生成ファイルを "out" ディレクトリに吐き出す
    "latex-workshop.latex.outDir": "out",
    // ビルドのレシピ
    "latex-workshop.latex.recipes": [
        {
            "name": "latexmk",
            "tools": [
                "latexmk"
            ]
        },
    ],
    // ビルドのレシピに使われるパーツ
    "latex-workshop.latex.tools": [
        {
            "name": "latexmk",
            "command": "latexmk",
            "args": [
                "-silent",
                "-outdir=%OUTDIR%",
                "%DOC%"
            ],
        },
    ],
}
```


以上。
