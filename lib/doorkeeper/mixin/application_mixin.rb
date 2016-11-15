module DoorkeeperNobrainer
  module ApplicationMixin
    extend ActiveSupport::Concern

    include Doorkeeper::OAuth::Helpers
    include Doorkeeper::Models::Scopes
    include ActiveModel::MassAssignmentSecurity if defined?(::ProtectedAttributes)

    included do
      has_many :access_grants, dependent: :destroy, class_name: 'Doorkeeper::AccessGrant'
      has_many :access_tokens, dependent: :destroy, class_name: 'Doorkeeper::AccessToken'

      validates :name, :secret, :uid, presence: true
      validates :uid, uniqueness: true
      validates :redirect_uri, redirect_uri: true

      before_validation :generate_uid, :generate_secret, on: :create
    end

    module ClassMethods
      def by_uid_and_secret(uid, secret)
        where(uid: uid.to_s, secret: secret.to_s).first
      end

      def by_uid(uid)
        where(uid: uid.to_s).first
      end
    end

    private

    def has_scopes?
      Doorkeeper.configuration.orm != :active_record ||
        Doorkeeper::Application.fields.keys.include?("scopes")
    end

    def generate_uid
      if uid.blank?
        self.uid = UniqueToken.generate
      end
    end

    def generate_secret
      if secret.blank?
        self.secret = UniqueToken.generate
      end
    end
  end
end
