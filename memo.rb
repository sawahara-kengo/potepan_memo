#キーワード
#1) gets メソッド
#2) readlines メソッド
#3) RubyでのCSVファイルの書き出し

# 【 CSV.open("sample.csv","w") do |csv| 】
#                         ┗ "w":ファイルを書き込みモードで開く(すでにファイルが存在する場合は書き換え(上書き))
#                         ┗ "a":ファイルを書き込みモードで開く(すでにファイルが存在する場合は末尾に出力(追記))
#                         ┗ "wb": "w"指定時の動作 + 改行コードLF(lineFeed)(\n)をそのまま書き込む


require "csv" # CSVファイルを扱うためのライブラリを読み込んでいます
    
    puts "行いたい操作に対応する数字を半角で入力してください"
    puts "1 → 新規でメモを作成する / 2 → 既存のメモを編集する"
    #入力があるまで待機
    memo_type = gets.to_i # ユーザーの入力値を取得し、数字へ変換しています

    # if文を使用して続きを作成していきましょう。
    # 「memo_type」の値（1 or 2）によって処理を分岐させていきましょう。

    if memo_type == 1 # 1が入力された時:新規作成
        puts "新規作成：設定したいファイル名を拡張子を除いて入力してください。"
        #入力があるまで待機
        file_name = gets.chomp #.chompで文字列の末尾にある改行文字を除去

        puts "メモしたい内容を入力してください。[Enter]で改行ができます。"
        puts "入力が済んだら、[Enter]を押した後に[Ctrl + D]を押してください。"
        #入力があるまで待機

        begin
            standard_input = STDIN.read #standard_input(標準入力)で入力内容を読み込み　readlinesは複数行を配列として読み込んでしまうため今回はread(文字列)で読み込み
            body = standard_input.chomp #改行文字を除去
            
            CSV.open("#{file_name}.csv","w") do |csv| #ブロック内の|csv|オブジェクトを通じてCSVデータを操作 今回はファイルの書き込み(w)
            csv.puts ["#{body}"] #作成したファイルにbodyを書き込み

            #ユーザーに処理された内容を表示
            puts "以下の内容でファイルが保存されました"
            puts "----------------------------"
            puts "【ファイル名】#{file_name}"
            puts "【メモの内容】"
            puts body
            puts "----------------------------"

        rescue => e
            #エラー時
            puts "メモが作成できませんでした"
            puts "エラー内容：#{e.message}"
            puts "エラー箇所：#{e.backtrace.join("\n")}"
        end
    end
    elsif memo_type == 2 # 2が入力された時
        puts "内容編集：メモを編集したいファイル名を拡張子を除いて入力してください"
        #入力があるまで待機
        trim_target = gets.chomp

        begin
            trim_file = CSV.read("#{trim_target}.csv") #対象のファイル名に一致するcsvファイル全体を読み込む
        rescue => e
            #エラー時
            puts "該当するファイルが見つかりませんでした"
            puts "エラー内容：#{e.message}"
        else
            puts "以下のファイルを編集します"
            puts "----------------------------"
            puts "【ファイル名】#{trim_target}"
            puts trim_file
            puts "----------------------------"
            puts "編集したい内容を入力してください(メモの内容が上書きされます)。"
            puts "入力が済んだら、[Enter]を押した後に[Ctrl + D]を押してください。"
            #入力があるまで待機

            begin
                trim_text = STDIN.read
                trim_body = trim_text.chomp
            
                CSV.open("#{trim_target}.csv","w") do |csv| #"a"だと追記になってしまうため"w"(上書き)を指定
                csv.puts ["#{trim_body}"]

                #ユーザーに処理された内容を表示
                puts "以下の内容でファイルが保存されました"
                puts "----------------------------"
                puts "【ファイル名】#{trim_target}"
                puts "【メモの内容】"
                puts trim_body
                puts "----------------------------"

            rescue => e
                #エラー時
                puts "編集を反映できませんでした"
                puts "エラー内容：#{e.message}"
                puts "エラー箇所：#{e.backtrace.join("\n")}"
            end
        end
    end
    else #1,2以外が入力された時
        puts "1,2のどちらかを半角数字で入力してください"
    end
