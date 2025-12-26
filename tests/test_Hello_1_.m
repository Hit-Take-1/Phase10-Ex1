% test_Hello_ クラスの定義
% matlab.unittest.TestCase を継承することで、ユニットテストの機能を利用可能にします
classdef test_Hello_1_ < matlab.unittest.TestCase
    
    % テストメソッドのブロック
    methods(Test)
        
        % テストケース1: 正常な入力に対する挙動の確認
        function testGreeting(tc)
            % hello("World") の戻り値が "Hello, World!" と一致するかを検証します
            % tc.verifyEqual(実測値, 期待値)
            tc.verifyEqual(hello("World"), "Hello,  World ! ");
        end
        
        % テストケース2: 不適切な入力（入力バリデーション）の確認
        function testArgValidation(tc)
            % hello([]) のように空の配列を渡した際、期待したエラーが発生するかを検証します
            % ※ エラーID "MATLAB:unassignedOutputs" は環境や実装により異なる場合があります
            
            %tc.verifyError(@() hello([]), "MATLAB:unassignedOutputs");
            tc.verifyError(@() hello([]), "MATLAB:validators:mustBeTextScalar");
        end
        
    end
end