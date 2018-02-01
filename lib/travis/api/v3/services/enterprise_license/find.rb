module Travis::API::V3
  class Services::EnterpriseLicense::Find < Service
    def run!
      response = Faraday.get("#{replicated_endpoint}/license/v1/license")
      replicated_response = JSON.parse(response.body)
      seats, expiration_time = process_license(replicated_response)
      active_users = query.active_users(expiration_time)

      result({
        seats: seats,
        active_users: active_users.count,
        expiration_time: expiration_time
      })
    end

    private

    def replicated_endpoint
      ENV['REPLICATED_INTEGRATIONAPI']
    end

    def process_license(replicated_response)
      te_license = replicated_response["fields"].find { |te_fields| te_fields["field"] == "te_license" }
      yaml = YAML.load(te_license["value"])
      [yaml["production"]["license"]["seats"], replicated_response["expiration_time"]]
    end
  end
end