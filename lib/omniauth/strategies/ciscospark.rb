require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Ciscospark < OmniAuth::Strategies::OAuth2
      # Give your strategy a name.
      option :name, "ciscospark"

      # This is where you pass the options you would pass when
      # initializing your consumer from the OAuth gem.
      option :client_options, {
        :site          => 'https://api.ciscospark.com',
        :authorize_url => '/v1/authorize',
        :token_url     => '/v1/access_token'
      }
      option :provider_ignores_state, true
      option :scope, "spark:messages_write spark:rooms_read spark:teams_read spark:memberships_read spark:messages_read spark:rooms_write spark:people_read spark:kms spark:memberships_write spark:teams_write spark:team_memberships_read spark:team_memberships_write"

      # These are called after authentication has succeeded. If
      # possible, you should try to set the UID without making
      # additional calls (if the user id is returned with the token
      # or as a URI parameter). This may not be possible with all
      # providers.

      uid{ raw_info['id'] }

      info do
        {
          :name => raw_info['name'],
          :email => raw_info['email']
        }
      end

      extra do
        {
          'raw_info' => raw_info
        }
      end

      def callback_phase # rubocop:disable AbcSize, CyclomaticComplexity, MethodLength, PerceivedComplexity
          self.access_token = build_access_token
          self.access_token = access_token.refresh! if access_token.expired?
      end

      def raw_info
        @raw_info ||= access_token.get('/me').parsed
      end

      def callback_url
       options[:callback_url] || full_host + script_name + callback_path
      end

    end
  end
end
