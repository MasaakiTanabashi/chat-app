require 'rails_helper'

RSpec.describe "ユーザーログイン機能", type: :system do
  it 'ログインしていない場合、サインページに移動する' do
    # トップページに遷移させる
    visit root_path

    # ログインしていない場合、サインインページに遷移することを期待する
    expect(current_path).to eq new_user_session_path
  end

  it 'ログインに成功し、ルートパスに遷移する' do
    # 予め、ユーザーをDBに保存する
     @user = FactoryBot.create(:user)
 
     # サインインページへ移動する
     visit  new_user_session_path
 
     # ログインしていない場合、サインインページに遷移することを期待する
     expect(current_path).to eq new_user_session_path
 
     # すでに保存されているユーザーのnameとemailを入力する
     fill_in 'user_email', with: @user.email
     fill_in 'user_password', with: @user.password
 
     # ログインボタンをクリックする
     click_on("Log in")
 
     # ルートページに遷移することを期待する
     expect(current_path).to eq root_path
   end

   it '送る値が空の為、メッセージの送信に失敗すること' do
    # サインインする
    sign_in(@room_user.user)

    # 作成されたチャットルームへ遷移する
    click_on(@room_user.room.name)

    # DBに保存されていないことを期待する
    expect{
      find('input[name="commit"]').click
    }.not_to change { Message.count }

    # 元のページに戻ってくることを期待する
    expect(current_path).to eq  room_messages_path(@room_user.room.id)
  end
end
