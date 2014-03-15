module Dea
  class Api
    class << self
      def log_in(email, password, url)
        Dea::Http.post('login', body: {
          email: email,
          password: password,
          exchangeurl: url
        })
      end

      def log_out(auth_token)
        Dea::Http.delete('logoff', auth_token: auth_token)
      end

      def users(auth_token)
        response = Dea::Http.get('contacts', auth_token: auth_token)
        Dea::User.batch_load(response.contacts)
      end

      def events(auth_token, options)
        response = Dea::Http.get('appointments', {
          params: events_params(options),
          auth_token: auth_token,
        })
        Dea::Event.batch_load(response.appointments)
      end

      def event(auth_token, options)
        response = Dea::Http.get("appointments/#{options[:id]}", {
          params: { email: options[:email] },
          auth_token: auth_token,
        })
        Dea::Event.new(response.appointment)
      end

      def create_event(auth_token, options)
        response = Dea::Http.post('appointments', {
          body: create_event_body(options),
          auth_token: auth_token,
        })
        response.id
      end

      def update_event(auth_token, options)
        Dea::Http.put("appointments/#{options[:id]}", {
          body: update_event_body(options),
          auth_token: auth_token,
        })
      end

      def delete_event(auth_token, options)
        Dea::Http.delete("appointments", {
          params: delete_event_params(options),
          auth_token: auth_token,
        })
      end

      def available?(auth_token, options)
        Dea::Http.get('schedule', {
          params: events_params(options),
          auth_token: auth_token,
        }).available
      end

      private

      def events_params(options)
        options.select{|key|[:email, :from, :to].include?(key)}
      end

      def create_event_body(options)
        keys = [:subject, :location, :body, :attendees, :resources, :from, :to]
        {
          "Email" => options[:email],
          "Appointment" => create_capitalized_hash(options, keys),
        }
      end

      def create_capitalized_hash(options, keys)
        {}.tap do |hash|
          options.select{|key|keys.include?(key)}.map do |key, val|
            hash[key.to_s.split('_').map(&:capitalize).join('')] = val
          end
        end
      end

      def update_event_body(options)
        keys = [:subject, :location, :body, :attendees, :resources, :from, :to]
        create_capitalized_hash(options, keys)
      end

      def delete_event_params(options)
        { id: options[:id], email: options[:email] }
      end
    end
  end
end
