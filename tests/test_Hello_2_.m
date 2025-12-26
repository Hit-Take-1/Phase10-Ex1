% CI/CD（GitHub Actionsなど）での自動化
% もし「Git上での確認」をより自動化したい場合、GitHub Actions を使うと便利です。 
% MATLAB公式が提供している matlab-actions/run-tests を利用すると、
% コードを push するたびに自動でテストが走り、以下のような形式で結果が表示されます。
%
% JUnit形式のXMLを書き出す。
%
% GitHub ActionsがそのXMLを読み取り、ブラウザ上の「Checks」タブに「✅ Test Passed」と表示する。
%
classdef test_Hello_2_ < matlab.unittest.TestCase
    methods(Test)
        function testGreeting(tc)
            % 期待値を修正（タイポと重複を除去）
            tc.verifyEqual(hello("World"), "Hello,  World ! ");
        end

        function testArgValidation(tc)
            % 入力バリデーションのテスト
            % hello([]) のように空の配列を渡した際、期待したエラーが発生するかを検証します
            % ※ エラーID "MATLAB:unassignedOutputs" は環境や実装により異なる場合があります

            % tc.verifyError(@() hello([]), "MATLAB:unassignedOutputs");
            tc.verifyError(@() hello([]), "MATLAB:validators:mustBeTextScalar");

        end
    end
end