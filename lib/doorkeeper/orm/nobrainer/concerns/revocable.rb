module Doorkeeper
  module Models
    module Nobrainer
      module Revocable
        def revoke(clock = Time)
          update({:revoked_at => clock.now.utc})
        end

        def revoked?
          !!(revoked_at && revoked_at <= Time.now.utc)
        end

        def revoke_previous_refresh_token!
          return unless refresh_token_revoked_on_use?
          old_refresh_token.revoke if old_refresh_token
          update({:previous_refresh_token => ""})
        end

        private

        def old_refresh_token
          @old_refresh_token ||=
            AccessToken.by_refresh_token(previous_refresh_token)
        end

        def refresh_token_revoked_on_use?
          AccessToken.refresh_token_revoked_on_use?
        end
      end
    end
  end
end
