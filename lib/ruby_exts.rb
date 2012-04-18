class String
  def urlize
    # TODO: remove special chars
    self.downcase.split(/\s+/).join("_").gsub(/\W+/i, '').gsub(/_+/, '_').gsub(/^_|_$/, '')
  end
end