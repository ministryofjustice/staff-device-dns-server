class BindClient
  def get_server_stats
    uri = URI.parse("http://localhost:8080/json/v1/server")
    req = Net::HTTP::Get.new(uri.path, "Content-Type" => "application/json")
    http = Net::HTTP.new(uri.host, uri.port)
    JSON.parse(http.request(req).body)
  end
end
