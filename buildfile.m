function buildfile(action)
% BUILDFILE CI環境向けのシンプルなビルドヘルパー
%
% 使い方:
%   buildfile("run")   - テストを実行し、失敗した場合は非ゼロの終了コード（エラー）を返す
%   buildfile("clean") - 生成された成果物（build-output）を削除する
%
% 引数なしで実行した場合は、デフォルトで "run" が実行されます。


% プロジェクトがロードされていない場合はロードする（後から追加した）
proj = matlab.project.currentProject;
if isempty(proj)
    % 現在のフォルダに .prj がある前提
    proj = matlab.project.loadProject(pwd);
end

if nargin == 0
    action = "run"; % 引数がない場合のデフォルトアクション
end

switch string(action)
    case "run"
        % ユニットテストに必要なクラスをインポート
        import matlab.unittest.TestRunner
        import matlab.unittest.TestSuite
        import matlab.unittest.plugins.XMLPlugin
        % HTMLレポートプラグインのインポート（後から追加した）
        import matlab.unittest.plugins.TestReportPlugin


        % buildfile tests フォルダ内実行結果出力用ディレクトリの作成
        outDir = fullfile(pwd, "run_buildfile_results");
        if ~exist(outDir, 'dir')
            mkdir(outDir); 
        end

        % 1. テストスイートの作成（tests フォルダ内のサブフォルダも含むすべてを対象）
        suite = TestSuite.fromFolder("tests", 'IncludingSubfolders', true);

        % 2. テストランナーの設定
        runner = TestRunner.withTextOutput;

        % HTML 形式ファイル... (runner設定のあたりで) ...
        htmlFile = fullfile(outDir, "test_report.html");
        runner.addPlugin(TestReportPlugin.producingHTML(htmlFile));

        % 3. CI/CDツール連携用：JUnit形式のXMLレポート出力設定
        % GitHub Actions 等のツールがテスト結果をブラウザで表示するために利用します
        junitFile = fullfile(outDir, "junit.xml");
        runner.addPlugin(XMLPlugin.producingJUnitFormat(junitFile));

        % 4. テストの実行
        results = runner.run(suite);

        % 5. 人間が読める簡易サマリー（テキストファイル）の保存
        summaryFile = fullfile(outDir, "summary.txt");
        fid = fopen(summaryFile, 'w');
        if fid ~= -1
            fprintf(fid, "Passed: %d\nFailed: %d\n\n", sum([results.Passed]), sum([results.Failed]));
            fclose(fid);
        end

        % 6. エラー判定：テストが1つでも失敗していれば、エラーを投げてプロセスを中断
        if any([results.Failed])
            error("ユニットテストに失敗したため、ビルドを中断します。");
        end

    case "clean"
        % 生成された成果物ディレクトリの削除
        outDir = fullfile(pwd, "run_buildfile_results");

        if isfolder(outDir)
            try
                rmdir(outDir, 's'); % フォルダとその中身をすべて削除
                fprintf("成果物フォルダを削除しました。\n");
            catch
                warning("build-output の削除に失敗しました（ファイルが使用中の可能性があります）。");
            end
        end
        fprintf("Clean 処理が完了しました。\n");

    otherwise
        % 想定外のアクションが指定された場合のエラー
        error("不明なアクションです: %s (run または clean を指定してください)", action);
end
end