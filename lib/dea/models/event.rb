module Dea
  class Event < ApiModel
    attr_accessor :id, :subject, :location, :body, :attendees, :resources, :summary, :starts_at, :ends_at

    def initialize(api_event)
      @id        = api_event["Id"]
      @subject   = api_event["Subject"]
      @location  = api_event["Location"]
      @body      = api_event["Body"]
      @attendees = api_event["Attendees"]
      @resources = api_event["Resources"]
      @starts_at = api_event["From"]
      @ends_at   = api_event["To"]
    end
  end
end
