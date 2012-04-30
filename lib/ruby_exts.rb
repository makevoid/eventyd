# encoding: utf-8

class String
  def urlize
    # TODO: remove special chars
    self.downcase.split(/\s+/).join("_").remove_accents.gsub(/\W+/i, '').gsub(/_+/, '_').gsub(/^_|_$/, '')
  end

  def remove_accents
    self.gsub(/ò|ó/, 'o')
    # TODO: etc
  end
end

class Date
  def to_s_month
    strftime("%d %B")
  end
end