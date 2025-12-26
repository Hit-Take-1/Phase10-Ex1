% run_tests.m
% このスクリプトは tests フォルダに配置してください。
% 役割: フォルダ内のテスト自動検出、実行、および Git 表示用 HTML レポートの生成
%
% このスクリプトは、tests フォルダ内に配置して実行することを想定しており、同じフォルダ内のテストを自動検出して実行します。
%


% GitHub Actions の matlab-actions/run-tests を利用する場合、
% この run_tests.m を用意しなくても自動でテストを実行してくれる機能があります。
%
% 自動実行（Actionの標準機能）: リポジトリ内の tests フォルダにある TestCase クラスを自動検出し、実行します。
%
% この場合、JUnit XML などのレポートも Action 側がオプションで生成してくれます。
% 
% 独自の run_tests.m を使う理由: 
% 「特定の HTML フォーマットにこだわりたい」
% 「テスト前後で特殊な環境構築（DB接続など）が必要」
% といった場合には、Action から run_tests.m を呼び出す形をあえて取ります。
%

% 運用のアドバイス
% Gitへのコミット: 生成された test_results.html を Git にコミットして push すれば、GitHub Actions 等を使わなくても、
% リポジトリ内のファイルをブラウザで開く（あるいはダウンロードして開く）ことで結果を確認できます。
% 
% GitHub Actions との組み合わせ: 
% 将来的に自動化（CI）を行う場合は、この run_tests.m を呼び出すように設定ファイル（YAML）に記述するだけで、
% 全く同じ形式のレポートを自動生成し続けることができます。
%

%% 1. テストスイートの作成
% pwd (現在のフォルダ) 内にあるすべての TestCase クラスを自動的に検出します
suite = testsuite(pwd);

%% 2. テストランナーの構成
% テキスト出力を備えたランナーを作成
runner = matlab.unittest.TestRunner.withTextOutput;

%% 3. HTMLレポート出力プラグインの追加
% 出力ファイル名
reportFile = 'test_results.html';

% HTMLレポートプラグインの設定
% タイトルや合格したテストの含めるかどうかを指定できます
plugin = matlab.unittest.plugins.TestReportPlugin.producingHTML(reportFile, ...
    'Title', ['Test Report: ' char(datetime('now'))], ...
    'IncludingPassedTests', true, ...
    'IncludingOutput', true);

runner.addPlugin(plugin);

%% 4. テストの実行
% 検出されたすべてのテストを実行し、結果を変数に格納
results = runner.run(suite);

%% 5. 結果の表示（MATLABコマンドウィンドウ用）
% 簡易的な結果テーブルを表示
disp('--- テスト実行結果サマリー ---');
disp(table(results));

% もし失敗があった場合に、わかりやすく通知
if any([results.Failed])
    warning('いくつかのテストが失敗しました。詳細は %s を確認してください。', reportFile);
else
    fprintf('すべてのテストが正常に完了しました。レポート: %s\n', reportFile);
end