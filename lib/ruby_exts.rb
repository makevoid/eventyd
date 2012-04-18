class String
  def urlize
    # TODO: remove special chars
    self.downcase.split("\s+").join("_")#.encode!("ASCII-8BIT", invalid: :replace, replace: '')
  end
end