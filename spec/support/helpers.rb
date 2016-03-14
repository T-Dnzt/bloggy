# spec/support/helpers.rb
module Helpers

  def json
    JSON.parse(last_response.body)
  end

  def to_json(hash)
    JSON[hash.to_json]
  end

end
