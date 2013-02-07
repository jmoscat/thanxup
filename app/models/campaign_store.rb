class CampaignStore #stores embedded in a campaign
  include Ripple::EmbeddedDocument
  property :store_id, String, index: true
end
