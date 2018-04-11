module Dollarbird
  class Account
    attr_reader :username,
      :password

    def initialize(username, password)
      @username = username
      @password = password
    end

    def authentication_token
      sign_in_response = ::HttpClient.new(
        "https://api.dollarbird.co/v1/sign-in"
      ).post do |req|
        req['Accept'] = "application/json"
        req['Content-Type'] = "application/json;charset=UTF-8"

        req.body = authentication_payload.to_json
        req
      end

      parsed_authentication_response = JSON.parse(
        sign_in_response.body
      )

      parsed_authentication_response["token"]
    rescue
      ""
    end

    private

    def authentication_payload
      {
        "identity" => username,
        "password" => password
      }
    end
  end
end