module Error::Helpers
  class Render
    def self.json(message, details = nil)
      (details ? { message: message, details: details } : { message: message }).as_json
    end
  end
end
