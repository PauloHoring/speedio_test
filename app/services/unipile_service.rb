# frozen_string_literal: true

class UnipileService
  include HTTParty
  base_uri ENV['UNIPILE_API_URL']

  class << self
    def request_configuration_link(current_user)
      unipile_api_key = ENV['UNIPILE_API_KEY']
      unipile_api_url = ENV['UNIPILE_API_URL']

      response = HTTParty.post(
        "#{unipile_api_url}/api/v1/hosted/accounts/link",
        headers: {
          'X-API-KEY' => unipile_api_key,
          'Content-Type' => 'application/json',
          'Accept' => 'application/json'
        },
        body: {
          type: 'create',
          providers: '*',
          api_url: unipile_api_url,
          expiresOn: (Time.now + 1.year).strftime('%Y-%m-%dT%H:%M:%S.%3NZ'),
          name: current_user.to_s
        }.to_json
      )

      response.success? ? response['url'] : nil
    end

    def send_linkedin_connection(account_id, public_identifier)
      public_id = extract_linkedin_identifier(public_identifier)

      provider_id = get_provider_id(account_id, public_id)

      body = {
        provider_id: provider_id,
        account_id: account_id
      }

      post('/api/v1/users/invite', headers: headers, body: body.to_json)
    end

    def send_linkedin_message(account_id, public_identifier, message)
      public_id = extract_linkedin_identifier(public_identifier)
      provider_id = get_provider_id(account_id, public_id)

      body = {
        attendees_ids: [provider_id],
        account_id: account_id,
        text: message
      }

      post('/api/v1/chats', headers: headers, multipart: true, body: body.to_json)
    end

    def send_email(account_id, to, body)
      post('/api/v1/emails',
           headers: headers,
           multipart: true,
           body: {
             account_id: account_id,
             body: body,
             to: [{ display_name: to, identifier: to }].to_json
           })
    end

    def headers
      {
        'Accept' => 'application/json',
        'Content-Type' => 'application/json',
        'X-API-KEY' => ENV['UNIPILE_API_KEY']
      }
    end

    def get_provider_id(account_id, public_identifier)
      response = get("/api/v1/users/#{public_identifier}",
                     headers: headers,
                     query: { account_id: account_id })

      raise "Failed to retrieve provider_id: #{response.code} - #{response.body}" unless response.success?

      response.parsed_response['provider_id']
    end

    def extract_linkedin_identifier(url)
      match = url.match(%r{linkedin\.com/in/([^/]+)})
      match ? match[1] : nil
    end
  end
end
