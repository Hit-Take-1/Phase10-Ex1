Example 1 — MATLAB Project + Git minimal template

How to use:
1. (Optional) Create/open project in MATLAB:
proj = matlab.project.createProject(pwd);
Save project to generate a proper project.prj if desired.

2. Run tests locally:
matlab -batch "buildfile('run')"

3. CI workflow provided in .github/workflows/matlab-ci.yml


```
ProjectRoot/
├── .github/                    # GitHub Actions 関連の設定
│   └── workflows/
│       └── matlab_ci.yml       # CI 実行の定義
├── src/                        # 製品ソースコード
│   └── hello.m                 # メインの関数やクラス
├── tests/                      # テストコード
│   └── test_Hello_.m           # テストクラス
├── doc/                        # ドキュメント専用フォルダ
├── .gitignore                  # Git 管理対象外の設定
├── buildfile.m                 # 【重要】ビルド・テストの司令塔スクリプト
└── README.md                   # Read me
```

