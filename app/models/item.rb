# You'll want one of these for each and everything I'm sending

class Item # AR or DataMapper, whatever
  def self.create_from_import(attributes)
    p attributes

    # map attributes from json to whatever columns are in the database
    # find an item that might already exist or create a new one
  end
end
