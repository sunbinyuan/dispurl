# encoding: US-ASCII
class Url < ActiveRecord::Base
  validates :redir_limit, numericality: { only_integer: true }
  validates :redirect_to, format: { with: /\A(?:(?:https?|ftp):\/\/)(?:\S+(?::\S*)?@)?(?:(?!(?:10|127)(?:\.\d{1,3}){3})(?!(?:169\.254|192\.168)(?:\.\d{1,3}){2})(?!172\.(?:1[6-9]|2\d|3[0-1])(?:\.\d{1,3}){2})(?:[1-9]\d?|1\d\d|2[01]\d|22[0-3])(?:\.(?:1?\d{1,2}|2[0-4]\d|25[0-5])){2}(?:\.(?:[1-9]\d?|1\d\d|2[0-4]\d|25[0-4]))|(?:(?:[a-z\x00a1-\xffff0-9]-*)*[a-z\x00a1-\xffff0-9]+)(?:\.(?:[a-z\x00a1-\xffff0-9]-*)*[a-z\x00a1-\xffff0-9]+)*(?:\.(?:[a-z\x00a1-\xffff]{2,})).?)(?::\d{2,5})?(?:[\/?#]\S*)?\z/,
    message: "is an invalid URL" }
  validates :alias, uniqueness: true
  validates :alias, length: {in: 4..20}
  validates :alias, format: {with: /[a-zA-Z0-9]+/}
  validates :redirect_to, presence: true
  
  BASECHARS = [('0'..'9').to_a,('A'..'Z').to_a,('a'..'z').to_a].flatten
  
  URL_PROTOCOL_HTTP = "http://"
  REGEX_LINK_HAS_PROTOCOL = Regexp.new('\Ahttp:\/\/|\Ahttps:\/\/', Regexp::IGNORECASE)
  
  def self.clean_url(url)
    return nil if url.blank?
    url = URL_PROTOCOL_HTTP + url.strip unless url =~ REGEX_LINK_HAS_PROTOCOL
    URI.parse(url).normalize.to_s
  end
  
  def self.generate_alias
    unique = false
    while unique == false
      randalias = (0..5).map {BASECHARS[rand(61)]}.join
      if !self.find_by({alias: randalias})
        unique = true
      end
    end
    randalias
  end
  
  def self.createlink(*args)
    create = Url.new(*args).save
  end
end
