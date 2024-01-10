class LineEventsController < ApplicationController
    require 'line/bot'
    skip_before_action :require_login
  protect_from_forgery

    # skip_before_action :verify_authenticity_token, only: :receive

  
    def client
      @client ||= Line::Bot::Client.new { |config|
        config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
        config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
      }
    end
  
    def receive
      body = request.body.read
      events = client.parse_events_from(body)
    #   events.each { |event|
    #     userId = event['source']['userId']  #userId取得
    #     p 'UserID: ' + userId # UserIdを確認
    #   }
      events.each do |event|
        if event['type'] == 'follow'
            # p '成功'
        end
      end
    #   events.each { |event|
    #   userId = event['source']['userId']  #userId取得
    #   p 'UserID: ' + userId # UserIdを確認
    #   if event == Line::Bot::Event::Follow
    #     userId = event['source']['userId']
    #     p 'UserIDの確認: ' + userId # UserIdを確認
    #   end
    # }
    # events.each do |event|
    #     if event.is_a?(Line::Bot::Event::Message) && event.type == Line::Bot::Event::MessageType::Text
    #       user_id = event['source']['userId']
    #       message_text = event['message']['text']
    
    #       # ユーザーに同じメッセージを返信する例
    #       client.reply_message(event['replyToken'], { type: 'text', text: "Received: #{message_text}" })
    
    #       # 特定のユーザーに直接メッセージを送信する例
    #       client.push_message(user_id, { type: 'text', text: 'Hello from the bot!' })
    #     end
    #   end
    
    #   head :ok
    end
  end