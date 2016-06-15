#
# +radiant+ extensions for the String class
#

class String

  #
  # +strip_suffix+
  #
  # `'hijack.jpg'.strip_suffix #=> 'hijack'`
  #
  def strip_suffix
    ridx = self.rindex('.') || 0
    self[0..ridx-1]
  end

  #
  # +humanize_ignorecase+
  #
  # `'this_is_Human'.humanize_ignorecase #=> 'This is Human'`
  #
  def humanize_ignorecase
    res = self.dup
    res.sub!(/_id\z/, '')
    res.tr!('_\-', ' ')
    res.sub!(/\A\w/) { |match| match.upcase }
    res
  end

  #
  # +radiantize+
  #
  # `'http://www.example.com/images/147582020_this_is_an_Image.jpg' #=> 'This is an Image'`
  #
  def radiantize
    ridx = self.rindex('/') || -1
    self[ridx+1..-1].sub(/\A[0-9]{8,}_/,'').strip_suffix.humanize_ignorecase
  end

end
