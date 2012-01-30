module Devise
  module Models
    # SecurePassword is responsible to verify if the password is realy secure
    module SecurePassword

      def self.included(base)
        base.extend ClassMethods

        base.class_eval do
          before_validation :secure_password
          
          protected

            def secure_password
              if  is_consecutive? or
                  has_not_lower_and_upper_characters? or
                  has_not_numbers? or
                  has_not_symbols? or
                  is_too_short?
                errors.add(:password, I18n.t("errors.messages.insecure_password"))
              end
            end

            def is_consecutive?
              is = true
              required_char = password[0]
              password.each_char do |c|
                is = false if c != required_char
                required_char = required_char.succ
              end
              is
            end

            def has_not_lower_and_upper_characters?
              return true if password[/[a-z]/].nil? or password[/[A-Z]/].nil?
              false
            end

            def has_not_numbers?
              return true if password[/[0-9]/].nil?
              false
            end

            def has_not_symbols?
              return true if password[/[^a-z0-9]/i].nil?
              false
            end

            def is_too_short?
              return true if password.size < 8
              false
            end
        end
      end


      module ClassMethods
      end
    end
  end
end
