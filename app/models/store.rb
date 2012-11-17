class Store
  def initialize
    client = Riak::Client.new
    bucket = client.bucket('store')
  end
end
